p_crypto = {}
--p_crypto.key = encoder.fromBase64("+vrX/9G5kSfaX8jbukkF0w==")
p_crypto.key = encoder.fromBase64("+vrX/9G5kSfaX8jbukkF0w==")

--Decrypts using a base64 encoded body and iv(nounce)
p_crypto.p_decrypt = function(base64Body, base64IV)
    return crypto.decrypt("AES-CBC", p_crypto.key, encoder.fromBase64(base64Body), encoder.fromBase64(base64IV))
end

--Encrypts using a generated iv
p_crypto.p_encrypt = function(body, IV)
    encryptedData = crypto.encrypt("AES-CBC", p_crypto.key, body, IV)
    return encoder.toBase64(encryptedData)
end

--Generate iv for encryption
p_crypto.generate_iv = function()
    nextnr = 10000000
    if file.open("counter.num") then
      nextnr = file.read()
      file.close()
    end
    
    if file.open("counter.num", "w+") then
      file.write(nextnr + 1)
      file.close()
    end

    return math.random(10000000, 99999999)..nextnr
end



