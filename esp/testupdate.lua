dofile("p_crypto.lua")
dofile("commun.lua")
dofile("OTAUpdater.lua")
commun.setup("pineapple","notanapple")
dofile("loop.lua")

tmr.alarm(0, 10000, 1, function()
	print("I'm updated, the new init.lua")
end)