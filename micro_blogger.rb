require "jumpstart_auth"
require "bitly"

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "Your tweet is longer than 140 characters, not posted"
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "Enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
			when "q" then puts "Goodbye!"
			when "t" then tweet(parts[1..-1].join(" "))
			when "dm" then dm(parts[1], parts[2..-1].join(" "))
			when "sf" then puts "Followers: #{followers_list}"
			when "spam" then spam_my_followers(parts[1..-1].join(" "))
			when "elt" then everyones_last_tweet
			when "s" then shorten(parts[1])
			when "turl" then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't know how to #{command}"
			end
		end
	end

	def followers_list
		screen_names = @client.followers.collect {|follower| @client.user(follower).screen_name}
	end

	def spam_my_followers(message)
		followers = followers_list
		followers.each do |follower|
			dm(follower, message)
		end
	end

	def everyones_last_tweet
		friend_ids = @client.friends.to_a  # returns a list of numerical user ids
		friends = []
        friend_ids.each do |id|
        	user = @client.user(id) # get the user for the given id
        	friends << user
        end

        friends.sort_by! {|friend| friend.screen_name.downcase}
        friends.each do |friend|
        	timestamp = friend.status.created_at.strftime("%A, %b %d")
        	name = friend.screen_name
        	message = friend.status.text
        	puts "#{name} on #{timestamp}: #{message}"
        end
	end

	def dm(target, message)
		screen_names = followers_list
		if screen_names.include?(target)
			puts "Trying to send #{target} this direct message:"
			puts message
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "You are trying to direct message someone who is not a follower."
		end
	end
end

def shorten(original_url)
	# Shortening code
	puts "Shortening this URL: #{original_url}"
	Bitly.use_api_version_3

	bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
	return bitly.shorten(original_url).short_url
end

blogger = MicroBlogger.new
blogger.run
