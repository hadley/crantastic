module Rails
  class Configuration
    def github_gem(name, options = {})
      options[:source] = 'http://gems.github.com'
      options[:lib] = name.sub(/[^-]+-/, '') unless options.has_key?(:lib)
      self.gem(name, options)
    end
  end
end
