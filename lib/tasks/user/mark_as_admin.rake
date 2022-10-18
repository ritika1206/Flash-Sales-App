namespace :user do
  desc "Marking a user as admin"
  task :mark_as_admin => [:environment] do
    puts 'Enter email id'
    user = User.find_by(email: gets.chomp)
    if user.present?
      if user.update(role: 'admin')
        puts 'Successfully marked user as admin'
      else
        puts 'Unable to mark as admin'
      end
    else
      puts "User does not exist"
    end
  end
end
