class AlbumsController < ApplicationController
  before_filter :set_uid

  def index
    @albums = Album.fetch_albums(@uid, session[:access_token])
  end

  def show
    @album_pics = Album.fetch_pics(@uid, params[:album_url], session[:access_token], params[:rights])[0..2]
    #@comment = Comment.new
  end

  private

  def set_uid
    @uid = current_user.uid
  end

end
