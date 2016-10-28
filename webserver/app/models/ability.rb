class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)

    if user.new_record?
    end

    if user.admin?
      can :manage, :all
    end

    if user.patient?
      can :show, Device, id: user.device.id
    end

    if user.doctor?
    end

  end
end
