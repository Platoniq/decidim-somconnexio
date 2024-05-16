# frozen_string_literal: true

module Decidim
  module Devise
    module SessionsControllerOverride
      extend ActiveSupport::Concern

      included do
        alias_method :original_after_sign_out_path_for, :after_sign_out_path_for
        alias_method :original_destroy, :destroy

        def destroy
          @user = current_user
          original_destroy
        end

        def after_sign_out_path_for(resource)
          if @user.odoo_identity?
            "https://oficinavirtual.somconnexio.coop"
          else
            original_after_sign_out_path_for(resource)
          end
        end
      end
    end
  end
end
