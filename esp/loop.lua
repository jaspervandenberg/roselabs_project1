loop = {}

loop.sendData = function()
    tmr.alarm(0, 10000, 1, function()
    
        IV = p_crypto.generate_iv()
        encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
        
        commun.put(encryptedData, IV, "rBhktM46dV0YT27")
        
    end)
end

loop.checkForUpdate = function()
    tmr.alarm(1, 7000, 1, function()
        print("Checking for updated firmware")
        ota_updater.update("rBhktM46dV0YT27")
        tmr.stop(1)
    end)
end

--loop.sendData()
loop.checkForUpdate() 

