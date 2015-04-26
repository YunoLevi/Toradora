#$:.unshift File.dirname(__FILE__) + '/../lib'
require 'rubygems'
require 'google-search'
require 'mechanize'
class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token
  respond_to :html
  
  def index
    if !current_user.nil?
      @tweets = Tweet.all
      
      client = Twitter::REST::Client.new do |config|
  
       config.consumer_key        = "mR5sZOHA4GKCtE8LJF4YQQEnQ"
       config.consumer_secret     = "9P1XXydm7Z7wJmeBZEfEZRgipLUFihPnNmSvZNWLCAUMon0AvR"
       config.access_token        = "2992787178-A7b9hs7GXJSMTnTEtVlPTAhPy3zt1NERk2R8UrZ"
       config.access_token_secret = "NPJFJrgoRlIDKjYE1gYaO5OFIcXsy6hWCzNuHBMRsHlim"
      end
      @my_tweets = client.user_timeline(current_user.name) #(current_user.name,:count => 30)
      @htags = []
      Hashtag.delete_all
      hashes = current_user.hashtags
      for tweet in  @my_tweets 
       words = tweet.text.split(/ /) 
         for word in words 
           if word.include?("#") || word.include?("@")
              word.slice!(0) 
              if !word.nil?
                @htags << word 
              end
            end 
         end  
       end 
       
       if hashes.empty?
         @htags.uniq.each do |word|
            Hashtag.create(:user_id => current_user.id, :word => word, :count => @htags.count(word))
         end
       #else
           #@htags.uniq.each do |word|
             #hash_word = Hashtag.where('user_id = ? AND word = ?', current_user.id, word).first
             #hash_word.count = @htags.count(word)
             #hash_word.save
           #end
       end
       @kwords = []
       @key_words = Hashtag.order('count DESC')
       @key_words.each do |w|
         @kwords << w.word
       end
       
      respond_with(@tweets)
    end
    
  end

  def show
    #respond_with(@tweet)
    redirect_to :action => "index"
  end

  def new
    @tweet = Tweet.new
    respond_with(@tweet)
  end

  def edit
  end


  def create
    @tweet = Tweet.new(tweet_params)
    @tweet.user_id = current_user.id
    @tweet.save
    redirect_to :action => "index"
    #respond_with(@tweet)
  end

  def update
    @tweet.update(tweet_params)
    respond_with(@tweet)
  end

  def destroy
    @tweet.destroy
    respond_with(@tweet)
  end

  def home
  end

  private
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    def tweet_params
      params.require(:tweet).permit(:user_id, :body)
    end
  
end
