commun = {}

commun.server = "dev.jaspervdberg.nl"

commun.setup = function(ssid, password)
    tmr.alarm(0, 1000, 1, function()
       if wifi.ap.getip() == nil then
          wifi.sta.config(ssid, password)
          print("Connecting to AP...")
       else
          print("IP Info: \nIP Address: ", wifi.ap.getip())
          tmr.stop(0)
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

commun.get = function(deviceid)
    http.get('http://'..commun.server..'/api/v1/firmwares',
        'Content-Type: text/plain\r\nuid: '..deviceid..'\r\n',
        nil,
        function(code, data)
            if (code < 0) then
                print("HTTP request failed")
                return false
            else
                return data
            end
        end
    )
end