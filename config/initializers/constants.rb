module FlashSales
  module User
    EMAIL_REGEX = /\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})\z/i
    COOKIE_EXPIRATION_DURATION = 10.days
  end

  module Mailer
    DEFAULT_EMAIL = 'super@flash.com'
  end

  module Reports
    DEFAULT_CUSTOMER_EXPENDITIURE_START_DATE = Date.new(2022, 9, 20)
  end

  module Deal
    TAX_PERCENTAGE_RANGE = 0..28
  end
end
