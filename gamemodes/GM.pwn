/*

	Main Gamemode

*/

#include <a_samp>
#undef MAX_PLAYERS
#define MAX_PLAYERS	500
#include <crashdetect.inc> 
#include <a_mysql.inc>
#include <a_actor.inc>
#include <a_zones.inc>
#include <CTime.inc>
#include <gvar.inc>
#include <easyDialog.inc>
#include <progress2.inc>
#include <Pawn.CMD.inc>
#include <mSelection.inc>
#include <TimestampToDate.inc>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <3DTryg.inc>
#include <streamer.inc>
#include <EVF2.inc>
#include <YSI\y_timers>
#include <sscanf2.inc>
#include <discord-connector>
#include <discord-cmd>
#include <yom_buttons.inc>
//#include <geoiplite.inc>
#include <garageblock.inc>
#include <timerfix.inc>


//-----[ Modular ]-----
#include "DATA\DEFINE.pwn"
#define DCMD_PREFIX '!'

//----------[ New Variable ]----
// Countdown
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

// Server Uptime
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//Model Selection 
new SpawnMale = mS_INVALID_LISTID,
	SpawnFemale = mS_INVALID_LISTID,
	MaleSkins = mS_INVALID_LISTID,
	FemaleSkins = mS_INVALID_LISTID,
	VIPMaleSkins = mS_INVALID_LISTID,
	VIPFemaleSkins = mS_INVALID_LISTID,
	SAPDMale = mS_INVALID_LISTID,
	SAPDFemale = mS_INVALID_LISTID,
	SAPDWar = mS_INVALID_LISTID,
	SAGSMale = mS_INVALID_LISTID,
	SAGSFemale = mS_INVALID_LISTID,
	SAMDMale = mS_INVALID_LISTID,
	SAMDFemale = mS_INVALID_LISTID,
	SANEWMale = mS_INVALID_LISTID,
	SANEWFemale = mS_INVALID_LISTID,
	toyslist = mS_INVALID_LISTID,
	viptoyslist = mS_INVALID_LISTID;
	
// Faction Vehicle
#define VEHICLE_RESPAWN 7200

new SAPDVehicles[30],
	SAGSVehicles[30],
	SAMDVehicles[30],
	SANAVehicles[30];

// Faction Vehicle
IsSAPDCar(carid)
{
	for(new v = 0; v < sizeof(SAPDVehicles); v++)
	{
	    if(carid == SAPDVehicles[v]) return 1;
	}
	return 0;
}

IsGovCar(carid)
{
	for(new v = 0; v < sizeof(SAGSVehicles); v++)
	{
	    if(carid == SAGSVehicles[v]) return 1;
	}
	return 0;
}

IsSAMDCar(carid)
{
	for(new v = 0; v < sizeof(SAMDVehicles); v++)
	{
	    if(carid == SAMDVehicles[v]) return 1;
	}
	return 0;
}

IsSANACar(carid)
{
	for(new v = 0; v < sizeof(SANAVehicles); v++)
	{
	    if(carid == SANAVehicles[v]) return 1;
	}
	return 0;
}

//Showroom Checkpoint
new ShowRoomCP,
	ShowRoomCPRent;

// Yom Button
new SAGSLobbyBtn[2],
	SAGSLobbyDoor,
	SAPDLobbyBtn[4],
	SAPDLobbyDoor[4],
	LLFLobbyBtn[2],
	LLFLobbyDoor;

// MySQL connection handle
new MySQL: g_SQL;

new TogOOC = 1;

// Player data
enum E_PLAYERS
{
	pID,
	pUCP[22],
	pExtraChar,
	pChar,
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	pIP[16],
	pVerifyCode,
	pPassword[65],
	pSalt[17],
	pEmail[40],
	pAdmin,
	pHelper,
	pLevel,
	pLevelUp,
	pVip,
	pVipTime,
	pGold,
	pRegDate[50],
	pLastLogin[50],
	pMoney,
	pBankMoney,
	pBankRek,
	pPhone,
	pPhoneCredit,
	pPhoneBook,
	pSMS,
	pCall,
	pCallTime,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pGender,
	pAge[50],
	pInDoor,
	pInHouse,
	pInBiz,
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
	pHunger,
	pStress,
	pEnergy,
	pBladder,
	pHungerTime,
	pEnergyTime,
	pStressTime,
	pBladderTime,
	pSick,
	pSickTime,
	pHospital,
	pHospitalTime,
	pInjured,
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pFactionLead,
	pTazer,
	pBroadcast,
	pNewsGuest,
	pFamily,
	pFamilyRank,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pWarn,
	pJob,
	pJob2,
	pJobTime,
	pExitJob,
	pMedicine,
	pMedkit,
	pMask,
	pHelmet,
	pSnack,
	pSprunk,
	pGas,
	pBandage,
	pGPS,
	pMaterial,
	pComponent,
	pFood,
	pSeed,
	pPotato,
	pWheat,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pPlant,
	pPlantTime,
	pFishTool,
	pWorm,
	pFish,
	pInFish,
	pIDCard,
	pIDCardTime,
	pDriveLic,
	pDriveLicTime,
	pBoatLic,
	pBoatLicTime,
	pFlyLic,
	pFlyLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pAdminDuty,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	pSPY,
	pTogPM,
	pTogLog,
	pTogAds,
	pTogWT,
	Text3D:pAdoTag,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackBisnis,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pFindEms,
	pCuffed,
	toySelected,
	bool:PurchasedToy,
	pEditingItem,
	pProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	pChooseSpawn,
	playerSpectated,
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pHelmetOn,
	pSeatBelt,
	pReportTime,
	//Player Progress Bar
	PlayerBar:fuelbar,
	PlayerBar:damagebar,
	PlayerBar:hungrybar,
	PlayerBar:energybar,
	PlayerBar:bladdybar,
	PlayerBar:spfuelbar,
	PlayerBar:spdamagebar,
	PlayerBar:sphungrybar,
	PlayerBar:spenergybar,
	PlayerBar:spbladdybar,
	PlayerBar:activitybar,
	pProducting,
	pCooking,
	pArmsDealer,
	pMechanic,
	pActivity,
	pActivityTime,
	//Jobs
	pSideJob,
	pSideJobTime,
	pGetJob,
	pGetJob2,
	pTaxiDuty,
	pTaxiTime,
	pFare,
	pFareTimer,
	pTotalFare,
	Float:pFareOldX,
	Float:pFareOldY,
	Float:pFareOldZ,
	Float:pFareNewX,
	Float:pFareNewY,
	Float:pFareNewZ,
	pMechDuty,
	pMechVeh,
	pMechColor1,
	pMechColor2,
	//ATM
	EditingATMID,
	//lumber job
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//Miner job
	EditingOreID,
	MiningOreID,
	CarryingLog,
	LoadingPoint,
	//production
	CarryProduct,
	//trucker
	pMission,
	pHauling,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Bank
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//Gas Station
	pFill,
	pFillTime,
	pFillPrice,
	//Gate
	gEditID,
	gEdit
	
};
new pData[MAX_PLAYERS][E_PLAYERS];
new g_MysqlRaceCheck[MAX_PLAYERS];


//----------[ Lumber Object Vehicle Job ]------------
#define MAX_LUMBERS 50
#define LUMBER_LIFETIME 100
#define LUMBER_LIMIT 10

enum    E_LUMBER
{
	// temp
	lumberDroppedBy[MAX_PLAYER_NAME],
	lumberSeconds,
	lumberObjID,
	lumberTimer,
	Text3D: lumberLabel
}
new LumberData[MAX_LUMBERS][E_LUMBER],
	Iterator:Lumbers<MAX_LUMBERS>;

new
	LumberObjects[MAX_VEHICLES][LUMBER_LIMIT];
	
new
	Float: LumberAttachOffsets[LUMBER_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};

//---------[ Ores miner Job Log ]-------	
#define LOG_LIFETIME 100
#define LOG_LIMIT 10
#define MAX_LOG 100

enum    E_LOG
{
	// temp
	bool:logExist,
	logType,
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	Text3D:logLabel
}
new LogData[MAX_LOG][E_LOG];

new
	LogStorage[MAX_VEHICLES][2];
	
//------[ Trucker ]--------

new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];
//-----[ Modular ]-----
main() 
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 8000, true);
}
#include "DATA\COLOR.pwn"
#include "DATA\PLAYERUCP.pwn"
#include "DATA\TEXTDRAW.pwn"
#include "DATA\TEXTDRAWCLICK.pwn"
#include "DATA\ANIMS.pwn"
#include "DATA\PRIVATE_VEHICLE.pwn"
#include "DATA\REPORT.pwn"
#include "DATA\WEAPON_ATTH.pwn"
#include "DATA\TOYS.pwn"
#include "DATA\HELMET.pwn"
#include "DATA\SERVER.pwn"
#include "DYNAMIC\DOOR.pwn"
#include "DYNAMIC\FAMILY.pwn"
#include "DYNAMIC\HOUSE.pwn"
#include "DYNAMIC\BISNIS.pwn"
#include "DYNAMIC\GAS_STATION.pwn"
#include "DYNAMIC\DYNAMIC_LOCKER.pwn"
#include "DATA\NATIVE.pwn"
#include "JOB\JOB_SWEEPER.pwn"
#include "JOB\JOB_BUS.pwn"
#include "DYNAMIC\VOUCHER.pwn"
#include "DATA\SALARY.pwn"
#include "DYNAMIC\ATM.pwn"
#include "DATA\ARMS_DEALER.pwn"
#include "DYNAMIC\GATE.pwn"
//#include "AUDIO.pwn"
#include "JOB\JOB_TAXI.pwn"
#include "JOB\JOB_MECH.pwn"
#include "JOB\JOB_LUMBER.pwn"
#include "JOB\JOB_MINER.pwn"
#include "JOB\JOB_PRODUCTION.pwn"
#include "JOB\JOB_TRUCKER.pwn"
#include "JOB\JOB_FISH.pwn"
#include "JOB\JOB_FARMER.pwn"

#include "CMD\ADMIN.pwn"
#include "CMD\FACTION.pwn"
#include "CMD\PLAYER.pwn"
#include "CMD\DISCORD.pwn"

#include "DATA\SAPD_TASER.pwn"
#include "DATA\SAPD_SPIKE.pwn"

#include "DATA\DIALOG.pwn"

#include "CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "CMD\ALIAS\ALIAS_HOUSE.pwn"
#include "CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"

#include "DATA\FUNCTION.pwn"

public OnGameModeInit()
{
	//mysql_log(ALL);
	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("");
		return 1;
	}
	print("MySQL connection is successful.");

	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers");
	mysql_tquery(g_SQL, "SELECT * FROM `trees`", "LoadTrees");
	mysql_tquery(g_SQL, "SELECT * FROM `ores`", "LoadOres");
	mysql_tquery(g_SQL, "SELECT * FROM `plants`", "LoadPlants");
	
	CreateTextDraw();
	CreateServerPoint();
	CreateJoinLumberPoint();
	CreateJoinTaxiPoint();
	CreateJoinMechPoint();
	CreateJoinMinerPoint();
	CreateJoinProductionPoint();
	CreateJoinTruckPoint();
	CreateArmsPoint();
	CreateJoinFarmerPoint();
	LoadTazerSAPD();
	//SetupPlayerTable();
	
	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	//SendRconCommand("hostname Xero Gaming Roleplay");
	SendRconCommand("mapname San Andreas");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(15.0);
	SetNameTagDrawDistance(20.0);
	//DisableNameTagLOS();
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text="NO ENTER");
	//Audio_SetPack("default_pack");
	
	SpawnMale = LoadModelSelectionMenu("spawnmale.txt");
	SpawnFemale = LoadModelSelectionMenu("spawnfemale.txt");
	MaleSkins = LoadModelSelectionMenu("maleskin.txt");
	FemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	VIPMaleSkins = LoadModelSelectionMenu("maleskin.txt");
	VIPFemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
	SAPDMale = LoadModelSelectionMenu("sapdmale.txt");
	SAPDFemale = LoadModelSelectionMenu("sapdfemale.txt");
	SAPDWar = LoadModelSelectionMenu("sapdwar.txt");
	SAGSMale = LoadModelSelectionMenu("sagsmale.txt");
	SAGSFemale = LoadModelSelectionMenu("sagsfemale.txt");
	SAMDMale = LoadModelSelectionMenu("samdmale.txt");
	SAMDFemale = LoadModelSelectionMenu("samdfemale.txt");
	SANEWMale = LoadModelSelectionMenu("sanewmale.txt");
	SANEWFemale = LoadModelSelectionMenu("sanewfemale.txt");
	toyslist = LoadModelSelectionMenu("toys.txt");
	viptoyslist = LoadModelSelectionMenu("viptoys.txt");
	
	
	new strings[128];
	CreateDynamicPickup(1239, 23, 1392.77, -22.25, 1000.97, -1);
	format(strings, sizeof(strings), "[City Hall]\n{FFFFFF}/newidcard - create new ID Card\n/newage - Change Birthday\n/sellhouse - sell your house\n/sellbisnis - sell your bisnis");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1392.77, -22.25, 1000.97, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card
	
	CreateDynamicPickup(1239, 23, 1395.82, -20.65, 1000.97, -1);
	format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/buyinsu - buy insurance\n/claimpv - claim insurance\n/sellpv - sell vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1395.82, -20.65, 1000.97, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance
	
	CreateDynamicPickup(1239, 23, 252.22, 117.43, 1003.21, -1);
	format(strings, sizeof(strings), "[License]\n{FFFFFF}/newdrivelic - create new license");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 252.22, 117.43, 1003.21, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic
	
	CreateDynamicPickup(1239, 23, 240.80, 112.95, 1003.21, -1);
	format(strings, sizeof(strings), "[Plate]\n{FFFFFF}/buyplate - create new plate");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 240.80, 112.95, 1003.21, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Plate
	
	CreateDynamicPickup(1239, 23, 246.45, 118.53, 1003.21, -1);
	format(strings, sizeof(strings), "[Ticket]\n{FFFFFF}/payticket - to pay ticket");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 246.45, 118.53, 1003.21, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket
	
	CreateDynamicPickup(1239, 23, 224.11, 118.50, 999.10, -1);
	format(strings, sizeof(strings), "[ARREST POINT]\n{FFFFFF}/arrest - arrest wanted player");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 224.11, 118.50, 999.10, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest
	
	CreateDynamicPickup(1239, 23, 1142.38, -1330.74, 13.62, -1);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1142.38, -1330.74, 13.62, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital
	
	CreateDynamicPickup(1239, 23, 2246.46, -1757.03, 1014.77, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 2246.46, -1757.03, 1014.77, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 2246.55, -1750.25, 1014.77, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 2246.55, -1750.25, 1014.77, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank
	
	CreateDynamicPickup(1239, 23, 2461.21, 2270.42, 91.67, -1);
	format(strings, sizeof(strings), "[IKLAN]\n{FFFFFF}/ads - public ads");
	CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, 2461.21, 2270.42, 91.67, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan
	
	//Dynamic CP
	ShowRoomCP = CreateDynamicCP(1750.25, -1766.13, 13.54, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("Buy Vehicle", COLOR_GREEN, 1750.25, -1766.13, 13.54, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	
	ShowRoomCPRent = CreateDynamicCP(1750.16, -1761.53, 13.54, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("Rental Vehicle\n"YELLOW_E"/unrentpv", COLOR_LBLUE, 1750.16, -1761.53, 13.54, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
	
	SAGSLobbyBtn[0] = CreateButton(1388.987670, -25.291969, 1001.358520, 180.000000);
	SAGSLobbyBtn[1] = CreateButton(1391.275756, -25.481920, 1001.358520, 0.000000);
	SAGSLobbyDoor = CreateDynamicObject(1569, 1389.375000, -25.387500, 999.978210, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
	
	SAPDLobbyBtn[0] = CreateButton(252.95264, 107.67332, 1004.00909, 264.79898);
	SAPDLobbyBtn[1] = CreateButton(253.43437, 110.62970, 1003.92737, 91.00000);
	SAPDLobbyDoor[0] = CreateDynamicObject(1569, 253.10965, 107.61060, 1002.21368,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[1] = CreateDynamicObject(1569, 253.12556, 110.49657, 1002.21460,   0.00000, 0.00000, -91.00000);

	SAPDLobbyBtn[2] = CreateButton(239.82739, 116.12640, 1004.00238, 91.00000);
	SAPDLobbyBtn[3] = CreateButton(238.75888, 116.12949, 1003.94086, 185.00000);
	SAPDLobbyDoor[2] = CreateDynamicObject(1569, 239.69435, 116.15908, 1002.21411,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[3] = CreateDynamicObject(1569, 239.64050, 119.08750, 1002.21332,   0.00000, 0.00000, 270.00000);
	
	//Family Button
	LLFLobbyBtn[0] = CreateButton(-2119.90039, 655.96808, 1062.39954, 184.67528);
	LLFLobbyBtn[1] = CreateButton(-2119.18481, 657.88519, 1062.39954, 90.00000);
	LLFLobbyDoor = CreateDynamicObject(1569, -2119.21509, 657.54187, 1060.73560,   0.00000, 0.00000, -90.00000);
	
	//Sidejob Vehicle
	AddSweeperVehicle();
	AddBusVehicle();
	
	/*new vehtext[128];
	SRV[0] = AddStaticVehicleEx(481, 1782.8107, -1789.0009, 13.4394, 270.4302, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[0]), FormatMoney(GetVehicleCost(481)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[0], 0);
	
	SRV[1] = AddStaticVehicleEx(509, 1783.0245, -1791.1428, 13.3071, 273.1105, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[1]), FormatMoney(GetVehicleCost(509)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[1], 0);
	
	SRV[2] = AddStaticVehicleEx(510, 1783.1400, -1793.4265, 13.4333, 270.4050, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[2]), FormatMoney(GetVehicleCost(510)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[2], 0);
	
	SRV[3] = AddStaticVehicleEx(463, 1771.0209, -1787.5016, 13.3307, 270.3632, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[3]), FormatMoney(GetVehicleCost(463)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[3], 0);
	
	SRV[4] = AddStaticVehicleEx(521, 1779.4094, -1797.8444, 13.3432, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[4]), FormatMoney(GetVehicleCost(521)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[4], 0);
	
	SRV[5] = AddStaticVehicleEx(461, 1776.8307, -1797.8292, 13.3249, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[5]), FormatMoney(GetVehicleCost(461)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[5], 0);
	
	SRV[6] = AddStaticVehicleEx(581, 1774.1938, -1797.7860, 13.3410, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[6]), FormatMoney(GetVehicleCost(581)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[6], 0);
	
	SRV[7] = AddStaticVehicleEx(468, 1770.8420, -1795.0306, 13.4695, 268.9327, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[7]), FormatMoney(GetVehicleCost(468)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[7], 0);
	
	SRV[8] = AddStaticVehicleEx(586, 1771.0509, -1791.2056, 13.3481, 271.8937, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[8]), FormatMoney(GetVehicleCost(586)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[8], 0);
	
	SRV[9] = AddStaticVehicleEx(462, 1783.1074, -1796.4341, 13.3418, 272.3698, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[9]), FormatMoney(GetVehicleCost(462)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[9], 0);
	
	SRV[10] = AddStaticVehicleEx(562, 1780.6313, -1746.7004, 13.4339, 272.3674, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[10]), FormatMoney(GetVehicleCost(562)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[10], 0);
	
	SRV[11] = AddStaticVehicleEx(559, 1780.5088, -1751.0884, 13.4335, 269.1176, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[11]), FormatMoney(GetVehicleCost(559)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[11], 0);
	
	SRV[12] = AddStaticVehicleEx(558, 1780.4934, -1755.6046, 13.3330, 270.1825, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[12]), FormatMoney(GetVehicleCost(558)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[12], 0);
	
	SRV[13] = AddStaticVehicleEx(560, 1780.3639, -1760.2197, 13.3498, 269.5254, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[13]), FormatMoney(GetVehicleCost(560)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[13], 0);
	
	SRV[14] = AddStaticVehicleEx(534, 1780.1563, -1765.0363, 13.5380, 269.2734, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[14]), FormatMoney(GetVehicleCost(534)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[14], 0);
	
	SRV[15] = AddStaticVehicleEx(535, 1780.0767, -1769.8610, 13.4390, 270.8372, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[15]), FormatMoney(GetVehicleCost(535)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[15], 0);
	
	SRV[16] = AddStaticVehicleEx(561, 1780.2644, -1775.0776, 13.5963, 270.4830, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[16]), FormatMoney(GetVehicleCost(561)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[16], 0);
	
	SRV[17] = AddStaticVehicleEx(565, 1780.2485, -1780.0298, 13.5388, 268.5630, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[17]), FormatMoney(GetVehicleCost(565)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[17], 0);
	
	SRV[18] = AddStaticVehicleEx(536, 1777.2966, -1792.3629, 13.4448, 266.4421, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[18]), FormatMoney(GetVehicleCost(536)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[18], 0);
	
	SRV[19] = AddStaticVehicleEx(567, 1777.0505, -1787.6537, 13.5397, 269.1854, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[19]), FormatMoney(GetVehicleCost(567)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[19], 0);
	
	SRV[20] = AddStaticVehicleEx(575, 1773.6133, -1746.8940, 13.4415, 267.7987, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[20]), FormatMoney(GetVehicleCost(575)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[20], 0);
	
	SRV[21] = AddStaticVehicleEx(576, 1773.8724, -1751.1239, 13.3463, 269.8656, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[21]), FormatMoney(GetVehicleCost(576)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[21], 0);
	
	SRV[22] = AddStaticVehicleEx(603, 1773.4714, -1755.6996, 13.5358, 269.4989, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[22]), FormatMoney(GetVehicleCost(603)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[22], 0);
	
	SRV[23] = AddStaticVehicleEx(421, 1773.2870, -1760.1803, 13.6587, 268.1767, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[23]), FormatMoney(GetVehicleCost(421)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[23], 0);
	
	SRV[24] = AddStaticVehicleEx(602, 1773.1527, -1765.1130, 13.5350, 269.3487, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[24]), FormatMoney(GetVehicleCost(602)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[24], 0);
	
	SRV[25] = AddStaticVehicleEx(424, 1763.0251, -1747.0309, 13.4563, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[25]), FormatMoney(GetVehicleCost(424)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[25], 0);
	
	SRV[26] = AddStaticVehicleEx(545, 1767.9030, -1747.1432, 13.6429, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[26]), FormatMoney(GetVehicleCost(545)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[26], 0);
	
	SRV[27] = AddStaticVehicleEx(470, 1763.0076, -1752.5802, 13.5407, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[27]), FormatMoney(GetVehicleCost(470)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[27], 0);
	
	SRV[28] = AddStaticVehicleEx(405, 1767.8601, -1752.9895, 13.6361, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[28]), FormatMoney(GetVehicleCost(405)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[28], 0);
	
	SRV[29] = AddStaticVehicleEx(445, 1762.8158, -1758.9573, 13.6367, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[29]), FormatMoney(GetVehicleCost(445)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[29], 0);
	
	SRV[30] = AddStaticVehicleEx(579, 1767.6091, -1759.2477, 13.6316, 0.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[30]), FormatMoney(GetVehicleCost(579)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[30], 0);
	
	SRV[31] = AddStaticVehicleEx(507, 1765.8990, -1765.1198, 13.6521, 270.5802, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"LG_E"%s", GetVehicleName(SRV[31]), FormatMoney(GetVehicleCost(507)));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, SRV[31], 0);

	VSRV[0] = AddStaticVehicleEx(522, 1764.1200, -1767.0721, 19.0150, 267.2831, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[0]), GetVipVehicleCost(522));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[0], 0);
	
	VSRV[1] = AddStaticVehicleEx(411, 1764.5015, -1763.0033, 19.1138, 269.4697, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[1]), GetVipVehicleCost(411));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[1], 0);
	
	VSRV[2] = AddStaticVehicleEx(451, 1764.4136, -1757.9407, 18.9155, 270.6092, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[2]), GetVipVehicleCost(451));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[2], 0);
	
	VSRV[3] = AddStaticVehicleEx(415, 1764.8381, -1752.6050, 19.2127, 269.6837, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[3]), GetVipVehicleCost(415));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[3], 0);
	
	VSRV[4] = AddStaticVehicleEx(402, 1765.0895, -1747.2574, 19.1356, 268.8522, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[4]), GetVipVehicleCost(402));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[4], 0);
	
	VSRV[5] = AddStaticVehicleEx(541, 1775.5743, -1763.1888, 18.9185, 269.6231, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[5]), GetVipVehicleCost(541));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[5], 0);
	
	VSRV[6] = AddStaticVehicleEx(429, 1775.4403, -1757.9485, 18.9151, 268.5131, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[6]), GetVipVehicleCost(429));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[6], 0);
	
	VSRV[7] = AddStaticVehicleEx(506, 1775.5327, -1752.8689, 19.1126, 269.4091, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[7]), GetVipVehicleCost(506));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[7], 0);
	
	VSRV[8] = AddStaticVehicleEx(494, 1773.2062, -1789.9043, 19.1187, -91.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[8]), GetVipVehicleCost(494));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[8], 0);
	
	VSRV[9] = AddStaticVehicleEx(502, 1773.0939, -1784.8964, 19.2225, 268.5928, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[9]), GetVipVehicleCost(502));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[9], 0);
	
	VSRV[10] = AddStaticVehicleEx(503, 1773.3008, -1780.1669, 19.1467, -91.0000, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[10]), GetVipVehicleCost(503));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[10], 0);
	
	VSRV[11] = AddStaticVehicleEx(409, 1774.4655, -1795.3044, 19.2847, 270.3382, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[11]), GetVipVehicleCost(409));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[11], 0);
	
	VSRV[12] = AddStaticVehicleEx(477, 1775.4735, -1747.1354, 19.1130, 269.5970, 0, 0, 100);
	format(vehtext, sizeof(vehtext), "%s\n"YELLOW_E"%d Coin", GetVehicleName(VSRV[12]), GetVipVehicleCost(477));
	CreateDynamic3DTextLabel(vehtext, COLOR_WHITE, 1782.8107, -1789.0009, 13.4394, 3.0, INVALID_PLAYER_ID, VSRV[12], 0);*/
	
	//SAPD LSPD Vehicles
	SAPDVehicles[0] = AddStaticVehicleEx(596,1602.0660,-1683.9678,5.6124,90.3080,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[1] = AddStaticVehicleEx(596,1602.1194,-1687.9663,5.6107,90.5233,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[2] = AddStaticVehicleEx(596,1602.1680,-1692.0110,5.6113,89.5516,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[3] = AddStaticVehicleEx(596,1602.1666,-1696.1469,5.6123,90.4002,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[4] = AddStaticVehicleEx(596,1602.1936,-1700.1580,5.6113,89.7974,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[5] = AddStaticVehicleEx(596,1602.1382,-1704.3373,5.6118,88.9091,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[6] = AddStaticVehicleEx(407,1595.5073,-1710.6666,5.6109,0.1711,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[7] = AddStaticVehicleEx(544,1591.3687,-1710.6256,5.6119,358.8773,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[8] = AddStaticVehicleEx(596,1587.3217,-1710.6517,5.6118,0.3150,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[9] = AddStaticVehicleEx(596,1583.3668,-1710.7098,5.6118,0.0238,0,1, VEHICLE_RESPAWN, 1); // Cruiser
	SAPDVehicles[10] = AddStaticVehicleEx(599,1545.7213,-1655.0195,6.0814,90.4218,0,1, VEHICLE_RESPAWN, 1); // Rancher
	SAPDVehicles[11] = AddStaticVehicleEx(599,1545.8069,-1651.1516,6.0790,88.2897,0,1, VEHICLE_RESPAWN, 1); // Rancher
	SAPDVehicles[12] = AddStaticVehicleEx(601,1526.5850,-1644.1801,5.6494,180.3210,1,1, VEHICLE_RESPAWN, 1); // Splashy
	SAPDVehicles[13] = AddStaticVehicleEx(601,1530.7244,-1644.2538,5.6494,179.6148,1,1, VEHICLE_RESPAWN, 1); // Splashy
	//SAPDVehicles[14] = AddStaticVehicleEx(427,1534.8553,-1644.8682,6.0226,180.7921,0,0, VEHICLE_RESPAWN, 1); // Enforcer
	//SAPDVehicles[15] = 	AddStaticVehicleEx(427,1538.9325,-1644.9508,6.0226,179.5991,0,0, VEHICLE_RESPAWN, 1); // Enforcer
	SAPDVehicles[14] = AddStaticVehicleEx(528,1527.6542,-1655.9646,5.9339,270.1992,0,0, VEHICLE_RESPAWN, 1); // SWAT Van
	SAPDVehicles[15] = AddStaticVehicleEx(560,1584.7515,-1667.5281,5.5974,270.7136,0,0, VEHICLE_RESPAWN, 1); // Sultan
	SAPDVehicles[16] = AddStaticVehicleEx(560,1584.7291,-1671.6987,5.5982,268.7675,0,0, VEHICLE_RESPAWN, 1); // Sultan
	SAPDVehicles[17] = AddStaticVehicleEx(523,1584.7783,-1675.3850,5.4639,270.6620,0,0, VEHICLE_RESPAWN, 1); // Police Bike
	SAPDVehicles[18] = AddStaticVehicleEx(523,1585.0814,-1680.4186,5.4661,272.0062,0,0, VEHICLE_RESPAWN, 1); // Police Bike
	SAPDVehicles[19] = AddStaticVehicleEx(523,1587.2833,-1677.7260,5.4654,269.2448,0,0, VEHICLE_RESPAWN, 1); // Police Bike
	SAPDVehicles[20] = AddStaticVehicleEx(596,1535.9803,-1677.6580,13.1176,359.4672,0,1, VEHICLE_RESPAWN, 1); // Cruiser (Front)
	SAPDVehicles[21] = AddStaticVehicleEx(596,1535.9502,-1667.3008,13.1039,180.1666,0,1, VEHICLE_RESPAWN, 1); // Cruiser (Front)
	SAPDVehicles[22] = AddStaticVehicleEx(525,1556.5985,-1606.3214,13.2680,179.1279,17,20, VEHICLE_RESPAWN, 1); // Tow Truck
	SAPDVehicles[23] = AddStaticVehicleEx(525,1560.8201,-1606.3423,13.2557,178.6305,18,20, VEHICLE_RESPAWN, 1); // Tow Truck
	SAPDVehicles[24] = AddStaticVehicleEx(497,1569.1587,-1641.0361,28.5788,89.5537,0,1, VEHICLE_RESPAWN, 1); // Maverick
	SAPDVehicles[25] = AddStaticVehicleEx(497,1547.7992,-1643.6317,28.5923,91.2595,0,1, VEHICLE_RESPAWN, 1); // Maverick
 	SAPDVehicles[26] = AddStaticVehicleEx(411,1578.5643,-1710.6968,5.6112,0.0933,0,1, VEHICLE_RESPAWN, 1); // Infernus
	SAPDVehicles[27] = AddStaticVehicleEx(411,1574.3217,-1710.7924,5.6117,0.8341,0,1, VEHICLE_RESPAWN, 1); // Infernus

	for(new x;x<sizeof(SAPDVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAPD-%d", SAPDVehicles[x]);
	    SetVehicleNumberPlate(SAPDVehicles[x], strings);
	    SetVehicleToRespawn(SAPDVehicles[x]);
	}
	
	/*SAGSVehicles[0] = AddStaticVehicleEx(409, 1534.4767, -1757.0521, 13.1437, 180.2723, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[1] = AddStaticVehicleEx(409, 1545.6013, -1757.0219, 13.1437, 180.2723, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[2] = AddStaticVehicleEx(409, 1539.9905, -1757.0594, 13.1437, 180.2723, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[3] = AddStaticVehicleEx(400, 1553.3678, -1775.4850, 13.5501, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[4] = AddStaticVehicleEx(400, 1553.2333, -1771.4791, 13.5501, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[5] = AddStaticVehicleEx(560, 1553.9814, -1783.3425, 13.0479, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[6] = AddStaticVehicleEx(560, 1553.9375, -1779.5382, 13.0479, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[7] = AddStaticVehicleEx(426, 1553.6774, -1787.2021, 13.1542, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[8] = AddStaticVehicleEx(439, 1553.3984, -1791.1477, 13.2904, 90.3328, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[9] = AddStaticVehicleEx(562, 1553.8031, -1795.1871, 13.1378, 91.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[10] = AddStaticVehicleEx(437, 1545.9094, -1819.8540, 13.4641, 0.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[11] = AddStaticVehicleEx(483, 1540.3176, -1818.8209, 13.4678, 0.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[12] = AddStaticVehicleEx(521, 1524.2035, -1754.7806, 12.9503, 178.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[13] = AddStaticVehicleEx(521, 1527.6666, -1754.8362, 12.9503, 178.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[14] = AddStaticVehicleEx(521, 1525.8569, -1754.8169, 12.9503, 178.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[15] = AddStaticVehicleEx(461, 1518.5685, -1754.8243, 12.9700, 178.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[16] = AddStaticVehicleEx(461, 1522.2450, -1754.6913, 12.9700, 178.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[17] = AddStaticVehicleEx(461, 1520.4065, -1754.8032, 12.9700, 178.0000, 0, 1, VEHICLE_RESPAWN);
	//SAGSVehicles[18] = AddStaticVehicleEx(417, 1530.6005, -1807.9861, 13.7233, 0.0000, -1, -1, VEHICLE_RESPAWN);	//heli
	//SAGSVehicles[19] = AddStaticVehicleEx(487, 1510.3551, -1816.0139, 13.6872, -84.0000, -1, -1, VEHICLE_RESPAWN);	//heli*/
	
	/*SAGSVehicles[0] = AddStaticVehicleEx(409, 1414.6333, -1859.0222, 13.1326, 90.3330, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[1] = AddStaticVehicleEx(409, 1415.2675, -1844.1443, 13.1326, 90.3330, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[2] = AddStaticVehicleEx(411, 1415.4066, -1834.1469, 13.2399, 90.5851, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[3] = AddStaticVehicleEx(411, 1415.4929, -1839.2155, 13.2399, 90.5851, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[4] = AddStaticVehicleEx(507, 1415.2688, -1829.0492, 13.2130, 89.9329, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[5] = AddStaticVehicleEx(431, 1413.0757, -1854.6390, 13.5431, 89.7958, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[6] = AddStaticVehicleEx(437, 1413.4871, -1849.3666, 13.5798, 90.3041, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[7] = AddStaticVehicleEx(521, 1459.8047, -1819.2911, 12.9433, 0.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[8] = AddStaticVehicleEx(581, 1454.9469, -1818.9352, 13.0384, 0.0000, 0, 1, VEHICLE_RESPAWN);
	SAGSVehicles[9] = AddStaticVehicleEx(461, 1449.7579, -1818.8969, 13.0665, 0.0000, 0, 1, VEHICLE_RESPAWN);*/
	
	SAGSVehicles[0] = AddStaticVehicleEx(405, 1406.1680, -1777.0349, 13.4792, 92.9325, 1, 1, VEHICLE_RESPAWN);
	SAGSVehicles[1] = AddStaticVehicleEx(405, 1406.6605, -1782.3423, 13.4790, 92.3889, 1, 1, VEHICLE_RESPAWN);
	SAGSVehicles[2] = AddStaticVehicleEx(409, 1407.4417, -1792.9128, 13.4407, 92.4881, 1, 1, VEHICLE_RESPAWN);
	SAGSVehicles[3] = AddStaticVehicleEx(409, 1407.8241, -1803.2029, 13.5150, 90.3660, 1, 1, VEHICLE_RESPAWN);
	SAGSVehicles[4] = AddStaticVehicleEx(411, 1524.1866, -1846.0491, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[5] = AddStaticVehicleEx(411, 1534.8187, -1845.9094, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[6] = AddStaticVehicleEx(411, 1529.4353, -1845.9347, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[7] = AddStaticVehicleEx(521, 1512.8479, -1846.1010, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[8] = AddStaticVehicleEx(521, 1519.4961, -1846.0326, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[9] = AddStaticVehicleEx(521, 1515.9736, -1845.9476, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
	SAGSVehicles[10] = AddStaticVehicleEx(437, 1494.1495, -1845.1425, 13.5694, -91.0000, 0, 0, VEHICLE_RESPAWN);

	
	for(new x;x<sizeof(SAGSVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAGS-%d", SAGSVehicles[x]);
	    SetVehicleNumberPlate(SAGSVehicles[x], strings);
	    SetVehicleToRespawn(SAGSVehicles[x]);
	}
	
	SAMDVehicles[0] = AddStaticVehicleEx(407, 1111.0358, -1328.3903, 13.6102, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[1] = AddStaticVehicleEx(407, 1098.1630, -1328.7020, 13.7072, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[2] = AddStaticVehicleEx(544, 1124.4944, -1327.0439, 13.9194, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[3] = AddStaticVehicleEx(416, 1116.0294, -1296.6489, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[4] = AddStaticVehicleEx(416, 1125.8785, -1296.2780, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[5] = AddStaticVehicleEx(416, 1121.1556, -1296.4138, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[6] = AddStaticVehicleEx(442, 1111.1719, -1296.7606, 13.4886, 185.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[7] = AddStaticVehicleEx(426, 1136.0360, -1341.2158, 13.3050, 0.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[8] = AddStaticVehicleEx(416, 1178.5963, -1338.9039, 14.1457, -91.0000, 1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[9] = AddStaticVehicleEx(586, 1130.7795, -1330.4045, 13.3639, 0.0000, 0, 1, VEHICLE_RESPAWN, 1);
	SAMDVehicles[10] = AddStaticVehicleEx(563, 1162.9077, -1313.8203, 32.1891, 270.6980, -1, 3, VEHICLE_RESPAWN, 1);
	SAMDVehicles[11] = AddStaticVehicleEx(487, 1163.0469, -1297.5098, 31.5550, 269.6279, -1, 3, VEHICLE_RESPAWN, 1);
	
	for(new x;x<sizeof(SAMDVehicles);x++)
	{
	    format(strings, sizeof(strings), "SAMD-%d", SAMDVehicles[x]);
	    SetVehicleNumberPlate(SAMDVehicles[x], strings);
	    SetVehicleToRespawn(SAMDVehicles[x]);
	}
	
	SANAVehicles[0] = AddStaticVehicleEx(582, 781.4338, -1337.5022, 13.9482, 91.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[1] = AddStaticVehicleEx(582, 758.7664, -1336.1642, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[2] = AddStaticVehicleEx(582, 764.4276, -1336.1959, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[3] = AddStaticVehicleEx(582, 770.3247, -1335.9663, 13.9482, 179.0212, -1, -1, VEHICLE_RESPAWN);
	//SANAVehicles[4] = AddStaticVehicleEx(582, 781.8044, -1348.0001, 13.9482, 91.0000, -1, -1, VEHICLE_RESPAWN);
	//SANAVehicles[5] = AddStaticVehicleEx(582, 781.6168, -1342.6869, 13.9482, 91.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[4] = AddStaticVehicleEx(418, 737.3025, -1334.3344, 14.1711, 246.6513, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[5] = AddStaticVehicleEx(413, 736.4621, -1338.6304, 13.7490, -113.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[6] = AddStaticVehicleEx(405, 737.4107, -1343.0820, 13.7357, -113.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[7] = AddStaticVehicleEx(461, 749.7194, -1334.2122, 13.2465, 178.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[8] = AddStaticVehicleEx(461, 753.8127, -1334.2727, 13.2465, 178.0000, -1, -1, VEHICLE_RESPAWN);
	//SANAVehicles[11] = AddStaticVehicleEx(461, 751.7328, -1334.2236, 13.2465, 178.0000, -1, -1, VEHICLE_RESPAWN);
	SANAVehicles[9] = AddStaticVehicleEx(488, 741.9925, -1371.2443, 25.8111, 0.0000, -1, -1, VEHICLE_RESPAWN);
	
	for(new x;x<sizeof(SANAVehicles);x++)
	{
	    format(strings, sizeof(strings), "SANA-%d", SANAVehicles[x]);
	    SetVehicleNumberPlate(SANAVehicles[x], strings);
	    SetVehicleToRespawn(SANAVehicles[x]);
	}
	
	
	/*CreateDynamicObject(19305, 1388.987670, -25.291969, 1001.358520, 0.000000, 0.000000, 180.000000, -1, -1, -1, 300.00, 300.00); 
	CreateDynamicObject(19305, 1391.275756, -25.481920, 1001.358520, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);
    SAGSLobbyKey[0] = CreateKeypadEx(1388.987670, -25.291969, 1001.358520, "1234");
    SAGSLobbyKey[1] = CreateKeypadEx(1391.275756, -25.481920, 1001.358520, "1234");
	SAGSLobbyDoor = CreateDynamicObject(1569, 1389.375000, -25.387500, 999.978210, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);*/
	
	/*CreateButton(Float:x, Float:y, Float:z, text[],
	world = 0, interior = 0, Float:areasize = 1.0, label = 0,
	labeltext[] = "", labelcolour = 0xFFFF00FF, Float:streamdist = BTN_DEFAULT_STREAMDIST, testlos = true)
	
	
	SAGSLobbyBtn[0] = CreateButton(1388.987670, -25.291969, 1001.358520, "SAGS Lobby", 0, 0, 1.0, 0, "No", 0xFFFF00FF, BTN_DEFAULT_STREAMDIST, true);
    SAGSLobbyBtn[1] = CreateButton(1391.275756, -25.481920, 1001.358520, "SAGS Lobby", 0,  0, 1.0, 0, "No", 0xFFFF00FF, BTN_DEFAULT_STREAMDIST, true);

	SAGSLobbyDoor = CreateDoor(1569, SAGSLobbyBtn,
		1389.375000, -25.387500, 999.978210, 0.00000, 0.00000, 0.00000,
		1387.9232, -25.3887, 999.9782, 0.00000, 0.00000, 0.00000,
		.movespeed = 1.0, .closedelay = 3000, .maxbuttons = 2, .movesound = 1186, .stopsound = 1186, .worldid = 0, .interiorid = 0, .initstate = DR_STATE_CLOSED);
	*/
	
	//Mappingan Nongkrong
	CreateObject(1702, -675.71997, 932.85303, 11.11923,   0.00000, 0.00000, 52.39256);
	CreateObject(1702, -671.41113, 934.43909, 11.11923,   0.00000, 0.00000, 291.48636);
	CreateObject(1817, -673.46869, 933.23010, 11.12383,   0.00000, 0.00000, 256.94504);
	CreateObject(1670, -672.97021, 932.73651, 11.62490,   0.00000, 0.00000, 43.20970);
	CreateObject(1484, -675.75128, 933.07605, 11.72820,   0.00000, 0.00000, 0.00000);
	CreateObject(638, -675.96472, 936.36658, 11.81450,   0.00000, 0.00000, 271.08249);
	CreateObject(1361, -673.32922, 936.09741, 11.87500,   0.00000, 0.00000, 0.00000);
	CreateObject(638, -670.56042, 936.39423, 11.81450,   0.00000, 0.00000, 271.08249);
	CreateObject(1702, -672.17493, 930.09039, 11.11923,   0.00000, 0.00000, 183.20018);
	CreateObject(2059, -673.10315, 932.39532, 11.63550,   0.00000, 0.00000, 282.75229);
	CreateObject(2232, -676.11139, 931.65930, 11.72750,   0.00000, 0.00000, 98.54639);
	CreateObject(1670, -676.14587, 931.66705, 12.32586,   0.00000, 0.00000, 43.20970);
	CreateObject(2232, -670.84637, 930.53979, 11.72750,   0.00000, 0.00000, 211.36740);
	CreateObject(1670, -670.90527, 930.57007, 12.32557,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -673.30841, 930.14960, 11.63550,   0.00000, 0.00000, 335.19873);
	CreateObject(2313, -681.26538, 929.93500, 11.11530,   0.00000, 0.00000, 87.56017);
	CreateObject(1752, -681.49774, 930.66071, 11.61340,   0.00000, 0.00000, 90.54723);
	CreateObject(1702, -678.67639, 932.81683, 11.11923,   0.00000, 0.00000, 302.16214);
	CreateObject(1702, -677.61041, 929.89423, 11.11923,   0.00000, 0.00000, 245.56239);
	CreateObject(1670, -681.26953, 929.83325, 11.61240,   0.00000, 0.00000, 38.65175);
	CreateObject(1543, -681.11737, 931.36945, 11.61257,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -672.63361, 933.21545, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, -677.74146, 913.71338, 11.09743,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, -681.66516, 913.71179, 11.09743,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, -681.65588, 917.71466, 11.09743,   0.00000, 0.00000, 0.00000);
	CreateObject(19128, -677.73291, 917.69659, 11.09743,   0.00000, 0.00000, 0.00000);
	CreateObject(1702, -674.79822, 914.52374, 11.10766,   0.00000, 0.00000, 268.14905);
	CreateObject(1702, -674.72675, 919.17944, 11.10766,   0.00000, 0.00000, 269.87485);
	CreateObject(2232, -675.09906, 916.59106, 11.66880,   0.00000, 0.00000, 280.82831);
	CreateObject(1670, -675.08148, 916.59106, 12.26814,   0.00000, 0.00000, 311.67957);
	CreateObject(2232, -675.13898, 915.13074, 11.66880,   0.00000, 0.00000, 257.16098);
	CreateObject(1670, -675.20007, 915.09998, 12.26692,   0.00000, 0.00000, 22.67710);
	CreateObject(638, -684.07642, 913.22998, 12.00789,   0.00000, 0.00000, 0.00000);
	CreateObject(1361, -684.37140, 915.31494, 11.81965,   0.00000, 0.00000, 0.00000);
	CreateObject(638, -684.29669, 917.83447, 11.70283,   0.00000, 0.00000, 0.41834);
	CreateObject(2047, -673.95428, 936.63159, 13.83030,   0.00000, 0.00000, 0.20300);
	CreateObject(2614, -673.96246, 936.68903, 14.50755,   0.00000, 0.00000, 0.00000);
	CreateObject(2047, -683.22424, 933.21826, 13.94814,   0.00000, 0.00000, 89.97572);
	CreateObject(2059, -674.83234, 933.71173, 11.63550,   0.00000, 0.00000, 218.12152);
	CreateObject(2059, -671.13971, 933.70520, 11.63550,   0.00000, 0.00000, 282.75229);
	CreateObject(1543, -671.25403, 934.24323, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -673.80121, 931.56000, 11.13550,   0.00000, 0.00000, 282.75229);
	CreateObject(2059, -671.86383, 932.10913, 11.13550,   0.00000, 0.00000, 187.03017);
	CreateObject(2628, -671.60333, 957.80334, 11.12274,   0.00000, 0.00000, 0.00000);
	CreateObject(2628, -672.92303, 957.84320, 11.12274,   0.00000, 0.00000, 0.00000);
	CreateObject(2628, -674.39044, 957.83313, 11.12274,   0.00000, 0.00000, 0.00000);
	CreateObject(2614, -688.24310, 943.91388, 15.63041,   0.00000, 0.00000, 185.12300);
	CreateObject(2632, -670.75562, 953.20587, 11.12368,   0.00000, 0.00000, 0.00000);
	CreateObject(2632, -670.78528, 950.21332, 11.12368,   0.00000, 0.00000, 0.00000);
	CreateObject(2631, -671.14972, 944.94183, 11.12360,   0.00000, 0.00000, 270.29538);
	CreateObject(2631, -674.73096, 944.91394, 11.12360,   0.00000, 0.00000, 270.29538);
	CreateObject(2630, -676.79846, 958.00159, 11.12286,   0.00000, 0.00000, 180.31738);
	CreateObject(2630, -678.41345, 957.99341, 11.12286,   0.00000, 0.00000, 180.31738);
	CreateObject(2630, -680.10980, 957.97357, 11.12286,   0.00000, 0.00000, 180.31738);
	CreateObject(19364, -707.93958, 937.58752, 13.22910,   0.00000, 0.00000, 271.46683);
	CreateObject(19364, -711.16095, 937.50854, 13.22910,   0.00000, 0.00000, 271.46683);
	CreateObject(19364, -714.35675, 937.42932, 13.22910,   0.00000, 0.00000, 271.46680);
	CreateObject(19364, -717.16675, 938.37347, 13.22910,   0.00000, 0.00000, 231.34068);
	CreateObject(19364, -718.25824, 944.09607, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -718.35236, 940.91199, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -718.16766, 947.29321, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -718.07733, 950.50977, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -695.29944, 972.06488, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -701.69647, 972.22888, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -698.48566, 972.14630, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -704.90399, 972.30707, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -708.10333, 972.38873, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -711.29028, 972.47021, 13.22910,   0.00000, 0.00000, 88.56609);
	CreateObject(19364, -714.31262, 971.86401, 13.22910,   0.00000, 0.00000, 114.23680);
	CreateObject(19364, -717.60022, 968.65411, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -717.69836, 965.45087, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -717.78748, 962.23737, 13.22910,   0.00000, 0.00000, 178.34496);
	CreateObject(19364, -716.22223, 970.98334, 13.22910,   0.00000, 0.00000, 114.66270);
	CreateObject(18241, -707.85040, 917.83429, 11.43653,   0.00000, 0.00000, 86.89547);
	CreateObject(8572, -703.69629, 926.39197, 13.65215,   0.00000, 0.00000, 175.01660);
	CreateObject(2395, -706.17053, 922.44513, 16.83105,   -91.00000, 1.00000, 86.33866);
	CreateObject(8572, -705.60956, 926.56750, 15.49880,   0.00000, 0.00000, 175.01660);
	CreateObject(970, -703.49860, 919.96429, 17.48950,   0.00000, 0.00000, 266.66202);
	CreateObject(970, -703.74908, 915.85895, 17.48950,   0.00000, 0.00000, 266.66202);
	CreateObject(970, -706.05048, 913.59680, 17.48950,   0.00000, 0.00000, 176.63634);
	CreateObject(970, -710.21906, 913.85992, 17.48950,   0.00000, 0.00000, 176.63634);
	CreateObject(970, -711.97498, 920.21008, 17.48950,   0.00000, 0.00000, 86.85619);
	CreateObject(970, -712.19757, 916.04260, 17.48950,   0.00000, 0.00000, 86.85619);
	CreateObject(970, -706.08026, 923.66199, 17.36950,   0.00000, 0.00000, 265.03464);
	CreateObject(970, -711.41229, 924.18634, 17.36950,   0.00000, 0.00000, 265.94061);
	CreateObject(16151, -710.90778, 918.16266, 17.27010,   0.00000, 0.00000, 177.20901);
	CreateObject(1711, -704.65308, 914.93671, 16.94076,   0.00000, 0.00000, 202.91066);
	CreateObject(1711, -706.70691, 914.69641, 16.94076,   0.00000, 0.00000, 143.40454);
	CreateObject(1711, -707.40106, 916.93787, 16.94076,   0.00000, 0.00000, 84.25421);
	CreateObject(1711, -706.33521, 918.86810, 16.94076,   0.00000, 0.00000, 30.60753);
	CreateObject(1711, -704.34882, 918.17468, 16.94076,   0.00000, 0.00000, 315.57208);
	CreateObject(1817, -705.21143, 916.15759, 16.94172,   0.00000, 0.00000, 71.62250);
	CreateObject(1670, -705.42017, 917.24011, 17.44101,   0.00000, 0.00000, 33.60771);
	CreateObject(1670, -705.75012, 916.46375, 17.44101,   0.00000, 0.00000, 106.87082);
	CreateObject(1543, -705.44281, 916.59229, 17.41552,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -705.61011, 917.53485, 17.41552,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -705.56342, 916.99121, 17.45350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -704.89697, 915.16406, 17.47350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -704.67401, 916.54382, 16.95350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -705.70044, 918.05145, 16.95350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -706.56860, 916.30646, 16.95350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -708.03979, 918.53680, 16.95350,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -704.93781, 919.37146, 16.95350,   0.00000, 0.00000, 295.36923);
	CreateObject(1543, -705.45465, 916.14508, 17.41552,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -705.89703, 916.33594, 17.41552,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -705.05066, 917.21741, 17.41552,   0.00000, 0.00000, 0.00000);
	CreateObject(1670, -709.89972, 919.06628, 17.89664,   0.00000, 0.00000, 54.92595);
	CreateObject(1670, -709.97296, 920.21045, 17.89664,   0.00000, 0.00000, 93.09599);
	CreateObject(1670, -710.36285, 914.99445, 17.89664,   0.00000, 0.00000, 81.14830);
	CreateObject(1543, -710.12238, 917.86359, 17.89543,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -710.14087, 916.46381, 17.89543,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -710.23175, 915.64478, 17.89543,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -711.68359, 914.72388, 17.89543,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -673.08325, 932.95624, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -673.25763, 932.06378, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -672.79523, 932.47858, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, -672.87305, 931.82751, 11.62776,   0.00000, 0.00000, 0.00000);
	CreateObject(2059, -672.65210, 933.99396, 11.13550,   0.00000, 0.00000, 187.03017);
	CreateObject(2059, -676.97742, 930.44531, 11.13550,   0.00000, 0.00000, 187.03017);
	CreateObject(2059, -669.95142, 931.83636, 11.13550,   0.00000, 0.00000, 187.03017);
	CreateObject(3276, -716.42017, 915.34631, 12.38281,   356.91949, 0.04363, -1.50098);
	CreateObject(3276, -716.22583, 926.32458, 12.38281,   356.91949, 0.04363, -1.50098);
	CreateObject(3276, -716.11481, 931.72400, 12.38281,   356.91949, 0.04363, -1.50098);
	CreateObject(2395, -708.82764, 922.67780, 16.83105,   -91.00000, 1.00000, 86.33866);
	CreateObject(1985, -679.72729, 945.72174, 11.12481,   0.00000, 0.00000, 0.00000);
	CreateObject(1985, -679.44757, 945.27374, 13.95609,   0.00000, 0.00000, 0.00000);
	CreateObject(1985, -681.54083, 945.16693, 13.95609,   0.00000, 0.00000, 0.00000);
	CreateObject(1985, -683.87701, 945.35284, 13.95609,   0.00000, 0.00000, 0.00000);
	CreateObject(2395, -680.89856, 946.77527, 13.94109,   91.00000, 74.00000, 286.49048);
	CreateObject(2395, -684.24622, 946.71887, 13.89910,   91.00000, 74.00000, 286.49051);
	CreateObject(2395, -678.05273, 946.50043, 14.16410,   -89.00000, 101.00000, 280.00000);
	CreateObject(2395, -681.79877, 946.51544, 14.08410,   -89.00000, 101.00000, 280.00000);
	CreateObject(14791, -679.74054, 951.86371, 13.16190,   0.00000, 0.00000, 0.00000);

	//Pasbek Gratisan
	CreateObject(5774, -4085.90723, -10667.39551, 2035.36755,   0.00000, 0.00000, 0.00000);
	CreateObject(1790, 9514.82324, -5018.15918, 3166.50513,   0.00000, 0.00000, 0.00000);
	CreateObject(16362, 341.84409, -1803.43445, 6.83743,   0.00000, 0.00000, 90.02863);
	CreateObject(8947, 315.54636, -1798.20264, 6.81149,   0.00000, 0.00000, 179.92101);
	CreateObject(14826, 310.99677, -1805.90649, 4.23834,   0.00000, 0.00000, 272.69705);
	CreateObject(1098, 321.70108, -1786.91907, 5.09812,   0.00000, 0.00000, 90.24177);
	CreateObject(1098, 321.73151, -1785.97412, 5.09812,   0.00000, 0.00000, 90.24177);
	CreateObject(1098, 320.22894, -1785.92822, 5.09812,   0.00000, 0.00000, 90.24177);
	CreateObject(1729, 309.19281, -1800.18481, 3.58475,   0.00000, 0.00000, 91.58844);
	CreateObject(1729, 309.20831, -1797.51697, 3.58475,   0.00000, 0.00000, 91.58844);
	CreateObject(1729, 309.21967, -1794.62964, 3.58475,   0.00000, 0.00000, 91.58844);
	CreateObject(1729, 309.18381, -1791.83081, 3.58475,   0.00000, 0.00000, 91.68944);
	CreateObject(10282, 318.59750, -1804.72021, 4.80446,   0.00000, 0.00000, 180.41841);
	CreateObject(18749, 320.97327, -1785.91626, 6.05519,   0.00000, 0.00000, 175.78090);
	CreateObject(1686, 323.62537, -1802.73376, 3.87624,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 353.96722, -1830.73108, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 340.05182, -1829.62280, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 326.15698, -1829.10071, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(621, 332.77255, -1827.66541, 0.32971,   0.00000, 0.00000, 0.00000);
	CreateObject(621, 346.00647, -1826.92346, 0.32971,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 314.62402, -1828.53076, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 289.98389, -1831.36951, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(620, 284.83743, -1818.31726, 2.12765,   0.00000, 0.00000, 0.00000);
	CreateObject(621, 318.44049, -1828.81848, 0.32971,   0.00000, 0.00000, 0.00000);
	CreateObject(619, 286.54736, -1817.08411, 2.83388,   0.00000, 0.00000, 108.98626);
	//Base. grove
	CreateDynamicObject(8210, 2513.30640, -1722.43896, 11.72510,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(8210, 2541.02734, -1694.98218, 11.72510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1728, 2527.96973, -1707.72522, 12.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(13011, 2514.66040, -1712.63159, 14.20000,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1468, 2519.91260, -1715.77942, 18.80000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1653, 2510.58691, -1713.66418, 18.27820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1653, 2497.77246, -1713.68726, 18.27820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1653, 2490.52222, -1713.62305, 18.27820,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1653, 2484.16626, -1717.75977, 18.22000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1653, 2490.60229, -1724.15857, 18.26000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1653, 2503.49829, -1724.19055, 18.26000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14791, 2491.50903, -1718.16956, 19.08000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(14782, 2484.54614, -1720.99292, 17.98000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1431, 2485.56323, -1714.05798, 18.25000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1431, 2498.54932, -1723.71033, 18.25000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3633, 2518.19702, -1722.73462, 18.05000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1362, 2497.26270, -1714.15625, 18.17890,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1362, 2508.75806, -1722.77222, 18.17890,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1728, 2500.65552, -1714.23694, 17.51500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1728, 2510.16992, -1714.31177, 17.51500,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1728, 2516.08594, -1722.92847, 17.51500,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1728, 2505.38257, -1722.92310, 17.51500,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1362, 2507.50024, -1714.23486, 18.17890,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2508.85791, -1722.75305, 16.92660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2507.61963, -1714.09375, 16.92660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2497.21289, -1713.99292, 16.92660,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2676, 2497.50928, -1715.10608, 17.69000,   0.00000, 0.00000, -164.00000);
	CreateDynamicObject(2676, 2497.89648, -1720.47791, 17.69000,   0.00000, 0.00000, -193.00000);
	CreateDynamicObject(2676, 2501.99194, -1721.22620, 17.69000,   0.00000, 0.00000, -47.00000);
	CreateDynamicObject(2676, 2508.79932, -1721.70471, 17.69000,   0.00000, 0.00000, -4.00000);
	CreateDynamicObject(2676, 2516.77026, -1721.76917, 17.69000,   0.00000, 0.00000, 40.00000);
	CreateDynamicObject(2676, 2507.57104, -1715.22620, 17.69000,   0.00000, 0.00000, 171.00000);
	CreateDynamicObject(1369, 2516.38184, -1714.25269, 18.15000,   0.00000, 0.00000, 25.00000);
	CreateDynamicObject(1338, 2518.34351, -1717.78931, 18.09750,   0.00000, 0.00000, 40.00000);
	CreateDynamicObject(2676, 2516.27002, -1715.29688, 17.69000,   0.00000, 0.00000, 178.00000);
	CreateDynamicObject(2676, 2528.96533, -1719.28027, 12.69000,   0.00000, 0.00000, 47.00000);
	CreateDynamicObject(2676, 2535.70996, -1716.96765, 12.69000,   0.00000, 0.00000, -18.00000);
	CreateDynamicObject(3461, 2523.28418, -1721.70410, 13.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2538.34302, -1720.42529, 13.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2523.60767, -1708.45630, 13.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3461, 2538.96216, -1705.66003, 13.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(933, 2532.13379, -1716.45642, 12.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(939, 2503.16602, -1710.36755, 14.97290,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19820, 2527.07373, -1708.12207, 12.41000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19820, 2526.68140, -1707.80603, 12.41000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19820, 2513.13989, -1714.53931, 17.56000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19820, 2513.48486, -1723.08594, 17.56000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19820, 2504.56787, -1720.93518, 17.56000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18659, 2519.95508, -1715.12512, 15.61720,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18659, 2526.45557, -1722.03723, 13.57120,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(18659, 2540.60327, -1708.06738, 13.57120,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1483, 2528.35083, -1708.27014, 15.61430,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1483, 2519.51685, -1708.63232, 15.61430,   0.00000, 0.00000, -90.00000);
	CreateDynamicObject(1728, 2518.63257, -1708.17737, 12.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(933, 2538.24609, -1712.71997, 12.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(933, 2525.18018, -1719.55237, 12.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1810, 2526.01636, -1718.19470, 12.46000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1810, 2524.01978, -1720.69800, 12.46000,   0.00000, 0.00000, 135.00000);
	CreateDynamicObject(1810, 2531.27075, -1717.61694, 12.46000,   0.00000, 0.00000, -171.00000);
	CreateDynamicObject(1810, 2533.53687, -1715.78088, 12.46000,   0.00000, 0.00000, -25.00000);
	CreateDynamicObject(1810, 2538.73340, -1711.22522, 12.46000,   0.00000, 0.00000, -25.00000);
	CreateDynamicObject(1810, 2537.39551, -1713.66760, 12.46000,   0.00000, 0.00000, 156.00000);
	CreateDynamicObject(1670, 2525.37231, -1718.93237, 13.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1670, 2525.01978, -1720.04626, 13.50000,   0.00000, 0.00000, -229.00000);
	CreateDynamicObject(1670, 2531.51514, -1716.52686, 13.50000,   0.00000, 0.00000, -229.00000);
	CreateDynamicObject(1670, 2532.09326, -1715.56580, 13.50000,   0.00000, 0.00000, -18.00000);
	CreateDynamicObject(1670, 2538.34839, -1712.28662, 13.50000,   0.00000, 0.00000, -18.00000);
	CreateDynamicObject(1670, 2538.28174, -1713.20142, 13.50000,   0.00000, 0.00000, -156.00000);
	CreateDynamicObject(1810, 2539.06641, -1713.67700, 12.46000,   0.00000, 0.00000, -149.00000);
	CreateDynamicObject(16151, 2520.74390, -1717.46387, 12.85000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1358, 2538.76172, -1716.93201, 13.70000,   0.00000, 0.00000, -62.00000);
	CreateDynamicObject(2671, 2526.99170, -1710.13647, 12.49000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2671, 2522.23218, -1708.86584, 12.47000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2671, 2515.16675, -1709.04639, 12.47000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2676, 2530.86157, -1715.00012, 12.69000,   0.00000, 0.00000, 47.00000);
	CreateDynamicObject(2676, 2538.80078, -1705.60071, 12.69000,   0.00000, 0.00000, -142.00000);
	CreateDynamicObject(2676, 2532.46875, -1707.67334, 12.69000,   0.00000, 0.00000, -142.00000);
	CreateDynamicObject(2676, 2536.96191, -1712.01990, 12.69000,   0.00000, 0.00000, 84.00000);
	CreateDynamicObject(19632, 2529.14673, -1709.94861, 12.48990,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1728, 2531.09448, -1709.44238, 12.40000,   0.00000, 0.00000, -120.00000);
	CreateDynamicObject(2676, 2521.25732, -1712.88843, 12.69000,   0.00000, 0.00000, -11.00000);
	CreateDynamicObject(11745, 2517.62622, -1708.22375, 12.60000,   0.00000, 0.00000, 0.00000);

		//rs
	CreateDynamicObject(1419, 1537.62366, -1679.53088, 13.03970,   180.00000, 0.00000, 90.00000);
	CreateDynamicObject(1419, 1537.59912, -1675.46118, 13.03970,   180.00000, 0.00000, 90.00000);
	CreateDynamicObject(1419, 1537.57520, -1665.61902, 13.03970,   180.00000, 0.00000, 90.00000);
	CreateDynamicObject(1419, 1537.56030, -1669.68970, 13.03970,   180.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1677.73499, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1684.65405, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1694.96460, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1705.16565, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1715.45374, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1664.17432, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1654.05176, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1643.82446, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(3578, 1529.63757, -1616.26465, 12.37360,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1215, 1529.60327, -1721.42468, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1529.76367, -1638.21460, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1529.71045, -1637.48694, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1529.57593, -1621.90723, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1529.61182, -1622.58081, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1537.27698, -1664.25854, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1534.54053, -1664.35779, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1534.53735, -1681.08838, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1537.19373, -1681.12842, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1529.59363, -1672.47412, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3379, 1529.57251, -1638.57593, 12.37053,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3379, 1529.61292, -1621.51257, 12.37050,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1216, 1535.44458, -1659.77466, 13.18160,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1216, 1535.49292, -1658.75354, 13.18160,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(19967, 1536.32202, -1681.18481, 12.37492,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1535.56689, -1681.09290, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19978, 1534.49390, -1680.78223, 12.37540,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19967, 1536.28040, -1664.50183, 180.37489,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19967, 1535.15112, -1664.16711, 12.37490,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1238, 1536.38562, -1664.01392, 12.68000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19984, 1529.64075, -1720.92358, 12.37517,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19984, 1529.55322, -1610.79651, 12.37640,   0.00000, 0.00000, 900.00000);
	CreateDynamicObject(3578, 1511.83154, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1501.74280, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1491.68298, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1476.64368, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1471.44543, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1461.65796, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1451.68616, -1732.25745, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3578, 1446.80896, -1732.25330, 12.37360,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19988, 1441.96387, -1732.25085, 12.37020,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19988, 1516.62354, -1732.26917, 12.36800,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1517.06885, -1727.09656, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1512.95142, -1727.09351, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1508.85962, -1727.09338, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1496.78772, -1727.08228, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1504.77673, -1727.06360, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1500.76965, -1727.07996, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1492.63037, -1727.08057, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1488.51782, -1727.09338, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1479.56177, -1727.06262, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1475.46021, -1727.06067, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1471.33362, -1727.05054, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1467.26099, -1727.03906, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1463.21948, -1727.05688, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1459.17139, -1727.06812, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1455.10315, -1727.06946, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1451.12695, -1727.08240, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1447.12183, -1727.09607, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1517.26135, -1732.28284, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1486.28809, -1732.21887, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1482.04175, -1732.23804, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1481.74451, -1727.00195, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1486.25647, -1727.02197, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1484.16541, -1727.10291, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1484.00757, -1732.31226, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1510.90491, -1737.69055, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1515.07532, -1737.65527, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1506.78638, -1737.70667, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1502.68127, -1737.70483, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1498.60693, -1737.70740, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1494.49756, -1737.72046, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1490.35388, -1737.71106, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1479.26379, -1737.72021, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1475.10254, -1737.72766, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1470.97534, -1737.74585, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1466.84387, -1737.76416, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1462.73535, -1737.77002, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1458.72534, -1737.79712, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1454.66418, -1737.81677, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1450.63135, -1737.81982, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1446.56958, -1737.80286, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1481.49939, -1737.68201, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1483.39368, -1737.66772, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1485.55420, -1737.72449, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1488.02966, -1737.73572, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1517.54175, -1737.67480, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1517.58997, -1739.15527, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1517.61499, -1740.90454, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1444.16626, -1737.82959, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1444.26758, -1739.30676, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1444.35339, -1740.86438, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1529.67664, -1669.49744, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1529.66101, -1670.96228, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1776, 1504.63477, -1710.80493, 14.00000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1775, 1504.68689, -1709.36743, 14.00000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1776, 1467.65002, -1711.10754, 14.00000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1775, 1467.82629, -1690.90625, 14.00000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1280, 1493.09912, -1724.31677, 12.87310,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1257, 1488.92969, -1724.79065, 13.80000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1257, 1474.17822, -1740.92834, 13.80000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1280, 1473.89697, -1724.05457, 12.89310,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1257, 1521.20715, -1675.78357, 13.80000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1257, 1521.25818, -1681.69446, 13.80000,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1257, 1538.10754, -1686.21863, 13.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1538.49329, -1658.92822, 13.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1508.60852, -1661.81104, 12.83550,   0.00000, 0.00000, 171.00000);
	CreateDynamicObject(1280, 1509.13489, -1658.60303, 12.83550,   0.00000, 0.00000, 171.00000);
	CreateDynamicObject(1280, 1510.67566, -1653.95142, 12.83550,   0.00000, 0.00000, 156.00000);
	CreateDynamicObject(1280, 1512.91272, -1650.09424, 12.83550,   0.00000, 0.00000, 142.00000);
	CreateDynamicObject(1594, 1513.78345, -1660.79968, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1594, 1517.16138, -1657.59485, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1594, 1517.99072, -1652.55493, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1594, 1520.25134, -1662.33240, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1518.22559, -1666.31921, 12.83550,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1280, 1518.25183, -1670.72058, 12.83550,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1594, 1520.33301, -1655.12842, 13.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1341, 1497.88965, -1722.15955, 13.51780,   0.00000, 0.00000, 265.00000);
	CreateDynamicObject(1594, 1510.46484, -1696.82605, 13.54000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1594, 1514.19067, -1696.66943, 13.52000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1341, 1512.82239, -1715.38770, 14.01780,   0.00000, 0.00000, -47.00000);
	CreateDynamicObject(1341, 1471.75256, -1717.23181, 14.03780,   0.00000, 0.00000, 309.00000);
	CreateDynamicObject(1340, 1519.59473, -1649.00745, 13.53750,   0.00000, 0.00000, 309.00000);
	CreateDynamicObject(19425, 1479.68420, -1733.93726, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1479.68933, -1737.10132, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1481.10974, -1733.85950, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1481.10864, -1736.99731, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1487.23047, -1730.75403, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1487.22961, -1727.61316, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1488.26978, -1730.69397, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1488.24976, -1727.55432, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19425, 1534.08252, -1684.42200, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1530.94348, -1684.45300, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1536.91272, -1699.90576, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1534.04260, -1639.58875, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1530.94360, -1639.62634, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1536.56409, -1654.01514, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1525.18420, -1621.02637, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1528.44409, -1621.03430, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1525.28162, -1667.62305, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1528.09583, -1667.63074, 12.36910,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19978, 1499.63293, -1737.49463, 12.37540,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19978, 1469.36206, -1737.50293, 12.37540,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19978, 1500.58398, -1727.15979, 12.37540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19978, 1467.66919, -1727.16296, 12.37540,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(11292, 1544.06128, -1720.49927, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1553.07300, -1720.46692, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1553.01917, -1716.33069, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1544.01770, -1716.34949, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1552.97034, -1724.56433, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1552.93518, -1725.80298, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1541.62903, -1722.27246, 13.12000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1545.83081, -1722.22876, 13.12000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1539.54895, -1720.19751, 13.12000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1575.47070, -1720.23376, 13.12000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1575.40125, -1716.01184, 13.12000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4639, 1549.28711, -1723.47607, 14.11890,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(11292, 1562.02759, -1716.47656, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1561.92944, -1720.50830, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1570.81384, -1720.51294, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1570.78699, -1716.37122, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1561.76538, -1724.42896, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1561.71838, -1725.79541, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1570.72498, -1724.43152, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1570.69446, -1725.77283, 11.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1346, 1515.14771, -1724.94592, 13.89640,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(19425, 1529.24878, -1739.13733, 12.36910,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1364, 1465.00000, 7769.00000, -1748.00000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1364, 1465.67175, -1749.42322, 15.18370,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1364, 1497.19006, -1749.52393, 15.18370,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1280, 1469.78613, -1741.49390, 12.89310,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1280, 1463.95947, -1741.66650, 12.89310,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1280, 1496.76282, -1741.78088, 12.89310,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(1280, 1503.02710, -1741.74365, 12.89310,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(19552, 1186.15186, -1325.55017, 12.15170,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1215.70654, -1360.86072, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.70752, -1356.74695, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.71338, -1364.98596, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72144, -1369.09094, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72595, -1373.16443, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.75171, -1377.24207, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.76074, -1381.34900, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1218.09375, -1385.38672, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1222.20837, -1385.39795, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1226.29480, -1385.40100, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1230.42249, -1385.40222, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1234.57190, -1385.40942, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1238.69751, -1385.41711, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1242.74854, -1385.42188, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1246.34277, -1383.08081, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.33679, -1378.98083, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.32263, -1374.86316, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.32410, -1370.76404, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.32751, -1366.64502, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.32214, -1362.51013, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.30200, -1358.39307, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.28162, -1354.26318, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.28027, -1350.15405, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.27063, -1346.01672, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.25317, -1341.93689, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.25635, -1337.93518, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.23975, -1333.95251, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.22803, -1329.93079, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.21313, -1325.81055, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.22424, -1321.68994, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.21240, -1317.57239, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.17468, -1313.44141, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.16760, -1309.31506, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.18054, -1305.18884, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.19592, -1301.06152, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.18982, -1296.96863, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1246.15869, -1292.83667, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1242.14648, -1290.42737, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1238.02466, -1290.47583, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1233.90662, -1290.48462, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1229.85815, -1290.48828, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1225.72241, -1290.48828, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1221.58521, -1290.47180, 13.07530,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1215.71973, -1293.14563, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.71973, -1352.66260, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72766, -1297.21741, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72314, -1301.33057, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72473, -1305.49207, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.71973, -1309.59070, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72876, -1313.61084, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.70422, -1317.75122, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.72009, -1321.90527, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(970, 1215.75146, -1326.04456, 13.07530,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(4639, 1217.73499, -1338.73535, 13.77860,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(968, 1216.44421, -1337.83496, 13.34480,   0.00000, 30.00000, 90.00000);
	CreateDynamicObject(968, 1216.33435, -1339.78906, 13.60480,   0.00000, 30.00000, 270.00000);
	CreateDynamicObject(1237, 1215.53845, -1328.66333, 12.55331,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1237, 1220.05933, -1339.32373, 12.11330,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1237, 1215.46863, -1349.83069, 12.55331,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1237, 1220.08960, -1338.19788, 12.11330,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1211.33032, -1368.50024, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1211.35938, -1360.73792, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1211.36230, -1321.33630, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1211.35278, -1309.25232, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1211.28833, -1297.22131, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1190.27808, -1378.18860, 13.63570,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1233, 1190.17932, -1323.07910, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1233, 1190.23877, -1308.03064, 13.63570,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1218.29724, -1290.40100, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1216.57556, -1290.43494, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1245.33997, -1290.29968, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1245.69934, -1385.57080, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1215.58472, -1384.70740, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1214.32935, -1350.01550, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1212.73669, -1351.01184, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1211.38696, -1352.08887, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1213.06799, -1338.68713, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1214.62537, -1328.49036, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1213.07751, -1327.84070, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1211.59912, -1326.64343, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1215.06311, -1357.12195, 13.75100,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1340, 1213.72864, -1315.57434, 13.53540,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1346, 1212.38135, -1306.14246, 13.90620,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1258, 1211.67224, -1309.70642, 13.05310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1258, 1211.55554, -1360.18677, 13.05310,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1215.37109, -1321.90027, 12.91710,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1215.33936, -1325.18237, 12.91710,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1215.45056, -1311.71375, 12.91710,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1257, 1186.81421, -1296.55554, 13.75100,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1280, 1186.29077, -1302.04163, 12.91710,   0.00000, 0.00000, 180.00000);
	CreateDynamicObject(1364, 1181.38684, -1315.01880, 13.31510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1364, 1181.34009, -1332.22595, 13.31510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1359, 1181.29895, -1312.47131, 13.21000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1359, 1181.02466, -1329.51465, 13.21000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1696, 1175.80774, -1324.17310, 13.37510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(1696, 1182.18591, -1324.17456, 12.17510,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(2687, 1171.78040, -1322.48389, 15.90570,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(7522, 1201.05859, -1374.22412, 18.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(7522, 1201.08997, -1374.21570, 10.48000,   0.00000, 180.00000, 180.00000);
	CreateDynamicObject(18284, 1242.22925, -1303.30713, 15.03790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18284, 1242.23438, -1332.88550, 15.03790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18284, 1242.25244, -1364.54797, 15.03790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18284, 1219.96338, -1364.60693, 15.03790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18284, 1219.51782, -1318.25891, 15.03790,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18452, 1184.66956, -1323.96863, 15.34780,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19367, 1184.84070, -1328.09082, 12.53440,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19367, 1184.83203, -1324.90369, 12.53440,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19367, 1184.82397, -1321.90173, 12.53440,   0.00000, 90.00000, 0.00000);
	CreateDynamicObject(19367, 1185.25122, -1319.49097, 12.53440,   0.00000, 90.00000, -20.00000);
	CreateDynamicObject(19367, 1186.46887, -1316.83105, 12.53440,   0.00000, 90.00000, -30.00000);
	CreateDynamicObject(19367, 1187.77747, -1314.51208, 12.49440,   -1.00000, 90.00000, -30.00000);
	CreateDynamicObject(19367, 1185.26697, -1330.49451, 12.53440,   0.00000, 90.00000, 20.00000);
	CreateDynamicObject(19367, 1186.17285, -1332.94031, 12.53440,   0.00000, 90.00000, 20.00000);
	CreateDynamicObject(19367, 1187.07080, -1335.34668, 12.53440,   0.00000, 90.00000, 20.00000);
	CreateDynamicObject(19367, 1188.02112, -1337.90540, 12.53440,   2.00000, 90.00000, 20.00000);
	CreateDynamicObject(1215, 1187.50122, -1324.90588, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1215, 1187.45154, -1322.96960, 13.14020,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(970, 1187.41614, -1331.49097, 13.07530,   0.00000, 0.00000, 112.14000);
	CreateDynamicObject(970, 1187.98389, -1318.95361, 13.07530,   0.00000, 0.00000, -107.00000);
	CreateDynamicObject(11455, 1201.07788, -1381.41040, 14.91430,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(11292, 1227.30200, -1293.05310, 13.49870,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1247, 1226.03528, -1294.65723, 14.10560,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1247, 1223.27686, -1294.66003, 14.10560,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1231.36914, -1295.34961, 12.46670,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1229.40320, -1295.42456, 12.46670,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1238, 1230.48999, -1295.38391, 12.46670,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1280, 1227.46887, -1295.25793, 12.42720,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(19866, 1216.57300, -1342.29150, 12.12650,   0.00000, -65.32000, 0.00000);
	CreateDynamicObject(19866, 1216.57422, -1347.18298, 12.12650,   0.00000, -65.32000, 0.00000);
	CreateDynamicObject(19866, 1216.65857, -1335.29297, 12.08650,   0.00000, -65.32000, 0.00000);
	CreateDynamicObject(19866, 1216.63550, -1330.39929, 12.08650,   0.00000, -65.32000, 0.00000);

	printf("[Object] Number of Dynamic objects loaded: %d", CountDynamicObjects());
	return 1;
}

public OnGameModeExit()
{
	new count = 0, count1 = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station] Number of Saved: %d", count);
	
	foreach(new pid : Plants)
	{
		if(Iter_Contains(Plants, pid))
		{
			count1++;
			Plant_Save(pid);
		}
	}
	printf("[Farmer Plant] Number of Saved: %d", count1);
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) 
	{
		if (IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	UnloadTazerSAPD();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
	return 1;
}

function SAGSLobbyDoorClose()
{
	MoveDynamicObject(SAGSLobbyDoor, 1389.375000, -25.387500, 999.978210, 3);
	return 1;
}

function SAPDLobbyDoorClose()
{
	MoveDynamicObject(SAPDLobbyDoor[0], 253.10965, 107.61060, 1002.21368, 3);
	MoveDynamicObject(SAPDLobbyDoor[1], 253.12556, 110.49657, 1002.21460, 3);
	MoveDynamicObject(SAPDLobbyDoor[2], 239.69435, 116.15908, 1002.21411, 3);
	MoveDynamicObject(SAPDLobbyDoor[3], 239.64050, 119.08750, 1002.21332, 3);
	return 1;
}

function LLFLobbyDoorClose()
{
	MoveDynamicObject(LLFLobbyDoor, -2119.21509, 657.54187, 1060.73560, 3);
	return 1;
}

public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0] || buttonid == SAGSLobbyBtn[1])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[0] || buttonid == SAPDLobbyBtn[1])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[0], 253.14204, 106.60210, 1002.21368, 3);
			MoveDynamicObject(SAPDLobbyDoor[1], 253.24377, 111.94370, 1002.21460, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[2] || buttonid == SAPDLobbyBtn[3])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[2], 239.52385, 114.75534, 1002.21411, 3);
			MoveDynamicObject(SAPDLobbyDoor[3], 239.71977, 120.21591, 1002.21332, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == LLFLobbyBtn[0] || buttonid == LLFLobbyBtn[1])
	{
		if(pData[playerid][pFamily] == 0)
		{
			MoveDynamicObject(LLFLobbyDoor, -2119.27148, 656.04028, 1060.73560, 3);
			SetTimer("LLFLobbyDoorClose", 5000, 0);
		}
		else
		{
			Error(playerid, "Access denied.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(!ispassenger)
	{
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAPD!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAGS!");
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SANEW!");
			}
		}
		if(GetVehicleModel(vehicleid) == 548 || GetVehicleModel(vehicleid) == 417 || GetVehicleModel(vehicleid) == 487 || GetVehicleModel(vehicleid) == 488 ||
		GetVehicleModel(vehicleid) == 497 || GetVehicleModel(vehicleid) == 563 || GetVehicleModel(vehicleid) == 469)
		{
			if(pData[playerid][pLevel] < 5)
			{
				RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Anda tidak memiliki izin!");
			}
		}
		/*foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) && pvData[pv][cLocked] == 1)
				{
					RemovePlayerFromVehicle(playerid);
					new Float:slx, Float:sly, Float:slz;
					GetPlayerPos(playerid, slx, sly, slz);
					SetPlayerPos(playerid, slx, sly, slz);
					Error(playerid, "This bike is locked by owner.");
				}
			}
		}*/
	}
	return 1;
}


/*public OnVehicleStreamIn(vehicleid, forplayerid)
{
	foreach(new pv : PVehicles)
	{
		if(vehicleid == pvData[pv][cVeh])
		{
			if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
			{
				if(pvData[pv][cLocked] == 1)
				{
					SetVehicleParamsForPlayer(vehicleid, forplayerid, 0, 1);
				}
			}
		}
	}
	return 1;
}*/

/*
public OnPlayerEnterKeypadArea(playerid, keypadid)
{
    ShowPlayerKeypad(playerid, keypadid);
    return 1;
}

public OnKeypadResponse(playerid, keypadid, bool:response, bool:success, code[])
{
    if(keypadid == SAGSLobbyKey[0])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
		if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
			if(success)
			{
				Info(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
			}
		}
	}
    if(keypadid == SAGSLobbyKey[1])
    {
        if(!response)
        {
            HidePlayerKeypad(playerid, keypadid);
            return 1;
        }
        if(response)
        {
            if(!success)
            {
                Error(playerid, "Wrong Code.");
            }
            if(success)
            {
                Info(playerid, "Welcome.");
				MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
				SetTimer("SAGSLobbyDoorClose", 5000, 0);
            }
        }
    }
    return 1;
} */

/*public OnPlayerActivateDoor(playerid, doorid)
{
	if(doorid == SAGSLobbyDoor)
	{
		if(pData[playerid][pFaction] != 2)
		{
			Error(playerid, "You dont have access!");
			return 1; // Cancels the door from being opened
		}
	}
	if(doorid == gMyDoor)
	{
		new bool:gIsDoorLocked = false;
		if(gIsDoorLocked == true)
		{
			SendClientMessage(playerid, -1, "Door is locked, can't open!");
			return 1; // Cancels the door from being opened
		}
	}
	return 1;
}

public OnButtonPress(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0])
	{
		Info(playerid, "Well done!");
	}
	if(buttonid == SAGSLobbyBtn[1])
	{
		Info(playerid, "Well done!");
	}
}*/

public OnPlayerText(playerid, text[])
{
	if(isnull(text)) return 0;
	printf("[CHAT] %s(%d) : %s", pData[playerid][pName], playerid, text);
	
	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s take the weapon off the belt and ready to shoot anytime.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s shocked after crash.", ReturnName(playerid));
		return 0;
	}
	if(text[0] == '!')
	{
		new tmp[512];
		if(text[1] == ' ')
		{
			format(tmp, sizeof(tmp), "%s", text[2]);
		}
		else
		{
			format(tmp, sizeof(tmp), "%s", text[1]);
		}
		if(pData[playerid][pAdminDuty] == 1)
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_RED, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
		else
		{
			if(strlen(tmp) > 64)
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %.64s ..", ReturnName(playerid), tmp);
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, ".. %s ))", tmp[64]);
				return 0;
			}
			else
			{
				SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: (( %s ))", ReturnName(playerid), tmp);
				return 0;
			}
		}
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "You dont have phone credits!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "You cant do at this time.");
				return 0;
			}
			new tmp[512];
			foreach(new ii : Player)
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[ii][pPhone] == pData[playerid][pSMS])
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
					{
						Error(playerid, "This number is not actived!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		// Anti-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		format(lstr, sizeof(lstr), "(cellphone) %s says: %s", ReturnName(playerid), text);
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		
		SendClientMessageEx(pData[playerid][pCall], COLOR_YELLOW, "[CELLPHONE] "WHITE_E"%s.", text);
		return 0;
	}
	else
	{
		// Anbi-Caps
		if(GetPVarType(playerid, "Caps"))
			UpperToLower(text);
		new lstr[1024];
		format(lstr, sizeof(lstr), "%s says: %s", ReturnName(playerid), text);
		ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		return 0;
	}
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        Error(playerid, "Unknow Command! /help for more info.");
        return 0;
    }
	printf("[CMD]: %s(%d) has used the command '%s' (%s)", pData[playerid][pName], playerid, cmd, params);
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	new PlayerIP[16];
	g_MysqlRaceCheck[playerid]++;
	ResetVariables(playerid);
	CreatePlayerTextDraws(playerid);
	//TextDrawShowForPlayer(playerid, TextDate);
	//TextDrawShowForPlayer(playerid, TextTime);
	for(new ns; ns < 3; ns++)
	{
		TextDrawShowForPlayer(playerid, NamaServer[ns]);
	}

	GetPlayerName(playerid, pData[playerid][pUCP], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	pData[playerid][pIP] = PlayerIP;
	
	SetTimerEx("SafeLogin", 1000, 0, "i", playerid);
	
	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `playerucp` WHERE `ucp` = '%e' LIMIT 1", pData[playerid][pUCP]);
	mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	SetPlayerColor(playerid, COLOR_WHITE);
	

	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 273.500000, 157.333541, 88.000000, 8.000000, 5930683, 100, 0);
	
	//HBE textdraw Modern
	pData[playerid][damagebar] = CreatePlayerProgressBar(playerid, 459.000000, 415.749938, 61.000000, 9.000000, 16711935, 1000.0, 0);
	pData[playerid][fuelbar] = CreatePlayerProgressBar(playerid, 459.500000, 432.083221, 61.000000, 9.000000, 16711935, 1000.0, 0);
                
	/*pData[playerid][hungrybar] = CreatePlayerProgressBar(playerid, 565.500000, 405.833404, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][energybar] = CreatePlayerProgressBar(playerid, 565.500000, 420.416717, 68.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][bladdybar] = CreatePlayerProgressBar(playerid, 565.500000, 435.000091, 68.000000, 8.000000, 16711935, 100.0, 0);
	*/
	//HBE textdraw Simple
	pData[playerid][spdamagebar] = CreatePlayerProgressBar(playerid, 565.500000, 383.666717, 51.000000, 7.000000, 16711935, 1000.0, 0);
	pData[playerid][spfuelbar] = CreatePlayerProgressBar(playerid, 566.000000, 398.250061, 51.000000, 7.000000, 16711935, 1000.0, 0);
                
	pData[playerid][sphungrybar] = CreatePlayerProgressBar(playerid, 467.500000, 433.833282, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spenergybar] = CreatePlayerProgressBar(playerid, 531.500000, 433.249938, 41.000000, 8.000000, 16711935, 100.0, 0);
	pData[playerid][spbladdybar] = CreatePlayerProgressBar(playerid, 595.500000, 433.250061, 41.000000, 8.000000, 16711935, 100.0, 0);

    	//rs
	RemoveBuildingForPlayer(playerid, 4138, 1536.1406, -1743.6875, 6.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1266, 1565.4141, -1722.3125, 25.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4030, 1536.1406, -1743.6875, 6.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1260, 1565.4141, -1722.3125, 25.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 1229, 1524.2188, -1693.9688, 14.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1571.6016, -1727.6563, 16.4219, 0.25);
	RemoveBuildingForPlayer(playerid, 5929, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1341.8516, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1328.0938, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 739, 1231.1406, -1356.2109, 12.7344, 0.25);
	RemoveBuildingForPlayer(playerid, 617, 1178.6016, -1332.0703, 12.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 618, 1177.7344, -1315.6641, 13.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1374.6094, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1356.5547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 1190.7734, -1320.8594, 15.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 5812, 1230.8906, -1337.9844, 12.5391, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1335.0547, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1317.7422, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1222.6641, -1300.9219, 12.2969, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1240.9219, -1300.9219, 12.2969, 0.25);
	
	//PlayAudioStreamForPlayer(playerid, "http://www.soi-rp.com/music/songs/LP-A_Light.mp3");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
    SetPlayerName(playerid, pData[playerid][pUCP]);
	//UpdateWeapons(playerid);
	g_MysqlRaceCheck[playerid]++;
	
	UpdatePlayerData(playerid);
	RemovePlayerVehicle(playerid);
	Report_Clear(playerid);
	Player_ResetMining(playerid);
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	Player_ResetHarvest(playerid);
	KillTazerTimer(playerid);
	
	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);
			
	if(IsValidDynamicObject(pData[playerid][pFlare]))
            DestroyDynamicObject(pData[playerid][pFlare]);

    pData[playerid][pAdoActive] = false;
	

	if (pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 40.0, x, y, z))
		{
			switch(reason)
			{
				case 0:
				{
					SendClientMessageEx(ii, COLOR_RED, "[SERVER]"YELLOW_E" %s(%d) has leave from the server.(timeout/crash)", pData[playerid][pName], playerid);
				}
				case 1:
				{
					SendClientMessageEx(ii, COLOR_RED, "[SERVER]"YELLOW_E" %s(%d) has leave from the server.(leaving)", pData[playerid][pName], playerid);
				}
				case 2:
				{
					SendClientMessageEx(ii, COLOR_RED, "[SERVER]"YELLOW_E" %s(%d) has leave from the server.(kicked/banned)", pData[playerid][pName], playerid);
				}
			}
		}
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
	//SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	//SpawnPlayer(playerid);
	/*new country[MAX_COUNTRY_LENGTH], city[MAX_CITY_LENGTH];
	GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	GetPlayerCity(playerid, city, MAX_CITY_LENGTH);*/
	
	foreach(new ii : Player)
	{
		if(pData[ii][pTogLog] == 0)
		{
			SendClientMessageEx(ii, COLOR_RED, "[SERVER]"YELLOW_E" %s(%d) has joined to the server.", pData[playerid][pName], playerid);
		}
	}

	StopAudioStreamForPlayer(playerid);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	
	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);
	return 1;
}

SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 0.0);
			SetPlayerPos(playerid, 1716.1129, -1880.0715, -10.0);
			SetPlayerCameraPos(playerid,1755.0413,-1824.8710,20.2100);
			SetPlayerCameraLookAt(playerid,1716.1129,-1880.0715,22.0264);
			SetPlayerVirtualWorld(playerid, 0);
			Dialog_Show(playerid, AgeScreen, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Enter", "Batal");
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
				ShowPlayerProgressBar(playerid, pData[playerid][sphungrybar]);
				ShowPlayerProgressBar(playerid, pData[playerid][spenergybar]);
				ShowPlayerProgressBar(playerid, pData[playerid][spbladdybar]);
				for(new txd = 12; txd > 11 && txd < 16; txd++)
				{
					TextDrawShowForPlayer(playerid, TDEditor_TD[txd]);
				}
			}
			if(pData[playerid][pHBEMode] == 2) //modern
			{
				for(new txd; txd < 21 ; txd++)
				{
				    TextDrawShowForPlayer(playerid, HBE[txd]);
				}
				for(new txdp; txdp < 8; txdp++)
				{
				    PlayerTextDrawShow(playerid, HBEP[txdp][playerid]);
				}
			}
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_RED);
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
		}
	}
}

function SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealth(playerid, pData[playerid][pHealth]);
	SetPlayerArmour(playerid, pData[playerid][pArmour]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	if(pData[playerid][pJail] > 0)
	{
		JailPlayer(playerid); 
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	return 1;
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == SpawnMale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	if(listid == SpawnFemale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	//Locker Faction Skin
	if(listid == SAPDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDWar)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	///Bisnis buy skin clothes
	if(listid == MaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == FemaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPMaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPFemaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == toyslist)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][1];
			
			GivePlayerMoneyEx(playerid, -price);
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			Dialog_Show(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	if(listid == viptoyslist)
	{
		if(response)
		{
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			Dialog_Show(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
			
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled toys");
	}
	return 1;
}

/*public OnPlayerRequestClass(playerid, classid)
{
	//SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
	return 1;
}
*/
public OnPlayerRequestSpawn(playerid)
{
	Error(playerid, "Jangan pernah tekan tombol spawn lagi!!");
	KickEx(playerid);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	pData[playerid][pSpawned] = 0;
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	Player_ResetMining(playerid);
	Player_ResetHarvest(playerid);
	
	pData[playerid][CarryProduct] = 0;
	
	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pCooking]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;
	
	pData[playerid][pMechDuty] = 0;
	pData[playerid][pTaxiDuty] = 0;
	pData[playerid][pMission] = -1;
	
	pData[playerid][pSideJob] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	foreach(new ii : Player)
    {
        if(pData[ii][pAdmin] > 0)
        {
            SendDeathMessageToPlayer(ii, killerid, playerid, reason);
        }
    }
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];
 
            GetWeaponName(weaponid, weaponname, sizeof(weaponname));
           
            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;
 
            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
 
            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);
           
            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;
			
			MySQL_SavePlayerToys(playerid);
		}
		else if(response == 0)
		{
			GameTextForPlayer(playerid, "~r~~h~Selection Cancelled~y~!", 4000, 5);

			SetPlayerAttachedObject(playerid,
				index,
				modelid,
				boneid,
				pToys[playerid][index][toy_x],
				pToys[playerid][index][toy_y],
				pToys[playerid][index][toy_z],
				pToys[playerid][index][toy_rx],
				pToys[playerid][index][toy_ry],
				pToys[playerid][index][toy_rz],
				pToys[playerid][index][toy_sx],
				pToys[playerid][index][toy_sy],
				pToys[playerid][index][toy_sz]);
		}
		SetPVarInt(playerid, "UpdatedToy", 1);
		TogglePlayerControllable(playerid, true);
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT: objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	if(pData[playerid][EditingTreeID] != -1 && Iter_Contains(Trees, pData[playerid][EditingTreeID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        TreeData[etid][treeX] = x;
	        TreeData[etid][treeY] = y;
	        TreeData[etid][treeZ] = z;
	        TreeData[etid][treeRX] = rx;
	        TreeData[etid][treeRY] = ry;
	        TreeData[etid][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_X, TreeData[etid][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Y, TreeData[etid][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Z, TreeData[etid][treeZ] + 1.5);

		    Tree_Save(etid);
	        pData[playerid][EditingTreeID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
	        pData[playerid][EditingTreeID] = -1;
	    }
	}
	if(pData[playerid][EditingOreID] != -1 && Iter_Contains(Ores, pData[playerid][EditingOreID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        OreData[etid][oreX] = x;
	        OreData[etid][oreY] = y;
	        OreData[etid][oreZ] = z;
	        OreData[etid][oreRX] = rx;
	        OreData[etid][oreRY] = ry;
	        OreData[etid][oreRZ] = rz;

	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_X, OreData[etid][oreX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Y, OreData[etid][oreY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Z, OreData[etid][oreZ] + 1.5);

		    Ore_Save(etid);
	        pData[playerid][EditingOreID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);
	        pData[playerid][EditingOreID] = -1;
	    }
	}
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_WHITE, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;
				
				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	if(checkpointid == pData[playerid][LoadingPoint])
	{
	    if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		return 1;
	}
	if(checkpointid == ShowRoomCP)
	{
		Dialog_Show(playerid, DIALOG_BUYPVCP, DIALOG_STYLE_LIST, "Showroom", "Bikes\nCars\nUnique Cars\nJob Cars", "Select", "Cancel");
	}
	if(checkpointid == ShowRoomCPRent)
	{
		new str[1024];
		format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days\n%s\t"LG_E"$500 / one days",
		GetVehicleModelName(414), 
		GetVehicleModelName(455), 
		GetVehicleModelName(456),
		GetVehicleModelName(498),
		GetVehicleModelName(499),
		GetVehicleModelName(609),
		GetVehicleModelName(478),
		GetVehicleModelName(422),
		GetVehicleModelName(543),
		GetVehicleModelName(554),
		GetVehicleModelName(525),
		GetVehicleModelName(438),
		GetVehicleModelName(420)
		);
		
		Dialog_Show(playerid, DIALOG_RENT_JOBCARS, DIALOG_STYLE_LIST, "Rent Job Cars", str, "Rent", "Close");
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(pData[playerid][pTrackCar] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan bisnis anda!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "/buy , /gps(My Mission) , /storeproduct.");
	}
	if(pData[playerid][pHauling] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		Info(playerid, "/buy , /gps(My Hauling) , /storegas.");
	}
	DisablePlayerRaceCheckpoint(playerid);
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	if(pData[playerid][CarryingLog] != -1)
	{
		if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pData[playerid][pFindEms] != INVALID_PLAYER_ID)
	{
		pData[playerid][pFindEms] = INVALID_PLAYER_ID;
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pSideJob] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 574)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint1))
			{
				SetPlayerCheckpoint(playerid, sweperpoint2, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint2))
			{
				SetPlayerCheckpoint(playerid, sweperpoint3, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint3))
			{
				SetPlayerCheckpoint(playerid, sweperpoint4, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint4))
			{
				SetPlayerCheckpoint(playerid, sweperpoint5, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint5))
			{
				SetPlayerCheckpoint(playerid, sweperpoint6, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint6))
			{
				SetPlayerCheckpoint(playerid, sweperpoint7, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint7))
			{
				SetPlayerCheckpoint(playerid, sweperpoint8, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint8))
			{
				SetPlayerCheckpoint(playerid, sweperpoint9, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint9))
			{
				SetPlayerCheckpoint(playerid, sweperpoint10, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint10))
			{
				SetPlayerCheckpoint(playerid, sweperpoint11, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint11))
			{
				SetPlayerCheckpoint(playerid, sweperpoint12, 7.0);
				//GameTextForPlayer(playerid, "~g~Bersih!", 1000, 3);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint12))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 600;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Sweeper)", 150);
				Info(playerid, "Sidejob(Sweeper) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint1))
			{
				SetPlayerCheckpoint(playerid, buspoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint2))
			{
				SetPlayerCheckpoint(playerid, buspoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint3))
			{
				SetPlayerCheckpoint(playerid, buspoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint4))
			{
				SetPlayerCheckpoint(playerid, buspoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint5))
			{
				SetPlayerCheckpoint(playerid, buspoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint6))
			{
				SetPlayerCheckpoint(playerid, buspoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint7))
			{
				SetPlayerCheckpoint(playerid, buspoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint8))
			{
				SetPlayerCheckpoint(playerid, buspoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint9))
			{
				SetPlayerCheckpoint(playerid, buspoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint10))
			{
				SetPlayerCheckpoint(playerid, buspoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint11))
			{
				SetPlayerCheckpoint(playerid, buspoint12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint12))
			{
				SetPlayerCheckpoint(playerid, buspoint13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint13))
			{
				SetPlayerCheckpoint(playerid, buspoint14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint14))
			{
				SetPlayerCheckpoint(playerid, buspoint15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint15))
			{
				SetPlayerCheckpoint(playerid, buspoint16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint16))
			{
				SetPlayerCheckpoint(playerid, buspoint17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint17))
			{
				SetPlayerCheckpoint(playerid, buspoint18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint18))
			{
				SetPlayerCheckpoint(playerid, buspoint19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint19))
			{
				SetPlayerCheckpoint(playerid, buspoint20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint20))
			{
				SetPlayerCheckpoint(playerid, buspoint21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint21))
			{
				SetPlayerCheckpoint(playerid, buspoint22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint22))
			{
				SetPlayerCheckpoint(playerid, buspoint23, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint23))
			{
				SetPlayerCheckpoint(playerid, buspoint24, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint24))
			{
				SetPlayerCheckpoint(playerid, buspoint25, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint25))
			{
				SetPlayerCheckpoint(playerid, buspoint26, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint26))
			{
				SetPlayerCheckpoint(playerid, buspoint27, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspoint27))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 900;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus)", 200);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	//DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
		else if(pData[playerid][CarryingLog] == 0)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping metal ore.");
			DisablePlayerCheckpoint(playerid);
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping coal ore.");
			DisablePlayerCheckpoint(playerid);
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return Error(playerid, "This entrance is locked at the moment.");
					
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return Error(playerid, "This door only for family.");
				}
				
				if(dData[did][dVip] > pData[playerid][pVip])
					return Error(playerid, "Your VIP level not enough to enter this door.");
				
				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return Error(playerid, "Your admin level not enough to enter this door.");
					
				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
					
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPosition(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				
				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return Error(playerid, "This bisnis is locked!");
					
				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);
				
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			pData[playerid][pInBiz] = -1;
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");
				
				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);
			
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");
					
				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Recharge...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "You got tased for %d secounds!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	//Vehicle
	if((newkeys & KEY_YES ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "engine");
		}
	}
	if((newkeys & KEY_NO ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "lights");
		}
	}
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			Info(playerid, " Kamu terlalu banyak minum.");
	   	}
	   	else
	   	{
	   	//	pData[playerid][pBladder] -= 1;
		    pData[playerid][pEnergy] += 5;
		}
	}
	if(PRESSED( KEY_FIRE ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			foreach(new did : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
							return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

						if(dData[did][dLocked])
							return Error(playerid, "This entrance is locked at the moment.");
							
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
						if(dData[did][dFamily] > 0)
						{
							if(dData[did][dFamily] != pData[playerid][pFamily])
								return Error(playerid, "This door only for family.");
						}
						
						if(dData[did][dVip] > pData[playerid][pVip])
							return Error(playerid, "Your VIP level not enough to enter this door.");
						
						if(dData[did][dAdmin] > pData[playerid][pAdmin])
							return Error(playerid, "Your admin level not enough to enter this door.");
							
						if(strlen(dData[did][dPass]))
						{
							new params[256];
							if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
							if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");
							
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
						else
						{
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
					}
				}
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
					
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
						}
						pData[playerid][pInDoor] = -1;
						SetPlayerInterior(playerid, dData[did][dExtint]);
						SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, WorldWeather);
					}
				}
			}
		}
	}
	//if(IsKeyJustDown(KEY_CTRL_BACK,newkeys,oldkeys))
	if(PRESSED( KEY_CTRL_BACK ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0)
		{
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
    }
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {	
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 99999);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
		if(pData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid) 
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
	}
	if(oldstate == PLAYER_STATE_PASSENGER)
	{
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {	
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/
			
		PlayerTextDrawHide(playerid, DPvehname[playerid]);
        PlayerTextDrawHide(playerid, DPvehengine[playerid]);
        PlayerTextDrawHide(playerid, DPvehspeed[playerid]);
		
        TextDrawHideForPlayer(playerid, TDEditor_TD[5]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[6]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[7]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[8]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[9]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[10]);
		
		TextDrawHideForPlayer(playerid, TDEditor_TD[11]);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
		
		//HBE textdraw Simple
		PlayerTextDrawHide(playerid, SPvehname[playerid]);
        PlayerTextDrawHide(playerid, SPvehengine[playerid]);
        PlayerTextDrawHide(playerid, SPvehspeed[playerid]);
		
		TextDrawHideForPlayer(playerid, TDEditor_TD[16]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[17]);
		TextDrawHideForPlayer(playerid, TDEditor_TD[18]);
		
		if(pData[playerid][pTaxiDuty] == 1)
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "You are no longer on taxi duty!");
		}
		if(pData[playerid][pFare] == 1)
		{
			KillTimer(pData[playerid][pFareTimer]);
			Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
			pData[playerid][pFare] = 0;
			pData[playerid][pTotalFare] = 0;
		}
        
		HidePlayerProgressBar(playerid, pData[playerid][spfuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][spdamagebar]);
		
        HidePlayerProgressBar(playerid, pData[playerid][fuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][damagebar]);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
		/*if(IsSRV(vehicleid))
		{
			new tstr[128], price = GetVehicleCost(GetVehicleModel(vehicleid));
			format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleName(vehicleid), FormatMoney(price));
			Dialog_Show(playerid, DIALOG_BUYPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
		}
		else if(IsVSRV(vehicleid))
		{
			new tstr[128], price = GetVipVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pVip] == 0)
			{
				Error(playerid, "Kendaraan Khusus VIP Player.");
				RemovePlayerFromVehicle(playerid);
				//SetVehicleToRespawn(GetPlayerVehicleID(playerid));
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
			else
			{
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d Coin", GetVehicleName(vehicleid), price);
				Dialog_Show(playerid, DIALOG_BUYVIPPV, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
		}*/
		
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						Error(playerid, "This bike is locked by owner.");
						return 1;
					}
				}
			}
		}
		
		if(IsASweeperVeh(vehicleid))
		{
			Dialog_Show(playerid, DIALOG_SWEEPER, DIALOG_STYLE_MSGBOX, "Side Job - Sweeper", "Anda akan bekerja sebagai pembersih jalan?", "Start Job", "Close");
		}
		if(IsABusVeh(vehicleid))
		{
			Dialog_Show(playerid, DIALOG_BUS, DIALOG_STYLE_MSGBOX, "Side Job - Bus", "Anda akan bekerja sebagai pengangkut penumpang bus?", "Start Job", "Close");
		}
		
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
		if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
            Info(playerid, "Anda tidak memiliki surat izin mengemudi, berhati-hatilah.");
        }
		if(pData[playerid][pHBEMode] == 1)
		{
			TextDrawShowForPlayer(playerid, TDEditor_TD[16]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[17]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[18]);
			
			PlayerTextDrawShow(playerid, SPvehname[playerid]);
			PlayerTextDrawShow(playerid, SPvehengine[playerid]);
			PlayerTextDrawShow(playerid, SPvehspeed[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][spfuelbar]);
			ShowPlayerProgressBar(playerid, pData[playerid][spdamagebar]);
		}
		else if(pData[playerid][pHBEMode] == 2)
		{
			TextDrawShowForPlayer(playerid, TDEditor_TD[5]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[6]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[7]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[8]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[9]);
			TextDrawShowForPlayer(playerid, TDEditor_TD[10]);
			
			PlayerTextDrawShow(playerid, DPvehname[playerid]);
			PlayerTextDrawShow(playerid, DPvehengine[playerid]);
			PlayerTextDrawShow(playerid, DPvehspeed[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][fuelbar]);
			ShowPlayerProgressBar(playerid, pData[playerid][damagebar]);
		}
		else
		{
		
		}
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;
		
		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}
	return 1;
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{

	return 1;
}

public OnPlayerUpdate(playerid)
{
	//SAPD Tazer/Taser
	UpdateTazer(playerid);
	
	//SAPD Road Spike
	CheckPlayerInSpike(playerid);
	return 1;
}

task VehicleUpdate[40000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 15);

            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 200)
            {
               Info(GetVehicleDriver(i), "This vehicle is low on fuel. You must visit a fuel station!");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "NoHave");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[ii][cVeh])) DestroyVehicle(pvData[ii][cVeh]);
				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
	}
}

public OnVehicleSpawn(vehicleid)
{
	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh] && pvData[ii][cRent] == 0)
		{
			/*if(pvData[ii][cClaim] != 0)
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
				{
					Info(pid, "Anda masih memiliki claim kendaraan, silahkan ambil di city hall!");
				}
				if(IsValidVehicle(pvData[ii][cVeh]))
					DestroyVehicle(pvData[ii][cVeh]);
					
				return 1;
			}*/
			if(pvData[ii][cInsu] > 0)
    		{
				pvData[ii][cInsu]--;
				pvData[ii][cClaim] = 1;
				pvData[ii][cClaimTime] = gettime() + (1 * 86400);
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
            		Info(pid, "Kendaraan anda hancur dan anda masih memiliki insuransi, silahkan ambil di kantor sags setelah 24 jam.");
				}
				if(IsValidVehicle(pvData[ii][cVeh]))
					DestroyVehicle(pvData[ii][cVeh]);
				
				pvData[ii][cVeh] = 0;
			}
			else
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					if(IsValidVehicle(pvData[ii][cVeh]))
						DestroyVehicle(pvData[ii][cVeh]);
            		Info(pid, "Kendaraan anda hancur dan tidak memiliki insuransi.");
					Iter_SafeRemove(PVehicles, ii, ii);
				}
			}
		}
	}
	return 1;
}

ptask PlayerVehicleUpdate[200](playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{	
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 350.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				GameTextForPlayer(playerid, "~r~Totalled!", 2500, 3);
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
				new Float:fDamage, fFuel, color1, color2;
				new tstr[64];
				
				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);
				
				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 1000.0) fDamage = 1000.0;
				
				fFuel = GetVehicleFuel(vehicleid);
				
				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 1000) fFuel = 1000;
				
				if(!GetEngineStatus(vehicleid))
				{
					PlayerTextDrawSetString(playerid, SPvehengine[playerid], "~r~OFF");
				}
				else
				{
					PlayerTextDrawSetString(playerid, SPvehengine[playerid], "~g~ON");
				}

				SetPlayerProgressBarValue(playerid, pData[playerid][spfuelbar], fFuel);
				SetPlayerProgressBarValue(playerid, pData[playerid][spdamagebar], fDamage);

				format(tstr, sizeof(tstr), "%s", GetVehicleName(vehicleid));
				PlayerTextDrawSetString(playerid, SPvehname[playerid], tstr);

				format(tstr, sizeof(tstr), "%.0f Mph", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, SPvehspeed[playerid], tstr);
			}
			else if(pData[playerid][pHBEMode] == 2)
			{
				new Float:fDamage, fFuel, color1, color2;
				new tstr[64];
				
				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);
				
				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 1000.0) fDamage = 1000.0;
				
				fFuel = GetVehicleFuel(vehicleid);
				
				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 1000) fFuel = 1000;
				
				if(!GetEngineStatus(vehicleid))
				{
					PlayerTextDrawSetString(playerid, DPvehengine[playerid], "~r~OFF");
				}
				else
				{
					PlayerTextDrawSetString(playerid, DPvehengine[playerid], "~g~ON");
				}

				SetPlayerProgressBarValue(playerid, pData[playerid][fuelbar], fFuel);
				SetPlayerProgressBarValue(playerid, pData[playerid][damagebar], fDamage);

				format(tstr, sizeof(tstr), "%s", GetVehicleName(vehicleid));
				PlayerTextDrawSetString(playerid, DPvehname[playerid], tstr);

				format(tstr, sizeof(tstr), "%.0f Mph", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, DPvehspeed[playerid], tstr);
				
				/*if(GetVehicleModel(vehicleid) != GetPVarInt(playerid, "veh_model"))
				{
					PlayerTextDrawSetPreviewModel(playerid, DPvehmodel[playerid], GetVehicleModel(vehicleid));
					PlayerTextDrawSetPreviewVehCol(playerid, DPvehmodel[playerid], color1, color2);
					PlayerTextDrawShow(playerid, DPvehmodel[playerid]);
					SetPVarInt(playerid, "veh_model", GetVehicleModel(vehicleid));
				}*/
			}
			else
			{
			
			}
		}
	}
}

ptask PlayerUpdate[999](playerid)
{
	//Anti-Cheat Vehicle health hack
	for(new v, j = GetVehiclePoolSize(); v <= j; v++) if(GetVehicleModel(v))
    {
        new Float:health;
        GetVehicleHealth(v, health);
        if( (health > VehicleHealthSecurityData[v]) && VehicleHealthSecurity[v] == false)
        {
			if(GetPlayerVehicleID(playerid) == v)
			{
				new playerState = GetPlayerState(playerid);
				if(playerState == PLAYER_STATE_DRIVER)
				{
					SetValidVehicleHealth(v, VehicleHealthSecurityData[v]);
					SendClientMessageToAllEx(COLOR_RED, "Anti-Cheat: "GREY2_E"%s have been auto kicked for vehicle health hack!", pData[playerid][pName]);
					KickEx(playerid);
				}
			}
        }
        if(VehicleHealthSecurity[v] == true)
        {
            VehicleHealthSecurity[v] = false;
        }
        VehicleHealthSecurityData[v] = health;
    }
	//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
		//SendAdminMessage(COLOR_RED, "Possible money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid) - pData[playerid][pMoney]);
	}
	//Anti Armour Hacks
	new Float:A;
	GetPlayerArmour(playerid, A);
	if(A > 98)
	{
		SetPlayerArmourEx(playerid, 0);
		SendClientMessageToAllEx(COLOR_RED, "Anti-Cheat: "GREY2_E"%s(%i) has been auto kicked for armour hacks!", pData[playerid][pName], playerid);
		KickEx(playerid);
	}
	//Weapon AC
	if(pData[playerid][pSpawned] == 1)
    {
        if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
        {
            pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

            if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 40 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
            {
                SendAdminMessage(COLOR_RED, "%s(%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
                //SendClientMessageToAllEx(COLOR_RED, "BotCmd: %s was kicked by BOT. Reason: used weapon hacks (%s).", pData[playerid][pName], ReturnWeaponName(pData[playerid][pWeapon]));
                SetWeapons(playerid); //Reload old weapons
				//KickEx(playerid);
                //Log_Write("logs/cheat_log.txt", "[%s] %s has possibly used weapon hacks (%s).", ReturnDate(), pData[playerid][pName], ReturnWeaponName(pData[playerid][pWeapon]));
                //return 1;
            }
        }
    }
	//Weapon Atth
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 250)
	{
		static weaponid, ammo, objectslot, count, index;
 
		for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			index = weaponid - 22;
		   
			if (weaponid && ammo && !WeaponSettings[playerid][index][Hidden] && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
			{
				objectslot = GetWeaponObjectSlot(weaponid);
 
				if (GetPlayerWeapon(playerid) != weaponid)
					SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);
 
				else if (IsPlayerAttachedObjectSlotUsed(playerid, objectslot)) RemovePlayerAttachedObject(playerid, objectslot);
			}
		}
		for (new i = 4; i <= 8; i++) if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			count = 0;
 
			for (new j = 22; j <= 38; j++) if (PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == i)
				count++;
 
			if(!count) RemovePlayerAttachedObject(playerid, i);
		}
		WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
	}
	
	//Player Update Online Data
	//GetPlayerHealth(playerid, pData[playerid][pHealth]);
    //GetPlayerArmour(playerid, pData[playerid][pArmour]);
	
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
		if(pData[playerid][pStress] > 100)
		{
			pData[playerid][pStress] = 0;
		}
		if(pData[playerid][pStress] < 0)
		{
			pData[playerid][pStress] = 40;
		}
		
		/*if(pData[playerid][pHealth] > 100.0)
		{
			SetPlayerHealthEx(playerid, 100.0);
		}*/
	}
	if(pData[playerid][pHBEMode] == 1 && pData[playerid][IsLoggedIn] == true)
	{
		SetPlayerProgressBarValue(playerid, pData[playerid][sphungrybar], pData[playerid][pHunger]);
		SetPlayerProgressBarColour(playerid, pData[playerid][sphungrybar], ConvertHBEColor(pData[playerid][pHunger]));
		SetPlayerProgressBarValue(playerid, pData[playerid][spenergybar], pData[playerid][pEnergy]);
		SetPlayerProgressBarColour(playerid, pData[playerid][spenergybar], ConvertHBEColor(pData[playerid][pEnergy]));
		SetPlayerProgressBarValue(playerid, pData[playerid][spbladdybar], pData[playerid][pStress]);
		SetPlayerProgressBarColour(playerid, pData[playerid][spbladdybar], ConvertHBEColor(pData[playerid][pStress]));
	}
	else if(pData[playerid][pHBEMode] == 2 && pData[playerid][IsLoggedIn] == true)
	{
		new strings[256];
		
		format(strings, sizeof(strings), "%d", pData[playerid][pHunger]);
		PlayerTextDrawSetString(playerid, HBEP[4][playerid], strings);
		PlayerTextDrawShow(playerid, HBEP[4][playerid]);
		
		format(strings, sizeof(strings), "%d", pData[playerid][pEnergy]);
		PlayerTextDrawSetString(playerid, HBEP[5][playerid], strings);
		PlayerTextDrawShow(playerid, HBEP[7][playerid]);
		
		format(strings, sizeof(strings), "%d", pData[playerid][pStress]);
		PlayerTextDrawSetString(playerid, HBEP[6][playerid], strings);
		PlayerTextDrawShow(playerid, HBEP[6][playerid]);
		
		/*format(strings, sizeof(strings), "%d", pData[playerid][pBladder]);
		PlayerTextDrawSetString(playerid, HBEP[7][playerid], strings);
		PlayerTextDrawShow(playerid, HBE[7][playerid]);*/
		
		format(strings, sizeof(strings), "%d", GetPlayerPing(playerid));
		PlayerTextDrawSetString(playerid, HBEP[3][playerid], strings);
		PlayerTextDrawShow(playerid, HBEP[3][playerid]);
		
		format(strings, sizeof(strings), "%d", playerid);
		PlayerTextDrawSetString(playerid, HBEP[2][playerid], strings);
		PlayerTextDrawShow(playerid, HBEP[2][playerid]);
	}

	if(pData[playerid][pEnergy] < 65 && pData[playerid][pHunger] < 65)
	{
	
	}
	else if(pData[playerid][pEnergy] == 100 && pData[playerid][pHunger] == 100)
	{
		
	}
	
	if(pData[playerid][pHospital] == 1)
    {
		if(pData[playerid][pInjured] == 1)
		{
			SetPlayerPosition(playerid, -2028.32, -92.87, 1067.43, 275.78, 1);
		
			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, playerid + 100);

			SetPlayerCameraPos(playerid, -2024.67, -93.13, 1066.78);
			SetPlayerCameraLookAt(playerid, -2028.32, -92.87, 1067.43);
			ResetPlayerWeaponsEx(playerid);
			TogglePlayerControllable(playerid, 0);
			pData[playerid][pInjured] = 0;
		}
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        if(pData[playerid][pHospitalTime] >= 15)
        {
            pData[playerid][pHospitalTime] = 0;
            pData[playerid][pHospital] = 0;
			pData[playerid][pHunger] = 50;
			pData[playerid][pEnergy] = 50;
			pData[playerid][pStress] = 0;
			SetPlayerHealthEx(playerid, 50);
			pData[playerid][pSick] = 0;
			GivePlayerMoneyEx(playerid, -150);
			SetPlayerHealthEx(playerid, 50);

            for (new i; i < 20; i++)
            {
                SendClientMessage(playerid, -1, "");
            }

			SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, COLOR_WHITE, "Kamu telah keluar dari rumah sakit, kamu membayar $150 kerumah sakit.");
            SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
			
			SetPlayerPosition(playerid, 1182.8778, -1324.2023, 13.5784, 269.8747);

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
			ClearAnimations(playerid);
			pData[playerid][pSpawned] = 1;
			SetPVarInt(playerid, "GiveUptime", -1);
		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
		new mstr[64];
        format(mstr, sizeof(mstr), "/death for spawn to hospital");
		InfoTD_MSG(playerid, 1000, mstr);
		
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 100)
            {
                Info(playerid, "Now you can spawn, type '/death' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }
		
        ApplyAnimation(playerid, "CRACK", "null", 4.0, 0, 0, 0, 1, 0, 1);
        ApplyAnimation(playerid, "CRACK", "crckdeth4", 4.0, 0, 0, 0, 1, 0, 1);
        SetPlayerHealthEx(playerid, 99999);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 150)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 10)
            {
                //SetPlayerHealth(playerid, health - 10);
                Info(playerid, "Kamu mulai kehilangan kesadaran karena kelaparan.");
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 120)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 10)
            {
                //SetPlayerHealth(playerid, health - 10);
                Info(playerid, "Kamu sangat kehausan.");
          		//SetPlayerDrunkLevel(playerid, 7000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
        if(++ pData[playerid][pStressTime] >= 150)
        {
            if(pData[playerid][pStress] < 97)
            {
                pData[playerid][pStress]++;
            }
            else if(pData[playerid][pStress] >= 90)
            {
                //SetPlayerHealth(playerid, health - 10);
                Info(playerid, "Sepertinya kamu mengalami stress berat kami sarankan anda ke rumah sakit untuk membeli obat atau ke tempat healing.");
          		SetPlayerDrunkLevel(playerid, 2200);
            }
            pData[playerid][pStressTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 200)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
					SetPlayerDrunkLevel(playerid, 8000);
					ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
					Info(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter.");
					SetPlayerHealth(playerid, hp - 3);
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be unjail in ~w~%d ~b~~h~seconds.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1482.0356,-1724.5726,13.5469,750, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SendClientMessageToAllEx(COLOR_RED, "Server: "GREY2_E" %s(%d) have been un-jailed by the server. (times up)", pData[playerid][pName], playerid);
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be released in ~w~%d ~b~~h~seconds.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1526.69, -1678.05, 5.89, 267.76, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Info(playerid, "You have been auto release. (times up)");
		}
	}
}

