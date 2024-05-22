# frozen_string_literal: true

require "rails_helper"

# We make sure that the checksum of the file overriden is the same
# as the expected. If this test fails, it means that the overriden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      "/app/controllers/decidim/devise/sessions_controller.rb" => "235cbe9844cdd39f65c72d3dc87f5f23",
      "/app/views/layouts/decidim/_head_extra.html.erb" => "1b8237357754cf519f4e418135f78440"
    }
  },
  {
    package: "decidim-action_delegator",
    files: {
      "/app/views/decidim/action_delegator/admin/settings/_form.html.erb" => "900447a24b3914d56de6ed53185f73d6",
      "/app/controllers/decidim/action_delegator/verifications/delegations_verifier/authorizations_controller.rb" => "39257248025a42c3b1b8870ed31d3721",
      "/app/models/decidim/action_delegator/setting.rb" => "242e32c4027fd47fd72e677db75da2f2",
      "/lib/decidim/action_delegator/verifications/delegations_authorizer.rb" => "81879b0c3efeb0e0747d5d4e69c686c1"
    }
  },
  {
    package: "decidim-odoo",
    files: {
      "/app/forms/decidim/odoo/verifications/odoo_member.rb" => "c684eb68ca7582c150691250e99fa483"
    }
  }
]

describe "Overriden files", type: :view do
  # rubocop:disable Rails/DynamicFindBy
  checksums.each do |item|
    spec = ::Gem::Specification.find_by_name(item[:package])

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end
  # rubocop:enable Rails/DynamicFindBy

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
