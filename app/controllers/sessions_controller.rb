require 'cgi'

class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to albums_url and return
    end
  end

  def create
    key = authenticate
    if key.blank?
      redirect_to root_url, notice: "Not able to Login"
    else
      session[:key] = key
      session[:user_id] = params[:user_id]
      redirect_to albums_url
    end
  end

  def destroy
    session[:user_id] = nil
    session[:key] = nil
    redirect_to root_url, notice: "Signed out!" and return
  end

  def failure
    redirect_to root_url, alert: "Authentication failed, please try again."
  end

  private

  def authenticate
    https = Net::HTTP.new('google.com', 443)
    https.use_ssl = true
    path = '/accounts/ClientLogin'
    headers = {
      "Content-Type" => "application/x-www-form-urlencoded"
    }
    body = inline_query ({
          "accountType" => "HOSTED_OR_GOOGLE",
          "Email"       => 'deepakvig',
          "Passwd"      => 'dee180pak$',
          "service"     => "lh2",
          "source"      => "ruby-picasa"
        })
    
    resp = https.post(path, body, headers)
    response = resp.body.split("\n").map { |v| v.split("=") }
    params = Hash[response]
    params["Auth"]
  end 

  def inline_query(query)
    query.map do |key, value|
      dasherized = key.to_s.gsub("_", "-")
      "#{CGI.escape(dasherized)}=#{CGI.escape(value.to_s)}"
    end.join("&")
  end

end
