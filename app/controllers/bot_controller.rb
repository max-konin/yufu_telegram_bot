require 'telegram/bot'

class BotController < ApplicationController
  def send_message
    chat_id = params.require(:chat_id)
    message = params.require(:message)

    Telegram::Bot::Client.run(Rails.application.secrets.telegram_token) do |bot|
      bot.api.send_message(chat_id: chat_id, text: message)
    end

    render json: true
  end
end
