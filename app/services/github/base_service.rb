# Base service
# inialize the client for all child classes

module Github
  TOKEN = ENV["GITHUB_ACCESSTOKEN"]

  class BaseService
    attr_reader :client

    def self.perform(*args)
      new(*args).perform
    end

    def initialize
      @client = Octokit::Client.new(access_token: TOKEN)
    end
  end
end
