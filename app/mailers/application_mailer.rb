class ApplicationMailer < ActionMailer::Base
  default from: Mailer::DEFAULT_EMAIL
  layout "mailer"
end
