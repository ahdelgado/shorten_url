require 'rails_helper'

RSpec.describe Url, type: :model do
  it 'is valid with a valid url' do
    url = build(:url)
    url.clean
    expect(url).to be_valid
  end
  it 'is invalid without a URL' do
    url = build(:url, long_url: nil)
    url.valid?
    expect(url.errors[:long_url]).to include('can\'t be blank', 'is not a valid URL')
  end
  it 'is invalid with an invalid URL' do
    url = build(:url, long_url: 'Invalid URL')
    url.valid?
    expect(url.errors[:long_url]).to include('is not a valid URL')
  end

  describe 'method' do
    before :each do
      sample_url = Faker::Internet.url
      @url1 = build(:url, long_url: sample_url)
      @url1.shorten_url
      @url1.save
      @url2 = build(:url, long_url: sample_url)
      @url2.shorten_url
    end
    it '#shorten_url always generates a short_url that is not in the database' do
      expect(Url.find_by_short_url(@url2.short_url).nil?).to eq(true)
    end
    it 'if #shorten_url detects a collision it will increment short_url by one char' do
      expect(@url2.short_url.length).to eq(@url1.short_url.length + 1)
    end
    it 'is invalid with a duplicate URL' do
      @url2.valid?
      expect(@url2.errors[:long_url]).to include('has already been taken')
    end

    context '#display_url' do
      before :each do
        @url = build(:url, long_url: 'https//' + ('a' * 100) + '.com')
      end
      it 'shortens URL with length > 80 to length 83' do
        expect(@url.display_url.length).to eq 83
      end
      it 'appends ... to end of URL if length is > 80' do
        expect(@url.display_url).to include('...')
      end
      it 'does not append ... to end of URL if length is < 80' do
        @url.long_url = 'www.short.com'
        expect(@url.display_url).to_not include('...')
      end
    end

    context '#clean' do
      it 'changes www.google.com to https://google.com' do
        url = build(:url, long_url: 'www.google.com')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
      it 'changes google.com to https://google.com' do
        url = build(:url, long_url: 'google.com')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
      it 'changes http://www.google.com to https://google.com' do
        url = build(:url, long_url: 'http://www.google.com')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
      it 'changes http://www.google.com to https://google.com' do
        url = build(:url, long_url: 'http://www.google.com')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
      it 'strips leading spaces from long_url' do
        url = build(:url, long_url: '  https://www.google.com')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
      it 'strips trailing spaces from long_url' do
        url = build(:url, long_url: 'https://www.google.com  ')
        url.clean
        expect(url.long_url).to eq('https://google.com')
      end
    end
  end

  describe 'is valid with the following URLs' do
    it 'http://foo.com/blah_blah' do
      url = build(:url, long_url: 'http://foo.com/blah_blah')
      expect(url).to be_valid
    end
    it 'http://foo.com/blah_blah/' do
      url = build(:url, long_url: 'http://foo.com/blah_blah/')
      expect(url).to be_valid
    end
    it 'http://foo.com/blah_blah_(wikipedia)' do
      url = build(:url, long_url: 'http://foo.com/blah_blah_(wikipedia)')
      expect(url).to be_valid
    end
    it 'http://foo.com/blah_blah_(wikipedia)_(again)' do
      url = build(:url, long_url: 'http://foo.com/blah_blah_(wikipedia)_(again)')
      expect(url).to be_valid
    end
    it 'http://www.example.com/wpstyle/?p=364' do
      url = build(:url, long_url: 'http://www.example.com/wpstyle/?p=364')
      expect(url).to be_valid
    end
    it 'https://www.example.com/foo/?bar=baz&inga=42&quux' do
      url = build(:url, long_url: 'https://www.example.com/foo/?bar=baz&inga=42&quux')
      expect(url).to be_valid
    end
    it 'http://✪df.ws/123' do
      url = build(:url, long_url: 'http://✪df.ws/123')
      expect(url).to be_valid
    end
    it 'http://userid:password@example.com:8080' do
      url = build(:url, long_url: 'http://userid:password@example.com:8080')
      expect(url).to be_valid
    end
    it 'http://userid:password@example.com:8080/' do
      url = build(:url, long_url: 'http://userid:password@example.com:8080/')
      expect(url).to be_valid
    end
    it 'http://userid@example.com' do
      url = build(:url, long_url: 'http://userid@example.com')
      expect(url).to be_valid
    end
    it 'http://userid@example.com:8080' do
      url = build(:url, long_url: 'http://userid@example.com:8080')
      expect(url).to be_valid
    end
    it 'http://userid@example.com/' do
      url = build(:url, long_url: 'http://userid@example.com/')
      expect(url).to be_valid
    end
    it 'http://userid@example.com:8080/' do
      url = build(:url, long_url: 'http://userid@example.com:8080/')
      expect(url).to be_valid
    end
    it 'http://userid:password@example.com' do
      url = build(:url, long_url: 'http://userid:password@example.com')
      expect(url).to be_valid
    end
  end

  describe 'is invalid with the following URLs' do
    it 'http://' do
      url = build(:url, long_url: 'http://')
      expect(url).to_not be_valid
    end
    it 'http://??' do
      url = build(:url, long_url: 'http://??')
      expect(url).to_not be_valid
    end
    it 'http://?' do
      url = build(:url, long_url: 'http://?')
      expect(url).to_not be_valid
    end
    it '///' do
      url = build(:url, long_url: '///')
      expect(url).to_not be_valid
    end
    it 'foo.com' do
      url = build(:url, long_url: 'foo.com')
      expect(url).to_not be_valid
    end
    it 'rdar://1234' do
      url = build(:url, long_url: 'rdar://1234')
      expect(url).to_not be_valid
    end
    it 'http://??/' do
      url = build(:url, long_url: 'http://??/')
      expect(url).to_not be_valid
    end
    it 'http://#' do
      url = build(:url, long_url: 'http://#')
      expect(url).to_not be_valid
    end
    it 'http://##' do
      url = build(:url, long_url: 'http://##')
      expect(url).to_not be_valid
    end
    it 'http://##/' do
      url = build(:url, long_url: 'http://##/')
      expect(url).to_not be_valid
    end
    it 'h://test' do
      url = build(:url, long_url: 'h://test')
      expect(url).to_not be_valid
    end
    it '//' do
      url = build(:url, long_url: '//')
      expect(url).to_not be_valid
    end
    it '//a' do
      url = build(:url, long_url: '//a')
      expect(url).to_not be_valid
    end
    it '///a' do
      url = build(:url, long_url: '///a')
      expect(url).to_not be_valid
    end
  end
end