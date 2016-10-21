IV = p_crypto.generate_iv()
encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
--decryptedData = p_crypto.p_decrypt(encryptedData, IV)

commun.put(encryptedData, IV, "PE8Ce51J2xt9Wby")
print(IV)
print(encryptedData)

print(commun.get("PE8Ce51J2xt9Wby"))


countr = 0

tmr.alarm(0, 1000, 1, function()
    count = count + 1
       if count > 1 then
          tmr.stop(0)
       else
        IV = p_crypto.generate_iv()
        encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
        --decryptedData = p_crypto.p_decrypt(encryptedData, IV)
        
        commun.put(encryptedData, IV, "PE8Ce51J2xt9Wby")
        print(IV)
        print(encryptedData)
          
       end
    end)

--tmr.alarm(1, 2000, 1, function()
--    countr = countr + 1
--       if countr > 40 then
--          tmr.stop(1)
--       else
--          print("e"..countr)
--          
--       end
--    end)
