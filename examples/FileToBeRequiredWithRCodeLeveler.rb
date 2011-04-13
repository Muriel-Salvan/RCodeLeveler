# RCodeLeveler test required file.
#
# This file is intended to be required using RCodeLeveler.
#
#--
# Copyright (c) 2007-2011 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

#__LVL__ 3 puts '1. This line only appears for a default level >= 3. This is like a debug log.'

# This comment is not interpreted by RCodeLeveler.

#__LVLCATBEGIN__ EnableStatistics 2
puts '2. These 2 lines only appear if the level'
puts '3.   for category "EnableStatistics" is >= 2'
# Please note that fctReturn5 is defined in the context of the file requiring this file.
#__LVLRUBY__ fctReturn5 - 2 == 3 ### puts '4. This line appears unless 5 - 2 != 3 on this system or the "EnableStatistics" category is at level < 2 (we still are in the level section opened above).'
#__LVLEND__
# Ends level section opened for category EnableStatistics level 2
