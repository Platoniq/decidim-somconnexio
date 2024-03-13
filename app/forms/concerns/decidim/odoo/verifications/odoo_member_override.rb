# frozen_string_literal: true

module Decidim
  module Odoo
    module Verifications
      module OdooMemberOverride
        extend ActiveSupport::Concern

        included do
          def participant
            nil
          end

          # currently, we rely on the last setting.
          # This could be improved by allowing the user to select the setting (or related phone).
          def setting
            @setting ||= context[:setting]
          end
        end
      end
    end
  end
end
