Settings.Locations = { 
   
    {
        name = "trainstation",
        label = "Train Station",
        coords = vector3(-223.3253, -996.7120, 34.0096),
        rot = vector3(0, -0, -139.7158),
        spawn = vector4(-206.3010, -1014.7507, 30.1381, 71.0018),
        image = "trainstation.PNG"
    }, 
    
    {
        name = "apartment",
        label = "Apartment",
        coords = vector3(-253.8258, -988.2850, 33.1299 - 1),
        rot = vector3(0, 0, 27.74866),
        spawn = vector4(-264.3110, -965.4418, 31.2238, 206.9434),
        image = "apartment.png",
        customspawn = true
    }, 
    
    {
        name = "busstation",
        label = "Bus Station",
        coords = vector3(468.5144, -652.8463, 33.5482 - 3),
        rot = vector3(0, 0, 60.24061),
        spawn = vector4(454.1389, -644.9709, 28.4275, 259.4299),
        image = "busstation.png"
    }, 
    
    {
        name = "motorhotel",
        label = "Harmony Motel",
        coords = vector3(1121.1310, 2673.9976, 40.2672),
        rot = vector3(0, -0, -113.5739),
        spawn = vector4(1137.7260, 2668.7571, 38.0306, 0.7733),
        image = "harmonymotel.png"
    }, 
    
    {
        name = "paletobus",
        label = "Paleto Bus Station",
        coords = vector3(-251.3850, 6171.1118, 32.9935),
        rot = vector3(-0, -0, -46.95641),
        spawn = vector4(-240.5397, 6183.3853, 31.4941, 138.4151),
        image = "paletobus.png"
    }, 
    
    {
        name = "beach",
        label = "Vespucci Beach",
        coords = vector3(-1873.4523, -1258.1714, 13.4857),
        rot = vector3(-0, -0, -37.41573),
        spawn = vector4(-1850.4877, -1232.8555, 13.0173, 321.2528),
        image = "beach.png"
    }, 
    
    {
        name = "jmotel",
        label = "Joshua Motel",
        coords = vector3(1472.1055, 3606.9622, 36.4326),
        rot = vector3(0, -0, -143.0325),
        spawn = vector4(1480.3282, 3593.9971, 35.3928, 21.6192),
        image = "jashuamotel.png"
    },
}


--- ===============================================================================
--- ===                         Onex Help
--- ===        if you still confused please create ticket on discord
--- ===============================================================================

--- If you want to put any trigger like if you want to add spawn on apartment then 

    -- {
    --     name = "apartment",
    --     label = "Apartment",
    --     coords = vector3(-253.8258, -988.2850, 33.1299 - 1),
    --     rot = vector3(0, 0, 27.74866),
    --     spawn = vector4(-264.3110, -965.4418, 31.2238, 206.9434),
    --     image = "apartment.png",
    --     customspawn = true
    -- }, 

    -- here make [customspawn = true] then there put then name as a example here "apartment" so like this

    -- if IndexName == "apartment" then
    --    Put your trigger so wehnevenr you press on that spawn it will run your trigger

--- ===============================================================================

function DoCustomSpawn(IndexName)
    if IndexName == "apartment" then
        TriggerEvent('apartments:client:EnterApartment')
    elseif IndexName == "test" then

    end
end