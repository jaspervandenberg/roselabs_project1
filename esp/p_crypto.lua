p_crypto = {}

p_crypto.p_decrypt = function(base64Body, base64IV)
    return crypto.decrypt("AES-CBC", vars.key, encoder.fromBase64(base64Body), encoder.fromBase64(base64IV))
end

p_crypto.p_encrypt = function(body, IV)
    encryptedData = crypto.encrypt("AES-CBC", vars.key, body, IV)
    return encoder.toBase64(encryptedData)
end

p_crypto.generate_iv = function()
    return math.random(10000000, 99999999)..math.random(10000000, 99999999)
end

p_crypto.get_counter = function()
    nextnr = 10000000
    if file.open("counter.num") then
      nextnr = file.read()
      file.close()
    end
    
    if file.open("counter.num", "w+") then
      file.write(nextnr + 1)
      file.close()
    end

    return nextnr
end


