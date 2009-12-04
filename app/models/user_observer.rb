class UserObserver < ActiveRecord::Observer

  def after_save(user)
    UserMailer.deliver_activation(user) if user.recently_activated? && user.not_using_openid?
  end
end
