local wezterm = require 'wezterm';

wezterm.on("update-right-status", function(window, pane)
  -- Each element holds the text for a cell in a "powerline" style << fade
  local cells = {};

  -- Figure out the cwd and host of the current pane.
  -- This will pick up the hostname for the remote host if your
  -- shell is using OSC 7 on the remote host.
  local cwd_uri = pane:get_current_working_dir()
  local hostname = ""
  if cwd_uri then
    print(cwd_uri)
    cwd_uri = cwd_uri:sub(8);
    local slash = cwd_uri:find("/")
    local cwd = ""
    if slash then
      hostname = cwd_uri:sub(1, slash-1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot-1)
      end

      -- and extract the cwd from the uri
      cwd = cwd_uri:sub(slash, #cwd_uri-1)
      -- we shorten it if it's too long
      if #cwd > 20 then
        local folders = {}
        for str in string.gmatch(cwd, "([^/]+)") do
          table.insert(folders, str)
        end
        local new_cwd = "/"

        -- like vim, just take 1st char of every folder except the last
        for i, f in ipairs(folders) do 
          if i ~= #folders then
            if f:sub(i,i) ~= "." then
                new_cwd = new_cwd..f:sub(i,i).."/"
            else
                new_cwd = new_cwd..f:sub(i,i+1).."/"
            end
          else
            new_cwd = new_cwd..f
          end
        end

        cwd = new_cwd
      end

      table.insert(cells, cwd);
    end
  end

  -- Simple datetime, e.g. "15:14"
  local date = wezterm.strftime("%H:%M");
  table.insert(cells, date);

  -- Hostname at the end
  table.insert(cells, hostname);

  -- The powerline < symbol
  local LEFT_ARROW = utf8.char(0xe0b3);
  -- The filled in variant of the < symbol
  local SOLID_LEFT_ARROW = utf8.char(0xe0b2)

  -- Color palette for the backgrounds of each cell
  local colors = {
    "#3c1361",
    "#52307c",
    "#663a82",
    "#7c5295",
    "#b491c8",
  };

  -- Foreground color for the text across the fade
  local text_fg = "#c0c0c0";

  -- The elements to be formatted
  local elements = {};
  -- How many cells have been formatted
  local num_cells = 0;

  -- Translate a cell into elements
  function push(text, is_last)
    local cell_no = num_cells + 1
    table.insert(elements, {Foreground={Color=text_fg}})
    table.insert(elements, {Background={Color=colors[cell_no]}})
    table.insert(elements, {Text=" "..text.." "})
    if not is_last then
      table.insert(elements, {Foreground={Color=colors[cell_no+1]}})
      table.insert(elements, {Text=SOLID_LEFT_ARROW})
    end
    num_cells = num_cells + 1
  end

  while #cells > 0 do
    local cell = table.remove(cells, 1)
    push(cell, #cells == 0)
  end

  window:set_right_status(wezterm.format(elements));
end);
