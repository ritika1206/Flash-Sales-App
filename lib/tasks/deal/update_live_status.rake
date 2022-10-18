namespace :deal do
  desc 'Publishing new deals scheduled to be published on current day and unpublishing old deals which were live'
  task :update_live_status => [:environment] do
    Deal.live_deals.each do |live_deal|
      live_deal.update(status: 'published') if live_deal.published_at != Date.today
    end
    new_live_deals = Deal.deals_publishing_today
    if new_live_deals.present? && new_live_deals.count <=2
      new_live_deals.each do |deal|
        if deal.publishable?
          if deal.update(status: 'live')
            puts "#{deal} published successfully"
          else
            puts "Unable to change status of the new live deal to live"
          end
        else
          puts "Unable to publish #{deal}"
        end
      end
    else
      puts "Deal cannot be published"
    end
  end
end
