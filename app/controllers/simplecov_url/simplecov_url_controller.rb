# frozen_string_literal: true

module SimplecovUrl
  class SimplecovUrlController < ApplicationController
    def index
      html = SimplecovUrl::HtmlProcessor.call

      return head(403) unless html

      render html: html
    end
  end
end
