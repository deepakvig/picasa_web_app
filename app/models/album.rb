require 'open-uri'
require 'nokogiri'

class Album

  attr_accessor :url

  def self.fetch_albums user_id, key
    path = "/data/feed/api/user/#{user_id}"
    puts key
    puts get_request(path, key).body
    document = Nokogiri::HTML(get_request(path, key).body)
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

  def self.fetch_pics path, key
    doc = Nokogiri::XML(get_request(path, key).body)
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

  def self.get_request path, headers
    https = Net::HTTP.new('picasaweb.google.com', 443)
    https.use_ssl = true
    headers = {
      'Authorization' => "GoogleLogin auth=#{headers}"
    }
    res = https.get(path, headers)
  end
  # attr_accessible :title, :body
end
