class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def post?
    user.admin? || user.user?
  end

  def put?
    user.admin? || record.id == user.id
  end

  def delete?
    user.admin? || record.id == user.id
  end
end
