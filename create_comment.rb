require "picasa"

begin
  client = Picasa::Client.new(:user_id => "deepakvig", :password => "dee180pak$")
  # create new album.
  a = client.comment.create(
    :album_id => "5821407449002245793",
    :photo_id => "5837016705233353714",
    :content => "dsafads"
  )
  puts a

rescue Picasa::ForbiddenError
  puts "You have the wrong user_id or password."
end
