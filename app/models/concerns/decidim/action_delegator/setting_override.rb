# frozen_string_literal: true

module Decidim
  module ActionDelegator
    module SettingOverride
      extend ActiveSupport::Concern
      included do
        enum authorization_method: { phone: 0, email: 1, both: 2, odoo: 3 }

        def odoo_required?
          verify_with_odoo?
        end

        def verify_with_odoo?
          authorization_method == "odoo"
        end
      end
    end
  end
end
