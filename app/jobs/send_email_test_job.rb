# frozen_string_literal: true

class SendEmailTestJob < ApplicationJob
  queue_as :mailers

  def perform
    user = User.first
    ExampleMailer.sample_email(user).deliver_now
  end
end
