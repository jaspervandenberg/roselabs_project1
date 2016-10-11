commun = {}

commun.server = "spectre"

commun.setup = function(ssid, password)
    wifi.sta.config(ssid, password)
end

commun.post = function(data)
    http.put('http://'..commun.server..':3000/api/v1/devices',
        'Content-Type: text/plain\r\nuid: 2zCpe4HRSho78T3\r\niv: ivivivivivivivi',
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

