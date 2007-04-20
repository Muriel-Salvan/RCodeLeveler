# RCodeLeveler regression test file.
#
#--
# Copyright (c) 2007 Muriel Salvan (muriel_@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Add as many .. as needed to reach the test directory
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'RCodeLevelerTest'

# Test uncommenting lines
class TestSimpleUncomment < Test::Unit::TestCase

  include RCodeLevelerTest
  def setup
    setRootDir(File.dirname(__FILE__))
  end

  # Test default uncomment
  def testDefaultNIL
    requireFile('Default')
    assert_equal(nil,$Var)
  end
  def testDefaultLower
    RCodeLeveler::setLevel(2)
    requireFile('Default')
    assert_equal(nil,$Var)
  end
  def testDefaultEqual
    RCodeLeveler::setLevel(3)
    requireFile('Default')
    assert_equal(1,$Var)
  end
  def testDefaultGreater
    RCodeLeveler::setLevel(4)
    requireFile('Default')
    assert_equal(1,$Var)
  end
  def testDefaultReset
    RCodeLeveler::setLevel(3)
    RCodeLeveler::resetLevels
    requireFile('Default')
    assert_equal(nil,$Var)
  end
  
  # Test category uncomment
  def testCategoryNIL
    requireFile('Category')
    assert_equal(nil,$Var)
  end
  def testCategoryLower
    RCodeLeveler::setLevel(2,'MyCat')
    requireFile('Category')
    assert_equal(nil,$Var)
  end
  def testCategoryEqual
    RCodeLeveler::setLevel(3,'MyCat')
    requireFile('Category')
    assert_equal(1,$Var)
  end
  def testCategoryGreater
    RCodeLeveler::setLevel(4,'MyCat')
    requireFile('Category')
    assert_equal(1,$Var)
  end
  def testCategoryOther
    RCodeLeveler::setLevel(3,'MyCatUnknown')
    requireFile('Category')
    assert_equal(nil,$Var)
  end
  def testCategoryReset
    RCodeLeveler::setLevel(3,'MyCat')
    RCodeLeveler::resetLevels
    requireFile('Category')
    assert_equal(nil,$Var)
  end
  
  # Test ruby uncomment
  def testRubyUncomment
    $CondVar = true
    requireFile('Ruby')
    assert_equal(1,$Var)
  end
  def testRubyComment
    $CondVar = false
    requireFile('Ruby')
    assert_equal(nil,$Var)
  end
  
  # Test accessing RCodeLeveler variables from ruby uncomment
  def testRubyDefaultLevel2
    RCodeLeveler::setLevel(2)
    requireFile('RubyDefaultLevel')
    assert_equal(nil,$Var)
  end
  def testRubyDefaultLevel4
    RCodeLeveler::setLevel(4)
    requireFile('RubyDefaultLevel')
    assert_equal(1,$Var)
  end
  def testRubyCategoryLevel2
    RCodeLeveler::setLevel(2,'MyCat')
    requireFile('RubyCategoryLevel')
    assert_equal(nil,$Var)
  end
  def testRubyCategoryLevel4
    RCodeLeveler::setLevel(4,'MyCat')
    requireFile('RubyCategoryLevel')
    assert_equal(1,$Var)
  end

  # Test several levels in the same file
  def testSeveralNone
    RCodeLeveler::setLevel(2)
    requireFile('Several')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testCategory1
    RCodeLeveler::setLevel(4)
    requireFile('Several')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testCategory2
    RCodeLeveler::setLevel(6)
    requireFile('Several')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test missing parameters for defaut
  def testMissingParameterDefault
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingParameterDefault')
    end
    assert_equal(nil,$Var)
  end
  
  # Test missing parameters for category
  def testMissingParametersCategory
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingParametersCategory')
    end
    assert_equal(nil,$Var)
  end
  
  # Test missing level for category
  def testMissingLevelCategory
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingLevelCategory')
    end
    assert_equal(nil,$Var)
  end
  
  # Test missing category for category
  def testMissingCategoryCategory
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingCategoryCategory')
    end
    assert_equal(nil,$Var)
  end
  
  # Test missing code for ruby
  def testMissingCodeRuby
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('MissingCodeRuby')
    end
    assert_equal(nil,$Var)
  end
  
end
