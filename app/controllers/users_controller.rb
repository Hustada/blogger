class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy
    
    def new
      @user = User.new
    end

    def show
      @user = User.find(params[:id])
      @posts = @user.posts.paginate(:page => params[:page], :per_page => 5)
      @comments = @user.comments.order('created_at DESC').paginate(page: params[:page],per_page: 5)
    end

    def create
      @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      UserMailer.account_activation(@user).deliver
      flash[:info] = "An email has been sent to activate your account. (Please check you spam folder)"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.all.paginate(:page => params[:page], :per_page => 10)
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  #before filters
   #confirms logged in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

  private

  def user_params 
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
