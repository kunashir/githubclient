class RepositoriesController < ApplicationController
  def index
    @repositories = nil
    @repositories = Github::SearchRepoService.perform(search_params[:q], per_page: search_params[:per_page], page: search_params[:page])
  end

  private

  def search_params
    params.permit(:q, :per_page, :page)
  end
end
