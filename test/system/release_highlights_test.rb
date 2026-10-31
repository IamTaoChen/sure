require "application_system_test_case"

class ReleaseHighlightsSystemTest < ApplicationSystemTestCase
  setup do
    @user = users(:family_admin)
    @user.update!(preferences: { "last_seen_release_tag" => "v0.7.5" })
    Sure.stubs(:version).returns(Semver.new("0.7.5-hotfix.1"))
    Provider::Github.any_instance.expects(:fetch_release_notes).never
    sign_in @user
  end

  test "an unseen release stays hidden after interaction and reload" do
    assert_no_selector "[data-controller='release-highlight']", visible: :all
    find("h1", text: @user.first_name).click
    assert_no_selector "dialog[open]"

    refresh
    assert_no_selector "[data-controller='release-highlight']", visible: :all
    refute @user.reload.release_seen?("v0.7.5-hotfix.1")
    page.save_screenshot(Rails.root.join("tmp/screenshots/hidden-release-highlights.png"))
  end
end
