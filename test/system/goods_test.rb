require "application_system_test_case"

class GoodsTest < ApplicationSystemTestCase
  setup do
    @good = goods(:one)
  end

  test "visiting the index" do
    visit goods_url
    assert_selector "h1", text: "Goods"
  end

  test "should create good" do
    visit goods_url
    click_on "New good"

    fill_in "Brand", with: @good.brand
    fill_in "Code", with: @good.code
    fill_in "Colour", with: @good.colour
    fill_in "Price", with: @good.price
    fill_in "Quantity", with: @good.quantity
    fill_in "Size", with: @good.size
    click_on "Create Good"

    assert_text "Good was successfully created"
    click_on "Back"
  end

  test "should update Good" do
    visit good_url(@good)
    click_on "Edit this good", match: :first

    fill_in "Brand", with: @good.brand
    fill_in "Code", with: @good.code
    fill_in "Colour", with: @good.colour
    fill_in "Price", with: @good.price
    fill_in "Quantity", with: @good.quantity
    fill_in "Size", with: @good.size
    click_on "Update Good"

    assert_text "Good was successfully updated"
    click_on "Back"
  end

  test "should destroy Good" do
    visit good_url(@good)
    click_on "Destroy this good", match: :first

    assert_text "Good was successfully destroyed"
  end
end
