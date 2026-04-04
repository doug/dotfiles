local M = {}

local STRIPS = 2
local DPI = 300

-- Detect display mode from preview area dimensions:
--   side pane: area.w is roughly 1/3 of terminal → not wide
--   fullscreen on big monitor (30"): area.w > 160 columns → full page fits
--   fullscreen on laptop: area.w between ~100-160 → needs strips
local function display_mode(area)
	if area.w <= area.h * 1.5 then
		return "pane"
	elseif area.w > 160 then
		return "fullscreen_big"
	else
		return "fullscreen_small"
	end
end

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then
		return
	end

	local mode = display_mode(job.area)
	local ok, err = self:render(job, cache, mode)
	if not ok or err then
		return ya.preview_widget(job, err)
	end

	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek(job)
	local h = cx.active.current.hovered
	if not h or h.url ~= job.file.url then
		return
	end

	local step = job.units > 0 and 1 or -1
	ya.emit("peek", {
		math.max(0, cx.active.preview.skip + step),
		only_if = job.file.url,
	})
end

function M:render(job, cache, mode)
	local cache_str = tostring(cache)

	if mode == "pane" or mode == "fullscreen_big" then
		-- Side pane or big monitor fullscreen: full page
		local args = {
			"-f", tostring(job.skip + 1),
			"-l", tostring(job.skip + 1),
			"-singlefile",
		}
		-- Render at high DPI for fullscreen, default for side pane
		if mode == "fullscreen_big" then
			args[#args + 1] = "-r"
			args[#args + 1] = tostring(DPI)
		end
		args[#args + 1] = "-jpeg"
		args[#args + 1] = "-jpegopt"
		args[#args + 1] = "quality=" .. rt.preview.image_quality

		args[#args + 1] = tostring(job.file.path)
		args[#args + 1] = cache_str

		local output, err = Command("pdftoppm"):arg(args):output()

		if not output then
			return true, Err("pdftoppm failed: %s", err)
		elseif not output.status.success then
			local pages = job.skip > 0 and tonumber(output.stderr:match("the last page %((%d+)%)"))
			return true, Err("pdftoppm: %s", output.stderr), pages
		end

		ya.image_precache(Url(cache_str .. ".jpg"), cache)
		return true
	end

	-- Fullscreen: render half-page strips
	local page = math.floor(job.skip / STRIPS) + 1
	local strip = job.skip % STRIPS

	local info = Command("pdfinfo"):arg({ tostring(job.file.path) }):output()
	if not info or not info.status.success then
		return true, Err("pdfinfo failed")
	end

	local pw, ph = info.stdout:match("Page size:%s+([%d%.]+)%s+x%s+([%d%.]+)")
	pw, ph = tonumber(pw), tonumber(ph)
	if not pw or not ph then
		return true, Err("Could not parse page size")
	end

	local scale = DPI / 72
	local out_w = math.ceil(pw * scale)
	local out_h = math.ceil(ph * scale)
	local strip_h = math.ceil(out_h / STRIPS)
	local y_offset = strip * strip_h

	local output, err = Command("pdftoppm")
		:arg({
			"-f", tostring(page),
			"-l", tostring(page),
			"-singlefile",
			"-r", tostring(DPI),
			"-x", "0",
			"-y", tostring(y_offset),
			"-W", tostring(out_w),
			"-H", tostring(strip_h),
			"-jpeg", "-jpegopt", "quality=90",
			tostring(job.file.path),
			cache_str,
		})
		:output()

	if not output then
		return true, Err("pdftoppm failed: %s", err)
	elseif not output.status.success then
		local pages = job.skip > 0 and tonumber(output.stderr:match("the last page %((%d+)%)"))
		if pages then
			return true, nil, (pages * STRIPS) - 1
		end
		return true, Err("pdftoppm: %s", output.stderr)
	end

	ya.image_precache(Url(cache_str .. ".jpg"), cache)
	return true
end

return M
