# TODO:
# - scores
#   I.e fuzzy {:first_name => 1, :last_name => 2}, last_name gives double score
#   Currently everything gets scored with 1
# - weighting of fuzzy_find results

module NoFuzz
  def self.included(model)
    model.extend ClassMethods
  end

  module ClassMethods
    def self.extended(model)
      @@model = model
    end

    def fuzzy(*fields)
      # put the parameters as instance variable of the model
      @@model.instance_variable_set(:@fuzzy_fields, fields)
      @@model.instance_variable_set(:@fuzzy_ref_id, "#{@@model.to_s.demodulize.underscore}_id")
      @@model.instance_variable_set(:@fuzzy_trigram_model, "#{@@model}Trigram".constantize)
    end

    def populate_trigram_index
      clear_trigram_index

      fuzzy_ref_id = self.instance_variable_get(:@fuzzy_ref_id)
      trigram_model = self.instance_variable_get(:@fuzzy_trigram_model)
      fields = self.instance_variable_get(:@fuzzy_fields)

      fields.each do |f|
        self.all.each do |i|
          word = ' ' + i.send(f)
          (0..word.length-3).each do |idx|
            tg = word[idx,3].downcase # Force normalization by downcasing for
                                      # now - should be overridable by the user
            trigram_model.create(:tg => tg, fuzzy_ref_id => i.id)
          end
        end
      end
      true
    end

    def clear_trigram_index
      self.instance_variable_get(:@fuzzy_trigram_model).delete_all
    end

    def fuzzy_find(word, limit = 0)
      fuzzy_ref_id = self.instance_variable_get(:@fuzzy_ref_id)
      trigram_model = self.instance_variable_get(:@fuzzy_trigram_model)
      fields = self.instance_variable_get(:@fuzzy_fields)

      word = ' ' + word + ' '
      trigrams = (0..word.length-3).collect { |idx| word[idx,3] }

      # ordered hash of package_id => score pairs
      trigram_groups = trigram_model.sum(:score, :conditions => [ "tg IN (?)", trigrams],
                                         :group => fuzzy_ref_id.to_s)

      count = 0
      @res = []
      trigram_groups.sort_by {|a| -a[1]}.each do |group|
        @res << self.find(group[0])
        count += 1
        break if count == limit
      end
      @res
    end
  end
end
