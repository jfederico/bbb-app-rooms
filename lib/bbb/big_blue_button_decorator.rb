# frozen_string_literal: true

require 'bigbluebutton_api'

module Bbb
  class BigBlueButtonDecorator < BigBlueButton::BigBlueButtonApi
    # This class is a proxy to BigBlueButton::BigBlueButtonApi that adds some
    # extra functionality.
    #

    # Define the initialize method in the superclass if not already defined.
    def initialize(*args)
      super(*args)  # Pass all arguments to the superclass BigBlueButtonApi
    end

    def join_meeting_url(meeting_id, user_name, password, options={})
      url = super(meeting_id, user_name, password, options)
      logger.debug("BigBlueButtonAPI: URL built = : #{url}")
      url
    end
  end
end
