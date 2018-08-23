#include <sourcemod> 
#include <zipcore_csgocolors> 

#define SERVER_TAG "[{lightyellow}AB{default}]"
bool trigger; 

ConVar airaccelerate;
ConVar autobunnyhopping; 
ConVar enableautobunnyhopping; 
ConVar staminajumpcost;
ConVar staminalandcost;

public Plugin:myinfo =
{
	name = "Bhop Toggle",
	author = "Cruze",
	description = "!ab,!abhop,!autobhop",
	version = "1.1",
	url = ""
}
public void OnPluginStart() 
{
	RegAdminCmd("sm_autobhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_abhop", Trigger_AutoBhop, ADMFLAG_RCON);
	RegAdminCmd("sm_ab", Trigger_AutoBhop, ADMFLAG_RCON);

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
public Action Trigger_AutoBhop(int client, int args)
{
		if(IsClientInGame(client) && !IsFakeClient(client))
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
			}
		}
	return Plugin_Handled;
}
