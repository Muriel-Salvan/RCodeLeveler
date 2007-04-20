# RCodeLeveler regression test file.
#
#--
# Copyright (c) 2007 Muriel Salvan (muriel_@users.sourceforge.net)
# Licensed under the terms specified in LICENSE file. No warranty is provided.
#++

# Add as many .. as needed to reach the test directory
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '..'))
require 'RCodeLevelerTest'

# Test level sections embedded
class TestEmbeddingSections < Test::Unit::TestCase

  include RCodeLevelerTest
  def setup
    setRootDir(File.dirname(__FILE__))
  end

  # Test basic embedding a comment
  def testCommentInEmbedded2
    RCodeLeveler::setLevel(2)
    requireFile('CommentInEmbedded')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testCommentInEmbedded4
    RCodeLeveler::setLevel(4)
    requireFile('CommentInEmbedded')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testCommentInEmbedded6
    RCodeLeveler::setLevel(6)
    requireFile('CommentInEmbedded')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test basic embedding an uncomment
  def testUncommentInEmbedded2
    RCodeLeveler::setLevel(2)
    requireFile('UncommentInEmbedded')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUncommentInEmbedded4
    RCodeLeveler::setLevel(4)
    requireFile('UncommentInEmbedded')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUncommentInEmbedded6
    RCodeLeveler::setLevel(6)
    requireFile('UncommentInEmbedded')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test ruby level embedding a Ruby comment
  def testRubyEmbeddingRubyCommentFF
    $CondVar1 = false
    $CondVar2 = false
    requireFile('RubyEmbeddingRubyComment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingRubyCommentTF
    $CondVar1 = true
    $CondVar2 = false
    requireFile('RubyEmbeddingRubyComment')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingRubyCommentFT
    $CondVar1 = false
    $CondVar2 = true
    requireFile('RubyEmbeddingRubyComment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingRubyCommentTT
    $CondVar1 = true
    $CondVar2 = true
    requireFile('RubyEmbeddingRubyComment')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test ruby level embedding a default uncomment
  def testRubyEmbeddingDefaultUncommentF2
    $CondVar = false
    RCodeLeveler::setLevel(2)
    requireFile('RubyEmbeddingDefault')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingDefaultUncommentT2
    $CondVar = true
    RCodeLeveler::setLevel(2)
    requireFile('RubyEmbeddingDefault')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingDefaultUncommentF4
    $CondVar = false
    RCodeLeveler::setLevel(4)
    requireFile('RubyEmbeddingDefault')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testRubyEmbeddingDefaultUncommentT4
    $CondVar = true
    RCodeLeveler::setLevel(4)
    requireFile('RubyEmbeddingDefault')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end

  # Test default level embedding a ruby uncomment
  def testDefaultEmbeddingRubyUncomment2F
    RCodeLeveler::setLevel(2)
    $CondVar = false
    requireFile('DefaultEmbeddingRuby')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testDefaultEmbeddingRubyUncomment4F
    RCodeLeveler::setLevel(4)
    $CondVar = false
    requireFile('DefaultEmbeddingRuby')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testDefaultEmbeddingRubyUncomment2T
    RCodeLeveler::setLevel(2)
    $CondVar = true
    requireFile('DefaultEmbeddingRuby')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testDefaultEmbeddingRubyUncomment4T
    RCodeLeveler::setLevel(4)
    $CondVar = true
    requireFile('DefaultEmbeddingRuby')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test embedding 3 levels of different categories
  def testEmbedded3LevelsDifferentCategories0
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories1
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories2
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories3
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories12
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories13
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories23
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategories123
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    requireFile('Embedded3LevelsDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
  end
  
  # Test embedding 3 levels with 1 different category between
  def testEmbedded3LevelsDifferentCategoryBetween0
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategoryBetween1
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategoryBetween2
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategoryBetween12
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategoryBetween13
    RCodeLeveler::setLevel(8,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsDifferentCategoryBetween123
    RCodeLeveler::setLevel(8,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    requireFile('Embedded3LevelsDifferentCategoryBetween')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
  end
  
  # Test embedding 3 levels of the same category
  def testEmbedded3LevelsSameCategory0
    RCodeLeveler::setLevel(2,'MyCat')
    requireFile('Embedded3LevelsSameCategory')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsSameCategory1
    RCodeLeveler::setLevel(4,'MyCat')
    requireFile('Embedded3LevelsSameCategory')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsSameCategory12
    RCodeLeveler::setLevel(6,'MyCat')
    requireFile('Embedded3LevelsSameCategory')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsSameCategory123
    RCodeLeveler::setLevel(8,'MyCat')
    requireFile('Embedded3LevelsSameCategory')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
  end
  
  # Test embedding a category in the default category
  def testEmbeddedCategoryInDefault0
    RCodeLeveler::setLevel(2)
    RCodeLeveler::setLevel(4,'MyCat')
    requireFile('EmbeddedCategoryInDefault')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedCategoryInDefault1
    RCodeLeveler::setLevel(4)
    RCodeLeveler::setLevel(4,'MyCat')
    requireFile('EmbeddedCategoryInDefault')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedCategoryInDefault2
    RCodeLeveler::setLevel(2)
    RCodeLeveler::setLevel(6,'MyCat')
    requireFile('EmbeddedCategoryInDefault')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedCategoryInDefault12
    RCodeLeveler::setLevel(4)
    RCodeLeveler::setLevel(6,'MyCat')
    requireFile('EmbeddedCategoryInDefault')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test embedding the default category in a category
  def testEmbeddedDefaultInCategory0
    RCodeLeveler::setLevel(2,'MyCat')
    RCodeLeveler::setLevel(4)
    requireFile('EmbeddedDefaultInCategory')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDefaultInCategory1
    RCodeLeveler::setLevel(4,'MyCat')
    RCodeLeveler::setLevel(4)
    requireFile('EmbeddedDefaultInCategory')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDefaultInCategory2
    RCodeLeveler::setLevel(2,'MyCat')
    RCodeLeveler::setLevel(6)
    requireFile('EmbeddedDefaultInCategory')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDefaultInCategory12
    RCodeLeveler::setLevel(4,'MyCat')
    RCodeLeveler::setLevel(6)
    requireFile('EmbeddedDefaultInCategory')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test embedding 2 different categories
  def testEmbeddedDifferentCategories0
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('EmbeddedDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDifferentCategories1
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('EmbeddedDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDifferentCategories2
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    requireFile('EmbeddedDifferentCategories')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbeddedDifferentCategories12
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    requireFile('EmbeddedDifferentCategories')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test embedding 4 sections in 3 levels:
  # 1
  # +- 2
  # +- 3
  #    +- 4
  def testEmbeddedSeveral3Levels0
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels1
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels2
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels3
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels4
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels12
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels13
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(1,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels14
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels23
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels24
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels34
    RCodeLeveler::setLevel(2,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels123
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(8,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels124
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(6,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
    assert_equal(nil,$Var4)
  end
  def testEmbeddedSeveral3Levels1234
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(6,'Cat2')
    RCodeLeveler::setLevel(8,'Cat3')
    RCodeLeveler::setLevel(10,'Cat4')
    requireFile('EmbeddedSeveral3Levels')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
    assert_equal(1,$Var4)
  end

  # Test embedding 2 different categories, with a lower level inside
  def testEmbedLowerLevelDifferentCategory0
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(2,'Cat2')
    requireFile('EmbedLowerLevelDifferentCategory')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbedLowerLevelDifferentCategory1
    RCodeLeveler::setLevel(6,'Cat1')
    RCodeLeveler::setLevel(2,'Cat2')
    requireFile('EmbedLowerLevelDifferentCategory')
    assert_equal(1,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbedLowerLevelDifferentCategory2
    RCodeLeveler::setLevel(4,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('EmbedLowerLevelDifferentCategory')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testEmbedLowerLevelDifferentCategory12
    RCodeLeveler::setLevel(6,'Cat1')
    RCodeLeveler::setLevel(4,'Cat2')
    requireFile('EmbedLowerLevelDifferentCategory')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end

  # Test useless embedding for comment
  def testUselessEmbeddedCommentException
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('UselessEmbeddedComment')
    end
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedCommentNoWarning2
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(2)
    requireFile('UselessEmbeddedComment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedCommentNoWarning4
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(4)
    requireFile('UselessEmbeddedComment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedCommentNoWarning6
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(6)
    requireFile('UselessEmbeddedComment')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
  # Test useless embedding for uncomment
  def testUselessEmbeddedUncommentException
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('UselessEmbeddedUncomment')
    end
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedUncommentNoWarning2
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(2)
    requireFile('UselessEmbeddedUncomment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedUncommentNoWarning4
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(4)
    requireFile('UselessEmbeddedUncomment')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedUncommentNoWarning6
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(6)
    requireFile('UselessEmbeddedUncomment')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end

  # Test useless intermediate level in a 3 levels embedding
  def testEmbedded3LevelsUselessBetween0
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(2,'Cat1')
    RCodeLeveler.setLevel(6,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsUselessBetween2
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(4,'Cat1')
    RCodeLeveler.setLevel(6,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsUselessBetween3
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(2,'Cat1')
    RCodeLeveler.setLevel(8,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsUselessBetween12
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(6,'Cat1')
    RCodeLeveler.setLevel(6,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsUselessBetween23
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(4,'Cat1')
    RCodeLeveler.setLevel(8,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
    assert_equal(nil,$Var3)
  end
  def testEmbedded3LevelsUselessBetween123
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(6,'Cat1')
    RCodeLeveler.setLevel(8,'Cat2')
    requireFile('Embedded3LevelsUselessBetween')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
    assert_equal(1,$Var3)
  end
  
  # Test useless embedding for comment of the same level
  def testUselessEmbeddedCommentSameLevelException
    assert_raise(RCodeLeveler::ParseError) do
      requireFile('UselessEmbeddedCommentSameLevel')
    end
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedCommentSameLevelNoWarning2
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(2)
    requireFile('UselessEmbeddedCommentSameLevel')
    assert_equal(nil,$Var1)
    assert_equal(nil,$Var2)
  end
  def testUselessEmbeddedCommentSameLevelNoWarning4
    RCodeLeveler.setWarningSeverity(0)
    RCodeLeveler.setLevel(4)
    requireFile('UselessEmbeddedCommentSameLevel')
    assert_equal(1,$Var1)
    assert_equal(1,$Var2)
  end
  
end
