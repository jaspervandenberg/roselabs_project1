ota_updater = {}


ota_updater.write_base64_to_file = function(base64_string, filename)
    update = encoder.fromBase64(base64_string)
    
    file.open(filename, 'w+') then
        file.write(update)
        file.close()
    end
end

ota_updater.verify_checksum = function(file_name, encrypted_checksum)
    file.open(filename, 'r') then
        conent = file.read()
        file.close()
    end
    
    -- TODO get iv from headers/request body
    iv = 'iv needs to come here'
    file_hash = crypto.toBase64(crypto.hash("sha1", content))
    encrypted_file_hash = p_crypto.p_encrypt(file_hash, iv)
    
    if encrypted_file_hash == encrypted_checksum
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

ota_updater.check_for_update = function(server_hostname, device_id)
    http.get('http://' .. server_hostname .. '/api/v1/firmwares',
        'Content-Type: text/plain\r\nuid: '..deviceid..'\r\n',
        function(code, data)
            if (code == 204) then
                return false
            else
                return data
            end
        end
        )    
end
