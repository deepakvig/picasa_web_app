require 'nokogiri'
require 'open-uri'

class Album

  attr_accessor :url

  def initialize(gid)
    @url = "#{ENV['GOOGLE_PICASA_BASE_URL']}#{gid}"
  end

  def fetch_albums
    document = Nokogiri::HTML(open(url))
    document.css('feed entry').map do |node|
      {
        :title => node.css('title').first.text,
        :url => node.css('link').first[:href],
        :photo_url => node.css('content').first[:url],
        :published_at => node.css('published').first.text
      }
    end
  end

  def fetch_pictures(url)
    doc = Nokogiri::XML(open(url))
    doc.css('feed entry').map do |node|
      id = node.css('id').text.split('/').last
      {
        :title => node.css('title').text,
        :url => node.css('content').first[:src],
        :published_at => node.css('published').text,
        :id => id,
        :comments => fetch_comments(id)
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


  # attr_accessible :title, :body
end
