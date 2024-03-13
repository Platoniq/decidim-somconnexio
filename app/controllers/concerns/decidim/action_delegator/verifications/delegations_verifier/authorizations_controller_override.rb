# frozen_string_literal: true

module Decidim
  module ActionDelegator
    module Verifications
      module DelegationsVerifier
        module AuthorizationsControllerOverride
          extend ActiveSupport::Concern

          included do
            def new
              @authorization.destroy! if authorization&.persisted? && !authorization&.granted?

              enforce_permission_to :create, :authorization, authorization: authorization
              @form = form(verifier_form).instance(setting: setting)
              participant = @form&.participant

              return unless ActionDelegator.authorize_on_login && setting&.verify_with_email?

              Decidim::Verifications::PerformAuthorizationStep.call(authorization, @form) do
                on(:ok) do
                  grant_and_redirect(participant)
                end
                on(:invalid) do
                  render :new
                end
              end
            end

            def create
              enforce_permission_to :create, :authorization, authorization: authorization

              @form = form(verifier_form).from_params(form_params, setting: setting)
              participant = @form&.participant

              Decidim::Verifications::PerformAuthorizationStep.call(authorization, @form) do
                on(:ok) do
                  if setting.phone_required?
                    flash[:notice] = t("authorizations.create.success", scope: "decidim.verifications.sms")
                    authorization_method = Decidim::Verifications::Adapter.from_element(authorization.name)
                    redirect_to authorization_method.resume_authorization_path(redirect_url: redirect_url)
                  else
                    grant_and_redirect(participant)
                  end
                end
                on(:invalid) do
                  flash.now[:alert] = t("authorizations.create.error", scope: "decidim.verifications.sms")
                  render :new
                end
              end
            end

            def grant_and_redirect(participant)
              authorization.grant!
              if participant
                participant.update!(decidim_user: authorization.user)
                flash[:notice] = t("authorizations.update.success", scope: "decidim.verifications.sms")
              end
              redirect
            end

            def verifier_form
              setting&.odoo_required? ? Decidim::Odoo::Verifications::OdooMember : DelegationsVerifierForm
            end

            def form_params
              params.merge(user: current_user)
            end
          end
        end
      end
    end
  end
end
