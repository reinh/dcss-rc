---------------------------
---- Begin force_mores ----
---------------------------

-- See README.md for documentation.

last_turn = you.turns()

-- Each entry must have a name field with a descriptive name, a pattern field
-- giving the regexp matching the appropriate monster(s), a cond field giving
-- the condition type, and a cutoff field giving the max value where the
-- force-more is active. Possible values for cond are xl and maxhp. Note that
-- the final force_more pattern will be "(PATTERN).*into view" where PATTERN is
-- the value from the pattern field if that is a string, or if pattern is an
-- array, a string made from joining the entries in pattern with '|'.

fm_patterns = {
  -- Fast, early game Dungeon problems for chars with low mhp.
  {name = "30mhp", cond = "maxhp", cutoff = 30,
   pattern = "adder|hound"},
  -- Dungeon monsters that can damage you for close to 50% of your mhp with a
  -- ranged attack.
  {name = "40mhp", cond = "maxhp", cutoff = 40,
   pattern = "orc priest|electric eel"},
  {name = "60mhp", cond = "maxhp", cutoff = 60,
   pattern = "acid dragon|steam dragon|manticore"},
  {name = "70mhp", cond = "maxhp", cutoff = 70,
   pattern = "centaur|meliai|yaktaur"},
  {name = "80mhp", cond = "maxhp", cutoff = 80,
   pattern = "gargoyle|orc (warlord|knight)"},
  {name = "90mhp", cond = "maxhp", cutoff = 90,
   pattern = "centaur warrior|efreet|molten gargoyle|tengu conjurer"},
  {name = "110mhp", cond = "maxhp", cutoff = 110,
   pattern = {"centaur warrior", "deep elf", "cyclops", "efreet",
              "molten gargoyle", "tengu conjurer", "yaktaur captain",
              "necromancer", "deep troll earth mage", "hell knight",
              "stone giant"} },
  {name = "160mhp", cond = "maxhp", cutoff = 160,
   pattern = {"(fire|ice|quicksilver|shadow|storm) dragon",
              "(fire|frost) giant", "war gargoyle"} },
} -- end fm_patterns

active_fm = {}
-- Set to true to get a message when the fm change
notify_fm = false

-- Wrapper of crawl.mpr() that prints text in white by default.
if not mpr then
  mpr = function (msg, color)
    if not color then
      color = "white"
    end
    crawl.mpr("<" .. color .. ">" .. msg .. "</" .. color .. ">")
  end
end

function init_force_mores()
  for i,v in ipairs(fm_patterns) do
    active_fm[#active_fm + 1] = false
  end
end

function update_force_mores()
  local activated = {}
  local deactivated = {}
  local hp, maxhp = you.hp()
  for i,v in ipairs(fm_patterns) do
    local msg = nil
    if type(v.pattern) == "table" then
      for j, p in ipairs(v.pattern) do
        if msg == nil then
          msg = p
        else
          msg = msg .. "|" .. p
        end
      end
    else
      msg = v.pattern
    end
    msg = "(" .. msg .. ").*into view"
    local action = nil
    local fm_name = v.pattern
    if v.name then
      fm_name = v.name
    end
    if not v.cond and not active_fm[i] then
      action = "+"
    elseif v.cond == "xl" then
      if active_fm[i] and you.xl() >= v.cutoff then
        action = "-"
      elseif not active_fm[i] and you.xl() < v.cutoff then
        action = "+"
      end
    elseif v.cond == "maxhp" then
      if active_fm[i] and maxhp >= v.cutoff then
        action = "-"
      elseif not active_fm[i] and maxhp < v.cutoff then
        action = "+"
      end
    end
    if action == "+" then
      activated[#activated + 1] = fm_name
    elseif action == "-" then
      deactivated[#deactivated + 1] = fm_name
    end
    if action ~= nil then
      local opt = "force_more_message " .. action .. "= " .. msg
      crawl.setopt(opt)
      active_fm[i] = not active_fm[i]
    end
  end
  if #activated > 0 and notify_fm then
    mpr("Activating force_mores: " .. table.concat(activated, ", "))
  end
  if #deactivated > 0 and notify_fm then
    mpr("Deactivating force_mores: " .. table.concat(deactivated, ", "))
  end
end

local last_turn = nil
function force_mores()
  if last_turn ~= you.turns() then
    update_force_mores()
    last_turn = you.turns()
  end
end

init_force_mores()

-------------------------
---- End force_mores ----
-------------------------
