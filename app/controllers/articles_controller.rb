class ArticlesController < ApplicationController
  before_action :set_article, only: [:show]

  def index
    @presented_articles = BaseCollectionPresenter.new(collection: Article.published.order(date: :desc).page(params[:page]).per(params[:per_page] || 15), view_template: view_context, presenter: ArticlePresenter)
  end

  def show
    redirect_to @presented_article, status: :moved_permanently if article_path(@article) != request.path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_article
    @article = Article.published.friendly.find(params[:id])
    @presented_article = ArticlePresenter.new(object: @article, view_template: view_context)
  end

end