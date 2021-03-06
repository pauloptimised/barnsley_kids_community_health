class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :global_site_settings, :set_service, :set_main_navigation, :set_service_navigation
  layout :set_layout

  def index
    if @service
      @presented_testimonial = TestimonialPresenter.new(object: @service.testimonials.displayed.service_home.last, view_template: view_context)
      @presented_faqs = BaseCollectionPresenter.new(collection: @service.frequently_asked_questions.displayed.service_home, view_template: view_context,
                                                    presenter: FrequentlyAskedQuestionPresenter)
      render template: "services/show"
    else
      @presented_banners = BaseCollectionPresenter.new(collection: Banner.displayed.order(position: :asc), view_template: view_context, presenter: BannerPresenter)
      @presented_services = BaseCollectionPresenter.new(collection: Service.displayed.order(position: :asc), view_template: view_context, presenter: ServicePresenter)
      article = Article.published.order(date: :desc).first
      @presented_article = ArticlePresenter.new(object: article, view_template: view_context) if article
    end
  end

  private

  def set_main_navigation
    @header_menu = Optimadmin::Menu.new(name: "header")
    @footer_menu = Optimadmin::Menu.new(name: "footer")
  end

  def set_service
    @service = Service.displayed.find_by(subdomain: request.subdomain)
    #@service = Service.find(1) if Rails.env.development?
    # this has to be here to be global
    @presented_service = ServicePresenter.new(object: @service, view_template: view_context) if @service
  end

  def set_service_navigation
    return nil if @service.nil?
    @service_menu = Optimadmin::Menu.new(name: @service.menu_name)
  end

  def global_site_settings
    @global_site_settings ||= Optimadmin::SiteSetting.current_environment
  end
  helper_method :global_site_settings

  def set_layout
    if @service.blank?
      "application"
    else
      "service"
    end
  end
end
