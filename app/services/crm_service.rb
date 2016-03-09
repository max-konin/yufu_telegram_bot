class CrmService
  include Singleton

  def telegram_user_exist?(telegram_id)
    run_request('users/check_telegram_id', 'GET', {telegram_id: telegram_id}) == 'true'
  end

  private
  def build_url(action)
    "#{Rails.application.config.crm_host}/api/admin/#{action}"
  end

  def run_request(action, method, payload = {})
    RestClient::Request.execute(method: method, url: build_url(action), payload: payload, headers: {
        content_type: :json, accept: :json
    })
  rescue => e
    Rails.logger.fatal e
    false
  end
end