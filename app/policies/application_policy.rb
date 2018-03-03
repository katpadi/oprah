class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def get?
    true
  end

  def show?
    true
  end

  def post?
    false
  end

  def put?
    false
  end

  def delete?
    false
  end

  def user_own_record?
    user.user? && record.user_id == user.id
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end
end
