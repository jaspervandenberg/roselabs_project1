p_crypto = {}

--Decrypts using a base64 encoded body and iv(nounce)
p_crypto.p_decrypt = function(body, key, iv)
    return crypto.decrypt("AES-CBC", key, encoder.fromBase64(body), encoder.fromBase64(iv))
end

--Encrypts using a generated iv
p_crypto.p_encrypt = function(body, key)
    return crypto.encrypt("AES-CBC", key, body, p_crypto.generate_iv());
end;

--Generate iv for encryption
p_crypto.generate_iv = function()
    return "ditiseennietwillekeurigeiv"
end



