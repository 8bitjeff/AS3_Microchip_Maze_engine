# AS3_Microchip_Maze_engine
Fully customizable "Pac-amn" style engine. Create mazes with tile sheets. See full instructions for all options.  

# Engine Instructions

# Micro Chip Maze Engine Documentation

# Over view

The Micro Chip Maze Engine is a tile-based Pacman style game engine written in AS3. It contains a number of gameplay enhancements over the original classic game. The engine was created to allow deployment as a single .swf file. For that reason, all assets are either embedded into the .fla file or are inside class wrapper files.  
95% of the Engine can be configured by changing class files and the tiles png outside the .fla file. There are a few minor changes that need to be made to the .fla file.  The png file will need to be reimported into the .fla before it can be used.

# Engine Feature Set:

 Create an unlimited number of levels
Once all levels are complete, they repeat on HARD level with everything speeded up
One all levels are complete on HARD, they repeat indefinitely in INSANE mode.
The maze is on a 15x15 grid. 
All game graphics come from a tile sheet consisting of 32x32 tiles
The entire game rendering is done on to a single BitmapData canvas. This allows for 100’s of moving objects with AI (if needed). 
Allows for unlimited variations on the 5 basic power ups – Attack (like Pac Man power pills), Freeze (freeze the enemy), Kill (kill all on screen enemy), protect (player is safe from harm for a limited amount of time), and Bonus X (adds  the players bonus multiplier).  You can create multiple versions of each power up to make them not as effective at high levels, etc. 
Freeze and Protect power ups have timers associated with them. Time added to these is cumulative. This can make for some interesting levels designs.
Allows for an unlimited number of different enemy types. They are differentiated by an AI intelligence value, movement speed, and animation frames applied.
The player earns bonus for killing enemy without dying, and from collecting power-ups. The Bonus timer will give the player bonus points for all time left after the level is complete. The Bonus multiplier will be multiplied to all of these bonus values and if the player earns enough bonus (set by game designer in level xml data), then the play earns an extra man.
All game settings are edited by game designer via XML and compiled into final game with class wrappers around the xml. This allows you to create a single file game that is easily portable and uploaded to portals, etc.

There are 4 main files that make up the description of the game play. They are all class files that must be compiled into the swf. These files are:
GameDataXML.as – Describes basic game data, like number of levels. It also describes all of the tiles used to for the various player states, and the enemy types and power up types
TileSheetDataXML.as – Describes all of the tiles in the tiles_final.png file (must be embedded into the library)  and their attributes

Tiles_final.png – a png file of 32x32 tiles that make up all game play graphics. Must be embedded in the .fla library with an export class called “tileSheet_png”

Level#DataXML.as – A simple class that contains the row and column descriptions for the level  tiles. Level1DataXML is included. To create more levels, you need to just create more Level#DataXML.as files and follow the below instructions as to how to make sure the they are included in the final GamePlay.as file.


The GameDataXML.as File  This class file is a wrapper for access to the basic game data xml. The wrapper is necessary to keep this final delivery a single .swf file with no external asset load needed. 
 - Describes the basics of the game layout - Describes the player and tiles used for animation
- Describes the enemy types and tiles used for animation
- Describes the power up types and tiles used for animation
- Describes the explosion animation used for enemy kills

# General Game Description
***** It is not recommended that the first 5 settings be modified. The Engine has not been tested with other values.
```xml <tilesize>32</tilesize>``` This is the in width and height of all the tiles and animated characters in the game.  It is not recommended that his be changed.
```xml <screenwidth>480</screenwidth>``` . This is the width in pixels of the output game screen. The number of tiles that fit the screen will be screenwidth/tilesize. 
```xml <screenheight>480</screenheight>``` . Same as above, but for the screen height.
```xml <tilesheetwidth>512</tilesheetwidth>```  The width of the imported tile sheet (tiles_final.png)
```xml <tilesheetheight>640</tilesheetheight>```  The height of the imported tile sheet.
***** End of the Not recommended to be changed values *****

<lives>5</lives> - Number of lives the player begins with
<score>0</score> - The starting score for the player.
<level>1</level> - The starting level for the player
<numlevels>1</numlevels> The total number of levels for the game
<dotscore>10</dotscore> The basic score for eating a dot.
<erasertile>14</erasertile> The tile used to erase other tiles and display the background of the maze.
<playeracceleration>4</playeracceleration>. The Speed in Pixels that the player will move.

The Player  This section of the GameDataXML.as is used to describe all of the player movement animations.  You have control over not just the left , right, up and down for the player, but also transition animations between left, right, up and down. In the example, those are set to just be a single tile, but they can be any number of tiles. 

The basic movement animations for the player are set in the <lefttile></lefttile>, <righttile</righttile>,<uptile></uptile>and <downtile></downtile>. You can add as many tiles as needed to any of the directions. Currently there are just 2 animation frames for right:
<righttile>0</righttile><righttile>1</righttile> To add more, simply add more <righttile></righttile> 

There are two special tile attributes for the player:
<levelout>32</levelout><levelout>33</levelout><levelout>0</levelout><levelout>1</levelout> - Specifies how to animate the player when the level is over.

<invfilter>73</invfilter><invfilter>74</invfilter><invfilter>75</invfilter><invfilter>76</invfilter> - Specifies a set of overlay tiles  to loop through and display on top of the player when he has eaten  protect (or invincible) power up.

# Power Ups
Power Ups are described with a series of attributes. 
There are currently 5 types. The <title> attribute is used by the game engine for logic. 
These should not be changed.

The <type> is just a number that allows you to have multiple different versions of the same <title>. You CANNOT repeat numbers between power up titles, so DO NOT make a <type>1</type> for <title>attack1</title> and a <type>1<.type> for the <title>Freeze</title> power up.. ALL power ups must have a unique <type>, but multiple can have the same title.

The ONLY VALID TITLES are: freeze, attack1, bonusx, kill, and protect.
You will see in the current file that there are no two power ups with the same Type or Title. This is just because the basic game is a simple implementation. To make a much more elaborate game with multiple levels and different values for the power-ups, you can add new types. Make sure to use consecutive, non-repeating numbers for the types.  The number is used in the TilesSheetDataXml.as file to describe the power up type for an individual tile.

Valid Attributes for power-ups:
<playeraccadjust></playeraccadjust> 0 = no freeze, 1=freeze enemy

<playeracctimeadd></playeracctimeadd> - this is the amount of time in seconds to add to the freeze timerfor user. All current on-screen enemy will be frozen for that amount of time.

<playerinvincibleadjust> </playerinvincibleadjust> true or false. This will control whether of not this power up will add time to the player protect timer

<playerinvincibletimeadd></playerinvincibletimeadd> How much time in seconds to add to the payer’s protect timer

<playereatenemyadjust> </playereatenemyadjust> true or false to control whether or not t his power up will allow the player to eat the other enemy (this is the attack power up)

<playereatenemytimeadd>0</playereatenemytimeadd> Time to add to the eat (attack) timer
 
<playerscoreadjust></playerscoreadjust> The score the player receives for eating this power up
<playerbonusadjust></playerbonusadjust> The bonus points to player receives for eating this power up
<playerbonustimeadjust></playerbonustimeadjust> The amount of time added to the player bonus timer for eating this power up

<playerkillallenemyadjust></playerkillallenemyadjust> true or false as to whether or not eating this power up will kill all of the currently on-screen enemy.

Enemy Each enemy type is described in much the same way as the player and the power ups.  The <title> attribute for the enemy is just a notation for the game designer and does not in any way affect game play (unlike the power ups). The <type></type> is the most important attribute. It MUST be UNIQUE to the enemy (just like the Power Ups). 
<Title>dumb1</Title> - Unlike Power-Ups, this is meaningless to game play, but can be used to help you remember what this enemy AI is like at a quick glance.
<id> </id>  An id that will be used to add this enemy to the Level data files. Make them descriptive and UNIQUE. They can be anything.
<downtile>,<uptile>,<righttile>, <lefttile> -  Just like the Player:  describes the series of animation tiles to loop through when the enemy is moving in that direction
speed> - Controls the number of pixels this enemy will move on each frame.
<intelligence> - A Number from 0 – 100 that represents the % chance that this enemy type will strictly follow the built-in maze-chase AI. A number from 30 – 90 is recommended as too low of a number will create a enemy that just randomly scrambles around the maze, too high a number and the enemy will freeze in place waiting for the player to make a move.
<score>  The number of points the player receives for eating this enemy type.
<fleefilter>80</fleefilter><fleefilter>81</fleefilter><fleefilter>82</fleefilter><fleefilter>83</fleefilter> - Like the player’s <invfilter>, these are tile frames that will overlay the enemy when the player is in chase mode.

Explosions Only one explosion is implemented in this engine, but more can be added with GamePlay.as customizations.  

<tile></tile> describes a series of tiles to loop through to create the explosion.  <type><type> a name that will be used internally to switch which explosion to show. Not currently implemented in  this engine as only one explosion is used.


# The TileSheetDataXML.as File
This class file is a wrapper for a description of each tile in the tiles_final.png file.
The tiles are listed in order from 0 through  the end of the tile sheet. They are NOT listed as rows and columns like level data would be listed. The tiles are loaded into a single dimensional array in the GamePlay.as class that is easily accessed by the engine the subscribe number of the tile id (see below). 

If a tile is used to simply describe the animation frames in the player, enemy type, or explosion it will not need to have any meta data attributes assigned. Those are intrinsic to the tiles when they make up those special case animation loops. All other tiles need to have a series of xml data that is used to describe the.

id – the number this tile will be in the internal tile array. Not needed by the engine, but added to this file to help the level designer

desc – A text description of the tile. Also not used by the engine, but added to help the level and game designers.

w – 0= this tile is NOT walkable, 1=this tile is walkable. All passage ways and power ups MUST be walkable.

c – 0=this tile is NOT collectible, 1= this tile is collectible. All dots and power ups must be collectible

p – 0=this tile is NOT a power up, 1=this tile is a power up. If  p=1, it MUST have a valid pt (see below)

pt – This is the numerical power up type number that corresponds to the type attribute in the GameDataXML.as file.

a – 0= This tile is not animated, 1 = this tile is animated. It MUST have a valid aList (see below)

aList – if this tile is animated, you will need to fill in a comma delimited list of the tiles to animate through

eg – 0= this tile is NOT and enemy generator, 1= this tile is an enemyGenerator


# The Level#DataL.as Files 
The level data as files are wrappers for the level description attributes. The rows and columns of tile numbers that make up the level display.

<framerate> - Deprecated. Do not use. This WAS used to control the frame rate of the level, but it resulted in strange behavior.
<backgroundtile> The tile sheet id number of the tile to use as the background for the level. It will only be seen if a tile on top has transparency.
<playerstartrow> The row, 0-14 to start the player
<playerstartcol>  The column, 0-14 to start the player

<enemytype num="1">EnemyRat</enemytype> This will add 1 EnemyRat (type) to the level. Remember, you can add your own enemy types and exchange them for this.
<enemytype num="3">EnemyBat</enemytype> - Same as above, but it will add 3 EnemyBat objects.
<bonustimelimit> The number of seconds to give the user to complete the level and still be awarded bonus time points.
<timebonus> The amount of points to award the player for each bonus time second left on the clock at level end.
<extramanamount> The total bonus needed to be achieved on each level to earn an extra man.
<enemytoeatforbonusxplus> The number of enemy the player must eat in a row with out dying to earn an increase in his/her bonus multiplier.
<attackbonusperkill> How much bonus to add to the player bonus total for each enemy eaten. This will be multiplied by the bonus multiplier.
<enemystartFrameDelay> Time in seconds to delay the enemy start at level begin
<enemyrestartFrameDelay>  Time in seconds for enemy to wait before re-spawn after being eaten. Make this unusually high for levels that you want to be easier. Make it shorter for more difficult levels. 

# Row and columns of level tile data:
<tilerow>
<tilecol>8</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>6</tilecol><tilecol>14</tilecol><tilecol>7</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>9</tilecol>
</tilerow>

Each row in a level is create inside a <tilerow></tilerow> and should consist of 15 <tilecol></tilecol> nodes with the tile sheet id number inside.


# The tiles_final.png file
This is just a plan old png file with a transparent background broken up into rows of 16 32x32 tiles. If you start counting in the upper left-hand tile as 0, it will correspond directly to the id number in the TileSheetDataXML.as file

It has the capacity to hold 320 tiles (16x20) 32x32 tiles.

It is in the .fla library and exported with a class name of “tileSheet_png”.


# How To Create a Basic Level
Levels are basically a collection of 15 rows of data with 15 elements inside. They are represented this way in XML:

<tilerow>
<tilecol>8</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>6</tilecol><tilecol>14</tilecol><tilecol>7</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>2</tilecol><tilecol>9</tilecol>
</tilerow>


Each tilecol represents the id of a tile on the tiles_final.png file (in order from 0 – 319), The current example game only uses 112 tiles, but supports all 320. Also, the png file and the GameDataXML.as file can easily be modified to allow the use of many many more (up to the max size of a BitmpData object).

Level data can use created by hand, or with the use of Mappy. I have included Mappy (a opens source tool) with  the engine. I am not going to go into too much detail about using mappy, but here are the basic steps to create a new level.  This is a special version of mappy that I have modified to export .xml files in the format needed for this engine. 

********
A plain vanilla new install of mappy will require you to put the png library (libpng12.dll)  in the root  and add my .lua script called “Export Flash actionscript.lua” to the luascr folder. You will need to edit the  mapwin.ini file also and add a line for the “Export Flash actionscript.lua”.   Use the one I provided so you don’t have to do this.
******

Open the mapwin1411/mapwin.exe file. 
Go to the [file] menu and click on file-open
Open up the level1.fmp file included in this distribution
Let’s say you are going to make level 2.
Save this file as level2.fmp
IF you have updated the tiles_final.png file, then [file]-Import and import the tile_final.png file into the project again. It will replace the current version.
Notice that the first tile is BLANK. This is the mappy eraser tile and while a great idea, it skews the data for level data by adding 1 to the actual tile number for each tile (easily fixable on export).
Paint your level. Tile 14  (15 now that all of tiles have been moved over by one by mappy) is your background tile. It is a Black square next to the yellow dot tile. Use that tile for your background, NOT the mappy tile 1 background eraser tile.
Make sure to leave some open tiles around the enemy generators or you will run the risk of the enemy getting stuck when they leave the generator.
Also, if you leave an open tile on any side, it will automatically create a tunnel to the opposite side of the screen. Make sure to leave that tile open on the opposite side or the level will turn out strange to the user.
When you are done with the level, you should save it.
Now, to export the level2.xml file, do this.
Go to [custom]-export xml
It will warn you about the block 0 being replaced, just click on Ok, it will be fixed soon.
Choose a file name, and DO NOT add .xml to the end of the name
Click on save
A dialog box will come up and ask you “Adjust Exported Values By”. Enter -1 and click on [ok]. This will re-adjust the data back to start at 0 and negate the tile 1 eraser that mappy added to the data.
You are now ready to add a new level to the game. 

How to add levels to the engine

How to add a new level to the game.
Edit the GameDataXML.as file and change the <numlevels>1</numlevels> to <numlevels>2</numlevels> 
Make a copy of the Level1DataXML.as file and name it Level2DataXML.as
Edit Level2DataXML.as
Change public class Level1DataXML implements iLevelData{  to  public class Level2DataXML implements iLevelData{
Change public function Level1DataXML(){  to  public function Level2DataXML(){
Open the level2.xml file from mappy and copy all 15 tile rows to the xml data in the class, replacing the current 15 lines.
Save the file
In the GamePlay.as file, you will need to add and instance of the new level.
On about line 148, add in this line:  var level2DataXML:Level2DataXML; Note that I have already added level 2 and level 3, but you will need to do so for levels 4 and beyond.

# Testing your level.
1. Change the GameDataXML.as file entry for <level>1</level> to <level>2</level> (or what ever the new level number is and test) by exporting the movie.

# Other changes the can be made in the .Fla

The .fla game file has a few more things that can/should be edited to fully change the game.

In the sprite clips folder you will want to edit  Micro Chip Maze and change it to a frame of your main character.
You can change all of the exported sounds. They are all included in the engine price, but you will probably have more appropriate ones for your own version.
All of the game screens are in the Screens folder in the library. Even if you leave all of the screens as is (not likely as they are UGLY as is), you will want to re-do these. The highscore screens are not used in this version unless Mochi High Scores are turned on.
