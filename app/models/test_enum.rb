class TestEnum < ApplicationRecord
    enum role: { client: 0, court_owner: 1, admin: 2 }, _default: "client"
  end
  