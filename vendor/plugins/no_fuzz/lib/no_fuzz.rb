# TODO:
# - scores
#   I.e fuzzy {:first_name => 1, :last_name => 2}, last_name gives double score
#   Currently everything gets scored with 1
# - weighting of fuzzy_find results
# - customizable normalization

# NOTE to self: patched levenshtein distance right in, to somewhat avoid
# completely horrendous results.

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

      @@model.send(:define_method, :create_trigrams) do
        self.class.instance_variable_get(:@fuzzy_fields).each do |f|
          word = ' ' + self.send(f)
          (0..word.length-3).each do |idx|
            tg = word[idx,3].downcase # Force normalization by downcasing for
                                      # now - should be overridable by the user
            self.class.instance_variable_get(:@fuzzy_trigram_model).create(:tg => tg,
                         self.class.instance_variable_get(:@fuzzy_ref_id) => self.id)
          end
        end
      end
    end

    def populate_trigram_index
      clear_trigram_index

      fuzzy_ref_id = self.instance_variable_get(:@fuzzy_ref_id)
      trigram_model = self.instance_variable_get(:@fuzzy_trigram_model)
      fields = self.instance_variable_get(:@fuzzy_fields)

      self.all.each do |i|
        i.create_trigrams
      end
      true
    end

    def clear_trigram_index
      self.instance_variable_get(:@fuzzy_trigram_model).delete_all
    end

    def fuzzy_find(word, limit = false, extra = {})
      fuzzy_ref_id = self.instance_variable_get(:@fuzzy_ref_id)
      trigram_model = self.instance_variable_get(:@fuzzy_trigram_model)
      fields = self.instance_variable_get(:@fuzzy_fields)

      word = ' ' + word + ' '
      trigrams = (0..word.length-3).collect { |idx| word.mb_chars[idx,3] }

      # ordered hash of package_id => score pairs
      trigram_groups = trigram_model.sum(:score, :conditions => [ "tg IN (?)", trigrams],
                                         :group => fuzzy_ref_id.to_s)

      conds = { :conditions => ["id IN (?)", trigram_groups.keys] }
      conds.merge!({:limit => limit}) if limit
      conds.merge!(extra) # includes etc
      m = Amatch::Levenshtein.new(word)
      self.all(conds).sort_by { |p| -m.similar(p.to_s) }
    end
  end
end
