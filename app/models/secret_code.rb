class SecretCode < ActiveRecord::Base
  belongs_to :user

  attr_accessor :code_count

  scope :available, -> { where(user_id: nil) }

  def self.generate
  	create(code: SecureRandom.hex(8))
  end

end
