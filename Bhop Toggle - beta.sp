#include <sourcemod> 
#include <zipcore_csgocolors> 

#pragma semicolon 1

#define SERVER_TAG "[{lightyellow}AB{default}]"

bool trigger = false;

ConVar autobunnyhopping;

Handle abVelocity;
Handle abAdvert;
Handle abAdvertMode;
Handle abMeterLocation;

public Plugin myinfo =
{
	name = "Bhop Toggle",
	author = "Cruze",
	description = "!ab,!abhop,!autobhop,!bhopon,!bhopoff",
	version = "1.6-beta",
	url = ""
}
public void OnPluginStart() 
{
	abVelocity	=	CreateConVar("ab_velocity", "1", "Whethere to show velocity when bhop is enabled.");
	abAdvert	=	CreateConVar("ab_advert", "1", "Enable or Disable Advert.");
	abAdvertMode	=	CreateConVar("ab_advertmode", "3", "Advert Location 1 = Chat, 2 = HintText, 3 = Text");
	abMeterLocation		=	CreateConVar("ssm_location", "1", "where should speed meter be shown. 0 = CenterHUD, 1 = New CSGO HUD");
	
	AutoExecConfig(true, "cruze_bhoptoggle");
	
	RegAdminCmd("sm_autobhop", Trigger_AutoBhop, ADMFLAG_RCON, "Toggle Bhop");
	RegAdminCmd("sm_abhop", Trigger_AutoBhop, ADMFLAG_RCON, "Toggle Bhop");
	RegAdminCmd("sm_ab", Trigger_AutoBhop, ADMFLAG_RCON, "Toggle Bhop On");
	RegAdminCmd("sm_bhopon", AutoBhopOn, ADMFLAG_RCON, "Turn Bhop On");
	RegAdminCmd("sm_bhopoff", AutoBhopOff, ADMFLAG_RCON, "Turn Bhop Off");
	RegAdminCmd("sm_sbhopon", SAutoBhopOn, ADMFLAG_RCON, "Silently turn Bhop On");
	RegAdminCmd("sm_sbhopoff", SAutoBhopOff, ADMFLAG_RCON, "Silently turn Bhop Off");
	
	HookEvent("round_start",OnBhop_RoundStart);

	autobunnyhopping = FindConVar("sv_autobunnyhopping");
	
	CreateTimer(600.0, Adverts, _, TIMER_REPEAT);
}

public void OnMapStart() 
{
	trigger=false;
}

public Action Adverts(Handle timer, any client)
{
	if(GetConVarBool(abAdvert))
	{
		if(GetConVarInt(abAdvertMode) == 1)
		{
			CPrintToChatAll("%s This server is running {green}BHOP Toggle {default}plugin by {olive}♚Cr[U]zE♚. ({darkblue}github.com/cruze03{default})", SERVER_TAG);
		}
		if(GetConVarInt(abAdvertMode) == 2)
		{
			PrintHintTextToAll("<b>BHOP TOGGLE PLUGIN BY <font color='#00ff00'>♚Cr[U]zE♚</font></b>");
		}
		if(GetConVarInt(abAdvertMode) == 3)
		{
			SetHudTextParams(-1.0, 0.32, 2.0, 0, 255, 255, 255, 2, 0.3, 0.3, 0.3);
			for(int i = 1; i <= MaxClients; ++i)
				if(IsClientInGame(i) && !IsFakeClient(i))
					ShowHudText(i, -1, "BHOP TOGGLE PLUGIN BY ♚Cr[U]zE♚");
		}
		//
	}
	return Plugin_Continue;
}

public void OnBhop_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if(GetConVarInt(autobunnyhopping) == 1)
	{
		char message[512];
		Format(message, sizeof(message), "%s {lime}Auto-BHOP is still {green}ON{lime}. Type {green}!ab {lime}or {green}!bhopoff{lime} to turn it off!{default}", SERVER_TAG);
		PrintToAdmins("*********************{purple}Message To Admins{default}*******************", "m");
		PrintToAdmins(message, "m");
		PrintToAdmins("***********************************************************", "m");
		SetCvarInt("mp_solid_teammates", 0); //turning off collision again because it was getting enable OnRoundStart for some reason
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
				SetCvarInt("sv_airaccelerate", 150);
				SetCvarInt("sv_autobunnyhopping", 1);
				SetCvarInt("sv_enablebunnyhopping", 1);
				SetCvarFloat("sv_staminajumpcost", 0.0);
				SetCvarFloat("sv_staminalandcost", 0.0);
				SetCvarInt("mp_solid_teammates", 0);
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
				SetCvarInt("sv_airaccelerate", 12);
				SetCvarInt("sv_autobunnyhopping", 0);
				SetCvarInt("sv_enablebunnyhopping", 0);
				SetCvarFloat("sv_staminajumpcost", 0.080);
				SetCvarFloat("sv_staminalandcost", 0.050);
				SetCvarInt("mp_solid_teammates", 1);
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
		SetCvarInt("sv_airaccelerate", 150);
		SetCvarInt("sv_autobunnyhopping", 1);
		SetCvarInt("sv_enablebunnyhopping", 1);
		SetCvarFloat("sv_staminajumpcost", 0.0);
		SetCvarFloat("sv_staminalandcost", 0.0);
		SetCvarInt("mp_solid_teammates", 0);
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
		SetCvarInt("sv_airaccelerate", 12);
		SetCvarInt("sv_autobunnyhopping", 0);
		SetCvarInt("sv_enablebunnyhopping", 0);
		SetCvarFloat("sv_staminajumpcost", 0.080);
		SetCvarFloat("sv_staminalandcost", 0.050);
		SetCvarInt("mp_solid_teammates", 1);
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
public Action SAutoBhopOn(client, args)
{
	if (IsValidClient(client))
	{
		SetCvarInt("sv_airaccelerate", 150);
		SetCvarInt("sv_autobunnyhopping", 1);
		SetCvarInt("sv_enablebunnyhopping", 1);
		SetCvarFloat("sv_staminajumpcost", 0.0);
		SetCvarFloat("sv_staminalandcost", 0.0);
		SetCvarInt("mp_solid_teammates", 0);
		trigger=true;
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 2);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
public Action SAutoBhopOff(client, args)
{
	if (IsValidClient(client))
	{
		SetCvarInt("sv_airaccelerate", 12);
		SetCvarInt("sv_autobunnyhopping", 0);
		SetCvarInt("sv_enablebunnyhopping", 0);
		SetCvarFloat("sv_staminajumpcost", 0.080);
		SetCvarFloat("sv_staminalandcost", 0.050);
		SetCvarInt("mp_solid_teammates", 1);
		trigger=false;
		for (int i = 1; i <= MaxClients; i++) if (IsValidClient(i, true, true))
		{
			SetEntProp(i, Prop_Send, "m_CollisionGroup", 5);  //[ENEMY COLLISION] 2 - none / 5 - 'default'
		}
	}
	return Plugin_Handled;
}
public void OnPlayerRunCmdPost(int client, int buttons, int impulse, const float vel[3], const float angles[3],
								int weapon, int subtype, int cmdnum, int tickcount, int seed, const int mouse[2]) 
{

	// If AutoBhop is enabled, player velocity(speed) will be shown. Thanks SHUFEN.jp(https://forums.alliedmods.net/member.php?u=250145) for helping me out!! ^___^

	if(GetConVarInt(autobunnyhopping) == 1  && IsValidClient(client) && GetConVarBool(abVelocity)) 
	{	
		if(IsPlayerAlive(client))
		{
			float vVel[3];
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
			float fVelocity = SquareRoot(Pow(vVel[0], 2.0) + Pow(vVel[1], 2.0));
			SetHudTextParamsEx(-1.0, 0.65, 0.1, {255, 255, 255, 255}, {0, 0, 0, 255}, 0, 0.0, 0.0, 0.0);
			if(GetConVarBool(abMeterLocation))
			{
				ShowHudText(client, 3, "Speed: %.2f u/s", fVelocity);
			}
			else
			{
				PrintHintText(client, "<font color='#FF0000'> Speed</font>:<font color='#00ff00'> %.2f</font> <u/s", fVelocity);
			}
		}
		if(IsClientObserver(client))
		{
			float vVel[3];
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel);
			float fVelocity = SquareRoot(Pow(vVel[0], 2.0) + Pow(vVel[1], 2.0));
			SetHudTextParamsEx(-1.0, 0.65, 0.1, {255, 255, 255, 255}, {0, 0, 0, 255}, 0, 0.0, 0.0, 0.0);

			int spectarget = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");

			if (spectarget < 1 || spectarget > MaxClients || !IsClientInGame(spectarget))
				return;

			char ClientName[32];
			GetClientName(spectarget, ClientName, 32);
			if(GetConVarBool(abMeterLocation))
			{
				if(IsFakeClient(spectarget))
				{
					ShowHudText(client, 3, "BOT %s's Speed: %.2f u/s", ClientName, fVelocity);
				}
				else
				{
					ShowHudText(client, 3, "%s's Speed: %.2f u/s", ClientName, fVelocity);
				}
			}
			else
			{
				if(IsFakeClient(spectarget))
				{
					if (GetClientTeam(spectarget) == 2)
					{
						PrintHintText(client, "<font color='#ede749'>BOT %s</font>'s <font color='#FF0000'>Speed</font>: <font color='#00ff00'> %.2f</font> u/s", ClientName, fVelocity);
					}
					else
					{
						PrintHintText(client, "<font color='#3169c4'>BOT %s</font>'s <font color='#FF0000'>Speed</font>: <font color='#00ff00'> %.2f</font> u/s", ClientName, fVelocity);
					}
				}
				else
				{
					if (GetClientTeam(spectarget) == 2)
					{
						PrintHintText(client, "<font color='#ede749'>%s</font>'s <font color='#FF0000'>Speed</font>: <font color='#00ff00'> %.2f</font> u/s", ClientName, fVelocity);
					}
					else
					{
						PrintHintText(client, "<font color='#3169c4'>%s</font>'s <font color='#FF0000'>Speed</font>: <font color='#00ff00'> %.2f</font> u/s", ClientName, fVelocity);
					}
				}
			}
		}
		return;
	}
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
stock void SetCvarInt(char[] scvar, int svalue)
{
	SetConVarInt(FindConVar(scvar), svalue, true);
}

stock void SetCvarFloat(char[] scvar, float svalue)
{
	SetConVarFloat(FindConVar(scvar), svalue, true);
}
