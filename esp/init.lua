function setup()
    dofile("commun.lua")
    dofile("p_crypto.lua")
    
    commun.setup("pineapple", "notanapple")
    
    test= p_crypto.p_encrypt("Hi, I'm secret!", "1234567890abcdef")
    
    dtest = p_crypto.p_decrypt(encoder.toBase64(test), "1234567890abcdef", encoder.toBase64(p_crypto.generate_iv()))
    
    print(dtest)
http.get("192.168.1.106", nil, function(code, data)
    if (code < 0) then
      print("HTTP request failed")
    else
      print(code, data)
    end
  end)
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


