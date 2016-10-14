dofile("commun.lua")
dofile("p_crypto.lua")
--commun.setup("pineapple","notanapple")

IV = p_crypto.generate_iv()
encryptedData = p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": "..math.random(10, 99).."}]}}", IV)
--decryptedData = p_crypto.p_decrypt(encryptedData, IV)

--commun.put(encryptedData, IV, "2zCpe4HRSho78T3")
print(p_crypto.generate_iv())


count = 0
countr = 0

tmr.alarm(0, 1000, 1, function()
    count = count + 1
       if count > 40 then
          tmr.stop(0)
       else
          print("t"..count)
          
       end
    end)

tmr.alarm(1, 2000, 1, function()
    countr = countr + 1
       if countr > 40 then
          tmr.stop(1)
       else
          print("e"..countr)
          
       end
    end)