-- SQL For YugiohDB. Author: Graham Burek --

CREATE TABLE Player
(
pid INT NOT NULL UNIQUE,
player_name TEXT NOT NULL,
dob DATE NOT NULL,
PRIMARY KEY(pid)
);

CREATE TABLE Places
(
ZIP INT NOT NULL UNIQUE,
state TEXT NOT NULL,
city TEXT NOT NULL,
PRIMARY KEY(ZIP)
);

CREATE TABLE Venue
(
vid INT NOT NULL UNIQUE,
venue_name TEXT NOT NULL,
address_1 TEXT NOT NULL,
address_2 TEXT,
address_3 TEXT,
ZIP INT NOT NULL UNIQUE references Places(ZIP),
PRIMARY KEY(vid)
);

CREATE TABLE SideDeck
(
sdid INT NOT NULL UNIQUE,
PRIMARY KEY(sdid)
);

CREATE TABLE Deck
(
did INT NOT NULL UNIQUE,
sdid INT NOT NULL UNIQUE references SideDeck(sdid),
deck_name TEXT,
PRIMARY KEY(did)
);

CREATE TABLE Tournament
(
tid INT NOT NULL UNIQUE,
tournament_name TEXT NOT NULL,
tournament_date DATE NOT NULL,
vid INT NOT NULL UNIQUE references Venue(vid),
PRIMARY KEY(tid)
);

CREATE TABLE Duel
(
match_id INT NOT NULL UNIQUE,
player_1_pid INT NOT NULL UNIQUE references Player(pid),
player_2_pid INT NOT NULL UNIQUE references Player(pid),
tid INT NOT NULL UNIQUE references Tournament(tid),
PRIMARY KEY(match_id)
);

CREATE TABLE Registration
(
pid INT NOT NULL UNIQUE references Player(pid),
tid INT NOT NULL UNIQUE references Tournament(tid),
PRIMARY KEY(pid,tid)
);

CREATE TABLE Runs
(
pid INT NOT NULL UNIQUE references Player(pid),
tid INT NOT NULL UNIQUE references Tournament(tid),
did INT NOT NULL UNIQUE references Deck(did),
PRIMARY KEY(pid)
);

CREATE TABLE Products
(
prid INT NOT NULL UNIQUE,
product_type TEXT NOT NULL CHECK(product_type IN ('card_pack','accessory')),
priceUSD MONEY NOT NULL,
PRIMARY KEY(prid)
);

CREATE TABLE Wares
(
vid INT NOT NULL UNIQUE references Venue(vid),
prid INT NOT NULL UNIQUE references Products(prid),
PRIMARY KEY(vid,prid)
);

CREATE TABLE Card
(
cid INT NOT NULL UNIQUE,
card_name TEXT NOT NULL UNIQUE,
flavor_text TEXT NOT NULL UNIQUE,
legality TEXT NOT NULL CHECK(legality IN('unrestricted','semi-limited','limited','forbidden')),
PRIMARY KEY(cid)
);

CREATE TABLE SideDeck_Card
(
sdid INT NOT NULL UNIQUE references SideDeck(sdid),
cid INT NOT NULL UNIQUE references Card(cid),
PRIMARY KEY(sdid,cid)
);

CREATE TABLE Deck_Card
(
did INT NOT NULL UNIQUE references Deck(did),
cid INT NOT NULL UNIQUE references Card(cid),
PRIMARY KEY(did,cid)
);

CREATE TABLE MonsterCard
(
cid INT NOT NULL UNIQUE references Card(cid),
star_level INT NOT NULL,
hasEffect BOOLEAN NOT NULL,
attack INT NOT NULL,
defense INT NOT NULL,
attribute TEXT NOT NULL,
monster_type TEXT NOT NULL,
PRIMARY KEY(cid)
);

CREATE TABLE SpellCard
(
cid INT NOT NULL UNIQUE references Card(cid),
spell_type TEXT NOT NULL,  
PRIMARY KEY(cid)
);

CREATE TABLE TrapCard
(
cid INT NOT NULL UNIQUE references Card(cid),
trap_type TEXT NOT NULL,  
PRIMARY KEY(cid)
);


