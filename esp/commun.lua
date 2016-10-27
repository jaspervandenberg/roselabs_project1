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
