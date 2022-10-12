namespace :user do
  desc 'Generating API tokens for existing users'
  task :generate_api_token => [:environment] do
    User.all.each do |user|
      user.regenerate_api_token
    end
    puts "Successfully generated API token for all existing users"
  end
end
