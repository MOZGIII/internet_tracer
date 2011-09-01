require 'yaml'
class String
  def to_regexp
    str = self
    str = "/#{str}/" unless str =~ /\A\/.*\/.*\z/
    YAML.load("!ruby/regexp #{str}")
  end unless method_defined?(:to_regexp)
end
