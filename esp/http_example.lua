-- Connect
tmr.alarm(0, 1000, 1, function()
   if wifi.sta.getip() == nil then
      wifi.sta.config("pineapple", "notanapple")
      print("Connecting to AP...\n")
   else
      print("IP Info: \nIP Address: ", ip)
      tmr.stop(0)
   end
end)

http.put("http://192.168.1.105:3000/api/v1/devices", 'Content-Type: text/plain', 'encrypted data goes here',
    function(code, data)
        if (code < 0) then
            print("HTTP request failed")
        else
            print(code, data)
    end
end)
