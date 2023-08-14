//------------[ Textdraw ]------------

//Pilih Spawn
new Text:PublicTD[17];
new Text:Box[5];
new Text:Spawn[4];

//HBE New
new Text:BAR[10];
new PlayerText:BARPERSEN[MAX_PLAYERS];
new PlayerText:PERSENBAR[MAX_PLAYERS];

//Info textdraw
new PlayerText:InfoTD[MAX_PLAYERS];
new Text:NamaServer[3];

//HBE textdraw Modern
new Text:TDEditor_TD[19];

new PlayerText:DPname[MAX_PLAYERS];
new PlayerText:DPmoney[MAX_PLAYERS];
new PlayerText:DPcoin[MAX_PLAYERS];

new PlayerText:DPvehname[MAX_PLAYERS];
new PlayerText:DPvehengine[MAX_PLAYERS];
new PlayerText:DPvehspeed[MAX_PLAYERS];
new Text:DPvehfare[MAX_PLAYERS];

//HBE textdraw Simple
new PlayerText:SPvehname[MAX_PLAYERS];
new PlayerText:SPvehengine[MAX_PLAYERS];
new PlayerText:SPvehspeed[MAX_PLAYERS];

new PlayerText:ActiveTD[MAX_PLAYERS];


CreatePlayerTextDraws(playerid)
{
	//HBE New
	PERSENBAR[playerid] = CreatePlayerTextDraw(playerid, 582.000000, 134.000000, "100");
	PlayerTextDrawFont(playerid, PERSENBAR[playerid], 3);
	PlayerTextDrawLetterSize(playerid, PERSENBAR[playerid], 0.229167, 0.950000);
	PlayerTextDrawTextSize(playerid, PERSENBAR[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, PERSENBAR[playerid], 1);
	PlayerTextDrawSetShadow(playerid, PERSENBAR[playerid], 0);
	PlayerTextDrawAlignment(playerid, PERSENBAR[playerid], 1);
	PlayerTextDrawColor(playerid, PERSENBAR[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, PERSENBAR[playerid], 255);
	PlayerTextDrawBoxColor(playerid, PERSENBAR[playerid], 50);
	PlayerTextDrawUseBox(playerid, PERSENBAR[playerid], 0);
	PlayerTextDrawSetProportional(playerid, PERSENBAR[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, PERSENBAR[playerid], 0);

	BARPERSEN[playerid] = CreatePlayerTextDraw(playerid, 581.000000, 109.000000, "100");
	PlayerTextDrawFont(playerid, BARPERSEN[playerid], 3);
	PlayerTextDrawLetterSize(playerid, BARPERSEN[playerid], 0.229167, 0.950000);
	PlayerTextDrawTextSize(playerid, BARPERSEN[playerid], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, BARPERSEN[playerid], 1);
	PlayerTextDrawSetShadow(playerid, BARPERSEN[playerid], 0);
	PlayerTextDrawAlignment(playerid, BARPERSEN[playerid], 1);
	PlayerTextDrawColor(playerid, BARPERSEN[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, BARPERSEN[playerid], 255);
	PlayerTextDrawBoxColor(playerid, BARPERSEN[playerid], 50);
	PlayerTextDrawUseBox(playerid, BARPERSEN[playerid], 0);
	PlayerTextDrawSetProportional(playerid, BARPERSEN[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, BARPERSEN[playerid], 0);

	//Info textdraw
	InfoTD[playerid] = CreatePlayerTextDraw(playerid, 148.888, 361.385, "Welcome!");
 	PlayerTextDrawLetterSize(playerid, InfoTD[playerid], 0.326, 1.654);
	PlayerTextDrawAlignment(playerid, InfoTD[playerid], 1);
	PlayerTextDrawColor(playerid, InfoTD[playerid], -1);
	PlayerTextDrawSetOutline(playerid, InfoTD[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, InfoTD[playerid], 0x000000FF);
	PlayerTextDrawFont(playerid, InfoTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, InfoTD[playerid], 1);
	
	ActiveTD[playerid] = CreatePlayerTextDraw(playerid, 274.000000, 176.583435, "Refulling...");
	PlayerTextDrawLetterSize(playerid, ActiveTD[playerid], 0.374000, 1.349166);
	PlayerTextDrawAlignment(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawColor(playerid, ActiveTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, ActiveTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, ActiveTD[playerid], 255);
	PlayerTextDrawFont(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawSetProportional(playerid, ActiveTD[playerid], 1);
	PlayerTextDrawSetShadow(playerid, ActiveTD[playerid], 0);
	
	//HBE Textdraw Modern
	DPname[playerid] = CreatePlayerTextDraw(playerid, 537.000000, 367.333251, "Dandy_Prasetyo");
	PlayerTextDrawLetterSize(playerid, DPname[playerid], 0.328999, 1.179998);
	PlayerTextDrawAlignment(playerid, DPname[playerid], 1);
	PlayerTextDrawColor(playerid, DPname[playerid], -1);
	PlayerTextDrawSetShadow(playerid, DPname[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPname[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPname[playerid], 255);
	PlayerTextDrawFont(playerid, DPname[playerid], 0);
	PlayerTextDrawSetProportional(playerid, DPname[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPname[playerid], 0);

	DPmoney[playerid] = CreatePlayerTextDraw(playerid, 535.000000, 381.916473, "$50.000");
	PlayerTextDrawLetterSize(playerid, DPmoney[playerid], 0.231499, 1.034165);
	PlayerTextDrawAlignment(playerid, DPmoney[playerid], 1);
	PlayerTextDrawColor(playerid, DPmoney[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, DPmoney[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPmoney[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPmoney[playerid], 255);
	PlayerTextDrawFont(playerid, DPmoney[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DPmoney[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPmoney[playerid], 0);

	DPcoin[playerid] = CreatePlayerTextDraw(playerid, 535.500000, 392.999877, "5000_Coin");
	PlayerTextDrawLetterSize(playerid, DPcoin[playerid], 0.246000, 0.952498);
	PlayerTextDrawAlignment(playerid, DPcoin[playerid], 1);
	PlayerTextDrawColor(playerid, DPcoin[playerid], -65281);
	PlayerTextDrawSetShadow(playerid, DPcoin[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPcoin[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPcoin[playerid], 255);
	PlayerTextDrawFont(playerid, DPcoin[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DPcoin[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPcoin[playerid], 0);

	DPvehname[playerid] = CreatePlayerTextDraw(playerid, 431.000000, 367.333312, "Turismo");
	PlayerTextDrawLetterSize(playerid, DPvehname[playerid], 0.299499, 1.121665);
	PlayerTextDrawAlignment(playerid, DPvehname[playerid], 1);
	PlayerTextDrawColor(playerid, DPvehname[playerid], -1);
	PlayerTextDrawSetShadow(playerid, DPvehname[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPvehname[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPvehname[playerid], 255);
	PlayerTextDrawFont(playerid, DPvehname[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DPvehname[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPvehname[playerid], 0);

	DPvehengine[playerid] = CreatePlayerTextDraw(playerid, 462.000000, 381.916778, "ON");
	PlayerTextDrawLetterSize(playerid, DPvehengine[playerid], 0.229000, 0.940832);
	PlayerTextDrawAlignment(playerid, DPvehengine[playerid], 1);
	PlayerTextDrawColor(playerid, DPvehengine[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, DPvehengine[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPvehengine[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPvehengine[playerid], 255);
	PlayerTextDrawFont(playerid, DPvehengine[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DPvehengine[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPvehengine[playerid], 0);

	DPvehspeed[playerid] = CreatePlayerTextDraw(playerid, 460.000000, 391.833312, "120_Mph");
	PlayerTextDrawLetterSize(playerid, DPvehspeed[playerid], 0.266999, 0.946666);
	PlayerTextDrawAlignment(playerid, DPvehspeed[playerid], 1);
	PlayerTextDrawColor(playerid, DPvehspeed[playerid], -1);
	PlayerTextDrawSetShadow(playerid, DPvehspeed[playerid], 0);
	PlayerTextDrawSetOutline(playerid, DPvehspeed[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, DPvehspeed[playerid], 255);
	PlayerTextDrawFont(playerid, DPvehspeed[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DPvehspeed[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DPvehspeed[playerid], 0);

	DPvehfare[playerid] = TextDrawCreate(462.000000, 401.166687, "$500.000");
	TextDrawLetterSize(DPvehfare[playerid], 0.216000, 0.952498);
	TextDrawAlignment(DPvehfare[playerid], 1);
	TextDrawColor(DPvehfare[playerid], 16711935);
	TextDrawSetShadow(DPvehfare[playerid], 0);
	TextDrawSetOutline(DPvehfare[playerid], 1);
	TextDrawBackgroundColor(DPvehfare[playerid], 255);
	TextDrawFont(DPvehfare[playerid], 1);
	TextDrawSetProportional(DPvehfare[playerid], 1);
	TextDrawSetShadow(DPvehfare[playerid], 0);

	//HBE textdraw Simple
	SPvehname[playerid] = CreatePlayerTextDraw(playerid, 540.000000, 366.749908, "Turismo");
	PlayerTextDrawLetterSize(playerid, SPvehname[playerid], 0.319000, 1.022498);
	PlayerTextDrawAlignment(playerid, SPvehname[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehname[playerid], -1);
	PlayerTextDrawSetShadow(playerid, SPvehname[playerid], 0);
	PlayerTextDrawSetOutline(playerid, SPvehname[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, SPvehname[playerid], 255);
	PlayerTextDrawFont(playerid, SPvehname[playerid], 1);
	PlayerTextDrawSetProportional(playerid, SPvehname[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SPvehname[playerid], 0);

	SPvehspeed[playerid] = CreatePlayerTextDraw(playerid, 538.000000, 412.833160, "250_Mph");
	PlayerTextDrawLetterSize(playerid, SPvehspeed[playerid], 0.275498, 1.244166);
	PlayerTextDrawAlignment(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehspeed[playerid], -1);
	PlayerTextDrawSetShadow(playerid, SPvehspeed[playerid], 0);
	PlayerTextDrawSetOutline(playerid, SPvehspeed[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, SPvehspeed[playerid], 255);
	PlayerTextDrawFont(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawSetProportional(playerid, SPvehspeed[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SPvehspeed[playerid], 0);

	SPvehengine[playerid] = CreatePlayerTextDraw(playerid, 611.500000, 414.000152, "ON");
	PlayerTextDrawLetterSize(playerid, SPvehengine[playerid], 0.280999, 1.104166);
	PlayerTextDrawAlignment(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawColor(playerid, SPvehengine[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, SPvehengine[playerid], 0);
	PlayerTextDrawSetOutline(playerid, SPvehengine[playerid], 2);
	PlayerTextDrawBackgroundColor(playerid, SPvehengine[playerid], 255);
	PlayerTextDrawFont(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawSetProportional(playerid, SPvehengine[playerid], 1);
	PlayerTextDrawSetShadow(playerid, SPvehengine[playerid], 0);
}

CreateTextDraw()
{
	//HBE Modern New
	BAR[0] = TextDrawCreate( 553.000000, 103.000000, "ld_dual:white");
	TextDrawFont(BAR[0], 4);
	TextDrawLetterSize(BAR[0], 0.600000, 2.000000);
	TextDrawTextSize(BAR[0], 56.500000, 23.500000);
	TextDrawSetOutline(BAR[0], 1);
	TextDrawSetShadow(BAR[0], 0);
	TextDrawAlignment(BAR[0], 1);
	TextDrawColor(BAR[0], 255);
	TextDrawBackgroundColor(BAR[0], 255);
	TextDrawBoxColor(BAR[0], 50);
	TextDrawUseBox(BAR[0], 1);
	TextDrawSetProportional(BAR[0], 1);
	TextDrawSetSelectable(BAR[0], 0);

	BAR[1] = TextDrawCreate(554.000000, 105.000000, "ld_dual:white");
	TextDrawFont(BAR[1], 4);
	TextDrawLetterSize(BAR[1], 0.600000, 2.000000);
	TextDrawTextSize(BAR[1], 54.500000, 20.500000);
	TextDrawSetOutline(BAR[1], 1);
	TextDrawSetShadow(BAR[1], 0);
	TextDrawAlignment(BAR[1], 1);
	TextDrawColor(BAR[1], 1296911871);
	TextDrawBackgroundColor(BAR[1], 255);
	TextDrawBoxColor(BAR[1], 50);
	TextDrawUseBox(BAR[1], 1);
	TextDrawSetProportional(BAR[1], 1);
	TextDrawSetSelectable(BAR[1], 0);

	BAR[2] = TextDrawCreate(575.000000, 108.000000, "ld_dual:white");
	TextDrawFont(BAR[2], 4);
	TextDrawLetterSize(BAR[2], 0.600000, 2.000000);
	TextDrawTextSize(BAR[2], 30.000000, 13.000000);
	TextDrawSetOutline(BAR[2], 1);
	TextDrawSetShadow(BAR[2], 0);
	TextDrawAlignment(BAR[2], 1);
	TextDrawColor(BAR[2], -16776961);
	TextDrawBackgroundColor(BAR[2], 255);
	TextDrawBoxColor(BAR[2], 50);
	TextDrawUseBox(BAR[2], 1);
	TextDrawSetProportional(BAR[2], 1);
	TextDrawSetSelectable(BAR[2], 0);

	BAR[3] = TextDrawCreate(569.000000, 105.000000, "ld_dual:white");
	TextDrawFont(BAR[3], 4);
	TextDrawLetterSize(BAR[3], 0.600000, 2.000000);
	TextDrawTextSize(BAR[3], 1.500000, 20.500000);
	TextDrawSetOutline(BAR[3], 1);
	TextDrawSetShadow(BAR[3], 0);
	TextDrawAlignment(BAR[3], 1);
	TextDrawColor(BAR[3], 255);
	TextDrawBackgroundColor(BAR[3], 255);
	TextDrawBoxColor(BAR[3], 50);
	TextDrawUseBox(BAR[3], 1);
	TextDrawSetProportional(BAR[3], 1);
	TextDrawSetSelectable(BAR[3], 0);

	BAR[4] = TextDrawCreate(553.000000, 128.000000, "ld_dual:white");
	TextDrawFont(BAR[4], 4);
	TextDrawLetterSize(BAR[4], 0.600000, 2.000000);
	TextDrawTextSize(BAR[4], 56.500000, 23.500000);
	TextDrawSetOutline(BAR[4], 1);
	TextDrawSetShadow(BAR[4], 0);
	TextDrawAlignment(BAR[4], 1);
	TextDrawColor(BAR[4], 255);
	TextDrawBackgroundColor(BAR[4], 255);
	TextDrawBoxColor(BAR[4], 50);
	TextDrawUseBox(BAR[4], 1);
	TextDrawSetProportional(BAR[4], 1);
	TextDrawSetSelectable(BAR[4], 0);

	BAR[5] = TextDrawCreate(554.000000, 108.000000, "HUD:radar_dateDrink");
	TextDrawFont(BAR[5], 4);
	TextDrawLetterSize(BAR[5], 0.600000, 2.000000);
	TextDrawTextSize(BAR[5], 12.500000, 14.000000);
	TextDrawSetOutline(BAR[5], 1);
	TextDrawSetShadow(BAR[5], 0);
	TextDrawAlignment(BAR[5], 1);
	TextDrawColor(BAR[5], -1);
	TextDrawBackgroundColor(BAR[5], 255);
	TextDrawBoxColor(BAR[5], 50);
	TextDrawUseBox(BAR[5], 1);
	TextDrawSetProportional(BAR[5], 1);
	TextDrawSetSelectable(BAR[5], 0);

	BAR[6] = TextDrawCreate(554.000000, 130.000000, "ld_dual:white");
	TextDrawFont(BAR[6], 4);
	TextDrawLetterSize(BAR[6], 0.600000, 2.000000);
	TextDrawTextSize(BAR[6], 54.500000, 20.500000);
	TextDrawSetOutline(BAR[6], 1);
	TextDrawSetShadow(BAR[6], 0);
	TextDrawAlignment(BAR[6], 1);
	TextDrawColor(BAR[6], 1296911871);
	TextDrawBackgroundColor(BAR[6], 255);
	TextDrawBoxColor(BAR[6], 50);
	TextDrawUseBox(BAR[6], 1);
	TextDrawSetProportional(BAR[6], 1);
	TextDrawSetSelectable(BAR[6], 0);

	BAR[7] = TextDrawCreate(575.000000, 133.000000, "ld_dual:white");
	TextDrawFont(BAR[7], 4);
	TextDrawLetterSize(BAR[7], 0.600000, 2.000000);
	TextDrawTextSize(BAR[7], 30.000000, 13.000000);
	TextDrawSetOutline(BAR[7], 1);
	TextDrawSetShadow(BAR[7], 0);
	TextDrawAlignment(BAR[7], 1);
	TextDrawColor(BAR[7], 9145343);
	TextDrawBackgroundColor(BAR[7], 255);
	TextDrawBoxColor(BAR[7], 50);
	TextDrawUseBox(BAR[7], 1);
	TextDrawSetProportional(BAR[7], 1);
	TextDrawSetSelectable(BAR[7], 0);

	BAR[8] = TextDrawCreate(555.000000, 132.000000, "HUD:radar_diner");
	TextDrawFont(BAR[8], 4);
	TextDrawLetterSize(BAR[8], 0.600000, 2.000000);
	TextDrawTextSize(BAR[8], 12.500000, 14.000000);
	TextDrawSetOutline(BAR[8], 1);
	TextDrawSetShadow(BAR[8], 0);
	TextDrawAlignment(BAR[8], 1);
	TextDrawColor(BAR[8], -1);
	TextDrawBackgroundColor(BAR[8], 255);
	TextDrawBoxColor(BAR[8], 50);
	TextDrawUseBox(BAR[8], 1);
	TextDrawSetProportional(BAR[8], 1);
	TextDrawSetSelectable(BAR[8], 0);

	BAR[9] = TextDrawCreate(569.000000, 130.000000, "ld_dual:white");
	TextDrawFont(BAR[9], 4);
	TextDrawLetterSize(BAR[9], 0.600000, 2.000000);
	TextDrawTextSize(BAR[9], 1.500000, 20.500000);
	TextDrawSetOutline(BAR[9], 1);
	TextDrawSetShadow(BAR[9], 0);
	TextDrawAlignment(BAR[9], 1);
	TextDrawColor(BAR[9], 255);
	TextDrawBackgroundColor(BAR[9], 255);
	TextDrawBoxColor(BAR[9], 50);
	TextDrawUseBox(BAR[9], 1);
	TextDrawSetProportional(BAR[9], 1);
	TextDrawSetSelectable(BAR[9], 0);


	//Pilih Spawn
	PublicTD[0] = TextDrawCreate(167.000000, 164.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[0], 4);
	TextDrawLetterSize(PublicTD[0], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[0], 17.000000, 17.000000);
	TextDrawSetOutline(PublicTD[0], 1);
	TextDrawSetShadow(PublicTD[0], 0);
	TextDrawAlignment(PublicTD[0], 1);
	TextDrawColor(PublicTD[0], -1);
	TextDrawBackgroundColor(PublicTD[0], 255);
	TextDrawBoxColor(PublicTD[0], 50);
	TextDrawUseBox(PublicTD[0], 1);
	TextDrawSetProportional(PublicTD[0], 1);
	TextDrawSetSelectable(PublicTD[0], 0);

	PublicTD[1] = TextDrawCreate(79.000000, 164.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[1], 4);
	TextDrawLetterSize(PublicTD[1], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[1], 17.000000, 17.000000);
	TextDrawSetOutline(PublicTD[1], 1);
	TextDrawSetShadow(PublicTD[1], 0);
	TextDrawAlignment(PublicTD[1], 1);
	TextDrawColor(PublicTD[1], -1);
	TextDrawBackgroundColor(PublicTD[1], 255);
	TextDrawBoxColor(PublicTD[1], 50);
	TextDrawUseBox(PublicTD[1], 1);
	TextDrawSetProportional(PublicTD[1], 1);
	TextDrawSetSelectable(PublicTD[1], 0);

	PublicTD[2] = TextDrawCreate(79.000000, 300.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[2], 4);
	TextDrawLetterSize(PublicTD[2], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[2], 17.000000, 17.000000);
	TextDrawSetOutline(PublicTD[2], 1);
	TextDrawSetShadow(PublicTD[2], 0);
	TextDrawAlignment(PublicTD[2], 1);
	TextDrawColor(PublicTD[2], -1);
	TextDrawBackgroundColor(PublicTD[2], 255);
	TextDrawBoxColor(PublicTD[2], 50);
	TextDrawUseBox(PublicTD[2], 1);
	TextDrawSetProportional(PublicTD[2], 1);
	TextDrawSetSelectable(PublicTD[2], 0);

	PublicTD[3] = TextDrawCreate(167.000000, 300.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[3], 4);
	TextDrawLetterSize(PublicTD[3], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[3], 17.000000, 17.000000);
	TextDrawSetOutline(PublicTD[3], 1);
	TextDrawSetShadow(PublicTD[3], 0);
	TextDrawAlignment(PublicTD[3], 1);
	TextDrawColor(PublicTD[3], -1);
	TextDrawBackgroundColor(PublicTD[3], 255);
	TextDrawBoxColor(PublicTD[3], 50);
	TextDrawUseBox(PublicTD[3], 1);
	TextDrawSetProportional(PublicTD[3], 1);
	TextDrawSetSelectable(PublicTD[3], 0);

	PublicTD[4] = TextDrawCreate(82.000000, 176.000000, "_");
	TextDrawFont(PublicTD[4], 1);
	TextDrawLetterSize(PublicTD[4], 0.600000, 14.400017);
	TextDrawTextSize(PublicTD[4], 298.500000, 1.500000);
	TextDrawSetOutline(PublicTD[4], 1);
	TextDrawSetShadow(PublicTD[4], 0);
	TextDrawAlignment(PublicTD[4], 2);
	TextDrawColor(PublicTD[4], -1);
	TextDrawBackgroundColor(PublicTD[4], 255);
	TextDrawBoxColor(PublicTD[4], -3841);
	TextDrawUseBox(PublicTD[4], 1);
	TextDrawSetProportional(PublicTD[4], 1);
	TextDrawSetSelectable(PublicTD[4], 0);

	PublicTD[5] = TextDrawCreate(181.000000, 176.000000, "_");
	TextDrawFont(PublicTD[5], 1);
	TextDrawLetterSize(PublicTD[5], 0.600000, 14.100016);
	TextDrawTextSize(PublicTD[5], 298.500000, 1.500000);
	TextDrawSetOutline(PublicTD[5], 1);
	TextDrawSetShadow(PublicTD[5], 0);
	TextDrawAlignment(PublicTD[5], 2);
	TextDrawColor(PublicTD[5], -1);
	TextDrawBackgroundColor(PublicTD[5], 255);
	TextDrawBoxColor(PublicTD[5], -3841);
	TextDrawUseBox(PublicTD[5], 1);
	TextDrawSetProportional(PublicTD[5], 1);
	TextDrawSetSelectable(PublicTD[5], 0);

	PublicTD[6] = TextDrawCreate(132.000000, 166.500000, "_");
	TextDrawFont(PublicTD[6], 1);
	TextDrawLetterSize(PublicTD[6], 0.600000, 0.250001);
	TextDrawTextSize(PublicTD[6], 298.500000, 85.500000);
	TextDrawSetOutline(PublicTD[6], 1);
	TextDrawSetShadow(PublicTD[6], 0);
	TextDrawAlignment(PublicTD[6], 2);
	TextDrawColor(PublicTD[6], -1);
	TextDrawBackgroundColor(PublicTD[6], 255);
	TextDrawBoxColor(PublicTD[6], -3841);
	TextDrawUseBox(PublicTD[6], 1);
	TextDrawSetProportional(PublicTD[6], 1);
	TextDrawSetSelectable(PublicTD[6], 0);

	PublicTD[7] = TextDrawCreate(132.000000, 312.000000, "_");
	TextDrawFont(PublicTD[7], 1);
	TextDrawLetterSize(PublicTD[7], 0.600000, 0.250001);
	TextDrawTextSize(PublicTD[7], 298.500000, 85.500000);
	TextDrawSetOutline(PublicTD[7], 1);
	TextDrawSetShadow(PublicTD[7], 0);
	TextDrawAlignment(PublicTD[7], 2);
	TextDrawColor(PublicTD[7], -1);
	TextDrawBackgroundColor(PublicTD[7], 255);
	TextDrawBoxColor(PublicTD[7], -3841);
	TextDrawUseBox(PublicTD[7], 1);
	TextDrawSetProportional(PublicTD[7], 1);
	TextDrawSetSelectable(PublicTD[7], 0);

	Box[0] = TextDrawCreate(131.000000, 169.000000, "_");
	TextDrawFont(Box[0], 1);
	TextDrawLetterSize(Box[0], 0.658333, 15.500021);
	TextDrawTextSize(Box[0], 299.500000, 92.000000);
	TextDrawSetOutline(Box[0], 1);
	TextDrawSetShadow(Box[0], 0);
	TextDrawAlignment(Box[0], 2);
	TextDrawColor(Box[0], -1);
	TextDrawBackgroundColor(Box[0], 255);
	TextDrawBoxColor(Box[0], -3841);
	TextDrawUseBox(Box[0], 1);
	TextDrawSetProportional(Box[0], 1);
	TextDrawSetSelectable(Box[0], 0);

	PublicTD[8] = TextDrawCreate(153.000000, 191.500000, "ld_pool:ball");
	TextDrawFont(PublicTD[8], 4);
	TextDrawLetterSize(PublicTD[8], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[8], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[8], 0);
	TextDrawSetShadow(PublicTD[8], 0);
	TextDrawAlignment(PublicTD[8], 1);
	TextDrawColor(PublicTD[8], 1296911871);
	TextDrawBackgroundColor(PublicTD[8], 255);
	TextDrawBoxColor(PublicTD[8], 1296911666);
	TextDrawUseBox(PublicTD[8], 1);
	TextDrawSetProportional(PublicTD[8], 1);
	TextDrawSetSelectable(PublicTD[8], 0);

	PublicTD[9] = TextDrawCreate(90.000000, 191.500000, "ld_pool:ball");
	TextDrawFont(PublicTD[9], 4);
	TextDrawLetterSize(PublicTD[9], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[9], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[9], 0);
	TextDrawSetShadow(PublicTD[9], 0);
	TextDrawAlignment(PublicTD[9], 1);
	TextDrawColor(PublicTD[9], 1296911871);
	TextDrawBackgroundColor(PublicTD[9], 255);
	TextDrawBoxColor(PublicTD[9], 1296911666);
	TextDrawUseBox(PublicTD[9], 1);
	TextDrawSetProportional(PublicTD[9], 1);
	TextDrawSetSelectable(PublicTD[9], 0);

	PublicTD[10] = TextDrawCreate(90.000000, 221.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[10], 4);
	TextDrawLetterSize(PublicTD[10], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[10], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[10], 0);
	TextDrawSetShadow(PublicTD[10], 0);
	TextDrawAlignment(PublicTD[10], 1);
	TextDrawColor(PublicTD[10], 1296911871);
	TextDrawBackgroundColor(PublicTD[10], 255);
	TextDrawBoxColor(PublicTD[10], 1296911666);
	TextDrawUseBox(PublicTD[10], 1);
	TextDrawSetProportional(PublicTD[10], 1);
	TextDrawSetSelectable(PublicTD[10], 0);

	PublicTD[11] = TextDrawCreate(153.000000, 221.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[11], 4);
	TextDrawLetterSize(PublicTD[11], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[11], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[11], 0);
	TextDrawSetShadow(PublicTD[11], 0);
	TextDrawAlignment(PublicTD[11], 1);
	TextDrawColor(PublicTD[11], 1296911871);
	TextDrawBackgroundColor(PublicTD[11], 255);
	TextDrawBoxColor(PublicTD[11], 1296911666);
	TextDrawUseBox(PublicTD[11], 1);
	TextDrawSetProportional(PublicTD[11], 1);
	TextDrawSetSelectable(PublicTD[11], 0);

	PublicTD[12] = TextDrawCreate(90.000000, 251.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[12], 4);
	TextDrawLetterSize(PublicTD[12], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[12], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[12], 0);
	TextDrawSetShadow(PublicTD[12], 0);
	TextDrawAlignment(PublicTD[12], 1);
	TextDrawColor(PublicTD[12], 1296911871);
	TextDrawBackgroundColor(PublicTD[12], 255);
	TextDrawBoxColor(PublicTD[12], 1296911666);
	TextDrawUseBox(PublicTD[12], 1);
	TextDrawSetProportional(PublicTD[12], 1);
	TextDrawSetSelectable(PublicTD[12], 0);

	PublicTD[13] = TextDrawCreate(153.000000, 251.000000, "ld_pool:ball");
	TextDrawFont(PublicTD[13], 4);
	TextDrawLetterSize(PublicTD[13], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[13], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[13], 0);
	TextDrawSetShadow(PublicTD[13], 0);
	TextDrawAlignment(PublicTD[13], 1);
	TextDrawColor(PublicTD[13], 1296911871);
	TextDrawBackgroundColor(PublicTD[13], 255);
	TextDrawBoxColor(PublicTD[13], 1296911666);
	TextDrawUseBox(PublicTD[13], 1);
	TextDrawSetProportional(PublicTD[13], 1);
	TextDrawSetSelectable(PublicTD[13], 0);

	PublicTD[14] = TextDrawCreate(90.000000, 280.500000, "ld_pool:ball");
	TextDrawFont(PublicTD[14], 4);
	TextDrawLetterSize(PublicTD[14], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[14], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[14], 0);
	TextDrawSetShadow(PublicTD[14], 0);
	TextDrawAlignment(PublicTD[14], 1);
	TextDrawColor(PublicTD[14], 16711935);
	TextDrawBackgroundColor(PublicTD[14], 255);
	TextDrawBoxColor(PublicTD[14], 1296911666);
	TextDrawUseBox(PublicTD[14], 1);
	TextDrawSetProportional(PublicTD[14], 1);
	TextDrawSetSelectable(PublicTD[14], 0);

	PublicTD[15] = TextDrawCreate(153.000000, 280.500000, "ld_pool:ball");
	TextDrawFont(PublicTD[15], 4);
	TextDrawLetterSize(PublicTD[15], 0.600000, 2.000000);
	TextDrawTextSize(PublicTD[15], 17.000000, 25.200000);
	TextDrawSetOutline(PublicTD[15], 0);
	TextDrawSetShadow(PublicTD[15], 0);
	TextDrawAlignment(PublicTD[15], 1);
	TextDrawColor(PublicTD[15], 16711935);
	TextDrawBackgroundColor(PublicTD[15], 255);
	TextDrawBoxColor(PublicTD[15], 1296911666);
	TextDrawUseBox(PublicTD[15], 1);
	TextDrawSetProportional(PublicTD[15], 1);
	TextDrawSetSelectable(PublicTD[15], 0);

	PublicTD[16] = TextDrawCreate(90.000000, 172.000000, "Choose Your Spawn");
	TextDrawFont(PublicTD[16], 2);
	TextDrawLetterSize(PublicTD[16], 0.174999, 1.249999);
	TextDrawTextSize(PublicTD[16], 400.000000, 11.500000);
	TextDrawSetOutline(PublicTD[16], 1);
	TextDrawSetShadow(PublicTD[16], 1);
	TextDrawAlignment(PublicTD[16], 1);
	TextDrawColor(PublicTD[16], -1);
	TextDrawBackgroundColor(PublicTD[16], 255);
	TextDrawBoxColor(PublicTD[16], 50);
	TextDrawUseBox(PublicTD[16], 0);
	TextDrawSetProportional(PublicTD[16], 0);
	TextDrawSetSelectable(PublicTD[16], 0);

	Box[1] = TextDrawCreate(130.000000, 194.000000, "_");
	TextDrawFont(Box[1], 1);
	TextDrawLetterSize(Box[1], 0.600000, 2.200000);
	TextDrawTextSize(Box[1], 298.500000, 62.000000);
	TextDrawSetOutline(Box[1], 1);
	TextDrawSetShadow(Box[1], 0);
	TextDrawAlignment(Box[1], 2);
	TextDrawColor(Box[1], -1);
	TextDrawBackgroundColor(Box[1], 255);
	TextDrawBoxColor(Box[1], 1296911871);
	TextDrawUseBox(Box[1], 1);
	TextDrawSetProportional(Box[1], 1);
	TextDrawSetSelectable(Box[1], 0);

	Box[2] = TextDrawCreate(130.000000, 224.000000, "_");
	TextDrawFont(Box[2], 1);
	TextDrawLetterSize(Box[2], 0.600000, 2.200000);
	TextDrawTextSize(Box[2], 298.500000, 62.000000);
	TextDrawSetOutline(Box[2], 1);
	TextDrawSetShadow(Box[2], 0);
	TextDrawAlignment(Box[2], 2);
	TextDrawColor(Box[2], -1);
	TextDrawBackgroundColor(Box[2], 255);
	TextDrawBoxColor(Box[2], 1296911871);
	TextDrawUseBox(Box[2], 1);
	TextDrawSetProportional(Box[2], 1);
	TextDrawSetSelectable(Box[2], 0);


	Box[3] = TextDrawCreate(130.000000, 253.500000, "_");
	TextDrawFont(Box[3], 1);
	TextDrawLetterSize(Box[3], 0.600000, 2.200000);
	TextDrawTextSize(Box[3], 298.500000, 62.000000);
	TextDrawSetOutline(Box[3], 1);
	TextDrawSetShadow(Box[3], 0);
	TextDrawAlignment(Box[3], 2);
	TextDrawColor(Box[3], -1);
	TextDrawBackgroundColor(Box[3], 255);
	TextDrawBoxColor(Box[3], 1296911871);
	TextDrawUseBox(Box[3], 1);
	TextDrawSetProportional(Box[3], 1);
	TextDrawSetSelectable(Box[3], 0);

	Box[4] = TextDrawCreate(130.000000, 283.500000, "_");
	TextDrawFont(Box[4], 1);
	TextDrawLetterSize(Box[4], 0.600000, 2.200000);
	TextDrawTextSize(Box[4], 298.500000, 62.000000);
	TextDrawSetOutline(Box[4], 1);
	TextDrawSetShadow(Box[4], 0);
	TextDrawAlignment(Box[4], 2);
	TextDrawColor(Box[4], -1);
	TextDrawBackgroundColor(Box[4], 255);
	TextDrawBoxColor(Box[4], 16711935);
	TextDrawUseBox(Box[4], 1);
	TextDrawSetProportional(Box[4], 1);
	TextDrawSetSelectable(Box[4], 0);

	Spawn[0] = TextDrawCreate(111.000000, 197.000000, "Bandara");
	TextDrawFont(Spawn[0], 2);
	TextDrawLetterSize(Spawn[0], 0.174999, 1.249999);
	TextDrawTextSize(Spawn[0], 400.000000, 11.500000);
	TextDrawSetOutline(Spawn[0], 1);
	TextDrawSetShadow(Spawn[0], 1);
	TextDrawAlignment(Spawn[0], 1);
	TextDrawColor(Spawn[0], -1);
	TextDrawBackgroundColor(Spawn[0], 255);
	TextDrawBoxColor(Spawn[0], 50);
	TextDrawUseBox(Spawn[0], 0);
	TextDrawSetProportional(Spawn[0], 1);
	TextDrawSetSelectable(Spawn[0], 1);

	Spawn[1] = TextDrawCreate(113.000000, 226.000000, "Stasiun");
	TextDrawFont(Spawn[1], 2);
	TextDrawLetterSize(Spawn[1], 0.174999, 1.249999);
	TextDrawTextSize(Spawn[1], 400.000000, 11.500000);
	TextDrawSetOutline(Spawn[1], 1);
	TextDrawSetShadow(Spawn[1], 1);
	TextDrawAlignment(Spawn[1], 1);
	TextDrawColor(Spawn[1], -1);
	TextDrawBackgroundColor(Spawn[1], 255);
	TextDrawBoxColor(Spawn[1], 50);
	TextDrawUseBox(Spawn[1], 0);
	TextDrawSetProportional(Spawn[1], 1);
	TextDrawSetSelectable(Spawn[1], 1);

	Spawn[2] = TextDrawCreate(111.000000, 256.000000, "Last Exit");
	TextDrawFont(Spawn[2], 2);
	TextDrawLetterSize(Spawn[2], 0.174999, 1.249999);
	TextDrawTextSize(Spawn[2], 400.000000, 11.500000);
	TextDrawSetOutline(Spawn[2], 1);
	TextDrawSetShadow(Spawn[2], 1);
	TextDrawAlignment(Spawn[2], 1);
	TextDrawColor(Spawn[2], -1);
	TextDrawBackgroundColor(Spawn[2], 255);
	TextDrawBoxColor(Spawn[2], 50);
	TextDrawUseBox(Spawn[2], 0);
	TextDrawSetProportional(Spawn[2], 1);
	TextDrawSetSelectable(Spawn[2], 1);

	Spawn[3] = TextDrawCreate(118.000000, 286.000000, "SPAWN");
	TextDrawFont(Spawn[3], 2);
	TextDrawLetterSize(Spawn[3], 0.174999, 1.249999);
	TextDrawTextSize(Spawn[3], 400.000000, 11.500000);
	TextDrawSetOutline(Spawn[3], 1);
	TextDrawSetShadow(Spawn[3], 1);
	TextDrawAlignment(Spawn[3], 1);
	TextDrawColor(Spawn[3], -1);
	TextDrawBackgroundColor(Spawn[3], 255);
	TextDrawBoxColor(Spawn[3], 50);
	TextDrawUseBox(Spawn[3], 0);
	TextDrawSetProportional(Spawn[3], 1);
	TextDrawSetSelectable(Spawn[3], 1);
	//Nama Server
	NamaServer[0] = TextDrawCreate(214.000000, 4.000000, "CENTURY CITY");
	TextDrawFont(NamaServer[0], 1);
	TextDrawLetterSize(NamaServer[0], 0.304166, 0.950000);
	TextDrawTextSize(NamaServer[0], 400.000000, 17.000000);
	TextDrawSetOutline(NamaServer[0], 1);
	TextDrawSetShadow(NamaServer[0], 0);
	TextDrawAlignment(NamaServer[0], 1);
	TextDrawColor(NamaServer[0], 2094792959);
	TextDrawBackgroundColor(NamaServer[0], 255);
	TextDrawBoxColor(NamaServer[0], 50);
	TextDrawUseBox(NamaServer[0], 0);
	TextDrawSetProportional(NamaServer[0], 1);
	TextDrawSetSelectable(NamaServer[0], 0);

	NamaServer[1] = TextDrawCreate(290.500000, 4.000000, "-");
	TextDrawFont(NamaServer[1], 1);
	TextDrawLetterSize(NamaServer[1], 0.304166, 0.950000);
	TextDrawTextSize(NamaServer[1], 400.000000, 17.000000);
	TextDrawSetOutline(NamaServer[1], 1);
	TextDrawSetShadow(NamaServer[1], 0);
	TextDrawAlignment(NamaServer[1], 1);
	TextDrawColor(NamaServer[1], -1);
	TextDrawBackgroundColor(NamaServer[1], 255);
	TextDrawBoxColor(NamaServer[1], 50);
	TextDrawUseBox(NamaServer[1], 0);
	TextDrawSetProportional(NamaServer[1], 1);
	TextDrawSetSelectable(NamaServer[1], 0);

	NamaServer[2] = TextDrawCreate(300.000000, 4.000000, "Finally Here");
	TextDrawFont(NamaServer[2], 1);
	TextDrawLetterSize(NamaServer[2], 0.304166, 0.950000);
	TextDrawTextSize(NamaServer[2], 400.000000, 17.000000);
	TextDrawSetOutline(NamaServer[2], 1);
	TextDrawSetShadow(NamaServer[2], 0);
	TextDrawAlignment(NamaServer[2], 1);
	TextDrawColor(NamaServer[2], -1);
	TextDrawBackgroundColor(NamaServer[2], 255);
	TextDrawBoxColor(NamaServer[2], 50);
	TextDrawUseBox(NamaServer[2], 0);
	TextDrawSetProportional(NamaServer[2], 1);
	TextDrawSetSelectable(NamaServer[2], 0);


	//HBE textdraw Modern
	TDEditor_TD[0] = TextDrawCreate(531.000000, 365.583435, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[0], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[0], 164.000000, 109.000000);
	TextDrawAlignment(TDEditor_TD[0], 1);
	TextDrawColor(TDEditor_TD[0], 120);
	TextDrawSetShadow(TDEditor_TD[0], 0);
	TextDrawSetOutline(TDEditor_TD[0], 0);
	TextDrawBackgroundColor(TDEditor_TD[0], 255);
	TextDrawFont(TDEditor_TD[0], 4);
	TextDrawSetProportional(TDEditor_TD[0], 0);
	TextDrawSetShadow(TDEditor_TD[0], 0);

	TDEditor_TD[1] = TextDrawCreate(533.000000, 367.916778, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[1], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[1], 105.000000, 13.000000);
	TextDrawAlignment(TDEditor_TD[1], 1);
	TextDrawColor(TDEditor_TD[1], -16776961);
	TextDrawSetShadow(TDEditor_TD[1], 0);
	TextDrawSetOutline(TDEditor_TD[1], 0);
	TextDrawBackgroundColor(TDEditor_TD[1], 255);
	TextDrawFont(TDEditor_TD[1], 4);
	TextDrawSetProportional(TDEditor_TD[1], 0);
	TextDrawSetShadow(TDEditor_TD[1], 0);

	TDEditor_TD[2] = TextDrawCreate(543.500000, 399.416625, "");
	TextDrawLetterSize(TDEditor_TD[2], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[2], 15.000000, 20.000000);
	TextDrawAlignment(TDEditor_TD[2], 1);
	TextDrawColor(TDEditor_TD[2], -1);
	TextDrawSetShadow(TDEditor_TD[2], 0);
	TextDrawSetOutline(TDEditor_TD[2], 0);
	TextDrawBackgroundColor(TDEditor_TD[2], 0);
	TextDrawFont(TDEditor_TD[2], 5);
	TextDrawSetProportional(TDEditor_TD[2], 0);
	TextDrawSetShadow(TDEditor_TD[2], 0);
	TextDrawSetPreviewModel(TDEditor_TD[2], 2703);
	TextDrawSetPreviewRot(TDEditor_TD[2], 0.000000, 90.000000, 80.000000, 1.000000);

	TDEditor_TD[3] = TextDrawCreate(536.500000, 414.000030, "");
	TextDrawLetterSize(TDEditor_TD[3], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[3], 26.000000, 19.000000);
	TextDrawAlignment(TDEditor_TD[3], 1);
	TextDrawColor(TDEditor_TD[3], -1);
	TextDrawSetShadow(TDEditor_TD[3], 0);
	TextDrawSetOutline(TDEditor_TD[3], 0);
	TextDrawBackgroundColor(TDEditor_TD[3], 0);
	TextDrawFont(TDEditor_TD[3], 5);
	TextDrawSetProportional(TDEditor_TD[3], 0);
	TextDrawSetShadow(TDEditor_TD[3], 0);
	TextDrawSetPreviewModel(TDEditor_TD[3], 1546);
	TextDrawSetPreviewRot(TDEditor_TD[3], 0.000000, 0.000000, 200.000000, 1.000000);

	TDEditor_TD[4] = TextDrawCreate(543.000000, 428.000030, "");
	TextDrawLetterSize(TDEditor_TD[4], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[4], 17.000000, 17.000000);
	TextDrawAlignment(TDEditor_TD[4], 1);
	TextDrawColor(TDEditor_TD[4], -1);
	TextDrawSetShadow(TDEditor_TD[4], 0);
	TextDrawSetOutline(TDEditor_TD[4], 0);
	TextDrawBackgroundColor(TDEditor_TD[4], 0);
	TextDrawFont(TDEditor_TD[4], 5);
	TextDrawSetProportional(TDEditor_TD[4], 0);
	TextDrawSetShadow(TDEditor_TD[4], 0);
	TextDrawSetPreviewModel(TDEditor_TD[4], 2738);
	TextDrawSetPreviewRot(TDEditor_TD[4], 0.000000, 0.000000, 100.000000, 1.000000);

	TDEditor_TD[5] = TextDrawCreate(425.000000, 365.583557, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[5], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[5], 102.000000, 92.000000);
	TextDrawAlignment(TDEditor_TD[5], 1);
	TextDrawColor(TDEditor_TD[5], 120);
	TextDrawSetShadow(TDEditor_TD[5], 0);
	TextDrawSetOutline(TDEditor_TD[5], 0);
	TextDrawBackgroundColor(TDEditor_TD[5], 255);
	TextDrawFont(TDEditor_TD[5], 4);
	TextDrawSetProportional(TDEditor_TD[5], 0);
	TextDrawSetShadow(TDEditor_TD[5], 0);

	TDEditor_TD[6] = TextDrawCreate(428.000000, 367.916717, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[6], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[6], 97.000000, 11.000000);
	TextDrawAlignment(TDEditor_TD[6], 1);
	TextDrawColor(TDEditor_TD[6], -16776961);
	TextDrawSetShadow(TDEditor_TD[6], 0);
	TextDrawSetOutline(TDEditor_TD[6], 0);
	TextDrawBackgroundColor(TDEditor_TD[6], 255);
	TextDrawFont(TDEditor_TD[6], 4);
	TextDrawSetProportional(TDEditor_TD[6], 0);
	TextDrawSetShadow(TDEditor_TD[6], 0);

	TDEditor_TD[7] = TextDrawCreate(428.000000, 380.750030, "Engine:");
	TextDrawLetterSize(TDEditor_TD[7], 0.248998, 1.063333);
	TextDrawAlignment(TDEditor_TD[7], 1);
	TextDrawColor(TDEditor_TD[7], -1);
	TextDrawSetShadow(TDEditor_TD[7], 0);
	TextDrawSetOutline(TDEditor_TD[7], 1);
	TextDrawBackgroundColor(TDEditor_TD[7], 255);
	TextDrawFont(TDEditor_TD[7], 1);
	TextDrawSetProportional(TDEditor_TD[7], 1);
	TextDrawSetShadow(TDEditor_TD[7], 0);

	TDEditor_TD[8] = TextDrawCreate(428.000000, 389.499969, "Speed:");
	TextDrawLetterSize(TDEditor_TD[8], 0.266499, 1.191666);
	TextDrawAlignment(TDEditor_TD[8], 1);
	TextDrawColor(TDEditor_TD[8], -1);
	TextDrawSetShadow(TDEditor_TD[8], 0);
	TextDrawSetOutline(TDEditor_TD[8], 1);
	TextDrawBackgroundColor(TDEditor_TD[8], 255);
	TextDrawFont(TDEditor_TD[8], 1);
	TextDrawSetProportional(TDEditor_TD[8], 1);
	TextDrawSetShadow(TDEditor_TD[8], 0);

	TDEditor_TD[9] = TextDrawCreate(437.000000, 411.083343, "");
	TextDrawLetterSize(TDEditor_TD[9], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[9], 13.000000, 18.000000);
	TextDrawAlignment(TDEditor_TD[9], 1);
	TextDrawColor(TDEditor_TD[9], -1);
	TextDrawSetShadow(TDEditor_TD[9], 0);
	TextDrawSetOutline(TDEditor_TD[9], 0);
	TextDrawBackgroundColor(TDEditor_TD[9], 0);
	TextDrawFont(TDEditor_TD[9], 5);
	TextDrawSetProportional(TDEditor_TD[9], 0);
	TextDrawSetShadow(TDEditor_TD[9], 0);
	TextDrawSetPreviewModel(TDEditor_TD[9], 1240);
	TextDrawSetPreviewRot(TDEditor_TD[9], 0.000000, 0.000000, 0.000000, 1.000000);

	TDEditor_TD[10] = TextDrawCreate(434.500000, 425.666595, "");
	TextDrawLetterSize(TDEditor_TD[10], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[10], 20.000000, 21.000000);
	TextDrawAlignment(TDEditor_TD[10], 1);
	TextDrawColor(TDEditor_TD[10], -1);
	TextDrawSetShadow(TDEditor_TD[10], 0);
	TextDrawSetOutline(TDEditor_TD[10], 0);
	TextDrawBackgroundColor(TDEditor_TD[10], 0);
	TextDrawFont(TDEditor_TD[10], 5);
	TextDrawSetProportional(TDEditor_TD[10], 0);
	TextDrawSetShadow(TDEditor_TD[10], 0);
	TextDrawSetPreviewModel(TDEditor_TD[10], 1650);
	TextDrawSetPreviewRot(TDEditor_TD[10], 0.000000, 0.000000, 0.000000, 1.000000);
	
	TDEditor_TD[11] = TextDrawCreate(427.000000, 400.583374, "Fare:");
	TextDrawLetterSize(TDEditor_TD[11], 0.360498, 1.022500);
	TextDrawAlignment(TDEditor_TD[11], 1);
	TextDrawColor(TDEditor_TD[11], -1);
	TextDrawSetShadow(TDEditor_TD[11], 0);
	TextDrawSetOutline(TDEditor_TD[11], 1);
	TextDrawBackgroundColor(TDEditor_TD[11], 255);
	TextDrawFont(TDEditor_TD[11], 1);
	TextDrawSetProportional(TDEditor_TD[11], 1);
	TextDrawSetShadow(TDEditor_TD[11], 0);
	
	//HBE textdraw Simple
	TDEditor_TD[12] = TextDrawCreate(450.500000, 428.000091, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[12], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[12], 191.000000, 27.000000);
	TextDrawAlignment(TDEditor_TD[12], 1);
	TextDrawColor(TDEditor_TD[12], 175);
	TextDrawSetShadow(TDEditor_TD[12], 0);
	TextDrawSetOutline(TDEditor_TD[12], 0);
	TextDrawBackgroundColor(TDEditor_TD[12], 255);
	TextDrawFont(TDEditor_TD[12], 4);
	TextDrawSetProportional(TDEditor_TD[12], 0);
	TextDrawSetShadow(TDEditor_TD[12], 0);

	TDEditor_TD[13] = TextDrawCreate(450.000000, 422.166778, "");
	TextDrawLetterSize(TDEditor_TD[13], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[13], 17.000000, 34.000000);
	TextDrawAlignment(TDEditor_TD[13], 1);
	TextDrawColor(TDEditor_TD[13], -1);
	TextDrawSetShadow(TDEditor_TD[13], 0);
	TextDrawSetOutline(TDEditor_TD[13], 0);
	TextDrawBackgroundColor(TDEditor_TD[13], 0);
	TextDrawFont(TDEditor_TD[13], 5);
	TextDrawSetProportional(TDEditor_TD[13], 0);
	TextDrawSetShadow(TDEditor_TD[13], 0);
	TextDrawSetPreviewModel(TDEditor_TD[13], 2703);
	TextDrawSetPreviewRot(TDEditor_TD[13], 100.000000, 0.000000, -10.000000, 1.000000);

	TDEditor_TD[14] = TextDrawCreate(507.500000, 429.166748, "");
	TextDrawLetterSize(TDEditor_TD[14], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[14], 25.000000, 20.000000);
	TextDrawAlignment(TDEditor_TD[14], 1);
	TextDrawColor(TDEditor_TD[14], -1);
	TextDrawSetShadow(TDEditor_TD[14], 0);
	TextDrawSetOutline(TDEditor_TD[14], 0);
	TextDrawBackgroundColor(TDEditor_TD[14], 0);
	TextDrawFont(TDEditor_TD[14], 5);
	TextDrawSetProportional(TDEditor_TD[14], 0);
	TextDrawSetShadow(TDEditor_TD[14], 0);
	TextDrawSetPreviewModel(TDEditor_TD[14], 1546);
	TextDrawSetPreviewRot(TDEditor_TD[14], 0.000000, 0.000000, 100.000000, 1.000000);

	TDEditor_TD[15] = TextDrawCreate(574.500000, 427.999969, "");
	TextDrawLetterSize(TDEditor_TD[15], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[15], 20.000000, 19.000000);
	TextDrawAlignment(TDEditor_TD[15], 1);
	TextDrawColor(TDEditor_TD[15], -1);
	TextDrawSetShadow(TDEditor_TD[15], 0);
	TextDrawSetOutline(TDEditor_TD[15], 0);
	TextDrawBackgroundColor(TDEditor_TD[15], 0);
	TextDrawFont(TDEditor_TD[15], 5);
	TextDrawSetProportional(TDEditor_TD[15], 0);
	TextDrawSetShadow(TDEditor_TD[15], 0);
	TextDrawSetPreviewModel(TDEditor_TD[15], 2738);
	TextDrawSetPreviewRot(TDEditor_TD[15], 0.000000, 0.000000, 100.000000, 1.000000);

	TDEditor_TD[16] = TextDrawCreate(533.000000, 365.000061, "LD_SPAC:white");
	TextDrawLetterSize(TDEditor_TD[16], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[16], 105.000000, 62.000000);
	TextDrawAlignment(TDEditor_TD[16], 1);
	TextDrawColor(TDEditor_TD[16], 175);
	TextDrawSetShadow(TDEditor_TD[16], 0);
	TextDrawSetOutline(TDEditor_TD[16], 0);
	TextDrawBackgroundColor(TDEditor_TD[16], 255);
	TextDrawFont(TDEditor_TD[16], 4);
	TextDrawSetProportional(TDEditor_TD[16], 0);
	TextDrawSetShadow(TDEditor_TD[16], 0);

	TDEditor_TD[17] = TextDrawCreate(550.000000, 378.999938, "");
	TextDrawLetterSize(TDEditor_TD[17], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[17], 11.000000, 14.000000);
	TextDrawAlignment(TDEditor_TD[17], 1);
	TextDrawColor(TDEditor_TD[17], -1);
	TextDrawSetShadow(TDEditor_TD[17], 0);
	TextDrawSetOutline(TDEditor_TD[17], 0);
	TextDrawBackgroundColor(TDEditor_TD[17], 0);
	TextDrawFont(TDEditor_TD[17], 5);
	TextDrawSetProportional(TDEditor_TD[17], 0);
	TextDrawSetShadow(TDEditor_TD[17], 0);
	TextDrawSetPreviewModel(TDEditor_TD[17], 1240);
	TextDrawSetPreviewRot(TDEditor_TD[17], 0.000000, 0.000000, 0.000000, 1.000000);

	TDEditor_TD[18] = TextDrawCreate(546.500000, 391.249938, "");
	TextDrawLetterSize(TDEditor_TD[18], 0.000000, 0.000000);
	TextDrawTextSize(TDEditor_TD[18], 18.000000, 19.000000);
	TextDrawAlignment(TDEditor_TD[18], 1);
	TextDrawColor(TDEditor_TD[18], -1);
	TextDrawSetShadow(TDEditor_TD[18], 0);
	TextDrawSetOutline(TDEditor_TD[18], 0);
	TextDrawBackgroundColor(TDEditor_TD[18], 0);
	TextDrawFont(TDEditor_TD[18], 5);
	TextDrawSetProportional(TDEditor_TD[18], 0);
	TextDrawSetShadow(TDEditor_TD[18], 0);
	TextDrawSetPreviewModel(TDEditor_TD[18], 1650);
	TextDrawSetPreviewRot(TDEditor_TD[18], 0.000000, 0.000000, 0.000000, 1.000000);
}
