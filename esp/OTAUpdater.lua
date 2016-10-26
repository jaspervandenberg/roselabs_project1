ota_updater = {}

ota_updater.getUpdate = function(deviceid)
    http.get('http://'..commun.server..'/api/v1/firmwares',
        'Content-Type: text/plain\r\nuid: '..deviceid..'\r\n',
        function(code, data)
            if (code == 200) then


                for i=0, string.len(data), 1000 do 
                    if file.open("update.tmp", "a") then
                      file.write(string.sub(data, i+1 ,i + 1000))
                      file.close()
                      print(string.sub(data, i+1 ,i + 1000))
                    end                    
                end
                print("update writen to file")
            
                
            elseif (code == 204) then
                print("No new Firmware")
            else
                print("faild to get update")
            end
        end
    )
end

ota_updater.update = function(deviceid)
    updateData = ''

    if file.open("update.tmp") then
        fileread = file.read()
        while fileread do
            if(fileread ~= nil) then
                updateData = updateData..fileread
            end
            fileread = file.read()    
            
        end
        file.close()
    else
        ota_updater.getUpdate(deviceid)
        return
    end

    --if pcall(function() 
        updateJson = cjson.decode(updateData)
        base64_encrypted_checksum = ''
        updatefile = ''
        base64_iv = ''
        for k,v in pairs(updateJson) do 

            if (k == 'base64_encrypted_checksum') then
                base64_encrypted_checksum = v
            elseif (k == 'base64_file') then
                print(v)
                updatefile = encoder.fromBase64(v)
                        
            elseif (k == 'base64_iv') then
                base64_iv = v
            end
        end
    
        if(ota_updater.verify_checksum(updatefile, base64_encrypted_checksum, base64_iv)) then
            if file.open("update.chk", "w+") then
              file.write(updatefile)
              file.close()
              print("verified firmware writen to file")
            end
            file.remove("update.tmp")
        else
            print("checksum not valid, updated firmware not writen to flash")
        end

    --end) then
    --    print("fin")
   -- else
   --     print("fail")
   -- end
        
end

ota_updater.verify_checksum = function(updateContent, base64encrypted_checksum, base64IV)
    
    calculatedUpdateHash = crypto.hash("sha1", updateContent)
    checksum = p_crypto.p_decrypt(base64encrypted_checksum, base64IV)
    
    if encrypted_file_hash == encrypted_checksum then
        print("checksum valid")
        ota_updater.apply_update("update.chk")
        return true
    else
        print("checksum invalid")
        return false
    end
end

ota_updater.apply_update = function(file_name)
    file.rename('init.lua', 'init.lua.old')
    file.rename(file_name, 'init.lua')
    node.restart()
end