require 'open-uri'
require 'nokogiri'

class Album

  attr_accessor :url

  def self.fetch_albums uid, access_token
    url = get_url uid, access_token
    document = Nokogiri::HTML(open(url))
    document.css('feed entry').map do |node|
      {
        :title => node.css('title').first.text,
        :url => node.css('link').first[:href],
        :photo_url => node.css('content').first[:url],
        :published_at => node.css('published').first.text,
        :rights => node.css('rights').first.text
      }
    end
  end

  def self.fetch_pics(uid, url, access_token, rights)
    url = get_url uid, access_token, rights, url
    doc = Nokogiri::XML(open(url))
    doc.css('feed entry').map do |node|
      url = node.css('id').text
      id = url.split('/').last
      {
        :title => node.css('title').text,
        :url => node.css('media|content').first[:url],
        :published_at => node.css('published').text,
        :id => id,
        :pic_url => url
        #:comments => fetch_comments(id)
      }
    end
  end

private

  def fetch_comments(id)
    Comment.where("picture_id = '#{id}'").includes(:user).map do |comment|
      {
        :text => comment.text,
        :author => comment.user.username,
        :created_at => comment.created_at
      }
    end
  end

  def self.get_url uid, access_token, rights='private', url=nil
    url = "#{ENV['GOOGLE_PICASA_BASE_URL']}#{uid}?kind=album" if !url 
    url = url + "&access=all&access_token=#{access_token}" if rights == 'private'
    url
  end

  # attr_accessible :title, :body
end
