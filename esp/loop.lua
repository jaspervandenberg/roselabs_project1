loop = {}

loop.sendData = function()
    tmr.alarm(0, 10000, 1, function()
    
        IV = p_crypto.generate_iv()
        encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
        
        commun.put(encryptedData, IV, "hallojasper")
        
    end)
end

loop.checkForUpdate = function()
    tmr.alarm(1, 60000, 1, function()
        print("Checking for updated firmware")
        print(commun.get("aaa"))
    end)
end

loop.sendData()
loop.checkForUpdate()
