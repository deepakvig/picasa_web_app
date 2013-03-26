class Album < ActiveResource::Base

  self.site = 'https://picasaweb.google.com/data/feed/api/user/deepakvig'

  # attr_accessible :title, :body
end
