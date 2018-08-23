#include <sourcemod> 
#include <zipcore_csgocolors> 

#define SERVER_TAG "[{lightyellow}AB{default}]"
bool trigger = false;

ConVar airaccelerate;
ConVar autobunnyhopping; 
ConVar enableautobunnyhopping; 
ConVar staminajumpcost;
ConVar staminalandcost;

public Plugin:myinfo =
{
	name = "Bhop Toggle",
	author = "Cruze",
	description = "!ab,!abhop,!autobhop,!bhopon,!bhopoff",
	version = "1.3",
	url = ""
}
public void OnPluginStart() 
{
	RegAdminCmd("sm_autobhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_abhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_ab", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_bhopon", AutoBhopOn, ADMFLAG_RCON);
	RegAdminCmd("sm_bhopoff", AutoBhopOff, ADMFLAG_RCON);

	airaccelerate = FindConVar("sv_airaccelerate");
	autobunnyhopping = FindConVar("sv_autobunnyhopping");
	enableautobunnyhopping = FindConVar("sv_enablebunnyhopping");
	staminajumpcost = FindConVar("sv_staminajumpcost");
	staminalandcost = FindConVar("sv_staminalandcost");
	
}
public void OnMapStart() 
{
	trigger=false;
}
public void OnRoundStart() 
{
	trigger=false;
}

public Action Trigger_AutoBhop(int client, int args)
{
		if (IsValidClient(client))
		{
			if(!trigger) // Bhop On
			{
				SetConVarInt(airaccelerate, 150);
				SetConVarInt(autobunnyhopping, 1);
				SetConVarInt(enableautobunnyhopping, 1);
				SetConVarFloat(staminajumpcost, 0);
				SetConVarFloat(staminalandcost, 0);
				trigger=true;
				CPrintToChatAll("%s {lime}Auto-BHOP has been turned {green}ON{default}", SERVER_TAG);
				SetHudTextParams(0.45, 0.350,  6.0, 0, 255, 0, 255, 0, 0.25, 0.5, 0.3);
				ShowHudText(client, -1, "AUTO-BHOP is turned ON");
				for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
				{
					SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  // 2 - none / 5 - 'default'
				}
			}
			else // Bhop Off
			{
				SetConVarInt(airaccelerate, 12);
				SetConVarInt(autobunnyhopping, 0);
				SetConVarInt(enableautobunnyhopping, 0);
				SetConVarFloat(staminajumpcost, 0.080);
				SetConVarFloat(staminalandcost, 0.050);
				trigger=false;
				CPrintToChatAll("%s {lightred}Auto-BHOP has been turned {darkred}OFF", SERVER_TAG);
				SetHudTextParams(0.45, 0.350, 6.0, 255, 0, 0, 255, 0, 0.25, 0.5, 0.3);
				ShowHudText(client, -1, "AUTO-BHOP is turned OFF");
				for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
				{
					SetEntProp(i, Prop_Send, "m_CollisionGroup", 5);  // 2 - none / 5 - 'default'
				}
			}
		}
	return Plugin_Handled;
}
public Action AutoBhopOn(int client, int args)
{
	if (IsValidClient(client))
	{
		SetConVarInt(airaccelerate, 150);
		SetConVarInt(autobunnyhopping, 1);
		SetConVarInt(enableautobunnyhopping, 1);
		SetConVarFloat(staminajumpcost, 0);
		SetConVarFloat(staminalandcost, 0);
		trigger=true;
		CPrintToChatAll("%s {lime}Auto-BHOP has been turned {green}ON{default}", SERVER_TAG);
		SetHudTextParams(0.45, 0.350,  6.0, 0, 255, 0, 255, 0, 0.25, 0.5, 0.3);
		ShowHudText(client, -1, "AUTO-BHOP is turned ON");
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  // 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
public Action AutoBhopOff(int client, int args)
{
	if (IsValidClient(client))
	{
		SetConVarInt(airaccelerate, 12);
		SetConVarInt(autobunnyhopping, 0);
		SetConVarInt(enableautobunnyhopping, 0);
		SetConVarFloat(staminajumpcost, 0.080);
		SetConVarFloat(staminalandcost, 0.050);
		trigger=false;
		CPrintToChatAll("%s {lightred}Auto-BHOP has been turned {darkred}OFF", SERVER_TAG);
		SetHudTextParams(0.45, 0.350, 6.0, 255, 0, 0, 255, 0, 0.25, 0.5, 0.3);
		ShowHudText(client, -1, "AUTO-BHOP is turned OFF");
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 5);  // 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
	
bool IsValidClient(int client, bool bAllowBots = true, bool bAllowDead = true)
{
    if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
    {
        return false;
    }
    return true;
}
