# frozen_string_literal: true

require 'rails'
require 'simplecov_url/html_processor'

RSpec.describe SimplecovUrl::HtmlProcessor do
  subject { described_class }
  let(:fixtures_path) { File.join(File.dirname(__FILE__), 'fixtures') }

  before do
    allow(File).to receive(:read).and_call_original
    allow(Rails).to receive(:root).and_return(fixtures_path)

    String.send(:define_method, :html_safe) { to_s }
  end

  context 'failure' do
    it 'returns error message if StandardError is raised' do
      allow(File).to receive(:read).and_raise(StandardError)

      expect(subject.call).to eq('Error: Unable to load test coverage report.')
    end

    it "returns 'no_report' message if no 'index.html' available" do
      allow(File).to(
        receive(:read)
          .with(File.join(fixtures_path, 'coverage', 'index.html'))
          .and_return(nil)
      )

      expect(subject.call).to eq(subject.new.send(:no_report_message))
    end

    it "returns 'no_report' message if access for the environment is denied" do
      allow(SimplecovUrl::AccessManager).to receive(:deny?).and_return(true)

      expect(subject.call).to be(nil)
    end

    ['application.js', 'application.css'].each do |filename|
      it "returns 'frontend_error' if no '#{filename}' available" do
        allow(File).to(
          receive(:read).with(frontend_path(filename)).and_return(nil)
        )

        expect(subject.call).to eq(subject.new.send(:frontend_error, filename))
      end
    end
  end

  context 'success' do
    it 'moves frontend assets inline and returns html page' do
      expectation = File.read(File.join(fixtures_path, 'expectation.html'))
      expect(subject.call).to eq(expectation)
    end
  end

  def frontend_path(filename)
    File.join(fixtures_path, 'coverage', 'assets', '0.10.2', filename)
  end
end
