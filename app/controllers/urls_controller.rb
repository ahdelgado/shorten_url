class UrlsController < ApplicationController
  before_action :get_url,         only: [:destroy, :edit, :update]
  before_action :get_urls,        only: [:create, :index]

  RECORDS_PER_PAGE = 6

  def index
  end

  def new
    @url = Url.new
  end

  def show
    @url = Url.find_by_short_url(params[:short_url])
    redirect_to @url.long_url
  end
  
  def create
    @url = Url.new(url_params)
    @url.clean  unless @url.long_url.nil? || @url.long_url.empty? # always clean before saving
    if @url.save
      flash[:success] = 'Short URL generated!'
      redirect_to urls_path(page: @urls.total_pages)
    else
      render 'new'
    end
  end

  def edit
    session[:return_to] ||= request.referer
  end

  def update
    @url.long_url = url_params[:long_url]
    @url.clean  unless @url.long_url.nil? || @url.long_url.empty? # always clean before saving
    if !Url.where(long_url: @url.long_url).exists? && @url.save
      flash[:success] = 'New short URL generated!'
      redirect_to session.delete(:return_to)
    else
      flash[:warning] = 'URL already exists in database.'
      render 'edit'
    end
  end
      
  def destroy
    @url.destroy
    flash[:success] = 'Short URL deleted'
    redirect_to urls_path
  end
  
  private

    def url_params
      params.require(:url).permit(:long_url)
    end

    def get_url
      @url = Url.find(params[:id])
    end

    def get_urls
      @urls = Url.page(params[:page]).per_page(RECORDS_PER_PAGE)
    end
end