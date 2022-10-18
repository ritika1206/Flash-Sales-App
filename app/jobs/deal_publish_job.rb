class DealPublishJob < ApplicationJob
  queue_as :default

  def perform
    rake deal:update_live_status
  end
end
