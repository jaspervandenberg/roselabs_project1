ota_updater = {}


ota_updater.write_base64_to_file = function(base64_string, filename)
    update = encoder.fromBase64(base64_string)
    
    if file.open(filename, 'w+') then
        file.write(update)
        file.close()
    end
end

ota_updater.verify_checksum = function(file_name, encrypted_checksum)
    if file.open(filename, 'r') then
        conent = file.read()
        file.close()
    end
    
    -- TODO get iv from headers/request body
    iv = 'iv needs to come here'
    file_hash = crypto.toBase64(crypto.hash("sha1", content))
    encrypted_file_hash = p_crypto.p_encrypt(file_hash, iv)
    
    if encrypted_file_hash == encrypted_checksum then
        return true
    else
        return false
    end
end

ota_updater.apply_update = function(file_name)
    file.rename('init.lua', 'init.lua.old')
    file.rename(file_name, 'init.lua')
    node.restart()
end
