local bootstrap = dofile("lua/custom/bootstrap.lua")
local function check(mode)
 local calls,removed,renamed={},false,false
 local deps={
  exists=function(p) return mode=="existing" or mode=="mismatch" or mode=="dirty" end,
  run=function(args)
   table.insert(calls,args)
   if mode=="offline" then return {code=1,stderr="synthetic failure"} end
   if args[4]=="rev-parse" then return {code=0,stdout=mode=="mismatch" and "wrong" or bootstrap.revision} end
   if args[4]=="status" then return {code=0,stdout=mode=="dirty" and " M lua/init.lua" or ""} end
   return {code=0,stdout=""}
  end,
  remove=function() removed=true end,
  rename=function() renamed=true;return true end,
 }
 local ok=pcall(bootstrap.ensure,"/synthetic/lazy.nvim",deps)
 if mode=="offline" then assert(not ok and removed and not renamed)
 elseif mode=="mismatch" or mode=="dirty" then assert(not ok and not removed and not renamed)
 elseif mode=="existing" then assert(ok and #calls==2 and not renamed)
 else assert(ok and renamed and not removed) end
end
for _,mode in ipairs({"fresh","existing","offline","mismatch","dirty"}) do check(mode) end
local lock=vim.json.decode(table.concat(vim.fn.readfile('lazy-lock.json'),'\n'))
assert(lock['lazy.nvim'].commit==bootstrap.revision,'Update lock and bootstrap pin together')
print('Five isolated bootstrap scenarios and lock consistency passed')
