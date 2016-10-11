commun = {}

commun.serverip = "192.168.1.100"

commun.setup = function(ssid, password)
    wifi.sta.config(ssid, password)
end

commun.post = function(data)
    http.post('http://httpbin.org/post',
        'Content-Type: text/plain\r\n',
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

