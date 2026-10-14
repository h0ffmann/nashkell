-- The paper's title is in its front matter, and pandoc prints it. The Markdown also starts with
-- the same title as a heading, so that the page reads well on GitHub. Printed twice it is noise:
-- this filter drops the first level-1 heading and moves the other headings up one level.
local dropped = false
function Header(h)
  if h.level == 1 and not dropped then
    dropped = true
    return {}
  end
  if h.level > 1 then h.level = h.level - 1 end
  return h
end
