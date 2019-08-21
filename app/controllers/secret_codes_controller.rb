class SecretCodesController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  def index
  	@secret_codes = SecretCode.includes(:user).all
    @secret_codes = @secret_codes.paginate(page: params[:page], per_page: 10)
    @secret_code = SecretCode.new
  end

  def create
    count = params[:secret_code][:code_count].to_i
    count = count.zero? ? 1 : count
    count.times do
      SecretCode.generate
    end
  	redirect_to secret_codes_path, :notice => "Secret Code added."
  end

  def destroy
    secret_code = SecretCode.find(params[:id])
    secret_code.destroy
    redirect_to secret_codes_path, :notice => "Secret Code deleted."
  end

  private

  def secret_code_params
    params.require(:secret_code).permit(:code)
  end

end
