require 'spec_helper'

describe 'handler' do
  let(:event_payload)     { File.read("spec/events/#{filename}.json") }
  let(:event)             { {'body' => event_payload} }

  let(:response)          { handler(event: event, context: {}) }
  let(:parsed_body)       { JSON.parse(response[:body]) }

  let!(:stub)             { stub_request(:post, "https://slack.com/api/chat.postMessage").to_return(status: 200, body: "", headers: {}) }

  context 'failed' do
    let(:filename)        { 'sample_body_failed' }

    it 'works' do
      expect(parsed_body['message']).to eq "Failure detected"

      expect(stub).to have_been_requested
    end
  end

  context 'success' do
    let(:filename)        { 'sample_body_success' }

    it 'works' do
      expect(parsed_body['message']).to eq "No failure detected"

      expect(stub).to_not have_been_requested
    end
  end

  context 'success after failed' do
    let(:filename)        { 'sample_body_success_after_failed' }

    it 'works' do
      expect(parsed_body['message']).to eq "No failure detected"

      expect(stub).to_not have_been_requested
    end
  end
end
