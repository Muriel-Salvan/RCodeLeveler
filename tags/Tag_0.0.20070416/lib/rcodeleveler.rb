# RCodeLeveler main library.
#
# RCodeLeveler is a Ruby preprocessor (used when requiring files) that
# interprets some comments in source files to enable or disable parts
# of the source code.
#
# Its goal is to activate parts of the source code without any performance issue.
# For example, logging some information only when the program is run with a given option.
# The simple implementation would be to dynamically test a condition enabling some parts
# of the code, but sometimes even a simple condition testing is harmful enough to performances
# to want to comment/uncomment the function call when needed. RCodeLeveler does it for you.
#
# As it alters tbe source code (in memory) before being interpreted by Ruby, it is not fit to enable source
# code based on dynamic conditions. It is used while requiring a Ruby source file. The conditions
# can be dynamically computed before requiring the file, but once it has been done it is too late:
# disabled code cannot be enabled back (unless you clear every class/module/constant defined
# by this file, delete its reference from Ruby's loaded files' cache and re-require it).
#
# In order to use the functionalities of RCodeLeveler, you have to require your Ruby files
# using +requireLevel+ function instead of +require+. Please note it works only with Ruby files.
#
# The files being required using +requireLevel+ can then use some special comments:
# * <b><tt>##\_\_LVL__ <Lvl> <Line></tt></b>: <tt><Line></tt> will be enabled only if the default level while
#   requiring this file is greater or equal than <tt><Lvl></tt>.
# * <b><tt>##\_\_LVLCAT__ <Cat> <Lvl> <Line></tt></b>: <tt><Line></tt> will be enabled only if the level 
#   for category <tt><Cat></tt> is greater or equal than <tt><Lvl></tt> while requiring this file.
# * <b><tt>##\_\_LVLRUBY__ <Code> ### <Line></tt></b>: <tt><Line></tt> will be enabled only if the ruby code
#   <b><tt><Code></tt> returns +true+ while requiring this file. Levels for categories while requiring
#   the file can be referenced using the variable <tt>@@RCLLevels</tt> that is of type
#   <tt>map< String, Integer ></tt> giving the level corresponding to a given category. The default
#   level can be referenced with <tt>@@RCLLevels[K_Default_Category]</tt>. This starts a level section.
# * <b><tt>##\_\_LVLBEGIN__ <Lvl></tt></b>: All subsequent lines will be enabled only if the default level while
#   requiring this file is greater or equal than <tt><Lvl></tt>. This starts a level section.
# * <b><tt>##\_\_LVLCATBEGIN__ <Cat> <Lvl></tt></b>: All subsequent lines will be enabled only if the level
#   for category <tt><Cat></tt> is greater or equal than <tt><Lvl></tt> while requiring this file. This starts a level section.
# * <b><tt>##\_\_LVLRUBYBEGIN__ <Code></tt></b>: All subsequent lines will be enabled only if the ruby code
#   <tt><Code></tt> returns +true+ while requiring this file. Levels for categories while requiring
#   the file can be referenced using the variable <tt>@@RCLLevels</tt> that is of type
#   <tt>map< String, Integer ></tt> giving the level corresponding to a given category. The default
#   level can be referenced with <tt>@@RCLLevels[K_Default_Category]</tt>. This starts a level section.
# * <b><tt>##\_\_LVLEND__</tt></b>: End the last opened level section of lines to be enabled/disabled that has been started
#   with <tt>##\_\_LVLBEGIN__</tt> or <tt>##\_\_LVLCATBEGIN__</tt> directives.
#
# Level sections can be hierarchically embedded one in another. If the inclusion of a level section
# is useless (because it will have the same activation level as its surrounding level section), RCodeLeveler
# will issue a warning during the file parsing.
#
# The following functions can be used to set levels before requiring the file:
# * <tt>RCodeLeveler::setLevel(iLevel)</tt>: Set the default level.
# * <tt>RCodeLeveler::setLevel(iLevel, iCategory)</tt>: Set the level for a given category.
# * <tt>RCodeLeveler::resetLevels</tt>: Reset all levels for all categories to 0.
#
# Please note that using only ##\_\_LVL__, ##\_\_LVLCAT__ and ##\_\_LVLRUBY__ directives enables you
# to also require the file without RCodeLeveler, with all leveled code commented. This can be useful
# if you use RCodeLeveler to just activate source code for debugging purposes only.
#
# You can also define different behaviour while encountering warnings during a file's parsing with function:
# * <tt>RCodeLeveler::setWarningSeverity(iWarningSeverity)</tt>
# where +iWarningSeverity+ can be:
# * 0: No warning.
# * 1: Display them on stderr.
# * 2: Throw an exception (default)
#
# Please check the tests to find examples of all possible functionalities and uses.
#
#--
# Copyright (c) 2007 Muriel Salvan (muriel_@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Main module for RCodeLeveler.
# +requireLevel+ method is not part of it: it is in the global Module scope.
module RCodeLeveler

  # Exception class due to a wrong decoding of the required file
  class ParseError < RuntimeError
  end

  public
  
  # Set warning severity.
  # 0: No warning.
  # 1: Display them on stderr.
  # 2: Throw an exception (default)
  #
  # Parameters:
  # * *iWarningSeverity* (_Integer_): Severity of warnings
  def RCodeLeveler.setWarningSeverity(iWarningSeverity)
    @@WarningSeverity = iWarningSeverity
  end
  
  # Reset all levels.
  def RCodeLeveler.resetLevels
    @@RCLLevels = {K_Default_Category => 0}
  end
  
  # Set a level for a category.
  #
  # Parameters:
  # * *iLevel* (_Integer_): The level
  # * *iCategory* (_String_): The category name [optional = K_Default_Category]
  def RCodeLeveler.setLevel(iLevel, iCategory = K_Default_Category)
    @@RCLLevels[iCategory] = iLevel
  end
  
  private
  
  # The default category (spaces have to be present to ensure users cannot use it)
  K_Default_Category = '* Default *'
  
  # The Ruby code category (spaces have to be present to ensure users cannot use it)
  K_Ruby_Category = '* Ruby *'
  
  # The map of levels per category
  #   map< String, Integer >
  @@RCLLevels = {K_Default_Category => 0}
  
  # The warning's severity
  # 0: No warning.
  # 1: Display them on stderr.
  # 2: Throw an exception (default)
  #   Integer
  @@WarningSeverity = 2

  # Issue a warning specific to RCodeLeveler
  # Parameters:
  #   iMessage (String): The message to output
  def RCodeLeveler.warning(iMessage)
    if (@@WarningSeverity == 1)
      $stderr.puts "RCodeLeveler - warning: #{iMessage}"
    elsif (@@WarningSeverity == 2)
      raise ParseError, "RCodeLeveler - warning: #{iMessage}"
    end
  end
  
  # Get the library file location.
  # This method should search for the file EXACTLY the same way Ruby does.
  # It has been coded bearing in mind the specifications of require and load methods of Kernel module
  # as explained in "Programming Ruby - The Pragmatic Programmers' Guide" Second Edition - by Dave Thomas
  # (thanks Dave by the way for your excellent book !)
  # It appears Ruby's behaviour comes from the method "file.c:rb_find_file(path)" (Ruby 1.8.5).
  #
  # Parameters:
  # * *iLibraryName* (_String_): Name of the library to load, as given to require and load methods
  # Return:
  # * _String_: The name of the real source file (or nil if none found)
  def RCodeLeveler.getRealLibraryPath(iLibraryName)
    lRealFileName = nil
    
    lExtension = File.extname(iLibraryName)
    if (lExtension == '')
      lFileNameWithExt = "#{iLibraryName}.rb"
    else
      lFileNameWithExt = iLibraryName
    end
    # Find the real file
    if ((lExtension == '') or
        (lExtension == '.rb'))
      if (File.expand_path(iLibraryName) == iLibraryName)
        # Absolute form
        if (File.exist?(lFileNameWithExt))
          lRealFileName = lFileNameWithExt
        end
      else
        # Relative form
        # Find in each directory of $:
        $:.each do |iDir|
          lFilePathAttempt = "#{iDir}/#{lFileNameWithExt}"
          if (File.exist?(lFilePathAttempt))
            # We found it
            lRealFileName = lFilePathAttempt
            break
          end
        end
      end
      # lRealFileName contains the real file name, or nil if none found
    end
    
    return lRealFileName
  end

  # Get the content of a file once levelized.
  #
  # Parameters:
  # * *iFileName* (_String_): Path to the source file to level
  # Return:
  # * <em>list<String></em>: The content of the file once levelized
  # * _Boolean_: Is the content really different from original content ?
  def RCodeLeveler.getSourceFileContentLevelized(iFileName)
    lNewFileContents = []
    lFoundLVLMacro = false
    
    # The stack of level sections
    # list< [ String,  Integer ] >
    #         Category Level
    lLevelSections = []
    # The map of highest level sections
    # map< String,  Integer ] >
    #      Category HighestLevel
    lHighestLevelSections = {}
    #puts "----- @@RCLLevels=#{@@RCLLevels}"
    # First read the source file
    File.open(iFileName, 'r') do |iOrgFile|
      lLineNumber = 1
      # The section that currently disables our lines of code
      # [ String,  Integer ]
      #   Category Level
      lLevelingSection = nil
      iOrgFile.readlines.each do |iCodeLine|
        # Here is the main algorithm of the leveler.
        # It recognizes the following special comment lines:
        #   #__LVL__ <Number> <Code>: Activate the code <Code> for a default level >= <Number>.
        #   #__LVLCAT__ <Category> <Number> <Code>: Activate the code <Code> for a category level >= <Number>.
        #   #__LVLBEGIN__ <Number>: The following lines of the file are activated for a default level >= <Number>. It is a level section.
        #   #__LVLCATBEGIN__ <Category> <Number>: The following lines of the file are activated for a category level >= <Number>. It is a level section.
        #   #__LVLEND__: Terminate a level section of code that began with __LVLBEGIN__ or __LVLBEGINCAT__ comment (terminate the last opened one).
        lLineStripped = iCodeLine.strip
        # The line storing the output (by default it is the input if the last level section authorizes it)
        # Check if we are in a context (from @@RCLLevels) that filters our current level sections' stack
        if (lLevelingSection == nil)
          lOutputLine = iCodeLine
        else
          lOutputLine = "# ! Level #{lLevelingSection[0]}.#{lLevelingSection[1]} ! #{iCodeLine}"
        end
        # Do we have to evaluate whether we have to evaluate the section or not after processing this line ?
        lReevaluateLevelingSection = false
        #puts "----- Line = #{iCodeLine}"
        # Interpret it
        if (lLineStripped[0..7] == '#__LVL__')
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVL__ ([0-9]*) (.*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            # Check that the level of this line is greater or equal to the current section's level
            lLevel = lLineArguments[0][0].to_i
            lLastLevel = lHighestLevelSections[K_Default_Category]
            if (lLastLevel == nil)
              lLastLevel = 0
            end
            if (lLevel <= lLastLevel)
              warning("#{iFileName}:#{lLineNumber}: This line can never be activated as it is part of a level section of level #{lLastLevel}: #{lLineStripped}")
            end
            if ((lLevelingSection == nil) and 
                (@@RCLLevels[K_Default_Category] >= lLevel))
              lOutputLine = "#{lLineArguments[0][1]}\n"
            end
          end
        elsif (lLineStripped[0..10] == '#__LVLCAT__')
          #puts '----- Match LVLCAT'
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVLCAT__ ([^ ]+) ([0-9]*) (.*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            #puts "----- Matched: #{lLineArguments.inspect}"
            # Check that the level of this line is greater or equal to the current section's level
            lCategory = lLineArguments[0][0]
            lLevel = lLineArguments[0][1].to_i
            lLastLevel = lHighestLevelSections[lCategory]
            if (lLastLevel == nil)
              lLastLevel = 0
            end
            #puts "----- Last level of category #{lCategory}: #{lLastLevel}"
            #puts "----- lLevelingSection=#{lLevelingSection.inspect}"
            if (lLevel <= lLastLevel)
              warning("#{iFileName}:#{lLineNumber}: This line can never be activated as it is part of a level section of level #{lLastLevel}: #{lLineStripped}")
            end
            if ((lLevelingSection == nil) and
                (@@RCLLevels[lCategory] != nil) and
                (@@RCLLevels[lCategory] >= lLevel))
              lOutputLine = "#{lLineArguments[0][2]}\n"
            end
          end
        elsif (lLineStripped[0..11] == '#__LVLRUBY__')
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVLRUBY__ (.*) ### (.*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            if ((lLevelingSection == nil) and
                (eval(lLineArguments[0][0])))
              lOutputLine = "#{lLineArguments[0][1]}\n"
            end
          end
        elsif (lLineStripped[0..12] == '#__LVLBEGIN__')
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVLBEGIN__ ([0-9]*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            lLevel = lLineArguments[0][0].to_i
            lLastLevel = lHighestLevelSections[K_Default_Category]
            if (lLastLevel == nil)
              lLastLevel = 0
            end
            if (lLevel <= lLastLevel)
              warning("#{iFileName}:#{lLineNumber}: This level section can never be activated as it is part of a level section of level #{lLastLevel}: #{lLineStripped}")
              lOutputLine = "# !!! This level section is useless as it is part of a level section of level #{lLastLevel}: #{lLineStripped}\n"
            end
            lLevelSections.push([K_Default_Category,lLevel])
            if ((lHighestLevelSections[K_Default_Category] == nil) or
                (lHighestLevelSections[K_Default_Category] < lLevel))
              lHighestLevelSections[K_Default_Category] = lLevel
            end
            lReevaluateLevelingSection = true
          end
        elsif (lLineStripped[0..15] == '#__LVLCATBEGIN__')
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVLCATBEGIN__ ([^ ]+) ([0-9]*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            lCategory = lLineArguments[0][0]
            lLevel = lLineArguments[0][1].to_i
            lLastLevel = lHighestLevelSections[lCategory]
            if (lLastLevel == nil)
              lLastLevel = 0
            end
            if (lLevel <= lLastLevel)
              warning("#{iFileName}:#{lLineNumber}: This level section can never be activated as it is part of a category level section of level #{lLastLevel}: #{lLineStripped}")
              lOutputLine = "# !!! This level section is useless as it is part of a category level section of level #{lLastLevel}: #{lLineStripped}\n"
            end
            lLevelSections.push([lCategory,lLevel])
            if ((lHighestLevelSections[lCategory] == nil) or 
                (lHighestLevelSections[lCategory] < lLevel))
              lHighestLevelSections[lCategory] = lLevel
            end
            # Check if we can output following source code
            if (@@RCLLevels[lCategory] == nil)
              @@RCLLevels[lCategory] = 0
            end
            lReevaluateLevelingSection = true
          end
        elsif (lLineStripped[0..16] == '#__LVLRUBYBEGIN__')
          lFoundLVLMacro = true
          lLineArguments = lLineStripped.scan(/^#__LVLRUBYBEGIN__ (.*)$/)
          if (lLineArguments.size != 1)
            warning("#{iFileName}:#{lLineNumber}: Malformed line: #{lLineStripped}")
            lOutputLine = "# !!! Malformed line: #{lLineStripped}\n"
          else
            # Create a unique category for this section
            lCategory = "#{K_Ruby_Category} #{lLineNumber}"
            lRubyCode = lLineArguments[0][0]
            # Set its level to 1
            lLevelSections.push([lCategory,1])
            lHighestLevelSections[lCategory] = 1
            # Check if we can output following source code
            if (eval(lRubyCode))
              # Activate it
              @@RCLLevels[lCategory] = 1
            else
              # Do not activate it
              @@RCLLevels[lCategory] = 0
            end
            lReevaluateLevelingSection = true
          end
        elsif (lLineStripped == '#__LVLEND__')
          lFoundLVLMacro = true
          if (lLevelSections.size > 0)
            lCategory, lLevel = lLevelSections.pop
            # Recompute the highest level for lCategory
            lNewHighestLevel = 0
            lLevelSections.each do |iLevelSectionInfo|
              if ((iLevelSectionInfo[0] == lCategory) and
                  (iLevelSectionInfo[1] > lNewHighestLevel))
                lNewHighestLevel = iLevelSectionInfo[1]
              end
            end
            if (lNewHighestLevel > 0)
              lHighestLevelSections[lCategory] = lNewHighestLevel
            else
              lHighestLevelSections.delete(lCategory)
            end
            lReevaluateLevelingSection = true
          else
            warning("#{iFileName}:#{lLineNumber}: Closing level section that was not opened.")
            lOutputLine = "# !!! Closing level section that was not opened: #{lLineStripped}\n"
          end
        end
        if (lReevaluateLevelingSection)
          # Check if we can output following source code
          lLevelingSection = nil
          @@RCLLevels.each do |iCategory, iLevel|
            lLastLevel = lHighestLevelSections[iCategory]
            if (lLastLevel == nil)
              lLastLevel = 0
            end
            if (iLevel < lLastLevel)
              lLevelingSection = [ iCategory, lLastLevel ]
              break
            end
          end
        end
        lNewFileContents << lOutputLine
        lLineNumber += 1
      end
    end
    if (lFoundLVLMacro)
      # Test that level sections were all terminated correctly
      if (lLevelSections.size > 0)
        warning("#{iFileName}: Level sections were not closed properly: #{lLevelSections.size} sections are still opened. It is very unlikely that source code could run.")
        lNewFileContents << "# !!! Level sections were not closed properly: #{lLevelSections.size} sections are still opened. It is very unlikely that source code could run: #{lLevelSections.join(', ')}\n"
      end
    end
    
    return lNewFileContents, lFoundLVLMacro
  end

end

# Require method to use that loads the file by enabling/disabling code levels.
# This method works only with .rb files.
#--
# This method is not in the RCodeLeveler module as it has to evaluate the modified code
# in the root binding. Another way to do it would have been to get the root binding in
# a global variable and use it.
#++
#
# Parameters:
# * *iLibraryName* (_String_): Name of the ruby file to require.
def requireLevel(iLibraryName)
  # Do not process if it was already done (check in $" variable)
  lExtension = File.extname(iLibraryName)
  if (lExtension == '')
    lFileNameWithExt = "#{iLibraryName}.rb"
  else
    lFileNameWithExt = iLibraryName
  end
  if ($".index(lFileNameWithExt) == nil)
    # Get the real location
    lRealFileName = RCodeLeveler::getRealLibraryPath(iLibraryName)
    if (lRealFileName != nil)
      # Avoid further parsing of this file with require or requireLevel
      $" << lFileNameWithExt
      lSourceCode, lDifferent = RCodeLeveler::getSourceFileContentLevelized(lRealFileName)
      # Uncomment to dump the file being really evaluated to stdout.
      #puts '======================================================================='
      #puts '======================================================================='
      #puts lRealFileName
      #puts '======================================================================='
      #puts '======================================================================='
      #puts lSourceCode.join('')
      # And now eval the code
      eval "#{lSourceCode.join('')}", nil, lRealFileName
    else
      # Dump error
      lDirList = $:.join(', ')
      raise LoadError, "Unable to find file #{iLibraryName}. List of directories searched: #{lDirList}. Please use requireLevel with Ruby source files only."
    end
  end
end
