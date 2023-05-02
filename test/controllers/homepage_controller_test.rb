require 'test_helper'

class HomepageControllerTest < ActionDispatch::IntegrationTest
  # Test the "index" action
  test 'should get index' do
    get root_url
    assert_response :success
  end

  # Test the "search" action
  test 'should post search' do
    post homepage_search_url, params: { question: 'Where art thou Romeo?', book: 'The Great Gatsby' }
    assert_response :success
  end

  # Test the "get_recent_questions" action
  test 'should get get_recent_questions' do
    get homepage_get_recent_questions_url
    assert_response :success
  end

  # Test the "delete_recent_question" action
  test 'should post delete_recent_question' do
    post homepage_delete_recent_question_url, params: { question: 'Question 4', book: 'The Great Gatsby' }
    assert_response :success
  end

end
