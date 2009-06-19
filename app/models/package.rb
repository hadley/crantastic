# == Schema Information
# Schema version: 20090619112911
#
# Table name: package
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  description       :text
#  created_at        :datetime
#  latest_version_id :integer
#

class Package < ActiveRecord::Base
  include NoFuzz
  fuzzy :name

  after_create :create_trigrams # Incrementally update the trigram index

  has_many :versions, :order => "id DESC", :dependent => :destroy
  has_many :package_ratings, :dependent => :destroy
  has_many :reviews, :dependent => :destroy
  has_many :taggings, :dependent => :destroy

  # We cache the latest version id
  belongs_to :latest_version, :class_name => "Version"
  alias :latest :latest_version

  fires :new_package, :on                => :create,
                      :subject           => :self,
                      :secondary_subject => :self # yes 2x package

  default_scope :order => "LOWER(package.name)"
  # Used for the Package atom-feed:
  named_scope :recent, :order => "#{self.table_name}", :include => :versions,
                       :conditions => "#{self.table_name}.created_at IS NOT NULL"

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :in => 2..255

  # We can't validate the presence of a latest_version_id here, since we
  # create packages before versions are associated. In conclusion, we have
  # to be careful and ideally use transactions when creating packages to avoid
  # inconsistent data in the database.

  def self.find_by_param(id)
    self.find_by_name(id.gsub("-", ".")) or raise ActiveRecord::RecordNotFound
  end

  ## No. of packages to show per page.
  def self.per_page; 50; end

  ## Search On Name of Package.
  def self.paginating_search(q, search_results_page)
    q.strip.downcase!

    if q.ends_with? '~' # fuzzy search
      # TODO It's kinda bad to do two database hits here, I think it can be resolved
      # by using paginate's :finder argument and creating a new method that
      # calls out to fuzzy_find.
      ids = Package.fuzzy_find(q[0...-1], per_page).collect { |i| i.id }
      [paginate(ids,
               {:include => {:versions => :maintainer},
               :page => search_results_page}), "fuzzy"]
    else
      res = paginate({ :conditions => [ 'LOWER(package.name) LIKE ?', '%' + q + '%'],
                       :include => [{:latest_version => :maintainer}],
                       :page => search_results_page })
      res.empty? ? self.paginating_search(q + '~', search_results_page) : [res]
    end
  end

  def self.search(q, limit=self.per_page)
    extra = { :include => :latest_version }
    res = []
    if q.ends_with? '~' # fuzzy search
      res = [Package.fuzzy_find(q[0...-1], limit, extra), "fuzzy"]
    else
      qq = '%' + q + '%'
      res = [Package.all(:conditions =>
                          ['LOWER(package.name) LIKE ? OR LOWER(version.description) LIKE ?', qq, qq],
                          :limit => limit, :include => :latest_version)]
      if res.first.empty?
        # Try a fuzzy search if no results were found
        res = [Package.fuzzy_find(q, limit, extra), "fuzzy"]
      end
    end
    res
  end

  # Returns an array of Tag objects that this package has been tagged with.
  #
  # @return [Array]
  def tags
    Tag.find_by_sql("SELECT * FROM tag WHERE id IN
                              (SELECT DISTINCT(tag_id) FROM tagging
                                      WHERE package_id = #{self.id})") || []
  end

  # @return [Fixnum] Number of ratings for this package for the given aspect
  def rating_count(aspect="overall")
    PackageRating.count(:conditions => ["package_id = ? AND aspect = ?",
                                        self.id, aspect])
  end

  # Rounded average rating for this package
  def average_rating(aspect="overall")
    PackageRating.calculate_average(self, aspect)
  end

  def to_param
    name.gsub(".", "-")
  end

  def to_s
    name
  end

  def google_url
    "http://www.google.com/search?q=" + CGI.escape("#{name} cran OR r-project -inurl:contrib -inurl:doc/packages -inurl:CRAN")
  end

  def scholar_url
    "http://scholar.google.com/scholar?q=" + CGI.escape(name)
  end

  def rhelp_url
   "http://finzi.psych.upenn.edu/cgi-bin/namazu.cgi" +
     "?idxname=Rhelp02a&idxname=Rhelp01&query=" + CGI.escape(name)
  end

  def rdevel_url
   "http://finzi.psych.upenn.edu/cgi-bin/namazu.cgi" +
     "?idxname=R-devel&query=" + CGI.escape(name)
  end

end
