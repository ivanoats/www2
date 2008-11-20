class TicketMailer < ActionMailer::Base

  def new_ticket(ticket)
    @subject    = ticket.subject #'TicketMailer#new_ticket'
    @body["ticket"]       = ticket
    ticket.department ||= "technical"
    if ticket.department == "technical"
      @recipients = %w(support@sustainablewebsites.com ivanoats+support@gmail.com)
    else
      @recipients = %w(ivan@sustainablewebsites.com ivanoats+sw@gmail.com)
    end
    @from       = ticket.email
    @headers["Reply-To"] = ticket.email
    @headers["Sender"]  =  "sustainablewebsites.com" #"ivanoats@a2s23.a2hosting.com"
    @headers["Return-path"] = "tickets@sustainablewebsites.com "#"ivanoats@a2s23.a2hosting.com"
  end
end
