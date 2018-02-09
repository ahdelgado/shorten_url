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
    @url = Url.generate(url_params[:long_url])
    if @url.save
      flash[:success] = 'Short URL generated!'
      redirect_to @url
    else
      flash.now[:danger] = 'An error ocurred. Could not save short URL.'
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
