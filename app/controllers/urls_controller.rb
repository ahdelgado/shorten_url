class UrlsController < ApplicationController
  def index
    @urls = Url.paginate(page: params[:page])
  end

  def new
    @url = Url.new
  end

  def show
    @url = Url.find(params[:id])
    redirect_to @url.long_url
  end
  
  def create
    @url = Url.new(url_params)
    @url.long_url = url_params[:long_url]
    @url.short_url = @url.shorten_url(url_params[:long_url])
    if @url.save
      flash[:success] = 'Short URL generated!'
      redirect_to urls_path
    else
      render 'new'
    end
  end
      
  def destroy
    Url.find(params[:id]).destroy
    flash[:success] = "URL deleted"
    redirect_to index_path
  end
  
  private

    def url_params
      params.require(:url).permit(:long_url)
    end

end
