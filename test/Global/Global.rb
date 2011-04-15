# RCodeLeveler regression test file.
#
#--
# Copyright (c) 2007 - 2011 Muriel Salvan (murielsalvan@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Add as many .. as needed to reach the test directory
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'RCodeLevelerTest'

# For the redirection of $stderr
require 'tempfile'

# Test global parameters
class TestGlobal < Test::Unit::TestCase

  include RCodeLevelerTest
  def setup
    setRootDir(File.dirname(__FILE__))
  end
  
  # Test warning severities
  def testNoWarning
    RCodeLeveler.setWarningSeverity(0)
    requireFile('MissingParameterDefault')
    assert_equal(nil,$Var)
  end
  def testDisplayedWarning
    # Save $stderr before altering it
    lOrgSTDERR = $stderr.clone
    # Crate the temporary file that will store $stderr
    lFile = Tempfile.new('warning')
    lFileName = lFile.path
    RCodeLeveler.setWarningSeverity(1)
    $stderr.reopen(lFile)
    begin
      requireFile('MissingParameterDefault')
    rescue
      # Reaffect $stderr before exiting
      $stderr.reopen(lOrgSTDERR)
      raise
    end
    # Reaffect $stderr
    $stderr.reopen(lOrgSTDERR)
    assert_equal(nil,$Var)
    lFile.close
    # Check content
    File.open(lFileName,'r') do |iFile|
      assert_equal(["RCodeLeveler - warning: #{File.dirname(__FILE__)}/RequiredFiles/MissingParameterDefault.rb:10: Malformed line: #__LVL__ $Var = 1\n"], iFile.readlines)
    end
    File.delete(lFileName)
  end
  def testExceptionWarning
    RCodeLeveler.setWarningSeverity(2)
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingParameterDefault')
    end
    assert_equal(nil,$Var)
  end

  # Test missing file
  def testMissingFile
    assert_raise(LoadError) do
      requireFile('MissingFile')
    end
  end
  
  # Test non Ruby file
  def testNonRubyFile
    assert_raise(LoadError) do
      requireFile('NonRubyFile.so')
    end
  end
  
  # Test using RCodeLeveler.getLeveledFileContent
  def testgetLeveledFileContent
    RCodeLeveler::setLevel(2)
    lNewContent, lDiff = RCodeLeveler.getLeveledFileContent('RequiredFiles/SimpleFile')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFile.rb", 'r') do |iFile|
      assert_not_equal(lNewContent, iFile.readlines)
    end
    assert_equal(true, lDiff)
  end
  
  # Test using RCodeLeveler.getLeveledFileContent with a file having no LVL macros
  def testgetLeveledFileContentNoLVL
    RCodeLeveler::setLevel(2)
    lNewContent, lDiff = RCodeLeveler.getLeveledFileContent('RequiredFiles/SimpleFileWithNoLVL')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFileWithNoLVL.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.getLeveledFileContent with a file having useless LVL macros
  def testgetLeveledFileContentUselessLVL
    # If set to 1, nothing will be leveled.
    RCodeLeveler::setLevel(1)
    lNewContent, lDiff = RCodeLeveler.getLeveledFileContent('RequiredFiles/SimpleFile')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFile.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.getLeveledFileContent with a file having useless LVL macros of blocks
  def testgetLeveledFileContentUselessLVLBlock
    # If set to 2, nothing will be leveled.
    RCodeLeveler::setLevel(2)
    lNewContent, lDiff = RCodeLeveler.getLeveledFileContent('RequiredFiles/SimpleFileBlock')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFileBlock.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.getLeveledFileContent on a missing file
  def testgetLeveledFileContentMissingFile
    assert_raise(LoadError) do
      RCodeLeveler.getLeveledFileContent('RequiredFiles/MissingFile')
    end
  end
  
  # Test using RCodeLeveler.getLeveledFileContent on a non Ruby file
  def testgetLeveledFileContentNonRubyFile
    assert_raise(LoadError) do
      RCodeLeveler.getLeveledFileContent('RequiredFiles/NonRubyFile.so')
    end
  end
  
  # Test using RCodeLeveler.setOutputDirectory
  def testsetOutputDirectory
    lOutputDir = Dir.tmpdir
    RCodeLeveler::setOutputDirectory(lOutputDir)
    RCodeLeveler::setLevel(2)
    requireFile('SimpleFile')
    lOutputFileName = "#{lOutputDir}/RequiredFiles/SimpleFile.leveled.rb"
    assert(File.exist?(lOutputFileName))
    lNewContent = nil
    File.open(lOutputFileName, 'r') do |iNewFile|
      lNewContent = iNewFile.readlines
    end
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFile.rb", 'r') do |iFile|
      assert_not_equal(iFile.readlines, lNewContent)
    end
    # Remove the new file
    File.delete(lOutputFileName)
  end
  
end
