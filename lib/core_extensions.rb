require 'iconv'

class Object
  def not_nil?; !nil?; end
  def not_blank?; !blank?; end
end

class Hash
  # NOTE: Currently only works for keys that are strings. Should ideally work
  # for symbols as well.
  def downcase_keys
    inject({}) do |options, (key, value)|
      options[key.downcase] = value
      options
    end
  end
end

class String
  def latin1_to_utf8
    Iconv.conv("UTF-8", "ISO-8859-1", self) rescue self
  end

  def strip_entities
    self.gsub(/&#?[A-Za-z0-9]+;/, '')
  end
end
