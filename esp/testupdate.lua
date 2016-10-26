uart.setup(0, 115200, 8, 0, 1, 1)


dofile("p_crypto.lua")
dofile("commun.lua")
dofile("OTAUpdater.lua")
commun.setup("pineapple","notanapple")
dofile("loop.lua")

tmr.alarm(2, 5000, 1, function()
	print("Firmware v0.9, 26-10-2016")
	tmr.stop(2)
end)