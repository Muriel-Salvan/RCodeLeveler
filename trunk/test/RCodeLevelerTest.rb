# RCodeLeveler common test file.
#
# This file defines all common methods for regression testing.
# It has to be included by any regression testing file.
#--
# Copyright (c) 2007 Muriel Salvan (muriel_@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

require 'rcodeleveler'
require 'test/unit'

# This module defines all the functions needed by the test cases
module RCodeLevelerTest

  # Change the root dir.
  # This is used by each usecase to inform the directory where Required Files are.
  # Clean files from RequiredFiles directories from Ruby's files cache $".
  # Clean variables set by required files: $Var, $Var1..4.
  # Add the root dir to $LOAD_PATH.
  # Reset all previously set levels.
  # Reset warning severity to 2.
  #
  # Parameters:
  # * *iRootDir* (_String_): The root dir (containing the FileSystems directory)
  def setRootDir(iRootDir)
    @RootDir = iRootDir
    $".delete_if do |iFileName|
      iFileName[0..13] == 'RequiredFiles/'
    end
    $Var = nil
    $Var1 = nil
    $Var2 = nil
    $Var3 = nil
    $Var4 = nil
    if (!$LOAD_PATH.include?(iRootDir))
      $LOAD_PATH << iRootDir
    end
    RCodeLeveler.resetLevels
    RCodeLeveler.setWarningSeverity(2)
    RCodeLeveler.setOutputDirectory(nil)
  end
  
  # Remove the directory that includes RequiredFiles for the next tests.
  # Otherwise it is possible that files getting same names in different
  # RequiredFiles directories are messed up in the requireFile method.
  def teardown
    $LOAD_PATH.delete_if do |iDirName|
      iDirName == @RootDir
    end
  end
  
  # Require a file to be loaded.
  #
  # Parameters:
  # * *iRequiredFileName* (_String_): Name of the Required File being operated by further tests.
  def requireFile(iRequiredFileName)
    requireLevel("RequiredFiles/#{iRequiredFileName}")
  end
  
end

# Requires recursively ruby files in sub-directories
#
# Parameters:
# * *iDir* (_String_): The directory to check
# * *iRequireThisDir* (_Boolean_): Do we require the .rb files of this directory ?
def requireTestRubyFiles(iDir, iRequireThisDir)
  Dir.foreach(iDir) do |iFileName|
    lFileName = "#{iDir}/#{iFileName}"
    if (File.directory?(lFileName))
      if ((iFileName != '.') and
          (iFileName != '..') and
          (iFileName != 'RequiredFiles'))
        # Recursion
        requireTestRubyFiles(lFileName, true)
      end
    else
      # If it is a ruby file, we might need to require it.
      if ((File.extname(iFileName) == '.rb') and
          iRequireThisDir)
        # Require it
        require lFileName
      end
    end
  end
end

# Automatically require all the ruby files in the sub-directories that are not FileSystems
requireTestRubyFiles(File.dirname(__FILE__), false)
