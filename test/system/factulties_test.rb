require "application_system_test_case"

class FactultiesTest < ApplicationSystemTestCase
  setup do
    @factulty = factulties(:one)
  end

  test "visiting the index" do
    visit factulties_url
    assert_selector "h1", text: "Factulties"
  end

  test "should create factulty" do
    visit factulties_url
    click_on "New factulty"

    fill_in "Name", with: @factulty.name
    fill_in "School", with: @factulty.school_id
    click_on "Create Factulty"

    assert_text "Factulty was successfully created"
    click_on "Back"
  end

  test "should update Factulty" do
    visit factulty_url(@factulty)
    click_on "Edit this factulty", match: :first

    fill_in "Name", with: @factulty.name
    fill_in "School", with: @factulty.school_id
    click_on "Update Factulty"

    assert_text "Factulty was successfully updated"
    click_on "Back"
  end

  test "should destroy Factulty" do
    visit factulty_url(@factulty)
    click_on "Destroy this factulty", match: :first

    assert_text "Factulty was successfully destroyed"
  end
end
