/*
 * FIXED ALL COMPILER WARNING ^__^
 */
#include <sourcemod> 
#include <zipcore_csgocolors> 

#pragma semicolon 1

#define SERVER_TAG "[{lightyellow}AB{default}]"

bool trigger = false;


ConVar airaccelerate;
ConVar autobunnyhopping; 
ConVar enableautobunnyhopping; 
ConVar staminajumpcost;
ConVar staminalandcost;
ConVar solidteammates;

public Plugin myinfo =
{
	name = "Bhop Toggle",
	author = "Cruze",
	description = "!ab,!abhop,!autobhop,!bhopon,!bhopoff",
	version = "1.5",
	url = ""
}
public void OnPluginStart() 
{
	RegAdminCmd("sm_autobhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_abhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_ab", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_bhopon", AutoBhopOn, ADMFLAG_RCON);
	RegAdminCmd("sm_bhopoff", AutoBhopOff, ADMFLAG_RCON);
	
	HookEvent("round_start",OnBhop_RoundStart);

	airaccelerate = FindConVar("sv_airaccelerate");
	autobunnyhopping = FindConVar("sv_autobunnyhopping");
	enableautobunnyhopping = FindConVar("sv_enablebunnyhopping");
	staminajumpcost = FindConVar("sv_staminajumpcost");
	staminalandcost = FindConVar("sv_staminalandcost");
	solidteammates = FindConVar("mp_solid_teammates");
	
}
public void OnMapStart() 
{
	trigger=false;
}
public void OnBhop_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(GetConVarInt(autobunnyhopping) == 1)
	{
		PrintToAdmins("*********************{purple}Message To Admins{default}*******************", "m");
		PrintToAdmins("[SM] {lime}Auto-BHOP is still {green}ON{lime}. Type {green}!ab {lime}or {green}!bhopoff{lime} to turn it off!{default}", "m");
		PrintToAdmins("***********************************************************", "m");
		SetConVarInt(solidteammates, 0); //turning off collision again because it was getting enable OnRoundStart for some reason
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
		}
	}
	//
}

public Action Trigger_AutoBhop(client, args)
{
		if (IsValidClient(client))
		{
			if(!trigger) // Bhop On
			{
				SetConVarInt(airaccelerate, 150);
				SetConVarInt(autobunnyhopping, 1);
				SetConVarInt(enableautobunnyhopping, 1);
				SetConVarInt(solidteammates, 0);
				SetConVarFloat(staminajumpcost, 0.0);
				SetConVarFloat(staminalandcost, 0.0);
				trigger=true;
				CPrintToChatAll("%s {lime}Auto-BHOP has been turned {green}ON{default}", SERVER_TAG);
				SetHudTextParams(0.45, 0.350,  6.0, 0, 255, 0, 255, 0, 0.25, 0.5, 0.3);
				ShowHudText(client, -1, "AUTO-BHOP is turned ON");
				for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
				{
					SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
				}
			}
			else // Bhop Off
			{
				SetConVarInt(airaccelerate, 12);
				SetConVarInt(autobunnyhopping, 0);
				SetConVarInt(enableautobunnyhopping, 0);
				SetConVarInt(solidteammates, 1);
				SetConVarFloat(staminajumpcost, 0.080);
				SetConVarFloat(staminalandcost, 0.050);
				trigger=false;
				CPrintToChatAll("%s {lightred}Auto-BHOP has been turned {darkred}OFF", SERVER_TAG);
				SetHudTextParams(0.45, 0.350, 6.0, 255, 0, 0, 255, 0, 0.25, 0.5, 0.3);
				ShowHudText(client, -1, "AUTO-BHOP is turned OFF");
				for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
				{
					SetEntProp(i, Prop_Send, "m_CollisionGroup", 5);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
				}
			}
		}
		return Plugin_Handled;
}
public Action AutoBhopOn(client, args)
{
	if (IsValidClient(client))
	{
		SetConVarInt(airaccelerate, 150);
		SetConVarInt(autobunnyhopping, 1);
		SetConVarInt(enableautobunnyhopping, 1);
		SetConVarInt(solidteammates, 0);
		SetConVarFloat(staminajumpcost, 0.0);
		SetConVarFloat(staminalandcost, 0.0);
		trigger=true;
		CPrintToChatAll("%s {lime}Auto-BHOP has been turned {green}ON{default}", SERVER_TAG);
		SetHudTextParams(0.45, 0.350,  6.0, 0, 255, 0, 255, 0, 0.25, 0.5, 0.3);
		ShowHudText(client, -1, "AUTO-BHOP is turned ON");
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
public Action AutoBhopOff(client, args)
{
	if (IsValidClient(client))
	{
		SetConVarInt(airaccelerate, 12);
		SetConVarInt(autobunnyhopping, 0);
		SetConVarInt(enableautobunnyhopping, 0);
		SetConVarInt(solidteammates, 1);
		SetConVarFloat(staminajumpcost, 0.080);
		SetConVarFloat(staminalandcost, 0.050);
		trigger=false;
		CPrintToChatAll("%s {lightred}Auto-BHOP has been turned {darkred}OFF", SERVER_TAG);
		SetHudTextParams(0.45, 0.350, 6.0, 255, 0, 0, 255, 0, 0.25, 0.5, 0.3);
		ShowHudText(client, -1, "AUTO-BHOP is turned OFF");
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 5);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
	
bool IsValidClient(client, bool bAllowBots = true, bool bAllowDead = true)
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
    {
        return false;
    }
    return true;
}
stock PrintToAdmins(const char[] message, const char[] flags) 
{ 
    for (new x = 1; x <= MaxClients; x++) 
    { 
        if (IsValidClient(x) && IsValidAdmin(x, flags)) 
        { 
            CPrintToChat(x, message);
        } 
    } 
}
bool IsValidAdmin(client, const char[] flags) 
{ 
    new ibFlags = ReadFlagString(flags); 
    if ((GetUserFlagBits(client) & ibFlags) == ibFlags) 
    { 
        return true; 
    } 
    if (GetUserFlagBits(client) & ADMFLAG_ROOT) 
    { 
        return true; 
    } 
    return false; 
}
