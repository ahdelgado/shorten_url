require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
  describe 'GET #index' do
    before :each do
      get :index
    end
    it 'has a 200 status code' do
      expect(response.status).to eq(200)
    end
    it 'renders the index template' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show/:short_url' do
    before :each do
      @url = build(:url)
      @url.clean
      @url.save
      get :show, short_url: @url.short_url
    end
    it 'redirects to the cleaned Url' do
      expect(response).to redirect_to(@url.url)
    end
    it 'has a 302 status code' do
      expect(response.status).to eq(302)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      context 'with a new Url' do
        before :each do
          post :create, url: { long_url: Faker::Internet.url}
        end
        it 'assigns the cleaned Url' do
          expect(assigns(:url).url).to eq Url.last.url
        end
        it 'creates a new Url entry' do
          expect change(Url, :count).by(1)
        end
        it 'redirects to the index page' do
          expect(response).to redirect_to urls_path
        end
      end

      context 'with a Url that is already in the database' do
        before :each do
          post :create, url: { long_url: 'www.google.com'}
        end
        it 'does not create a new Url entry' do
          expect{
            post :create, url: { long_url: 'www.google.com'}
          }.to_not change(Url, :count)
        end
        it 'does not create a new Url entry when clean method detects same Url' do
          expect{
            post :create, url: { long_url: 'https//google.com'}
          }.to_not change(Url, :count)
        end
        it 'renders the :new template' do
          post :create, url: { long_url: 'https//google.com'}
          expect(response).to render_template :new
        end
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new Url entry when Url is nil and renders the :new template' do
        expect{
          post :create, url: { long_url: nil}
        }.to_not change(Url, :count)
        expect(response).to render_template :new
      end
      it 'does not create a new Url entry when Url is empty string and renders the :new template' do
        expect{
          post :create, url: { long_url: '    '}
        }.to_not change(Url, :count)
        expect(response).to render_template :new
      end
      it 'does not create a new Url entry when Url is invalid and renders the :new template' do
        expect{
          post :create, url: { long_url: 'Invalid entry'}
        }.to_not change(Url, :count)
        expect(response).to render_template :new
      end
    end
  end
end