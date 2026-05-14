RSpec.shared_context "auth_headers" do
  let(:user) { double("User", id: 1, role: "admin") }
  let(:token) { JsonWebToken.encode(user_id: user.id) }
  let(:auth_headers) { { "Authorization" => "Bearer #{token}" } }
end
