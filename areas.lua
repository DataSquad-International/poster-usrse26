-- Turns plain Quarto divs into Typst layout so coauthors never edit Typst.
--   ::: {.cells columns="1fr 1fr 1fr" gutter="70pt"}   a row of independent areas
--   ::: {.cell} ... :::                                 one area (text stays inside it)
--   ::: {.carleton} ... :::   /   ::: {.ucla} ... :::   an example tagged with its school
local function raw(s) return pandoc.RawBlock('typst', s) end

function Div(el)
  if el.classes:includes('lede') then
    local out = pandoc.List{raw('#lede[')}
    out:extend(el.content)
    out:insert(raw(']'))
    return out
  end
  if el.classes:includes('carleton') or el.classes:includes('ucla') then
    local fn = el.classes:includes('carleton') and 'carleton' or 'ucla'
    local out = pandoc.List{raw('#' .. fn .. '[')}
    out:extend(el.content)
    out:insert(raw(']'))
    return out
  end
  if el.classes:includes('cells') then
    local cols = (el.attributes['columns'] or '1fr'):gsub('%s+', ', ')
    local gut = el.attributes['gutter'] or '60pt'
    local out = pandoc.List{raw('#grid(columns: (' .. cols .. ',), column-gutter: ' .. gut .. ', row-gutter: 40pt,')}
    for _, c in ipairs(el.content) do
      if c.t == 'Div' and c.classes:includes('cell') then
        out:insert(raw('['))
        out:extend(c.content)
        out:insert(raw('],'))
      end
    end
    out:insert(raw(')'))
    return out
  end
end
