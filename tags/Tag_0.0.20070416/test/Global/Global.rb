# RCodeLeveler regression test file.
#
#--
# Copyright (c) 2007 Muriel Salvan (muriel_@users.sourceforge.net)
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
  
end
