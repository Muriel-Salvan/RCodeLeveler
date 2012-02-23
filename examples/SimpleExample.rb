# RCodeLeveler example file.
#
# This file shows basic use of RCodeLeveler
#
#--
# Copyright (c) 2007 - 2012 Muriel Salvan (muriel@x-aeon.com)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

require 'rcodeleveler'

# We set the parameters that will tune the parsing of the file to be required
# Set the default category to 4
RCodeLeveler::set_level(4)
# Set the category "EnableStatistics" to 2
RCodeLeveler::set_level(2, 'EnableStatistics')
# Define a function that will be used in the file to be required
def fctReturn5
  return 5
end

# And now we require the file (first add the directory to the load path)
$LOAD_PATH << File.dirname(__FILE__)
require_level 'FileToBeRequiredWithRCodeLeveler'

puts 'Normally 4 lines should have appeared above this one.'
