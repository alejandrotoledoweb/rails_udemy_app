require "test_helper"

class LessosnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lessosn = lessosns(:one)
  end

  test "should get index" do
    get lessosns_url
    assert_response :success
  end

  test "should get new" do
    get new_lessosn_url
    assert_response :success
  end

  test "should create lessosn" do
    assert_difference("Lessosn.count") do
      post lessosns_url, params: { lessosn: { content: @lessosn.content, course_id: @lessosn.course_id, title: @lessosn.title } }
    end

    assert_redirected_to lessosn_url(Lessosn.last)
  end

  test "should show lessosn" do
    get lessosn_url(@lessosn)
    assert_response :success
  end

  test "should get edit" do
    get edit_lessosn_url(@lessosn)
    assert_response :success
  end

  test "should update lessosn" do
    patch lessosn_url(@lessosn), params: { lessosn: { content: @lessosn.content, course_id: @lessosn.course_id, title: @lessosn.title } }
    assert_redirected_to lessosn_url(@lessosn)
  end

  test "should destroy lessosn" do
    assert_difference("Lessosn.count", -1) do
      delete lessosn_url(@lessosn)
    end

    assert_redirected_to lessosns_url
  end
end
