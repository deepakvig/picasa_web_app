class CommentsController < ApplicationController
  require 'uri'
  require 'net/http'

  def create
    @desc = params[:desc]    
    url = params[:pic_url]
    puts params[:pic_url]+"?access_token="+session[:access_token]
    uri = URI.parse("https://picasaweb.google.com")
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(post_comment_request_url)
    request.add_field('Content-Type', 'application/atom+xml')
    request.add_field('Authorization', "GoogleLogin auth=#{session[:access_token]}")
    request.body = build_request_body(params[:comment])
    response = http.request(request)

    puts "Interesting"
    puts response.inspect
    render :text => response
  end

  private
  def post_comment_request_url
    #url = "https://picasaweb.google.com/data/feed/api"\
    url = "/data/feed/api/user/deepakvig"\
          "/albumid/5821407449002245793"\
          "/photoid/5837016705233353714"
  end
  def build_request_body(comment)
  # request_body = Nokogiri::XML::Builder.new do |xml|
# xml.entry(:xmlns => 'http://www.w3.org/2005/Atom') {
# xml.content comment
# xml.category( :scheme => "http://schemas.google.com/g/2005#kind",
# :term => "http://schemas.google.com/photos/2007#comment")
# }
# end
# request_body.to_xml
    return "<entry xmlns='http://www.w3.org/2005/Atom'><content>great photo!</content><category scheme=\"http://schemas.google.com/g/2005#kind\" term=\"http://schemas.google.com/photos/2007#comment\"/></entry>"
  end


  def valid_xml desc
    xml = "<entry xmlns='http://www.w3.org/2005/Atom'><content>"+desc+"</content><category scheme='http://schemas.google.com/g/2005#kind' term='http://schemas.google.com/photos/2007#comment'/></entry>"
    xml
  end
end
