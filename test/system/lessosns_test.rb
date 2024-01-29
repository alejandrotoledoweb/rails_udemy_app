require "application_system_test_case"

class LessosnsTest < ApplicationSystemTestCase
  setup do
    @lessosn = lessosns(:one)
  end

  test "visiting the index" do
    visit lessosns_url
    assert_selector "h1", text: "Lessosns"
  end

  test "should create lessosn" do
    visit lessosns_url
    click_on "New lessosn"

    fill_in "Content", with: @lessosn.content
    fill_in "Course", with: @lessosn.course_id
    fill_in "Title", with: @lessosn.title
    click_on "Create Lessosn"

    assert_text "Lessosn was successfully created"
    click_on "Back"
  end

  test "should update Lessosn" do
    visit lessosn_url(@lessosn)
    click_on "Edit this lessosn", match: :first

    fill_in "Content", with: @lessosn.content
    fill_in "Course", with: @lessosn.course_id
    fill_in "Title", with: @lessosn.title
    click_on "Update Lessosn"

    assert_text "Lessosn was successfully updated"
    click_on "Back"
  end

  test "should destroy Lessosn" do
    visit lessosn_url(@lessosn)
    click_on "Destroy this lessosn", match: :first

    assert_text "Lessosn was successfully destroyed"
  end
end
