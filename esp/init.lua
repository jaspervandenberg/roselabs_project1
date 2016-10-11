function setup()
    dofile("commun.lua")
    dofile("p_crypto.lua")
    
    commun.setup("pineapple", "notanapple")
    base64_key = encoder.fromBase64("MJ4h1Le2SpWtbr93CuyrwQ==")
    test = encoder.toBase64(p_crypto.p_encrypt("{\"device\": {\"blood_sugars\": [{\"level\": 10}, {\"level\": 20}]}}", base64_key))
    
    dtest = p_crypto.p_decrypt(encoder.toBase64(test), "1234567890abcdef", encoder.toBase64(p_crypto.generate_iv()))

    print("Encrypte encode data: " .. test)
    print("Encrypte decode data: ".. encoder.fromBase64(test))
    print(" ")
    print("Encode key: " .. encoder.toBase64(base64_key))
    print("Decode key: ".. base64_key)
    
    --commun.post(encoder.toBase64(test))
end

function loop()
    print("t")
    delay_ms(10000)
end
function delay_ms (milli_secs)
   local ms = milli_secs * 1000
   local timestart = tmr.now ( )
   while (tmr.now ( ) - timestart < ms) do
      tmr.wdclr ( )
   end
end


setup ( )
--while (1) do
--   loop ( )
--end
