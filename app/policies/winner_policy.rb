class WinnerPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def post?
    user.admin?
  end

  def get?
    user.admin?
  end
end
