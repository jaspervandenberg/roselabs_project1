class Api::V1::DevicesController < Api::V1::ApplicationController
  include AESDecryptor

  def update
    if @device.nil?
      # Fake decryption to prevent timing attacks
      decrypt_body(request.body.string, 'thisisafdflkjwflkwejlfkakeiv', Device.first)
    else
      begin
        body = decrypt_body(request.body.string, request.headers['iv'], @device)
        json_body = JSON.parse(body.strip)['device']['blood_sugars']
        json_body.each do |sugar_level|
          @device.blood_sugars.create(level: sugar_level['level'])
        end
      rescue OpenSSL::Cipher::CipherError
      end
    end

    render nothing: true, status: 204

  end
end
