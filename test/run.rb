# RCodeLeveler main test file.
#
#--
# Copyright (c) 2007 - 2012 Muriel Salvan (muriel@x-aeon.com)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

lRootDir = File.expand_path("#{File.dirname(__FILE__)}/..")

$: << "#{lRootDir}/test"
$: << "#{lRootDir}/lib"

require 'RCodeLevelerTest'

