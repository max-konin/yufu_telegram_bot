#!/usr/bin/env ruby
require 'telegram/bot'
# You might want to change this
ENV["RAILS_ENV"] ||= "production"

root = File.expand_path(File.dirname(__FILE__))
root = File.dirname(root) until File.exists?(File.join(root, 'config'))
Dir.chdir(root)

require File.join(root, "config", "environment")

logger = Logger.new(Rails.root.join('log', 'telegram-bot.log'))

token = Rails.application.secrets.telegram_token

logger.info 'Telegram Bot: Connecting to telegram...'

Telegram::Bot::Client.run(token, logger: logger) do |bot|
  bot.logger.info('Bot has been started')
  bot.listen do |message|
    if !CrmService.instance.telegram_user_exist?(message.chat.id)
      text = "Hello, #{message.from.first_name}. You don't assign your YUFU CRM account with telegram. Your telegram ID is #{message.chat.id}. Please set up it in your CRM profile"
    else
      if %w(/start /hello).include? message.text
        text = "Hello, #{message.from.first_name}. Nice to see you."
      else
        text = "I do not understand"
      end
    end
    bot.api.send_message chat_id: message.chat.id, text: text
  end
end