# frozen_string_literal: true

require 'bbb_api'

module ApplicationHelper
  include BbbApi

  def omniauth_bbbltibroker_url(path = nil)
    url = Rails.configuration.omniauth_site[:bbbltibroker]
    url += Rails.configuration.omniauth_root[:bbbltibroker] if Rails.configuration.omniauth_root[:bbbltibroker].present?
    url += path unless path.nil?
    url
  end

  def omniauth_client_token(lti_broker_url)
    oauth_options = {
      grant_type: 'client_credentials',
      client_id: Rails.configuration.omniauth_key[:bbbltibroker],
      client_secret: Rails.configuration.omniauth_secret[:bbbltibroker],
    }
    response = RestClient.post("#{lti_broker_url}/oauth/token", oauth_options)
    JSON.parse(response)['access_token']
  end

  def omniauth_provider?(code)
    provider = code.to_s
    OmniAuth.strategies.each do |strategy|
      return true if provider.downcase == strategy.to_s.demodulize.downcase
    end
    false
  end

  def can_edit?(user, resource)
    Abilities.can?(user, :edit, resource)
  end

  def can_download_recording?(user, resource)
    Abilities.can?(user, :download_presentation_video, resource)
  end

  def show_terms_use_message?(resource)
    config = ConsumerConfig.find_by(key: resource[:consumer_key])
    config.present? && config[:message_reference_terms_use]
  end

  def show_external_widget?(resource)
    key = ConsumerConfig.find_by(key: resource[:consumer_key])
    byebug
    key.present? && key[:external_widget]
  end

  def render_external_widget(resource)
    key = ConsumerConfig.find_by(key: resource[:consumer_key])
    key.tag_widget.html_safe
  end

  def theme_defined?
    !Rails.configuration.theme.blank?
  end

  def app_theme
    Rails.configuration.theme
  end

  def spaces_configured?
    !Rails.configuration.spaces_key.blank? && !Rails.configuration.spaces_secret.blank? &&
    !Rails.configuration.spaces_bucket.blank?
  end

  def theme_class
    "theme-#{Rails.configuration.theme}" if theme_defined?
  end
end
