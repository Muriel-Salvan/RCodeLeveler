# RCodeLeveler Gem specification
#
#--
# Copyright (c) 2007 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

require 'rubygems'
# To compute minor version automatically
require 'date'

# Return the Gem specification
#
# Return:
# * <em>Gem::Specification</em>: The Gem specification
def getSpecification
  return Gem::Specification.new do |iSpec|
    iSpec.name = 'RCodeLeveler'
    lNow = DateTime.now
    iSpec.version = "0.1.#{sprintf('%04d%02d%02d',lNow.year,lNow.month,lNow.day)}"
    iSpec.author = 'Muriel Salvan'
    iSpec.email = 'murielsalvan@users.sourceforge.net'
    iSpec.homepage = 'http://rcodeleveler.sourceforge.net/'
    iSpec.platform = Gem::Platform::RUBY
    iSpec.summary = 'A Ruby preprocessor that enables/disables parts of the source code.'
    iSpec.files = Dir.glob('{test,lib,docs,examples}/**/*').delete_if do |iFileName|
      iFileName == 'CVS'
    end
    iSpec.require_path = 'lib'
    iSpec.autorequire = 'rcodeleveler'
    iSpec.test_file = 'test/run.rb'
    iSpec.has_rdoc = true
    iSpec.extra_rdoc_files = ['README',
                              'TODO',
                              'Bugs',
                              'Releases',
                              'LICENSE',
                              'AUTHORS',
                              'Credits',
                              'examples']
  end
end
