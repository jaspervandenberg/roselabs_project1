uart.setup(0, 115200, 8, 0, 1, 1)

p_crypto = {}
--p_crypto.key = encoder.fromBase64("+vrX/9G5kSfaX8jbukkF0w==")
p_crypto.key = encoder.fromBase64("lKHLOaeUKuUFxkab3xJX8g==")

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

commun = {}

commun.server = "192.168.1.105:3000"
--commun.server = "dev.jaspervdberg.nl"

commun.setup = function(ssid, password)

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
          --wifi.sta.config(ssid, password)
          print("Connecting to AP...")
       else
          print("IP Info: \nIP Address: ", wifi.ap.getip())
          tmr.stop(2)
       end
    end)
end

commun.put = function(data, iv, deviceid)
    http.put('http://'..commun.server..'/api/v1/devices',
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

ota_updater = {}

ota_updater.getUpdate = function(deviceid)
    http.get('http://'..commun.server..'/api/v1/firmwares',
        'Content-Type: text/plain\r\nuid: '..deviceid..'\r\nLast-Checksum: '..ota_updater.readLastChecksum()..'\r\n',
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
                print("faild to get update, code: "..code)
                if(data ~= nil) then
                    print(data)
                end
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
    print(updateData)
        updateJson = cjson.decode(updateData)
        base64_encrypted_checksum = ''
        updatefile = ''
        base64_iv = ''
        for k,v in pairs(updateJson) do 

            if (k == 'base64_encrypted_checksum') then
                base64_encrypted_checksum = v
            elseif (k == 'base64_file') then
                updatefile = encoder.fromBase64(v)
                        
            elseif (k == 'base64_iv') then
                base64_iv = v
            end
        end
    
        if(ota_updater.verify_checksum(updatefile, base64_encrypted_checksum, base64_iv)) then
            file.remove("update.chk")
            for i=0, string.len(updatefile), 1000 do 
                if file.open("update.chk", "a") then
                  file.write(string.sub(updatefile, i+1 ,i + 1000))
                  file.close()
                  print(string.sub(updatefile, i+1 ,i + 1000))
                end                    
            end
            print("verified firmware writen to file")
            file.remove("update.tmp")

            ota_updater.apply_update("update.chk")
        else
            print("checksum not valid, updated firmware not writen to flash")
        end

    --end) then
    --    print("fin")
   -- else
   --     print("fail")
   -- end
        
end

ota_updater.writeChecksumToFile = function(checksum)
    if file.open("version.key", "w+") then
        file.write(checksum)
        file.close()
    end  
end

ota_updater.readLastChecksum = function()
    checksum = ''
    if file.open("version.key") then
        checksum = file.read()  
        file.close()
    end  
    return checksum
end

ota_updater.verify_checksum = function(updateContent, base64encrypted_checksum, base64IV)
    
    calculatedUpdateHash = crypto.hash("sha256", updateContent)
    checksum = p_crypto.p_decrypt(base64encrypted_checksum, base64IV)
    print(string.sub(encoder.toBase64(checksum), 0, 43)..'=')
    print(encoder.toBase64(calculatedUpdateHash))
    
    if encoder.toBase64(calculatedUpdateHash) == string.sub(encoder.toBase64(checksum), 0, 43)..'=' then
        print("checksum valid")        
        ota_updater.writeChecksumToFile(string.sub(encoder.toBase64(checksum), 0, 43)..'=')
        return true
    else
        print("checksum invalid")
        return false
    end
end

ota_updater.apply_update = function(file_name)
    print(file_name)
    file.remove("init.lua.old")
    file.rename('init.lua', 'init.lua.old')
    file.rename(file_name, 'init.lua')
    file.rename(file_name, 'init.lua')
    file.rename(file_name, 'init.lua')
    print("init.lua replaced, restart MCU")
    node.restart()
end

loop = {}

loop.sendData = function()
    tmr.alarm(0, 10000, 1, function()
    
        IV = p_crypto.generate_iv()
        encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
        
        commun.put(encryptedData, IV, "ca3u06ICx9iK4AB")
        --commun.put(encryptedData, IV, "PE8Ce51J2xt9Wby")
        
    end)
end

loop.checkForUpdate = function()
    tmr.alarm(1, 62500, 1, function()
        print("Checking for updated firmware")
        ota_updater.update("ca3u06ICx9iK4AB")
        --ota_updater.update("PE8Ce51J2xt9Wby")
  --      tmr.stop(1)
    end)
end

loop.sendData()
loop.checkForUpdate() 

commun.setup("pineapple","notanapple")