# frozen_string_literal: true

module SimplecovUrl
  class AccessManager
    def self.deny?
      new.deny?
    end

    def deny?
      tmp = ENV['ALLOWED_SIMPLECOV_ENVIRONMENTS']

      tmp.present? ? tmp.split(',').none? { |env| env == Rails.env } : false
    end
  end
end
