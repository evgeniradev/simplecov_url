# frozen_string_literal: true

require 'rails'
require 'simplecov_url/access_manager'

RSpec.describe SimplecovUrl::AccessManager do
  subject { described_class }

  before do
    allow(Rails).to receive(:env).and_return('test')
  end

  it 'grants access if env variable not set' do
    ENV['ALLOWED_SIMPLECOV_ENVIRONMENTS'] = nil

    expect(subject.deny?).to be(false)
  end

  it 'grants access if env variable includes the current Rails environment' do
    ENV['ALLOWED_SIMPLECOV_ENVIRONMENTS'] = 'prodution,development,test'

    expect(subject.deny?).to be(false)
  end

  it 'denies access if env variable excludes the current Rails environment' do
    ENV['ALLOWED_SIMPLECOV_ENVIRONMENTS'] = 'prodution,development'

    expect(subject.deny?).to be(true)
  end
end
