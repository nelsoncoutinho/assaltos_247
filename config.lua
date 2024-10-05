Config, Locales = {}, {}

-- Language configuration
Config.Locale = "pt" -- set default language ("en", "pt")

-- Number of police officers required to start a robbery
Config.RequiredPolice = 0

-- Dispatch system to be used ("cd_dispatch", "qs-dispatch")
Config.DispatchSystem = "cd_dispatch"

-- Notification system to be used ("ox", "okokNotify")
Config.NotificationSystem = "ox"

-- Marker settings
Config.Marker = {
    r = 250, g = 0, b = 0, a = 100,  -- red color
    x = 1.0, y = 1.0, z = 1.5,       -- small cylinder-shaped circle
    DrawDistance = 15.0, Type = 1    -- default circle type, low draw distance due to indoor area
}

-- Distance required to interact with the robbery point
Config.InteractionDistance = 3.0

-- Cooldown time between robberies (in seconds)
Config.RobberyCooldown = 1800

-- Determines the max distance to rob the store
Config.MaxDistance = 20

-- Determines if the robbery gives dirty money (true) or clean money (false)
Config.GiveDirtyMoney = true

-- Locations of stores that can be robbed
Stores = {
    ["paleto_twentyfourseven"] = {
		position = { x = 1734.6629638672, y = 6420.6142578125, z = 35.037258148193 },
		reward = math.random(40000, 50000),
		nameOfStore = "24/7. (Paleto Bay)",
		secondsRemaining = 250, -- seconds
		lastRobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { x = 1961.24, y = 3749.46, z = 32.34 },
		reward = math.random(40000, 50000),
		nameOfStore = "24/7. (Sandy Shores)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { x = -709.77783203125, y = -904.10211181641, z = 19.215591430664},
		reward = math.random(40000, 50000),
		nameOfStore = "24/7. (Little Seoul)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["bar_one"] = {
		position = { x = 1990.57, y = 3044.95, z = 47.21 },
		reward = math.random(40000, 50000),
		nameOfStore = "Yellow Jack. (Sandy Shores)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor"] = {
		position = { x = -2959.4916992188, y = 387.22326660156, z = 14.043260574341 },
		reward = math.random(40000, 50000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor2"] = {
		position = { x = -3047.8620605469, y = 585.61303710938, z = 7.9089322090149 },
		reward = math.random(40000, 50000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ocean_liquor3"] = {
		position = { x = -3249.8752441406, y = 1004.3237915039, z = 12.83071231842 },
		reward = math.random(40000, 50000),
		nameOfStore = "Robs Liquor. (Great Ocean Highway)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["rancho_liquor"] = {
		position = { x = 1126.80, y = -980.40, z = 45.41 },
		reward = math.random(40000, 50000),
		nameOfStore = "Robs Liquor. (El Rancho Blvd)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["sanandreas_liquor"] = {
		position = {x = -1220.6580810547, y = -915.85186767578, z = 11.32629776001},
		reward = math.random(40000, 50000),
		nameOfStore = "Robs Liquor. (San Andreas Avenue)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["grove_ltd"] = {
		position = { x = -43.374992370605, y = -1748.4464111328, z = 29.421010971069},
		reward = math.random(40000, 50000),
		nameOfStore = "LTD Gasoline. (Grove Street)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["mirror_ltd"] = {
		position = { x = 1159.5926513672, y = -313.98226928711, z = 69.205055236816 },
		reward = math.random(40000, 50000),
		nameOfStore = "LTD Gasoline. (Mirror Park Boulevard)",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},

	["ADD"] = {
		position = { x = 28.271953582764, y = -1339.3951416016, z = 29.497024536133 },
		reward = math.random(40000, 50000),
		nameOfStore = "Twenty Four Seven.",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},

	["ADD1"] = {
		position = { x = 378.10913085938, y = 333.26577758789, z = 103.56636810303 },
		reward = math.random(40000, 50000),
		nameOfStore = "Twenty Four Seven.",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},

	["ADD2"] = {
		position = { x = -1479.1003417969, y = -375.38891601562, z = 39.163391113281 },
		reward = math.random(40000, 50000),
		nameOfStore = "Liquor Store",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ADD3"] = {
		position = { x = -1829.1999511719, y = 798.83715820312, z = 138.19065856934 },
		reward = math.random(40000, 50000),
		nameOfStore = "Twenty Four Seven",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ADD4"] = {
		position = { x = 546.40454101562, y = 2663.0812988281, z = 42.156536102295 },
		reward = math.random(40000, 50000),
		nameOfStore = "Twenty Four Seven",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ADD5"] = {
		position = { x = 1169.0554199219, y = 2717.7983398438, z = 37.157608032227 },
		reward = math.random(40000, 50000),
		nameOfStore = "Liquor Store",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	},
	["ADD6"] = {
		position = { x = 2672.9338378906, y = 3286.5134277344, z = 55.241142272949 },
		reward = math.random(40000, 50000),
		nameOfStore = "Twenty Four Seven",
		secondsRemaining = 300, -- seconds
		lastRobbed = 0
	}
}

-- Do Not Touch
-- Function to get translations
function _L(id)
    if Locales[Config.Locale][id] then
        return Locales[Config.Locale][id]
    else
        print("Translation '"..id.."' doesn't exist")
    end
end