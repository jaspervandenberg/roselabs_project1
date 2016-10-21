update = {}

update.check = function(deviceid)
    updateFile = commun.get("PE8Ce51J2xt9Wby")
    
    if file.open("update.tmp", "w+") then      
      file.write(nextnr + 1)
      file.close()
    end
end