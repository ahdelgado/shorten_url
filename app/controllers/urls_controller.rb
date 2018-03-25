class UrlsController < ApplicationController
  before_action :get_url,         only: [:destroy, :edit, :update]

  def index
    @urls = Url.paginate(page: params[:page])
  end

  def new
    @url = Url.new
  end

  def show
    @url = Url.find_by_short_url(params[:short_url])
    redirect_to @url.url
  end
  
  def create
    @url = Url.new(url_params)
    @url.clean  # always clean before saving
    if @url.save
      flash[:success] = 'Short URL generated!'
      redirect_to urls_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @url.long_url = url_params[:long_url]
    @url.clean  # always clean before saving
    if !Url.where(url: @url.url).exists? && @url.save
      flash[:success] = 'New short URL generated!'
      redirect_to urls_path
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

end
