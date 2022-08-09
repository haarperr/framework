Config.Doors = {
	[`prison_prop_door1`] = { Electronic = true },
	[`prison_prop_door1a`] = { Electronic = true },
	[`prison_prop_door2`] = { Electronic = true },
	[`prison_prop_jaildoor`] = { Electronic = true },
	[`xm_cellgate`] = { Sliding = true, Locked = false, Electronic = true },
	[`prop_gate_prison_01`] = { Sliding = true, Distance = 10.0, Electronic = true },
	[`hei_prop_station_gate`] = { Sliding = true, Distance = 6.0, Electronic = true, Fob = true },
	[`v_ilev_gtdoor`] = { Electronic = true },
	[`v_ilev_gtdoor02`] = { Electronic = true },
	[`prop_fnclink_03gate5`] = { Electronic = true },
	[`prop_strip_door_01`] = {},
	[`v_ilev_door_orangesolid`] = {},
	[`v_ilev_roc_door2`] = {},
	[`prop_magenta_door`] = {},
	[`v_ilev_arm_secdoor`] = { Electronic = true },
	[`v_ilev_fa_dinedoor`] = {},
	[`v_ilev_ph_gendoor`] = {},
	[`v_ilev_ph_gendoor002`] = {},
	[`v_ilev_ph_gendoor004`] = {},
	[`v_ilev_ph_gendoor005`] = {},
	[`v_ilev_ph_gendoor006`] = {},
	[`v_ilev_ph_cellgate`] = {},
	[`v_ilev_ph_cellgate02`] = {},
	[395979613] = {},
	[-361000789] = { Sliding = true },
	[4787313] = { Sliding = true },
	[-543497392] = {},
	[452874391] = {},
	[-739665083] = {},
	[1240350830] = {},
	[1286535678] = { Sliding = true, Distance = 10.0 },
	[282722808] = {},
	[964838196] = { Locked = true, Item = "Lockpick" }, -- PSB & City Hall.

	--[[ Bank Doors ]]--
	[`hei_v_ilev_bk_gate_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.2, 0.0, 0.0, -0.1, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_gate_molten",
		}
	},

	[`hei_v_ilev_bk_gate2_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.2, 0.0, 0.0, -0.1, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_gate2_molten",
		}
	},

	[`hei_v_ilev_bk_safegate_pris`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { -0.2, 0.0, -0.1, 0.0, 0.0, -90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
			SwapModel = "hei_v_ilev_bk_safegate_molten",
		}
	},

	[`v_ilev_gb_vaubar`] = {
		Item = "Thermite",
		SpecialState = {
			Lifetime = 15.0,
			Offsets = { 0.35, 0.0, 0.0, 0.0, 0.0, 90.0 },
			PtfxDict = "scr_ornate_heist",
			PtfxName = "scr_heist_ornate_thermal_burn",
		}
	},
	
	[`hei_v_ilev_bk_gate_molten`] = { Ignore = true },
	[`hei_v_ilev_bk_gate2_molten`] = { Ignore = true },
	[`hei_v_ilev_bk_safegate_molten`] = { Ignore = true },
	
	[`hei_prop_hei_bankdoor_new`] = { Locked = false },
	[`v_ilev_bk_door`] = { Item = "Lockpick" },
	[`v_ilev_fingate`] = {},
	[`v_ilev_gb_teldr`] = { Item = "Lockpick" },

	--[[ City Hall / Courthouse ]]--
	[660342567] = {}, -- front door
	[-1094765077] = {}, -- front door
	[1762042010] = {}, -- office doors
	[-1940023190] = {}, -- hallway doors
	[297112647] = {}, -- lower side door
	[830788581] = {}, -- lower side door
	[918828907] = {}, -- cell door

	--[[DOJ Offices]]
	[1753086613] = {},
	[-1795009631] = {},
	[906126164] = {},
	[1054027861] = {},
	[362516170] = {},
	[1065280144] = {},
	[-468297138] = {},
	[1276717658] = {},
	[725274945] = {},

	--[[ Jewelry ]]--
	[1425919976] = { Item = "Thermite", Locked = true },
	[9467943] = { Item = "Thermite", Locked = true },
	[1335309163] = { Item = "Thermite", Locked = true },

	--[[ Vaults ]]--
	[`v_ilev_bk_vaultdoor`] = { Vault = -160.0 },
	[`v_ilev_gb_vauldr`] = { Vault = -90.0, Distance = 1.0 },
	[`v_ilev_fin_vaultdoor`] = { Vault = 170.0, Distance = 4.0 },
	[`v_ilev_cbankvauldoor01`] = { Default = -105.0, Vault = 105.0 },
	[`hei_prop_heist_sec_door`] = { Vault = -90.0 },

	[`ch_prop_arcade_fortune_door_01a`] = { Locked = true, Vault = 90.0 },

	--[[ Humane Labs ]]--
	[-1081024910] = { Sliding = true, Locked = true, Speed = 10.0, Force = 1.0 }, -- Front bay.
	[161378502] = { Sliding = true, Locked = true, Speed = 10.0, Force = 1.0 }, -- Sliding glass (R).
	[-1572101598] = { Sliding = true, Locked = true, Speed = 10.0, Force = -1.0 }, -- Sliding glass (L).
	[-421709054] = { Locked = true },
	[1282049587] = { Locked = true },
	[19193616] = { Locked = true },

	--[[ Gabz Hospital ]]--
	[-1421582160] = {},
	[-1700911976] = { Locked = true },
	[-1927754726] = {},
	[-434783486] = { Locked = true },
	[-820650556] = { Locked = true, Distance = 10.0 },
	[1248599813] = {},
	[854291622] = { Locked = true },
	[-487908756] = { Locked = false, Sliding = true, Distance = 10.0, Speed = 3.0, Range = 4.0, Electronic = true },
	[661758796] = { Locked = false, Sliding = true, Distance = 10.0, Speed = 3.0, Range = 4.0, Electronic = true },

	--[[ Gabz MRPD ]]--
	[-692649124] = {},
	[1830360419] = {},
	[-1406685646] = {},
	[-96679321] = {},
	[149284793] = {},
	[-288803980] = {},
	[-1547307588] = {},
	[2130672747] = { Sliding = true, Distance = 8.0, Speed = 2.0, Fob = true },
	[-53345114] = {},
	[-1258679973] = {},
	[-190780785] = { Sliding = true, Distance = 10.0, Speed = 1.5 },
	[`hei_prop_station_gate`] = { Sliding = true, Distance = 15.0, Speed = 1.5, Electronic = true }, -- Back Gate
	[-1635161509] = { Sliding = true, Fob = true },
	[-1868050792] = { Sliding = true, Fob = true },

	--[[ Gabz SSSO ]]--
	[-1501157055] = {},
	[1364638935] = {},
	[-1264811159] = {},
	[2010487154] = {},
	[-1626613696] = {},
	[-1156020871] = {},

	--[[ Hedwig Paleto PD ]]--
	[-1184194650] = {},
	[82228897] = {},
	[-1566739956] = {},
	[-954385653] = {},
	[-758001036] = {},
	[1908183115] = {},
	[-1483471451] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	--[[ Davis / Capital Blvd Firehouse ]]--
	[1934132135] = { Sliding = true, Distance = 10.0, Speed = 3.0, Electronic = true },
	[-903733315] = {},
	[-1056920428] = {},
	[-585526495] = {},

	--[[ Gabz Vanilla Unicorn ]]--
	[390840000] = {},
	[1695461688] = {},

	--[[ New Prison / Bolingbroke ]]--
	[741314661] = { Sliding = true, Speed = 5.0, Distance = 15.0, Electronic = true },
	[-1156020871] = { Item = "Thermite" },
	[1373390714] = { Item = "Thermite" },
	[871712474] = { Item = "Thermite" },
	[539686410] = { Electronic = true },
	[-684929024] = { Electronic = true },
	[2074175368] = { Electronic = true },
	[-1624297821] = { Electronic = true },
	[-1392981450] = { Electronic = true },
	[2024969025] = { Electronic = true },
	[241550507] = { Electronic = true },
	[913760512] = { Locked = false, Electronic = true },

	--[[ Tequi-la-la ]]--
	[757543979] = {},
	[202981272] = {},
	[1117236368] = {},
	[993120320] = {},

	--[[ Bean Machine & PDM ]]--
	[736699661] = {},
	[1417577297] = {},
	[2059227086] = {},
	[-883710603] = {},

	-- [[ PDM ]]
	[2089009131] = {},
	[1973010099] = {},
	[1010499530] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	-- [[ Power Autos ]]
	[-427498890] = { Sliding = true, Distance = 10.0, Speed = 3.0 },
	[-734132119] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	--[[ Arcade ]]--
	[-1977830166] = {},
	[1044811355] = {},
	[-637233066] = {},
	[1044811355] = {},
	[-2051651622] = {},
	[-2045695986] = {},
	[-114880996] = {},
	[1122723068] = { Sliding = true },
	[-603547852] = { Sliding = true },

	--[[ Weed | High Times ]]--
	[230454090] = {},
	[-538477509] = {},
	[-311575617] = {},

	--[[ Tuner Meetup ]]
	[-982531572] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	--[[ Offices ]]--
	[220394186] = {},
	[1939954886] = {},
	[-923302700] = {},
	[1901651314] = {},
	[9006550] = {},
	[-1625169788] = {},
	[-88942360] = {},

	--[[ Sewer ]] --
	[-267021114] = {},
	[`v_ilev_rc_door2`] = {},

	--[[ Victrix ]]--
	[1388116908] = {},
	[933053701] = {},
	[1286392437] = { Sliding = true },

	--[[ Cayo Perico ]]--
	[1215477734] = { NoDouble = false },
	[-1574151574] = { NoDouble = false },
	[-607013269] = {},
	[-1360938964] = {},
	[-2058786200] = {},
	[-630812075] = {},
	[1526539404] = {},
	[1413187371] = {},
	[227019171] = {},
	[141297241] = { Sliding = true, Distance = 5.0 },
	[-1052729812] = { NoDouble = false },
	[1866987242] = { NoDouble = false },
	[-1635579193] = {},
	[-23367131] = {},
	[-1747016523] = {},

	--[[ Paleto Medical ]]--
	[-770740285] = {},
	[613848716] = {},

	--[[ Yellowjack ]]--
	[-287662406] = {},
	[479144380] = {},
	[747286790] = {},
	[-2049972581] = {},
	[-547305886] = {},
	[-1875254669] = {},
	[1287245314] = { Sliding = true, Distance = 5.0 },

	--[[ Luchettis ]]--
	[-950166942] = {},
	[1289778077] = {},
	[757543979] = {},
	[2035930085] = {},

	--[[ Axel's Auto at Elgin & Spanish ]]--
	[141631573] = {},
	[-1458889440] = {},
	[-1218332211] = {},
	[-1309543596] = {},
	[1497823487] = {},
	[-733661186] = {},

	--[[ Malone and Sons ]]--
	[-422301745] = {},
	[-233085163] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	--[[ Sweet and Spice ]]--
	[-869148156] = {},
	[1397156203] = {},

	--[[ Beanies ]]--
	[-69331849] = {},
	[526179188] = {},
	[-1283712428] = {},
	[-60871655] = {},
	[522844070] = { Sliding = true, Distance = 10.0, Speed = 3.0 },
	[1099436502] = {},
	[-562476388] = { Sliding = true, Speed = 2.0 },
	[1717323416] = {},

	--[[ Burger Shot ]]--
	[1800304361] = {},
	[167687243] = {},
	[233831934] = {},
	[-1871759441] = { Sliding = true, Distance = 2.0 },
	[-1253427798] = {},
	[1517256706] = {},
	[1980817304] = {},
	[386432549] = {},
	[-806752263] = {},
	[1462909834] = {},
	[-2009111682] = {},
	[-1938756667] = {},
	[-1475798232] = {},
	[-1877571861] = {},

	--[[ Hayes Auto Body Shop ]]--
	[-634936098] = {},

	--[[ Beeker's Garage \ Paleto ]]--
	[1335311341] = {},

	--[[ Taco Shop ]]--
	[-1215222675] = {},

	--[[ Bahama Mama's ]]--
	[-1119680854] = {},
	[-1747430008] = {},
	[401003935] = {},
	[-2003105485] = {},
	[-822900180] = { Sliding = true, Distance = 10.0, Speed = 3.0 },

	--[[ Pearls ]]--
	[-1643773373] = {},
	[-1197804771] = {},
	[1994441020] = {},
	[1870406214] = {},
	[-1196002204] = {},
	[-1285189121] = {},

	--[[ Park Ranger Station ]]--
	[-117185009] = {},
	[1704212348] = {},
	[517369125] = {},

	--[[ Chumash PD ]]--
	[-1726331785] = {},
	[1817008884] = {},
	[458025182] = {},

	--[[ Davis PD ]]--
	[1670919150] = {},
	[618295057] = {},
	[-425870000] = {},
	[-1335406364] = {},
	[-728950481] = {},
	[-674638964] = {},
	[-425870000] = {},

	[1738519111] = {},
	[-1047370197] = {},
	[2093103062] = {},
	[-1925177820] = {},
	[-1685865813] = {},
	[-1360054856] = {},
	[471928866] = {},
	[-667323357] = {},
	[2130535758] = {},
	[782481772] = {},
	[167807608] = {},
	[-1842288246] = {},
	[-944738487] = {},
	[2102943923] = {},

	--[[ Pawn Shop ]]--
	[-538477509] = {},
	[-952356348] = {},
	[-2030748569] = {},
	[-397082484] = {},
	[1655182495] = {},

	--[[La Mesa]]
	[277920071] = {},
	[-34368499] = {},
	[-1011300766] = {},
	[-1189294593] = {},
	[-1983352576] = {},
	[2076628221] = {},
	[539497004] = {},
	[1861900850] = {},
	[-375301406] = {},
	[-1213101062] = {},
	[272264766] = {},
	[1491736897] = {},
	[1162089799] = {},
	[-1339729155] = {},
	[-1246730733] = {},

	--[[ Rebel Radio ]]--
	[-1576989776] = {},
	[-1995612459] = {},
}