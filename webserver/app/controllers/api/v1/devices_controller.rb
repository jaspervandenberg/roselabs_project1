class Api::V1::DevicesController < Api::V1::ApplicationController
  include AESDecryptor

  def update
    # Make sure the request is not repeated
    if @device.nil? && request.headers['iv'].nil? && request.headers['iv'].last(8).to_i - 10000000 < @device.blood_sugars.count
      # Fake decryption to prevent timing attacks
      decrypt_body(request.body.string, 'thisisafdflkjwflkwejlfkakeiv', Device.first)
    else
      body = decrypt_body(request.body.string, request.headers['iv'], @device)
      json_body = JSON.parse(body.strip)['device']['blood_sugars']
      json_body.each do |sugar_level|
        @device.blood_sugars.create(level: sugar_level['level'])
      end
    end

    render nothing: true, status: 204

  end
end
