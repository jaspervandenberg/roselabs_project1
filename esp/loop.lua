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

