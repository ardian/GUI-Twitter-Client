Shoes.setup do
  gem 'twitter'
end

require 'twitter'

class TwitterApp < Shoes

  OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE


  $client = Twitter::REST::Client.new do |config|
    config.consumer_key        = "CONSUMER_KEY"
    config.consumer_secret     = "CONSUMER_SECRET"
    config.access_token        = "ACCESS_TOKEN"
    config.access_token_secret = "ACCESS_TOKEN_SECRET"
  end

  url "/", :home
  url "/CreateTweet", :CreateTweet
  url "/SearchForTweets", :SearchForTweets

  def home
    background "#333", width: 50
    stack displace_left: 50 do
      image "static/twitter_logo.svg.png", margin_left: 100, margin_top: 10
      flow margin_left: 70, margin_top: 5 do
        button "Create Tweet", margin: 5, width: 110 do visit '/CreateTweet'end
        button "Search For Tweets", margin: 5, width: 145 do visit '/SearchForTweets' end
      end
    end
  end

  # Create tweets screen

  def CreateTweet
    background "#333", width: 50
    stack displace_left: 50  do
      image "static/twitter_logo.svg.png", margin_left: 100, margin_top: 10
      @input = edit_line text: "Write your tweet!", margin_left: 100, margin_top: 15
      flow margin_left: 120, margin_top: 5 do
        button "Tweet", :margin => 5 do
          puts "Trying to tweet..."
          $client.update(@input.text)
        end
        button "Back", margin: 5 do visit '/'end
      end
    end
  end

  # Search for tweets screen

  def SearchForTweets
    background "#333", width: 50
    stack displace_left: 50 do
      image "static/twitter_logo.svg.png", margin_left: 100, margin_top: 10
      @input = edit_line text: "Search for Tweets", margin_left: 100, margin_top: 15
      flow margin_left: 120, margin_top: 5 do
        button "Search", margin: 5 do
          $client.search(@input.text, result_type: "recent").take(3).each do |tweet|
            para  tweet.text + "\n\n", :stroke => "#1da1f2", margin_left: 51
          end
        end
        button  "Back", margin: 5 do visit '/' end
      end
    end
  end
end

Shoes.app title: "Twitter", :width => 500, :margin => 5, resizable: false
