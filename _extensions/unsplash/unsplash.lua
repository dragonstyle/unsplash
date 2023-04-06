
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

    local height = 300
    local width = 300
    local keywords = nil
    if args[1] ~= nil then
      keywords = pandoc.utils.stringify(args[1])
    end
    if kwargs['height'] ~= nil then
      local rawHeight = tonumber(pandoc.utils.stringify(kwargs['height']))
      if rawHeight ~= nil then
        height = math.floor(rawHeight)
      end
    end
    if kwargs['width'] ~= nil then
      local rawWidth = tonumber(pandoc.utils.stringify(kwargs['width']))
      if rawWidth ~= nil then
        width = math.floor(rawWidth)
      end

    end

    local url = "https://source.unsplash.com/random/" .. tostring(width) .. '×' .. tostring(height) .. ""
    if keywords ~= nil then
      url = url .. '/?' .. keywords
    end



    -- read the image
    local imgMt, imgContents = pandoc.mediabag.fetch(url)

    -- place it in media bag and link to it
    if imgContents ~= nil then
      local filename = pandoc.path.filename(os.tmpname()) ..'.' .. mimeImgExts[imgMt]
      pandoc.mediabag.insert(filename, imgMt, imgContents)
      local imgAttr = pandoc.Attr("", "", {["height"]=tostring(height), ["width"]=tostring(width)})
      local img = pandoc.Image("", filename, "", imgAttr)
      quarto.log.output(img)
      return img
    end
  end
}


