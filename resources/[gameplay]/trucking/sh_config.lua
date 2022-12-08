Config = {
    Debug = false,
    DistanceMultiplier = 0.25,
    GetJobCoords = vector3(863.2913208007812, -3210.044677734375, 5.90066480636596),
    TrailerDropOff = vector4(923.914794921875, -3233.075927734375, 6.05833864212036, 89.88346862792969),
    LoadAction = {
        Anim = {
            Dict = "friends@frm@ig_1",
            Name = "greeting_idle_b",
            Flag = 48,
            DisableMovement = true,
        },
        Label = "Loading trailer...",
        Duration = 10000,
        UseWhileDead = false,
        CanCancel = true,
        Disarm = true,
    },
	UnloadAction = {
		Anim = {
            Dict = "missfam4", 
            Name = "base", 
            Flag = 49, 
            Props = {
                { 
                    Model = "p_amb_clipboard_01", 
                    Bone = 36029, 
                    Offset = { 0.16, 0.08, 0.1, -130.0, -50.0, 0.0 } 
                },
            },
            DisableMovement = true,
		},
		Label = "Unloading trailer...",
		Duration = 10000,
		UseWhileDead = false,
		CanCancel = true,
		Disarm = true,
	},
	Trucks = {  
        [GetHashKey("PACKER")] = true,
        [GetHashKey("PHANTOM")] = true,
        [GetHashKey("PHANTOM3")] = true,
        [GetHashKey("HAULER")] = true,
	},
    TrailerBays = {
        { Name = "Bay 01", Coords = vector4(892.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 02", Coords = vector4(896.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 03", Coords = vector4(900.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 04", Coords = vector4(904.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 05", Coords = vector4(908.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 06", Coords = vector4(912.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 07", Coords = vector4(916.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 08", Coords = vector4(920.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 09", Coords = vector4(924.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 10", Coords = vector4(928.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 11", Coords = vector4(932.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 12", Coords = vector4(936.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 13", Coords = vector4(940.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 14", Coords = vector4(944.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 15", Coords = vector4(948.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 16", Coords = vector4(952.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 17", Coords = vector4(956.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 18", Coords = vector4(960.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 19", Coords = vector4(964.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
        { Name = "Bay 20", Coords = vector4(968.5406494140625, -3210.05078125, 7.77818632125854, 180.0), },
    },
    Deliveries = {
        {
            Name = "Fuel Delivery",
            Description = "Deliver a supply of fuel to the requested gas station.",
            SharedDestinations = {
                vector4(-81.85237884521484, -1755.491943359375, 29.70981407165527, 340.0907287597656),  -- Grove & Davis Gas Station
                vector4(292.9481506347656, -1247.440673828125, 29.42940902709961, 88.87139129638672), -- Strawberry & Capital Gas Station
                vector4(1196.7933349609375, -1407.6768798828125, 35.3880386352539, 180.51260375976565), -- Capital & El Rancho Gas Station
                vector4(824.1854248046875, -1024.2548828125, 26.40395736694336, 0.2020448744297), -- Vespucci & Popular Gas Station
                vector4(-532.5772705078125, -1194.4266357421875, 18.56161880493164, 70.0794448852539), -- Calais & Innocence Gas Station
                vector4(-707.2921142578125, -937.187744140625, 19.24054336547851, 179.7266845703125), -- Ginger & Lindsey Circus Gas Station
                vector4(1177.0523681640625, -315.0708312988281, 69.34188079833984, 280.0766296386719), -- West Mirror & Mirror Park Blvd Gas Station
                vector4(2551.7548828125, 344.4566040039063, 108.63064575195312, 267.30810546875), -- Palamino Fwy Gas Station
                vector4(626.8653564453125, 284.0591125488281, 103.18650817871094, 0.39639967679977), -- Finwell & Clinton Gas Station
                vector4(-1443.7484130859375, -260.769775390625, 46.45512390136719, 132.1048583984375), -- S Rockford & N Rockford Gas Station
                vector4(-2091.738525390625, -301.7126159667969, 14.68847560882568, 84.03534698486328), -- W Eclipse & Great Ocean Gas Station
                vector4(-1787.758056640625, 809.7332763671875, 140.1643218994141, 224.2237091064453), -- N Rockford & Banham Canyon Gas Station
                vector4(-2554.158203125, 2347.572265625, 34.71618270874023, 273.0334167480469), -- Route 68 & Great Ocean Gas Station
                vector4(61.7599868774414, 2782.335205078125, 59.53538131713867, 143.74899291992188), -- Route 68 & Route 68 Approach Gas Station
                vector4(256.7842407226563, 2613.124267578125, 46.62208557128906, 279.9002075195313), -- Route 68 & Joshua Gas Station
                vector4(1029.9832763671875, 2662.994873046875, 41.20542907714844, 359.94384765625), -- Route 68 in Grand Senora Gas Station
                vector4(2690.296142578125, 3270.6181640625, 56.8950080871582, 150.3898162841797), -- Senora Fwy in Grand Senora Gas Station
                vector4(1986.6058349609375, 3776.939697265625, 33.83490371704101, 207.01406860351565), -- Alhambra & Marina Gas Station
                vector4(1695.7569580078125, 4916.97119140625, 43.73260879516601, 54.34557342529297), -- Grapeseed Main Gas Station
                vector4(193.9938507080078, 6603.4462890625, 33.48580551147461, 190.8874969482422), -- Great Ocean & Procopio Gas Station
                vector4(-98.08396911621094, 6399.19091796875, 33.10734558105469, 45.96105575561523), -- Paleto Blvd & Cascabel Gas Station
            },
            Stages = {
                [1] = {
                    Type = "Pickup",
                    Message = "Pickup the empty fuel tanker from the Murietta Oil Field.",
                    TrailerModel = GetHashKey("TANKER"),
                    TrailerCoords = { -- Oil Fields (Pickup)
                        vector4(1725.2955322265625, -1654.74267578125, 114.21041870117188, 195.69070434570312),
                        vector4(1710.4703369140625, -1653.575439453125, 114.1233367919922, 237.7752685546875),
                        vector4(1712.35009765625, -1661.098388671875, 114.13800811767578, 228.8958282470703),
                        vector4(1709.1656494140625, -1635.6036376953125, 114.13971710205078, 188.3766326904297),
                        vector4(1714.6732177734375, -1634.1478271484375, 114.14540100097656, 190.2021942138672),
                        vector4(1721.3631591796875, -1702.6412353515625, 114.09795379638672, 206.8322906494141),
                    },
                },
                [2] = {
                    Type = "Load",
                    Message = "Go down the hill and fill up the tanker.",
                    Destination = {
                        vector4(1508.439453125, -1751.4854736328125, 78.72405242919922, 340.05859375), -- Oil Fields (Load)
                    },
                },
                [3] = {
                    Type = "Unload",
                    Repeat = 3,
                    Message = "Offload some fuel at the gas station on STREETNAME.",
                    Destination = {}, -- Empty table uses SharedDestinations for location
                },
                [4] = {
                    Type = "DropOff",
                    Message = "Drop off the empty tanker at the Murrietta Oil Field.",
                    ReturnTrailer = {
                        vector4(1715.8182373046875, -1567.3419189453125, 112.78780364990236, 301.0658874511719), -- Oil Fields (DropOff)
                    },
                },
            },
        },
        {
            Name = "Exotic Cars Delivery",
            Description = "Pickup a set of exotic cars from the dock and deliver them to the exotic car dealership.",
            Stages = {
                [1] = {
                    Type = "Pickup",
                    Message = "Pickup the empty car hauler from STREETNAME.",
                    TrailerModel = GetHashKey("TR2"),
                    TrailerCoords = {}, -- Empty table uses TrailerBays for location
                },
                [2] = {
                    Type = "Load",
                    Message = "Pickup the dealership's order of exotic cars at the docks on STREETNAME.",
                    Destination = {
                        vector4(-127.92088317871094, -2396.970703125, 6.16303634643554, 89.996826171875), -- Chupacabra St Dock
                        vector4(1208.0076904296875, -2990.8857421875, 6.03303527832031, 1.63627839088439), -- Buccaneer Way Dock
                        vector4(1009.8472290039064, -2911.679443359375, 6.06281042098999, 91.76387786865236), -- Buccaneer Way Dock
                    },
                },
                [3] = {
                    Type = "Attach",
                    TrailerModel = GetHashKey("TR4"),
                    ForceAttached = true,
                    TrailerCoords = nil, -- nil uses location of previous trailer
                },
                [4] = {
                    Type = "Unload",
                    Message = "Drop off the cars at the dealership on STREETNAME.",
                    Destination = {
                        vector4(-21.09139823913574, -1108.2025146484375, 26.83706474304199, 161.27767944335938), -- PDM
                        vector4(-761.1719970703125, -229.93711853027344, 37.44532775878906, 30.14760971069336), -- Malone & Sons
                    },
                },
                [5] = {
                    Type = "Attach",
                    TrailerModel = GetHashKey("TR2"),
                    ForceAttached = true,
                    TrailerCoords = nil, -- nil uses location of previous trailer
                },
                [6] = {
                    Type = "DropOff",
                    Message = "Drop off the empty car hauler back at the BILGECO lot.",
                    ReturnTrailer = {}, -- Empty table uses TrailerDropOff for dropoff
                },
            },
        },
        {
            Name = "Log Delivery",
            Description = "Pickup a load from the lumber yard and deliver it to the smeltery",
            Stages = {
                [1] = {
                    Type = "Pickup",
                    Message = "Pickup the logs from the lumber yard near STREETNAME.",
                    TrailerModel = GetHashKey("TRAILERLOGS"),
                    TrailerCoords = {
                        vector4(-601.7595825195312, 5310.26953125, 71.96724700927734, 177.8346405029297), -- Lumber Yard
                        vector4(-572.6244506835938, 5373.1884765625, 71.8869400024414, 285.0751037597656), -- Lumber Yard
                    }, 
                },
                [2] = {
                    Type = "DropOff",
                    Message = "Drop the logs off at the smeltery on STREETNAME",
                    ReturnTrailer = {
                        vector4(1071.791748046875, -1951.47802734375, 32.66940689086914, 144.86679077148438), -- Smeltery
                        vector4(984.1658325195312, -1921.51904296875, 32.79023361206055, 87.79792785644531), -- Smeltery
                    }, 
                },
            },
        },
    },
}