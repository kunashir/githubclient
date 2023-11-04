require "test_helper"

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  test "should be success without any params" do
    VCR.use_cassette("no_param_search") do
      get repositories_index_url
      assert_response :success
    end
  end

  test "should be success with search params" do
    VCR.use_cassette("search_success") do
      visit repositories_index_url(q: "adjust")
      assert page.has_selector?("div.result")
      assert page.has_selector?("li", count: 30)
    end
  end

  test "should be success with specific per_page value" do
    VCR.use_cassette("search_success_different_per_page") do
      visit repositories_index_url(q: "adjust", per_page: 10)
      assert page.has_selector?("div.result")
      assert page.has_selector?("li", count: 10)
    end
  end

  test "should be success with specific page value" do
    VCR.use_cassette("search_success_different_page") do
      visit repositories_index_url(q: "adjust", page: 10)
      assert page.has_selector?("div.result")
    end
  end

  test "should be success with invalid page value" do
    VCR.use_cassette("search_success_bad_page") do
      visit repositories_index_url(q: "adjust", page: 100_000)
      assert_not page.has_selector?("div.result")
    end
  end
end
