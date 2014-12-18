--------------------------------------------------------------------------------
--[[
Dusk Engine Component: Settings

Controls and keeps track of user preferences for various engine aspects.
--]]
--------------------------------------------------------------------------------

local settings = {}

--------------------------------------------------------------------------------
-- Localize
--------------------------------------------------------------------------------
local require = require

local verby = require("Dusk.dusk_core.external.verby")
local screen = require("Dusk.dusk_core.misc.screen")

local type = type
local verby_assert = verby.assert
local verby_error = verby.error

--------------------------------------------------------------------------------
-- Data
--------------------------------------------------------------------------------
local data = {
	-- Should we display a rectangle that's Tiled's background color
	displayBackgroundRectangle = false,
	
	-- Does a dot in a property name place a property in a separate table
	-- (obj.x.y.z vs. obj["x.y.z"])
	dotImpliesTable = true,

	-- Should Dusk detect the path a map is in and search for tilesets relative to
	-- that path
	detectMapPath = true,

	-- Should prefixes like !dot! or !nodot! have the rest of the property clipped
	-- with a space after it for readability (`!dot! prop` vs. `!dot!prop`)
	spaceAfterEscapedPrefix = false,

	-- Should the first body on a physics object be auto-generated by Dusk
	autoGenerateObjectShapes = true,

	-- One of "min", "max", or "average"; non-circular physics ellipse radius fit
	-- mode. "min" makes the physics radius fit the smaller of an ellipse's two
	-- axes, "max" makes it fit the larger axis, and "average" averages the axes.
	ellipseRadiusMode = "min",

	-- Should rectangle objects be further classified into "square" and "point"
	-- object types (for equal-sided and zero-sized objects, respectively)
	objTypeRectPointSquare = true,

	-- Should virtual objects (rectangles, ellipses, polygons) be visible
	virtualObjectsVisible = true,

	-- Allow camera functionality
	enableCamera = true,

	-- Deault tracking level for camera; the closer to 0 this is, the more slowly
	-- and fluidly the camera tracks. This can be changed on a per-map basis with
	-- `map.setTrackingLevel()` or `map.setDamping()`
	defaultCameraTrackingLevel = 1,

	-- A little difficult to explain; should the camera treat its bounds as
	-- "align the camera's side with this number - half screen width" or as "stop
	-- tracking when you get here" when the camera is scaled
	--
	-- Perchance a diagram would help ("B" denotes the bounds point):
	--
	-- When scaleCameraBoundsToScreen = true:
	--    ________________
	--   |  |    |       |
	--   |  |    B       |
	--   |__|____|_______|
	--      ^- left edge of screen
	-- When scaled up:
	--    _______________
	--   |  | |          |
	--   |  | B          |
	--   |__|_|__________|
	--      ^- left edge of screen remains the same; Dusk changes bounds to fit
	--
	-- When scaleCameraBoundsToScreen = false:
	--    ________________
	--   |  |    |       |
	--   |  |    B       |
	--   |__|____|_______|
	--      ^- left edge of screen
	-- When scaled up:
	--    _______________
	--   |     | |       |
	--   |     | B       |
	--   |_____|_|_______|
	--         ^- left edge of screen changes instead of bounds point
	--
	-- There's probably a better way to explain it, but that's the best I can do.
	scaleCameraBoundsToScreen = true,

	-- Allow Dusk to clip and draw tiles as needed
	enableTileCulling = true,

	-- Functions called when an object is created (primarily for styling virtual
	-- objects)
	onPointBased = function(p) p.strokeWidth = 5 p:setStrokeColor(1, 1, 1, 0.5) end,
	onEllipse = function(e) e:setFillColor(0, 0, 0, 0) e.strokeWidth = 5 e:setStrokeColor(1, 1, 1, 0.5) end,
	onImageObj = function(t) end,
	onRect = function(r) r:setFillColor(0, 0, 0, 0) r.strokeWidth = 5 r:setStrokeColor(1, 1, 1, 0.5) end,
	onObj = function(o) end,

	-- Debug/experimental settings

	-- Redraw tiles if culling finds them and they're already there; lowers
	-- performance by a huge amount. Only here for me to debug Dusk with.
	redrawOnTileExistent = false,

	-- Allow Dusk to cull rotated maps; if you're not rotating your maps, this
	-- should be inactive. It adds a small performance drop. On the other hand, if
	-- you're rotating your maps, all sorts of culling matrix corruption happens
	-- unless this is enabled.
	enableRotatedMapCulling = false,

	-- Math evaluation variables for use with !math! properties
	mathVariables = {
		screenWidth = screen.width,
		screenHeight = screen.height
	}
}

--------------------------------------------------------------------------------
-- Set Preference
--------------------------------------------------------------------------------
function settings.set(preferenceName, value)
	if not preferenceName or value == nil then verby_error("Missing one or more arguments to `settings.set()` (`dusk.setPreference()`)") end
	if data[preferenceName] == nil then verby_error("Unrecognized setting \"" .. preferenceName .. "\".") end

	data[preferenceName] = value
end

--------------------------------------------------------------------------------
-- Get Preference
--------------------------------------------------------------------------------
function settings.get(preferenceName)
	if preferenceName == nil then verby_error("No argument passed to `settings.get()` (`dusk.getPreference()`)") end
	return data[preferenceName] or nil
end

--------------------------------------------------------------------------------
-- Add/Remove Evaluation Variable
--------------------------------------------------------------------------------
function settings.setMathVariable(varName, value) data.mathVariables[varName] = value end
function settings.removeMathVariable(varName) data.mathVariables[varName] = nil end

return settings