# frozen_string_literal: true

require_relative "service"

module Swiftner
  module API
    # Docs (remember to do!)
    class LinkedContent < Service   
      def self.find_linked_contents
        response = client.get("/linked-content/get-all/")
        map_collection(response)
      end

      def self.find(linked_content_id)
        response = client.get("/linked-content/get/#{linked_content_id}")
        build(response.parsed_response)
      end

      def self.create(attributes)
        validate_required(attributes, :url)

        response = client.post(
          "/linked-content/create",
          body: attributes.to_json,
          headers: { "Content-Type" => "application/json" }
        )

        build(response.parsed_response)
      end

      def update(attributes)
        attributes = attributes.transform_keys(&:to_s)
        @details = @details.merge(attributes)

        client.put(
          "/linked-content/update/#{id}",
          body: @details.to_json,
          headers: { "Content-Type" => "application/json" }
        )
        self
      end

      def transcriptions
        response = client.get("/linked-content/get/#{id}/transcriptions")
        response.map { |transcription| API::Transcription.build(transcription) }
      end
    end
  end
end