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
