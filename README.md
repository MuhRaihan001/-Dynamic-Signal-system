# Tower Signal System Usage Documentation

This documentation aims to assist other developers in utilizing and integrating the tower signal system into their projects. This system enables the creation, editing, loading, and checking of signals from towers. Below are the step-by-step instructions on how to use various features within this system.

## Usage Steps

### 1. Creating a New Tower

To create a new tower, use the command `/createtower`. The tower will be created at the player's current position with the specified ID and radius.

**Command Format:**

```
/createtower [id] [radius]
```

**Example:**

```
/createtower 1 50.0
```

This will create a tower with ID 1 and a radius of 50.0 at the player's current position.

### 2. Editing Tower Radius

To edit the radius of an existing tower, use the command `/editradius`. This will update the tower's radius with the specified ID.

**Command Format:**

```
/editradius [id] [radius]
```

**Example:**

```
/editradius 1 100.0
```

This will change the radius of the tower with ID 1 to 100.0.

### 3. Refreshing All Towers

To refresh all towers from the database, use the command `/refreshtower`. This command will remove all current tower objects and reload them from the database.

**Command Format:**

```
/refreshtower
```

**Example:**

```
/refreshtower
```

This will refresh all existing towers with the latest data from the database.

### 4. Checking Tower Signal

To check if a player is within the signal range of a tower, use the command `/checksignal`. This command will send a message to the player informing them whether they are within the tower's signal range or not.

**Command Format:**

```
/checksignal
```

**Example:**

```
/checksignal
```

This will send a message to the player indicating whether they are within the tower's signal range or not.

## Integration Guide

### Integrating the System into Your Project

1. **Database Initialization:**

   Ensure that the `signals` table exists in your database. The table structure should match the columns used in the script.

   ```sql
   CREATE TABLE signals (
       id INT PRIMARY KEY,
       radius FLOAT,
       x FLOAT,
       y FLOAT,
       z FLOAT
   );
   ```

4. **Integrating Functions and Commands:**

   Place all functions and commands from this script into your main script or in a separate file that you then include.

   ```c
   #include "signas.pwn"
   ```

### Usage in Project

1. **Loading Towers When the Server Starts:**

   Make sure to call `LoadTowers()` when the server starts to load all towers from the database.

   ```c
   public OnGameModeInit()
   {
       LoadTowers();
       return 1;
   }
   ```

2. **Handling Player Commands:**

   All available commands are ready to use in-game and can be directly called by players by typing the command in the chat.

   ```c
   CMD:call(playerid)
  {
    new signal = CatchNearSignal(playerid);
    if(signal == -1)
      return SendClientMessage(playerid,  -1, "No signal");
    //rest of your code
  }
   ```

By following this guide, you'll be able to integrate and use the tower signal system in your SA-MP project seamlessly. If there are any questions or issues, be sure to check the server logs for further information on any errors that may occur.
