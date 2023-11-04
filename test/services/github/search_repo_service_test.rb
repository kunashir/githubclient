require "test_helper"

class Github::SearchRepoServiceTest < ActiveSupport::TestCase
  attr_reader :query, :options

  def setup
    @query = "rails"
    @options = {per_page: 30, page: 2}
  end

  def test_perform
    VCR.use_cassette("github_repositories_search") do
      result = Github::SearchRepoService.perform(query, options)
      assert_equal Github::RepositoryCollection, result.class
      assert_equal 30, result.items.size
      assert_equal 2, result.page
    end
  end

  def test_perform_bad_params
    VCR.use_cassette("github_repositories_search_bad_page") do
      options = {per_page: 1_000_000, page: 1_000_000}
      refute Github::SearchRepoService.perform(query, options)
    end
  end

  def test_peform_request_failer
    Octokit::Client.any_instance.expects(:search_repositories).raises(Octokit::UnprocessableEntity)
    refute Github::SearchRepoService.perform(query, options)
  end
end
