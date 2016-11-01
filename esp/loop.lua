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

