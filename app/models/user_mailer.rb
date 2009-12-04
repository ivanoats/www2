class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject << 'Please activate your new account'
    @body[:url] = "#{APP_CONFIG[:site_url]}/activate/#{user.activation_code}"
  end
  
  def admin_notification(user)
    setup_email(user)
    @subject << 'Please activate your administrator account'
    @body[:url] = "#{APP_CONFIG[:site_url]}/activate_admin/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject << 'Your account has been activated!'
    @body[:url] = APP_CONFIG[:site_url]
  end
  
  def billing_transfer(user, password)
    setup_email(user)
    @subject << "Your account has been transferred to the new billing system"
    @body[:password] = password
  end
  
  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from = APP_CONFIG[:admin_email]
    @subject = "[#{APP_CONFIG[:site_name]}] "
    @sent_on = Time.now
    @body[:user] = user
    @content_type = 'text/html'
    
  end
end
