# frozen_string_literal: true

Rails.application.routes.draw do
  get :simplecov, to: 'simplecov_url/simplecov_url#index'
end
