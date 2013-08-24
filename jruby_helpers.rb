require 'java'

require 'jruby_helpers/import'
require 'jruby_helpers/require_jars'

module JrubyHelpers
  def self.extended(base)
    base.extend JrubyHelpers::Import
    base.extend JrubyHelpers::RequireJars
  end
end
