
local mimeImgExts = {
  ["image/jpeg"]="jpg",
  ["image/gif"]="gif",
  ["image/vnd.microsoft.icon"]="ico",
  ["image/avif"]="avif",
  ["image/bmp"]="bmp",
  ["image/png"]="png",
  ["image/svg+xml"]="svg",
  ["image/tiff"]="tif",
  ["image/webp"]="webp",
}

local function file_exists(name)
  local f = io.open(name, 'r')
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

local function write_file(path, contents, mode)
  pandoc.system.make_directory(pandoc.path.directory(path), true)
  mode = mode or "a"
  local file = io.open(path, mode)
  if file then
    file:write(contents)
    file:close()
    return true
  else
    return false
  end
end




return {
  ['unsplash'] = function(args, kwargs, meta) 

    
    -- positional == keywords
    -- {{< unsplash cat >}}
    -- {{< unsplash keywords="cats" height="300" width="300"}}

    -- TODO: use the real api to download a copy of the image using rest
    -- TODO: ping the download url
    -- TODO: Generate a stable name for the image 
    -- TODO: Make this a format resource instead of media bag, so images become stable
    -- TODO: generate more complete information from REST endpoint to credit author

    local height = nil
    local width = nil
    local keywords = nil
    
    local filename
    if args[1] ~= nil then
      filename = pandoc.utils.stringify(args[1])
      local stem = pandoc.path.split_extension(pandoc.path.filename(filename))
      keywords = stem
    end

    if kwargs['height'] ~= nil and #kwargs['height'] > 0 then
      local rawHeight = tonumber(pandoc.utils.stringify(kwargs['height']))
      if rawHeight ~= nil then
        height = math.floor(rawHeight)
      end
    end
    if kwargs['width'] ~= nil and #kwargs['width'] > 0 then
      local rawWidth = tonumber(pandoc.utils.stringify(kwargs['width']))
      if rawWidth ~= nil then
        width = math.floor(rawWidth)
      end
    end
    if kwargs['keywords'] ~= nil and #kwargs['keywords'] > 0 then
      keywords = pandoc.utils.stringify(kwargs['keywords'])
    end

    local url = "https://source.unsplash.com/random"
    if width and height then
      url = url .. "/" .. tostring(width) .. '×' .. tostring(height)
    end
    if keywords ~= nil then
      url = url .. '/?' .. keywords
    end

    local imgAttrRaw = {}
    if width then
      imgAttrRaw['width'] = width
    end
    if height then
      imgAttrRaw['height'] = height
    end
    local imgAttr = pandoc.Attr("", {}, imgAttrRaw)

    if filename ~= nil and file_exists(filename) then
      return pandoc.Image("", filename, "", imgAttr)
    elseif filename ~= nil then
      -- read the image
      local _imgMt, imgContents = pandoc.mediabag.fetch(url)
      write_file(filename, imgContents, "wb")
      return pandoc.Image("", filename, "", imgAttr)
    else
      -- read the image
      local imgMt, imgContents = pandoc.mediabag.fetch(url)

      -- place it in media bag and link to it
      if imgContents ~= nil then
        local tmpFileName = pandoc.path.filename(os.tmpname()) ..'.' .. mimeImgExts[imgMt]
        pandoc.mediabag.insert(tmpFileName, imgMt, imgContents)
        return pandoc.Image("", tmpFileName, "", imgAttr)
      end
    end


  end
}


