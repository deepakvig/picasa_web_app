class CommentsController < ApplicationController
  require 'uri'
  require 'net/http'
  require 'net/https'

  def create

    @desc = params[:desc]
    @pic_id = params[:pic_url].split("/")[-1]
    path = params[:pic_url].split("/")[-5..-1].join("/")

    https = Net::HTTP.new('picasaweb.google.com', 443)
    https.use_ssl = true
    path = '/data/feed/api/user/'+ path #deepakvig/albumid/5821407449002245793/photoid/5837016705233353714'
    headers = {
      "Content-Type" => "application/atom+xml",
      'Authorization' => "GoogleLogin auth=#{session[:key]}"
    }
    resp = https.post(path, build_request_body(@desc), headers)
  end

  private

  def build_request_body(comment)
    return "<entry xmlns='http://www.w3.org/2005/Atom'><content>#{comment}</content><category scheme=\"http://schemas.google.com/g/2005#kind\" term=\"http://schemas.google.com/photos/2007#comment\"/></entry>"
  end
end
