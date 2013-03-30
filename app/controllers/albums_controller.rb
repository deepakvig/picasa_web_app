class AlbumsController < ApplicationController

  def index
    if !logged_in?
      redirect_to root_url and return
    end   
    @albums = Album.fetch_albums( session[:user_id], session[:key])
  end

  def show
    if !logged_in?
      redirect_to root_url and return
    end   
    @album_pics = Album.fetch_pics( params[:album_url], session[:key])[0..2]
  end

end
