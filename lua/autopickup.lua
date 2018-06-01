-- Equipment autopickup (by Medar and various others)
local function pickup_equipment(it, name)
  if it.is_useless then return end

  local class = it.class(true)
  if class == "armour" then
    local good_slots = {cloak="Cloak", helmet="Helmet",
                        gloves="Gloves", boots="Boots"}
    st, _ = it.subtype()

    -- Autopickup found aux armour if 1) we don't have any or 2) it's artefact,
    -- or 3) if we don't have artefact or ego armour, and the found armour is
    -- ego.
    if good_slots[st] ~= nil then
      if good_slots[st] == "Gloves" and you.has_claws() > 0 then return end

      if it.artefact then return true end

      local cur = items.equipped_at(good_slots[st])
      if cur == nil then return true end

      if cur.branded or cur.artefact then return end
      if it.branded then return true end
      -- Autopickup found body armour of the same kind we're wearing, according
      -- to conditions (2) and (3) above used for aux slots.
    elseif st == "body" then
      local cur = items.equipped_at("armour")
      if cur == nil then return end
      if cur.name("qual") ~= it.name("qual") then return end

      if it.artefact then return true end

      if cur.branded or cur.artefact then return end
      if it.branded then return true end
    end
  end
  return
end

add_autopickup_func(pickup_equipment)
