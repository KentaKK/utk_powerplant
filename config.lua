Config = {}

--[[
	Discord Config is inside server/main.lua
]]--

Config.policeJobs = {"police", "sheriff"} -- jobok amik értesítést kapnak és beleszámítanak a minimum rendőrbe
Config.GiveMoney = true -- False if player don't get money when robbing
Config.Account = 'black_money' -- Just in case you use a different name for dirty money
Config.Money = math.random(100000, 150000) -- Amount player receives when robbing the train. You can use math.random(minimum,maximum)
Config.GiveItems = false -- Give items?
Config.Items = {
	{name = 'saw', count = 1},
	{name = 'headbag', count = 1},
}
Config.GiveWeapons = false -- True if you want player to receive weapons
Config.Weapons = {
	{weapon = 'weapon_smokegrenade', ammo = 25},
	{weapon = 'weapon_crowbar', ammo = 1},
}

Config.Lang = {
['you_stole'] = 'Szereztél',
}

RegisterNetEvent('utk:notify')
AddEventHandler('utk:notify', function(msg)
    ShowNotification(msg)
end)

function ShowHelpNotification(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, 50)
end

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0, 1)
end

Peds = {
	{
		Position = vector4(2677.87, 1593.17, 32.55, 263.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2788.70, 1573.65, 30.79, 255.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2776.31, 1526.47, 30.79, 250.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2768.3, 1479.03, 30.79, 250.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2768.3, 1635.54, 24.55, 5.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2786.31, 1647.95, 24.75, 186.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2826.02, 1554.83, 24.57, 78.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2811.51, 1469.78, 24.77, 348.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2761.76, 1469.54, 47.95, 349.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2778.67, 1447.2, 24.57, 76.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
			-- 10
	{
		Position = vector4(2745.16, 1452.85, 24.55, 168.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2807.45, 1504.16, 24.75, 80.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2839.43, 1517.76, 24.75, 346.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2846.09, 1533.29, 24.75, 164.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2796.54, 1470.96, 34.35, 343.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2844.91, 1458.69, 32.75, 86.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2764.39, 1482.92, 30.79, 256.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2746.84, 1496.45, 38.29, 256.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2709.19, 1509.42, 24.56, 71.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2735.34, 1559.16, 24.55, 72.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
			-- 20
	{
		Position = vector4(2733.83, 1551.46, 24.55, 76.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2765.91, 1561.41, 24.55, 161.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2751.42, 1565.93, 24.55, 161.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2758.39, 1537.09, 24.56, 351.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2741.79, 1541.07, 24.55, 340.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2750.41, 1527.15, 24.55, 162.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2734.75, 1531.35, 24.54, 169.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2740.83, 1498.22, 24.52, 161.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2746.23, 1476.41, 24.55, 359.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2740.83, 1498.21, 24.55, 161.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
			-- 30
	{
		Position = vector4(2761.13, 1527.11, 37.68, 267.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2770.69, 1563.67, 37.68, 267.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2751.71, 1451.15, 24.55, 162.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2709.15, 1466.75, 24.54, 96.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2703.83, 1487.22, 24.52, 79.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2707.33, 1473.11, 42.25, 77.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
	{
		Position = vector4(2740.83, 1498.21, 24.55, 161.00),
		Model = `s_m_m_chemsec_01`,
					Weapon = `WEAPON_CARBINERIFLE`
	},
}
