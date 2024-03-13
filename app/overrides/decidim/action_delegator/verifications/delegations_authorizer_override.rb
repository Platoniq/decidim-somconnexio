# frozen_string_literal: true

module Decidim
  module ActionDelegator
    module Verifications
      module DelegationsAuthorizerOverride
        extend ActiveSupport::Concern

        included do
          def authorize
            status = super
            return status unless status == [:ok, {}]

            # if used outside a consultation, allow all
            return [:ok, {}] if consultation.blank?
            return [:ok, {}] if setting.odoo_required?
            return [:ok, {}] if belongs_to_consultation? && user_in_census?

            [:unauthorized, { extra_explanation: extra_explanations }]
          end
        end
      end
    end
  end
end
