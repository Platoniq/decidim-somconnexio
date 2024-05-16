# frozen_string_literal: true

Rails.application.config.to_prepare do
  Decidim::ActionDelegator::Verifications::DelegationsVerifier::AuthorizationsController.include(
    Decidim::ActionDelegator::Verifications::DelegationsVerifier::AuthorizationsControllerOverride
  )
  Decidim::Devise::SessionsController.include(Decidim::Devise::SessionsControllerOverride)
  Decidim::ActionDelegator::Setting.include(Decidim::ActionDelegator::SettingOverride)
  Decidim::ActionDelegator::Verifications::DelegationsAuthorizer.include(Decidim::ActionDelegator::Verifications::DelegationsAuthorizerOverride)
  Decidim::Odoo::Verifications::OdooMember.include(Decidim::Odoo::Verifications::OdooMemberOverride)
end
