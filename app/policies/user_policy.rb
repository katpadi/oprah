class UserPolicy
  attr_reader :current_user, :model

  def initialize(current_user, model)
    @current_user = current_user
    @user = model
  end

  def get?
    @current_user.admin?
  end

  def show?
    @current_user.admin? or @current_user == @user
  end

  def put?
    @current_user.admin?
  end

  def delete?
    return false if @current_user == @user
    @current_user.admin?
  end

end
