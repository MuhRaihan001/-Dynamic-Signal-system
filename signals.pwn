#define MAX_TOWERS      70
#define TOWER_OBJECT    3763
#define Signal:%0(%1)                    forward %0(%1); public %0(%1)

enum tower_data
{
    TOWER_ID,
    Float:TOWER_POS[3],
    Float:TOWER_RADIUS,
    Text3D:TOWER_TEXT,
    bool:TOWER_STATUS
}
new TowerData[MAX_TOWERS][tower_data];
new TowerArrayObject[MAX_TOWERS];

Signal:CreateTowerSignal(id, Float:x, Float:y, Float:z, Float:radius)
{
    new text[310], query[510];
    TowerData[id][TOWER_ID] = id;
    TowerData[id][TOWER_RADIUS] = radius;
    TowerData[id][TOWER_STATUS] = true;
    format(text, sizeof(text), "ID:%d\nStatus:%s\nRadius:%fm", id, TowerData[id][TOWER_STATUS] ? ("Good") : ("Bad"), radius);
    TowerData[id][TOWER_TEXT] = Create3DTextLabel(text, 0xFFFFFFFF, x, y, z, 50.0, 0);
    TowerArrayObject[id] = CreateObject(TOWER_OBJECT, x, y, z, 0.0, 0.0, 0.0, 50.0);
    mysql_format(mysql, query, sizeof query, "INSERT INTO signals (`id`, `radius`, `x`, `y`, `z`) VALUES (%d, %f, %f, %f, %f)", id, radius, x, y, z);
    mysql_query(mysql, query, false);
    print("[Signal-System] New tower to spread signal created");
    return 1;
}

Signal:LoadTowers()
{
    new Cache: result, text[150];

	result = mysql_query(mysql, "SELECT * FROM signals", true);
    for(new i = 0; i < cache_num_rows(); i++)
    {
        TowerData[i][TOWER_ID] = cache_get_field_content_int(i, "id", mysql);
        TowerData[i][TOWER_RADIUS] = cache_get_field_content_float(i, "radius", mysql);
        TowerData[i][TOWER_POS][0] = cache_get_field_content_float(i, "x", mysql);
        TowerData[i][TOWER_POS][1] = cache_get_field_content_float(i, "y", mysql);
        TowerData[i][TOWER_POS][2] = cache_get_field_content_float(i, "z", mysql);

        TowerData[i][TOWER_STATUS] = true;
        format(text, sizeof(text), "ID:%d\nStatus:%s\nRadius:%fm", i, TowerData[i][TOWER_STATUS] ? ("Good") : ("Bad"), TowerData[i][TOWER_RADIUS]);
        TowerData[i][TOWER_TEXT] = Create3DTextLabel(text, 0xFFFFFFFF, TowerData[i][TOWER_POS][0], TowerData[i][TOWER_POS][1], TowerData[i][TOWER_POS][2], 50.0, 0);
        TowerArrayObject[i] = CreateObject(TOWER_OBJECT, TowerData[i][TOWER_POS][0], TowerData[i][TOWER_POS][1], TowerData[i][TOWER_POS][2], 0.0, 0.0, 0.0, 50.0);
    }
    print("[Signal-System] Loaded all tower to spread signal across city");
    cache_delete(result);
    return 1;
}

Signal:CatchNearSignal(playerid)
{
    for(new i = 0; i < MAX_TOWERS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, TowerData[i][TOWER_RADIUS], TowerData[i][TOWER_POS][0], TowerData[i][TOWER_POS][1], TowerData[i][TOWER_POS][2]))
        {
            return i;
        }
    }
    return -1;
}

Signal:RefreshTower()
{
    for(new i = 0; i < MAX_TOWERS; i++)
    {
        Delete3DTextLabel(TowerData[i][TOWER_TEXT]);
        DestroyObject(TowerArrayObject[i]);
    }
    LoadTowers();
}

CMD:createtower(playerid, params[])
{
    new id, Float: radius, Float:x, Float:y, Float:z;
    if(sscanf(params, "if", id, radius)) return SendClientMessage(playerid, 0xCECECEFF, "Use: /createtower [id] [radius]");
    if(id < 0 || id >= MAX_TOWERS) return SendClientMessage(playerid, 0xCECECEFF, "[Signal-System] Invalid id");
    if(radius < 0.0) return SendClientMessage(playerid, 0xCECECEFF, "[Signal-System] Invalid radius for this tower");
    GetPlayerPos(playerid, x, y, z);
    CreateTowerSignal(id, x, y, z, radius);
    return 1;
}

CMD:editradius(playerid, params[])
{
    new id, Float: radius, query[510];
    if(sscanf(params, "if", id, radius)) return SendClientMessage(playerid, 0xCECECEFF, "Use: /createtower [id] [radius]");
    if(id < 0 || id >= MAX_TOWERS) return SendClientMessage(playerid, 0xCECECEFF, "[Signal-System] Invalid id");
    if(radius < 0.0) return SendClientMessage(playerid, 0xCECECEFF, "[Signal-System] Invalid radius for this tower");
    TowerData[id][TOWER_RADIUS] = radius;
    mysql_format(mysql, query, sizeof query, "UPDATE signals SET radius = %f WHERE id = %d", radius, id);
    mysql_query(mysql, query, false);

    format(query, sizeof query, "[Signal-System] You change the max radius of tower with id %d and new radius %f", id, radius);
    SendClientMessage(playerid, -1, query);
    return 1;
}

CMD:refreshtower(playerid)
{
    RefreshTower();
    return 1;
}

CMD:checksignal(playerid)
{
    new signal = CatchNearSignal(playerid);
    if(signal != -1)
    {
        SendClientMessage(playerid, 0xCECECEFF, "You are in the range of tower");
    }
    else
    {
        SendClientMessage(playerid, 0xCECECEFF, "You are not in the range of tower");
    }
    return 1;
}
