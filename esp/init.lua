function setup()
    dofile("commun.lua")

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
