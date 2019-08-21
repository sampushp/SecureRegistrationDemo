class User < ActiveRecord::Base
  has_one :secret_code, dependent: :nullify
  enum role: [:user, :admin]
  after_initialize :set_default_role, :if => :new_record?

  attr_accessor :secret_code

  after_commit :associate_secret_code, on: :create

  # Used for creating default admin through seeds.
  def self.create_default_admin
    find_or_create_by!(email: Rails.application.secrets.admin_email) do |user|
      user.password = Rails.application.secrets.admin_password
      user.password_confirmation = Rails.application.secrets.admin_password
      user.admin!
    end
  end

  # Dfault role of all users will be user and can only be modified by admin user.
  def set_default_role
    self.role ||= :user
  end

  # Secret code once used to register get associated to that user and can not be further used.
  def associate_secret_code
    code = SecretCode.available.find_by_code(secret_code)
    code.try(:update_column, :user_id, id)
  end

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
