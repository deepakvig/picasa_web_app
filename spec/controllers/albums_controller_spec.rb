require 'spec_helper'

describe AlbumsController do

  before(:each) do
    session[:user_id] = "fdssf"
    session[:key] = "sdfaf"
  end

  describe 'GET #index' do
    it "populates an array of albums" do
      get :index
      expect(assigns(:albums)).not_to be_nil
    end

    it "renders the :index view" do
      get :index
      response.should render_template :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it "populates an array of album_pics" do
      get :show, :album_url => 'http://picasaweb.google.com'
      expect(assigns(:album_pics)).not_to be_nil
    end

    it "renders the :index view" do
      get :show, :album_url => 'http://picasaweb.google.com'
      expect(response).to render_template :show
    end

  end

end
