# Class encapsulate repositories search
# @param query [String] Search term and qualifiers
# @param options [Integer] :page Page of paginated results
# @param options [Integer] :per_page Number of items per page

module Github
  class RepositoryCollection
    attr_reader :repos, :total_count, :page, :per_page

    def initialize(repos:, total_count:, page:, per_page:)
      @repos = repos
      @total_count = total_count
      @page = page
      @per_page = per_page
    end

    def current_page
      page.to_i || 1
    end

    def total_pages
      total_count / per_page.to_i
    end

    def limit_value
      per_page
    end

    def items
      repos
    end
  end

  class SearchRepoService < BaseService
    attr_reader :query, :options

    PER_PAGE = 30

    def initialize(query, options = {})
      super()
      @query = query
      @options = options
    end

    def perform
      response = client.search_repositories(query, options)
      total_count = response.total_count
      RepositoryCollection.new(repos: response.items, total_count: total_count, page: options[:page] || 1, per_page: options[:per_page] || PER_PAGE)
    rescue Octokit::UnprocessableEntity, Faraday::ConnectionFailed
      # TODO: return info about exception if possible (valid point for 422)
      nil
    end
  end
end
