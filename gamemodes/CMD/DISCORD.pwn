forward DCC_DM(str[]);
public DCC_DM(str[])
{
    new DCC_Channel:PM;
	PM = DCC_GetCreatedPrivateChannel();
	DCC_SendChannelMessage(PM, str);
	return 1;
}

forward DCC_DM_EMBED(str[], pin, id[]);
public DCC_DM_EMBED(str[], pin, id[])
{
    new DCC_Channel:PM, query[200];
	PM = DCC_GetCreatedPrivateChannel();

	new DCC_Embed:embed = DCC_CreateEmbed(.title="IndoLast Roleplay", .image_url="https://cdn7937840356p.com/attachments/1072491683398299668/1079378403565785099/IMG-20230226-WA0005.jpg");
	new str1[100], str2[100];

	format(str1, sizeof str1, "```\nHalo!\nUCP kamu berhasil terverifikasi,\nGunakan PIN dibawah ini untuk login ke Game```");
	DCC_SetEmbedDescription(embed, str1);
	format(str1, sizeof str1, "UCP");
	format(str2, sizeof str2, "\n```%s```", str);
	DCC_AddEmbedField(embed, str1, str2, bool:1);
	format(str1, sizeof str1, "PIN");
	format(str2, sizeof str2, "\n```%d```", pin);
	DCC_AddEmbedField(embed, str1, str2, bool:1);

	DCC_SendChannelEmbedMessage(PM, embed);

	mysql_format(g_SQL, query, sizeof query, "INSERT INTO `playerucp` (`ucp`, `verifycode`, `DiscordID`) VALUES ('%e', '%d', '%e')", str, pin, id);
	mysql_tquery(g_SQL, query);
	return 1;
}

forward CheckDiscordUCP(DiscordID[], Nama_UCP[]);
public CheckDiscordUCP(DiscordID[], Nama_UCP[])
{
	new DCC_Channel:channelucp;
	channelucp = DCC_FindChannelById("1104346868424646686");
	new rows = cache_num_rows();
	new DCC_Role: WARGA, DCC_Guild: guild, DCC_User: user, dc[100];
	new verifycode = RandomEx(111111, 988888);
	if(rows > 0)
	{
		return DCC_SendChannelMessage(channelucp, "```\n[INFO]: Nama UCP account tersebut sudah terdaftar```");
	}
	else 
	{
		new ns[32];
		guild = DCC_FindGuildById("1104342158477115392");
		WARGA = DCC_FindRoleById("1104346325757206610");
		user = DCC_FindUserById(DiscordID);
		format(ns, sizeof(ns), "Warga | %s ", Nama_UCP);
		DCC_SetGuildMemberNickname(guild, user, ns);
		DCC_AddGuildMemberRole(guild, user, WARGA);

		format(dc, sizeof(dc),  "```\n[UCP]: %s is now Verified.```", Nama_UCP);
		DCC_SendChannelMessage(channelucp, dc);
		DCC_CreatePrivateChannel(user, "DCC_DM_EMBED", "sds", Nama_UCP, verifycode, DiscordID);
	}
	return 1;
}

forward CheckDiscordID(DiscordID[], Nama_UCP[]);
public CheckDiscordID(DiscordID[], Nama_UCP[])
{
	new DCC_Channel:channelucp;
	channelucp = DCC_FindChannelById("1104346868424646686");
	new rows = cache_num_rows(), ucp[20], dc[100];
	if(rows > 0)
	{
		cache_get_value_name(0, "ucp", ucp);

		format(dc, sizeof(dc),  "```\n[INFO]: Kamu sudah mendaftar UCP sebelumnya dengan nama %s```", ucp);
		return DCC_SendChannelMessage(channelucp, dc);
	}
	else 
	{
		new characterQuery[178];
		mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `ucp` = '%s'", Nama_UCP);
		mysql_tquery(g_SQL, characterQuery, "CheckDiscordUCP", "ss", DiscordID, Nama_UCP);
	}
	return 1;
}


DCMD:register(user, channel, params[])
{
	new id[21];
    if(channel != DCC_FindChannelById("1104346868424646686"))
		return 1;
    if(isnull(params)) 
		return DCC_SendChannelMessage(channel, "```\n[USAGE]: !register [UCP NAME]```");
	if(!IsValidNameUCP(params))
		return DCC_SendChannelMessage(channel, "```\nGunakan nama UCP bukan nama IC!```");
	
	DCC_GetUserId(user, id, sizeof id);

	new characterQuery[178];
	mysql_format(g_SQL, characterQuery, sizeof(characterQuery), "SELECT * FROM `playerucp` WHERE `DiscordID` = '%s'", id);
	mysql_tquery(g_SQL, characterQuery, "CheckDiscordID", "ss", id, params);
	DCC_SendChannelMessage(channel, "```\n[BOT]: UCP ANDA BERHASIL TERDAFTAR , SILAHKAN CEK DM ANDA !```");

	return 1;
}

/*DCMD:server(user, channel, params[])
{
	foreach(new i : Player)
	{
		new DCC_Embed:embed = DCC_CreateEmbed(.title = "IndoLast World");
		new str1[100], str2[100], name[MAX_PLAYER_NAME+1];
		GetPlayerName(i, name, sizeof(name));

		format(str1, sizeof str1, "**NAME SERVER**");
		format(str2, sizeof str2, "\nIndoLast Roleplay");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**WEBSITE**");
		format(str2, sizeof str2, "\nhttps://discord.gg/IndoLastrp");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**PLAYERS**");
		format(str2, sizeof str2, "\n%d Online", pemainic);
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "**GAMEMODE**");
		format(str2, sizeof str2, "\nLRP V7 REMAKE TEAM INDOLAST");
		DCC_AddEmbedField(embed, str1, str2, false);
		format(str1, sizeof str1, "__[ID]\tName\tLevel\tPing__\n");
		format(str2, sizeof str2, "**%i\t%s\t%i\t%i**\n", i, name, GetPlayerScore(i), GetPlayerPing(i));
		DCC_AddEmbedField(embed, str1, str2, false);

		DCC_SendChannelEmbedMessage(channel, embed);
		return 1;
	}
	return 1;
}*/