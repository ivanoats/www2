class OrderMailer < ActionMailer::Base
  

  def complete(sent_at = Time.now)
    subject    'OrderMailer#complete'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

  def approved(sent_at = Time.now)
    subject    'OrderMailer#approved'
    recipients ''
    from       ''
    sent_on    sent_at
    
    body       :greeting => 'Hi,'
  end

end
