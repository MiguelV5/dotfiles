local M = {}

function GetPath(str)
	local sep = '/'
	if ya.target_family() == "windows" then
		sep = '\\'
	end
    return str:match("(.*"..sep..")")
end

-- 1. Modified: Restricted tags to Title, Artist, Album, and Duration
function Exiftool(...)
	local child = Command("exiftool")
		:arg{
			"-q", "-q", "-S", 
			"-Title", "-Artist", "-Album", "-Duration", 
			tostring(...),
		}
		:stdout(Command.PIPED)
		:stderr(Command.NULL)
		:spawn()
	return child
end

function Mediainfo(...)
	local file, cache_dir = ...
	local template = cache_dir.."mediainfo.txt"
	local child = Command("mediainfo")
		:arg{
			"--Output=file://"..template, tostring(file)
		}
		:stdout(Command.PIPED)
		:stderr(Command.NULL)
		:spawn()
	return child
end

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then return end

	local cache_dir = GetPath(tostring(cache))

	local status, child = pcall(Mediainfo, job.file.url, cache_dir)
	if not status or child == nil then
		status, child = pcall(Exiftool, job.file.url)
		if not status or child == nil then
			local error = ui.Line { ui.Span("Make sure exiftool is installed") }
			local p = ui.Text(error):area(job.area):wrap(ui.Wrap.YES)
			ya.preview_widget(job, { p })
			return
		end
	end

	local limit = job.area.h
	local i, metadata = 0, {}
	repeat
		local next, event = child:read_line()
		if event == 1 then return self:fallback_to_builtin()
		elseif event ~= 0 then break end

		i = i + 1
		if i > job.skip then
			local m_title, m_tag = Prettify(next)
			if m_title ~= "" and m_tag ~= "" then
				table.insert(metadata, ui.Line{ ui.Span(m_title):bold(), ui.Span(m_tag) })
				-- Removed the extra empty line to save space for the image
			end
		end
	until i >= job.skip + limit

	local p = ui.Text(metadata):area(job.area):wrap(ui.Wrap.YES)
	ya.preview_widget(job, { p })

	-- 2. Modified: Increased image size (occupies bottom 65% of the area)
	local cover_width = job.area.w
	local cover_height = math.floor(job.area.h * 0.65)

	local bottom_rect = ui.Rect {
		x = job.area.x,
		y = job.area.bottom - cover_height,
		w = cover_width,
		h = cover_height,
	}

	if self:preload(job) == true then
		ya.image_show(cache, bottom_rect)
	end
end

function Prettify(metadata)
	local substitutions = {
		Title = "Title:",
		Artist = "Artist:",
		Album = "Album:",
		Duration = "Duration:"
	}

	for k, v in pairs(substitutions) do
		metadata = metadata:gsub(tostring(k)..":", v, 1)
	end

	local t={}
	for str in string.gmatch(metadata , "([^"..":".."]+)") do
		if str ~= "\n" then table.insert(t, str) end
	end

	local title, tag_data = "", ""
	if t[1] ~= nil then
		title, tag_data = t[1]..": ", table.concat(t, ":", 2)
	end
	return title, tag_data
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		ya.manager_emit("peek", {
			tostring(math.max(0, cx.active.preview.skip + job.units)),
			only_if = tostring(job.file.url),
		})
	end
end

-- 3. Modified: Stripped the Mediainfo template to the bare essentials
function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache or fs.cha(cache) then return true end

	local mediainfo_template = 'General;"\
$if(%Title%,Title: %Title%,)\
$if(%Performer%,Artist: %Performer%,)\
$if(%Album%,Album: %Album%,)\
$if(%Duration/String%,Duration: %Duration/String%)\
"'

	local cache_dir = GetPath(tostring(cache))
	fs.write(Url(cache_dir.."mediainfo.txt"), mediainfo_template)

	local output = Command("exiftool")
		:arg{ "-b", "-CoverArt", "-Picture", tostring(job.file.url) }
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then return true end
	return fs.write(cache, output.stdout) and true or false
end

return M

