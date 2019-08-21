class UsersController < ApplicationController
  before_action :authenticate_user!

  load_resource except: :user_show

  def index
    authorize! :index, User
  end

  def show
    unless current_user.admin?
      unless @user == current_user
        redirect_to root_path, :alert => "Access denied."
      end
    end
  end

  def update
    authorize! :update, User
    if @user.update_attributes(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    authorize! :destroy, User
    @user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def user_show
    redirect_to current_user
  end

  private

  def secure_params
    params.require(:user).permit(:role)
  end

end
