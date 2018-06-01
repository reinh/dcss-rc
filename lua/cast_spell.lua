-- Spellcasting spam reduction by monqy
local function generic_cast_spell(cmd)
  crawl.mpr('<cyan>Cast which spell?</cyan>')
  crawl.flush_prev_message()
  crawl.process_keys(cmd)
end

function cast_spell()
  generic_cast_spell('z')
end

function force_cast_spell()
  generic_cast_spell('Z')
end
