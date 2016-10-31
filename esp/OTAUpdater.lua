ota_updater = {}

ota_updater.getUpdate = function()
    http.get('http://'..vars.server..'/api/v1/firmwares',
        'Content-Type: text/plain\r\nuid: '..vars.uid..'\r\nLast-Checksum: '..encoder.toBase64(crypto.fhash("sha256","init.lua"))..'\r\n',
        function(code, data)
            if (code == 200) then

                fileHmac = crypto.hmac('sha256', data, vars.key)
                if file.open("hmac.key", "w+") then
                  file.write(encoder.toBase64(fileHmac))
                  file.close()
                end  
                
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
                print("faild to get update, code: "..code)
                if(data ~= nil) then
                    print(data)
                end
            end
        end
    )
end

ota_updater.update = function()
    updateData = ''

    if file.open("update.tmp") then
       file.close()
       
    else
        ota_updater.getUpdate()
        return
    end
    
    ota_updater.verifyAndApplyUpdate()
        
end

ota_updater.readLastChecksum = function()
    checksum = ''
    if file.open("hmac.key") then
        checksum = file.read()  
        file.close()
    end  
    return checksum
end

ota_updater.verifyAndApplyUpdate = function(updateContent, hmac_checksum)

    http.get('http://'..vars.server..'/api/v1/firmwares?hmac=true',
        'Content-Type: text/plain\r\nuid: '..vars.uid..'\r\n',
        function(code, data)
            if (code == 200) then
                if ota_updater.readLastChecksum() == data then
                    ota_updater.apply_update("update.tmp")
                    return true
                else
                    print("hmac invalid")
                    return false
                end
            else
                print("Can't get hmac")
            end
        end
    )    
end

ota_updater.apply_update = function(file_name)
    print(file_name)
    file.remove("init.lua.old")
    file.rename('init.lua', 'init.lua.old')
    file.rename(file_name, 'init.lua')
    file.rename(file_name, 'init.lua')
    file.rename(file_name, 'init.lua')
    file.remove("update.tmp")
    print("init.lua replaced, restart MCU")
    node.restart()
end
