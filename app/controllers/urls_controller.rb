class UrlsController < ApplicationController
  before_action :get_url,         only: [:show, :destroy, :edit]

  def index
    @urls = Url.paginate(page: params[:page])
  end

  def new
    @url = Url.new
  end

  def show
    redirect_to @url.url
  end
  
  def create
    @url = Url.new(url_params)
    @url.clean
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
  end
      
  def destroy
    @url.destroy
    flash[:success] = 'URL deleted'
    redirect_to index_path
  end
  
  private

    def url_params
      params.require(:url).permit(:long_url)
    end

    def get_url
      @url = Url.find(params[:id])
    end

end
