module FlashSales
  module User
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
