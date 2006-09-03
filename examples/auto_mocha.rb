class Article

  attr_reader :id

  def accepted_comments
    Comment.find_all_by_article_id(self.id).select { |comment| comment.accepted? }
  end

end

require 'rubygems'
require 'auto_mocha'
require 'test/unit'

class OrderTest < Test::Unit::TestCase

  # illustrates stubbing of previously undefined class Comment
  def test_should_return_accepted_comments_for_this_article
    unaccepted_comment = stub(:accepted? => false)
    accepted_comment = stub(:accepted? => true)
    comments = [unaccepted_comment, accepted_comment]
    Comment.stubs(:find_all_by_article_id).returns(comments)
    article = Article.new
    assert_equal [accepted_comment], article.accepted_comments
  end

end

