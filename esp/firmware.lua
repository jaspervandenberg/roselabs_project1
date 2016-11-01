uart.setup(0, 115200, 8, 0, 1, 1)
dofile("vars.lua")

commun = {}

commun.setup = function()

    enduser_setup.start(
  function()
    print("Connected to wifi as:" .. wifi.sta.getip())
  end,
  function(err, str)
    print("enduser_setup: Err #" .. err .. ": " .. str)
  end
);
    
    tmr.alarm(2, 1000, 1, function()
    
       if wifi.ap.getip() == nil then
          print("Connecting to AP...")
       else
          print("IP Info: \nIP Address: ", wifi.ap.getip())
          tmr.stop(2)
       end
    end)
end

commun.put = function(data, iv, deviceid)
    http.put('http://'..vars.server..'/api/v1/devices',
        'Content-Type: text/plain\r\nuid: '..deviceid..'\r\niv: '..iv..'\r\n',
        data,
        function(code, data)
        
            if (code < 0) then
                print("HTTP request failed")
            else
                print(code, data)
            end
        end
    )
end

commun.setup()

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

loop = {}

loop.sendData = function()
    tmr.alarm(0, 10000, 1, function()
    
        IV = p_crypto.generate_iv()
        encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(3, 32).."}], \"counter\": "..p_crypto.get_counter().."}}", IV)
        
        commun.put(encryptedData, IV, vars.uid)
        
    end)
end

loop.checkForUpdate = function()
    tmr.alarm(1, 62500, 1, function()
        print("Checking for updated firmware")
        ota_updater.update()
    end)
end

loop.sendData()
loop.checkForUpdate()