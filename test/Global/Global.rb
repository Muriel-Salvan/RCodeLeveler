# RCodeLeveler regression test file.
#
#--
# Copyright (c) 2007 - 2012 Muriel Salvan (muriel@x-aeon.com)
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
    RCodeLeveler.set_warning_severity(0)
    requireFile('MissingParameterDefault')
    assert_equal(nil,$Var)
  end
  def testDisplayedWarning
    # Save $stderr before altering it
    lOrgSTDERR = $stderr.clone
    # Crate the temporary file that will store $stderr
    lFile = Tempfile.new('warning')
    lFileName = lFile.path
    RCodeLeveler.set_warning_severity(1)
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
    RCodeLeveler.set_warning_severity(2)
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
  
  # Test using RCodeLeveler.get_leveled_file_content
  def testget_leveled_file_content
    RCodeLeveler::set_level(2)
    lNewContent, lDiff = RCodeLeveler.get_leveled_file_content('RequiredFiles/SimpleFile')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFile.rb", 'r') do |iFile|
      assert_not_equal(lNewContent, iFile.readlines)
    end
    assert_equal(true, lDiff)
  end
  
  # Test using RCodeLeveler.get_leveled_file_content with a file having no LVL macros
  def testget_leveled_file_contentNoLVL
    RCodeLeveler::set_level(2)
    lNewContent, lDiff = RCodeLeveler.get_leveled_file_content('RequiredFiles/SimpleFileWithNoLVL')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFileWithNoLVL.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.get_leveled_file_content with a file having useless LVL macros
  def testget_leveled_file_contentUselessLVL
    # If set to 1, nothing will be leveled.
    RCodeLeveler::set_level(1)
    lNewContent, lDiff = RCodeLeveler.get_leveled_file_content('RequiredFiles/SimpleFile')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFile.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.get_leveled_file_content with a file having useless LVL macros of blocks
  def testget_leveled_file_contentUselessLVLBlock
    # If set to 2, nothing will be leveled.
    RCodeLeveler::set_level(2)
    lNewContent, lDiff = RCodeLeveler.get_leveled_file_content('RequiredFiles/SimpleFileBlock')
    File.open("#{File.dirname(__FILE__)}/RequiredFiles/SimpleFileBlock.rb", 'r') do |iFile|
      assert_equal(iFile.readlines, lNewContent)
    end
    assert_equal(false, lDiff)
  end
  
  # Test using RCodeLeveler.get_leveled_file_content on a missing file
  def testget_leveled_file_contentMissingFile
    assert_raise(LoadError) do
      RCodeLeveler.get_leveled_file_content('RequiredFiles/MissingFile')
    end
  end
  
  # Test using RCodeLeveler.get_leveled_file_content on a non Ruby file
  def testget_leveled_file_contentNonRubyFile
    assert_raise(LoadError) do
      RCodeLeveler.get_leveled_file_content('RequiredFiles/NonRubyFile.so')
    end
  end
  
  # Test using RCodeLeveler.set_output_directory
  def testset_output_directory
    lOutputDir = Dir.tmpdir
    RCodeLeveler::set_output_directory(lOutputDir)
    RCodeLeveler::set_level(2)
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
