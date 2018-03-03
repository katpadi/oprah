class EntryPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def post?
    user.admin? || user.user?
  end

  def put?
    user.admin? || user_own_record?
  end

  def delete?
    user.admin? || user_own_record?
  end
end
