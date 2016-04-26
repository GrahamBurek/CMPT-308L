-- SQL For YugiohDB. Author: Graham Burek --

-- Clear database before script execution: --
DROP VIEW IF EXISTS MonsterCardView;
DROP VIEW IF EXISTS SpellCardView;
DROP VIEW IF EXISTS TrapCardView;
DROP TABLE IF EXISTS MonsterCard;
DROP TABLE IF EXISTS SpellCard;
DROP TABLE IF EXISTS TrapCard;
DROP TABLE IF EXISTS Duel;
DROP TABLE IF EXISTS Runs;
DROP TABLE IF EXISTS Registration;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS SideDeck_Card;
DROP TABLE IF EXISTS Deck_Card;
DROP TABLE IF EXISTS Card;
DROP TABLE IF EXISTS Deck;
DROP TABLE IF EXISTS SideDeck;
DROP TABLE IF EXISTS Tournament;
DROP TABLE IF EXISTS Venue;
DROP TABLE IF EXISTS Places;

----------- Create statements: ------------
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
ZIP INT NOT NULL references Places(ZIP),
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
sdid INT NOT NULL references SideDeck(sdid),
deck_name TEXT,
PRIMARY KEY(did)
);

CREATE TABLE Tournament
(
tid INT NOT NULL UNIQUE,
tournament_name TEXT NOT NULL,
tournament_date DATE NOT NULL CHECK(tournament_date > now()),
vid INT NOT NULL references Venue(vid),
PRIMARY KEY(tid)
);

CREATE TABLE Duel
(
match_id INT NOT NULL UNIQUE,
player_1_pid INT NOT NULL references Player(pid),
player_2_pid INT NOT NULL references Player(pid),
tid INT NOT NULL references Tournament(tid),
winner_num INT NOT NULL CHECK(winner_num IN(0,1,2)),
PRIMARY KEY(match_id)
);

CREATE TABLE Registration
(
pid INT NOT NULL references Player(pid),
tid INT NOT NULL references Tournament(tid),
PRIMARY KEY(pid,tid)
);

CREATE TABLE Runs
(
pid INT NOT NULL references Player(pid),
tid INT NOT NULL references Tournament(tid),
did INT NOT NULL references Deck(did),
PRIMARY KEY(pid,tid)
);

CREATE TABLE Card
(
cid INT NOT NULL UNIQUE,
card_name TEXT NOT NULL UNIQUE,
flavor_text TEXT NOT NULL,
legality TEXT NOT NULL CHECK(legality IN('unrestricted','semi-limited','limited','forbidden')),
PRIMARY KEY(cid)
);

CREATE TABLE SideDeck_Card
(
sdid INT NOT NULL references SideDeck(sdid),
cid INT NOT NULL references Card(cid),
qty INT NOT NULL CHECK(qty IN(1,2,3)),
PRIMARY KEY(sdid,cid)
);

CREATE TABLE Deck_Card
(
did INT NOT NULL references Deck(did),
cid INT NOT NULL references Card(cid),
qty INT NOT NULL CHECK(qty IN(1,2,3)),
PRIMARY KEY(did,cid)
);

CREATE TABLE MonsterCard
(
cid INT NOT NULL references Card(cid),
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
cid INT NOT NULL references Card(cid),
spell_type TEXT NOT NULL,  
PRIMARY KEY(cid)
);

CREATE TABLE TrapCard
(
cid INT NOT NULL references Card(cid),
trap_type TEXT NOT NULL,  
PRIMARY KEY(cid)
);

---------------- Sample data for database: --------------- 

INSERT INTO Player(pid,player_name,dob) VALUES
 -- start values: --
(1,'Billy Brake','1980-09-10'),
(2,'Patrick Hoban','1981-10-01'),
(3,'Jerry Wang','1982-02-15'),
(4,'Dale Bellido','1983-06-02'),
(5,'Chris Bowling','1983-06-27'),
(6,'Fili Luna','1986-01-28'),
(7,'Ryan Spicer','1987-01-19'),
(8,'Matt Peddle','1988-10-24'),
(9,'Theerasak Poonsombat','1990-01-22'),
(10,'Cesar Gonalez','1993-05-04'),
(11,'Jason Holloway','1994-06-07'),
(12,'Roy St. Clair','1994-09-26'),
(13,'Anthony Alvarado','1995-02-17'),
(14,'Adam Corn','1996-03-19'),
(15,'Sean Conway','1996-05-13'),
(16,'Yugi Moto','1997-03-26');
 -- end values: --

INSERT INTO Places(ZIP,state,city) VALUES
 -- start values: --
(10301,'NY','Staten Island'),
(89044,'NV','Las Vegas'),
(94102,'CA','San Francisco'),
(60290,'IL','Chicago'),
(77001,'TX','Houston'),
(17101,'NJ','Newark'),
(22901,'RI','Providence'),
(44101,'OH','Cleveland'),
(33010,'FL','Miami');
 -- end values: --

INSERT INTO Venue(vid, venue_name,address_1,address_2,address_3,ZIP) VALUES
 -- start values: --
(1,'Get There Games','1759 Victory Blvd',NULL,NULL,10301),
(2,'Alexis Park Resort','375 E. Harmon Ave.',NULL,NULL,89044),
(3,'Florida International University','3000 N.E. 151st St.','Wolf University Center',NULL,33010),
(4,'Top Cut Comics Chicago','6390 S. Archer Ave.',NULL,NULL,60290),
(5,'Greenspoint Mall','12300 North Freeway',NULL,NULL,77001);
 -- end values: --

INSERT INTO SideDeck(sdid) VALUES
 -- start values --
 (1),
 (2),
 (3),
 (4),
 (5);
 -- end values --

 INSERT INTO Deck(did,sdid,deck_name) VALUES
 -- start values --
 (1,2,'Blue-Eyes Turbo'),
 (2,1,'Artifact Monarchs'),
 (3,5,NULL),
 (4,4,'Dark Magic Deck'),
 (5,2,NULL);
 -- end values --

INSERT INTO Tournament(tid,tournament_name,tournament_date,vid) VALUES
 -- start values --
(1,'YCS Regional Qualifier Chicago','2016-09-20',4),
(2,'EVO 2016','2016-07-15',2),
(3,'LLDS 2016','2016-11-01',1),
(4,'Ultimate Duelist Series','2017-10-22',5),
(5,'TCG World Championship','2017-06-21',3);
 -- end values --

INSERT INTO Duel(match_id,player_1_pid,player_2_pid,tid,winner_num) VALUES
 -- start values --
(1,1,16,4,1),
(2,1,16,4,0),
(3,3,7,2,0),
(4,7,8,3,2),
(5,2,6,5,1),
(6,9,14,1,0),
(7,11,15,1,1),
(8,10,9,2,0),
(9,8,9,2,0),
(10,4,6,3,2),
(11,10,9,3,0),
(12,2,1,5,1),
(13,11,5,1,1),
(14,3,5,3,2),
(15,12,8,1,1),
(16,4,3,2,0),
(17,15,1,4,2),
(18,1,6,3,0),
(19,9,1,5,1),
(20,2,14,1,0);
 -- end values --

 INSERT INTO Registration(pid,tid) VALUES
 -- start values --
 (1,1),
 (1,2),
 (1,3),
 (1,4),
 (1,5),
 (2,2),
 (2,3),
 (2,4),
 (3,5),
 (3,1),
 (3,2),
 (3,3),
 (4,1),
 (4,2),
 (4,3),
 (4,4),
 (4,5),
 (5,1),
 (5,2),
 (6,3),
 (6,4),
 (6,5),
 (6,2),
 (7,1),
 (7,3),
 (7,5),
 (8,2),
 (8,4),
 (9,1),
 (10,1),
 (10,2),
 (10,3),
 (11,1),
 (11,2),
 (11,3),
 (11,4),
 (12,3),
 (12,4),
 (12,1),
 (13,1),
 (13,2),
 (13,3),
 (13,4),
 (13,5),
 (14,1),
 (14,2),
 (15,2),
 (15,3),
 (15,5),
 (15,4),
 (16,1),
 (16,2),
 (16,3),
 (16,4),
 (16,5);
 -- end values --

INSERT INTO Runs(pid,tid,did) VALUES
-- start values --
(1,1,1),
(1,2,1),
(1,3,2),
(1,4,3),
(1,5,1),
(2,2,4),
(2,3,5),
(2,4,5),
(3,1,3),
(3,2,3),
(3,3,3),
(3,5,1),
(4,1,1),
(4,2,1),
(4,3,1),
(4,4,5),
(4,5,5),
(5,1,2),
(5,2,2),
(6,3,1),
(6,4,2),
(6,5,4),
(6,2,4),
(7,1,5),
(7,3,5),
(7,5,5),
(8,2,2),
(8,4,2),
(9,1,2),
(10,1,1),
(10,2,1),
(10,3,4),
(11,1,4),
(11,2,3),
(11,3,4),
(11,4,1),
(12,3,1),
(12,4,1),
(12,1,2),
(13,1,3),
(13,2,5),
(13,3,5),
(13,4,5),
(13,5,1),
(14,1,2),
(14,2,2),
(15,2,3),
(15,3,3),
(15,5,5),
(15,4,1),
(16,1,1),
(16,2,2),
(16,3,2),
(16,4,5),
(16,5,1);
-- end values --

INSERT INTO Card(cid,card_name,flavor_text,legality) VALUES
-- start legal card values --
(1,'Blue-Eyes White Dragon', 'This legendary dragon is a powerful engine of destruction. Virtually invincible, very few have faced this awesome creature and lived to tell the tale.','unrestricted'),
(2,'Black Luster Soldier', 'This card can only be Special Summoned by removing 1 LIGHT and 1 DARK monster in your Graveyard from play.','limited'),
(3,'Eclipse Wyvern', 'If this card is sent to the Graveyard: Banish 1 Level 7 or higher LIGHT or DARK Dragon-Type monster from your Deck.','unrestricted'),
(4,'Maiden with Eyes of Blue', 'When this card is targeted for an attack: You can negate the attack, and if you do, change the battle position of this card, then you can Special Summon 1 "Blue-Eyes White Dragon" from your hand, Deck, or Graveyard.','unrestricted'),
(5,'Flamvell Guard', 'A Flamvell guardian who commands fire with his will. His magma-hot barrier protects his troops from intruders.','unrestricted'),
(6,'Swordsman of Revealing Light', 'You can Special Summon this card from your hand, then if this cards DEF is higher than the attacking monsters ATK, destroy that attacking monster.','unrestricted'),
(7,'Mystical Space Typhoon', 'Destroy 1 Spell or Trap Card on the Field.','unrestricted'),
(8,'One for One', 'Send 1 Monster Card from your hand to the Graveyard. Special Summon 1 Level 1 monster from your hand or Deck.','semi-limited'),
(9,'Trade-In', 'Discard 1 Level 8 monster; draw 2 cards.','unrestricted'),
(10,'Compulsory Evacuation Device', 'Return 1 monster on the field to its owners hand.','limited'),
(11,'Genex Ally Birdman', 'You can return 1 face-up monster you control to the hand to Special Summon this card from your hand.','limited'),
(12,'Maxx "C"', 'This turn, each time your opponent Special Summons a monster(s), immediately draw 1 card.','unrestricted'),
(13,'Neo-Spacian Grand Mole', 'If this card attacks or is attacked by an opponents monster you can return both monsters to their owners hands at the start of the Damage Step','limited'),
(14,'Rescue Rabbit', 'You can banish this face-up card you control; Special Summon 2 Level 4 or lower Normal Monsters with the same name from your Deck.','unrestricted'),
(15,'Kabazauls', 'A huge monster in the shape of a hippopotamus. The sneezing from his gigantic body is so fierce that people mistake it for a hurricane.','unrestricted'),
(16,'Sangan', 'When this card is sent from the field to the Graveyard: Add 1 monster with 1500 or less ATK from your Deck to your hand.','limited'),
(17,'Book of Moon', 'Target 1 face-up monster on the field; change that target to face-down Defense Position.','limited'),
(18,'Dark Hole', 'Destroy all monsters on the field.','semi-limited'),
(19,'Enemy Controller', 'Tribute 1 monster, then target 1 face-up monster your opponent controls; take control of that target until the End Phase.','limited'),
(20,'Solemn Warning', 'When a monster(s) would be Summoned, OR when a Spell Card, Trap Card, or monster effect is activated that includes an effect that Special Summons a monster(s): Pay 2000 LP; negate the Summon or activation, and if you do, destroy that card.','unrestricted'),
(21,'Torrential Tribute', 'When a monster(s) is Summoned: Destroy all monsters on the field.','semi-limited'),
(22,'Artifact Beagalltach', 'You can Set this card from your hand to your Spell & Trap Zone as a Spell Card.','unrestricted'),
(23,'Artifact Moralltach', 'During your opponents turn, if this Set card in the Spell & Trap Zone is destroyed and sent to your Graveyard: Special Summon it.','unrestricted'),
(24,'Artifact Scythe', 'If this card is Special Summoned during your opponents turn: Your opponent cannot Special Summon monsters from the Extra Deck for the rest of this turn.','unrestricted'),
(25,'Elemental HERO Bubbleman', 'If this is the only card in your hand, you can Special Summon it (from your hand).','semi-limited'),
(26,'Elemental HERO Shadow Mist', 'If this card is Special Summoned: You can add 1 "Change" Quick-Play Spell Card from your Deck to your hand.','unrestricted'),
(27,'A Hero Lives', 'If you control no face-up monsters: Pay half your LP; Special Summon 1 Level 4 or lower "Elemental HERO" monster from your Deck.','limited'),
(28,'Artifact Ignition', 'Target 1 Spell/Trap Card on the field; destroy that target, and if you do, Set 1 "Artifact" monster directly from your Deck to your Spell & Trap Zone as a Spell Card.','unrestricted'),
(29,'Instant Fusion', 'Pay 1000 LP; Special Summon 1 Level 5 or lower Fusion Monster from your Extra Deck, but it cannot attack, also it is destroyed during the End Phase.','limited'),
(30,'Artifact Sanctum', 'Special Summon 1 "Artifact" monster from your Deck.','unrestricted'),
-- end legal card values --
-- start illegal card values --
(31,'Solemn Judgment', 'When a monster would be Summoned, OR a Spell/Trap Card is activated: Pay half your Life Points; negate the Summon or activation, and if you do, destroy that card.','forbidden'),
(32,'Monster Reborn', 'Target 1 monster in either players Graveyard; Special Summon it.','forbidden'),
(33,'Ring of Destruction', 'Destroy 1 face-up Monster Card and inflict Direct Damage equal to the destroyed cards ATK to the Life Points of both you and your opponent.','forbidden'),
(34,'Time Seal', 'Skip the Draw Phase of your opponents next turn.','forbidden'),
(35,'Cyber-Stein', 'Pay 5000 Life Points. Special Summon 1 Fusion Monster from your Extra Deck to the field in Attack Position.','forbidden');
-- end illegal card values --

INSERT INTO SideDeck_Card(sdid,cid,qty) VALUES
-- start values --
(1,1,1),
(1,29,1),
(1,22,1),
(1,25,1),
(1,11,1),
(2,4,1),
(2,6,1),
(2,15,1),
(2,2,1),
(2,17,1),
(3,5,1),
(3,3,1),
(3,7,1),
(3,4,1),
(4,20,1),
(4,24,1),
(4,29,1),
(4,17,1),
(4,8,1),
(5,19,1),
(5,12,1);
-- end values --

INSERT INTO Deck_Card(did,cid,qty) VALUES
-- start values --
    -- Deck 1 Cards:
(1,1,2),
(1,2,1),
(1,5,3),
(1,18,2),
(1,30,3),
    -- Deck 2 Cards:
(2,10,1),
(2,3,3),
(2,7,3),
(2,15,3),
(2,30,2),
    -- Deck 3 Cards:
(3,4,3),
(3,12,3),
(3,16,1),
(3,17,1),
(3,27,1),
(3,9,3),
-- Deck 4 Cards:
(4,21,2),
(4,11,1),
(4,2,1),
(4,26,3),
(4,30,3),
-- Deck 5 Cards:
(5,28,3),
(5,3,2),
(5,7,1),
(5,6,3),
(5,29,1);
-- end values --

INSERT INTO MonsterCard(cid,star_level,hasEffect,attack,defense,attribute,monster_type) VALUES
-- start values --
(1,8,FALSE,3000,2500,'LIGHT','Dragon'),
(2,8,TRUE,3000,2500,'DARK','Warrior'),
(3,4,TRUE,1600,0,'LIGHT','Dragon'),
(4,1,TRUE,0,0,'LIGHT','Spellcaster'),
(5,2,FALSE,100,2000,'FIRE','Dragon'),
(6,8,TRUE,0,2400,'LIGHT','Warrior'),
(11,3,TRUE,1300,0,'DARK','Machine'),
(12,2,TRUE,0,0,'EARTH','Insect'),
(13,3,TRUE,900,0,'EARTH','Rock'),
(14,4,TRUE,300,100,'EARTH','Beast'),
(15,4,FALSE,1900,0,'WATER','Dinosaur'),
(16,3,TRUE,1300,0,'DARK','Fiend'),
(22,5,TRUE,1400,2100,'LIGHT','Fairy'),
(23,5,TRUE,2100,1400,'LIGHT','Fairy'),
(24,5,TRUE,2200,900,'LIGHT','Fairy'),
(25,4,TRUE,800,1200,'WATER','Warrior'),
(26,4,TRUE,1000,1500,'DARK','Warrior'),
(35,3,TRUE,700,500,'DARK','Machine');
-- end values --

INSERT INTO SpellCard(cid,spell_type) VALUES
-- start values --
(7,'Quick-Play'),
(8,'Normal'),
(9,'Normal'),
(17,'Quick-Play'),
(18,'Normal'),
(19,'Quick-Play'),
(27,'Normal'),
(28,'Quick-Play'),
(29,'Normal'),
(32,'Normal');
-- end values --

INSERT INTO TrapCard(cid,trap_type) VALUES
-- start values --
(10,'Normal'),
(20,'Counter'),
(21,'Normal'),
(30,'Normal'),
(31,'Counter'),
(33,'Normal'),
(34,'Normal');
-- end values --

--------------- Triggers ----------------

DROP FUNCTION IF EXISTS checkLegality();
DROP FUNCTION IF EXISTS check_deck_size();
DROP FUNCTION IF EXISTS check_side_deck_size();
DROP FUNCTION IF EXISTS check_dueling_players();
DROP FUNCTION IF EXISTS check_card_type_monster();
DROP FUNCTION IF EXISTS check_card_type_spell();
DROP FUNCTION IF EXISTS check_card_type_trap();

-- Checks if a forbidden card would be inserted into a deck, and prevents it.
CREATE OR REPLACE FUNCTION checkLegality() RETURNS trigger AS
$$
DECLARE
    currentRecord text;
BEGIN
    FOR currentRecord IN SELECT legality FROM Card WHERE NEW.cid = Card.cid LOOP
        IF  currentRecord = 'forbidden' THEN
            RAISE NOTICE 'Cid % is a forbidden card and cant be used.',NEW.cid;
            RETURN NULL;
        END IF;
    END LOOP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Checks if a deck is too large or small to be used in a tournament. --
CREATE OR REPLACE FUNCTION check_deck_size() RETURNS trigger AS
$$
DECLARE
    --deckID integer;
    totalCards integer := 0;
    currentRecord record;

BEGIN
    --deckID := NEW.did; 
    FOR currentRecord IN SELECT Deck_Card.qty FROM Deck_Card WHERE NEW.did = Deck_Card.did LOOP
        totalCards := totalCards + currentRecord.qty;
    END LOOP;
    IF totalCards > 15 THEN
        RAISE NOTICE 'The new deck is too big. It has % cards.', totalCards;
        RETURN NULL;
    ELSIF totalCards < 10 THEN
        RAISE NOTICE 'The new deck is too small. It has % cards.', totalCards;
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Checks if a side deck is too big to be run alongside a deck. --
CREATE OR REPLACE FUNCTION check_side_deck_size() RETURNS trigger AS
$$
DECLARE
    --deckID integer;
    totalCards integer := 0;
    currentRecord record;

BEGIN
    --deckID := NEW.did; 
    FOR currentRecord IN SELECT SideDeck_Card.qty FROM SideDeck_Card WHERE NEW.sdid = SideDeck_Card.sdid LOOP
        totalCards := totalCards + currentRecord.qty;
    END LOOP;
    IF totalCards > 5 THEN
        RAISE NOTICE 'The new side deck is too big. It has % cards.', totalCards;
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Checks to make sure that players are registered for a tournament they duel in, and are not dueling themselves. --
CREATE OR REPLACE FUNCTION check_dueling_players() RETURNS trigger AS
$$
BEGIN
    IF NEW.player_1_pid = NEW.player_2_pid THEN
        RAISE NOTICE 'A player cannot duel his or herself!';
        RETURN NULL;
    ELSIF NEW.player_1_pid NOT IN(SELECT pid FROM Registration WHERE NEW.tid = Registration.tid) THEN
        RAISE NOTICE 'Player 1 is not registered for that tournament.';
        RETURN NULL;
    ELSIF NEW.player_2_pid NOT IN(SELECT pid FROM Registration WHERE NEW.tid = Registration.tid) THEN
        RAISE NOTICE 'Player 2 is not registered for that tournament.';
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_card_type_monster() RETURNS trigger AS
$$
DECLARE
    multitypeCards integer;
BEGIN
    SELECT count(*) INTO multitypeCards FROM SpellCard, TrapCard
    WHERE NEW.cid = SpellCard.cid
    OR NEW.cid = TrapCard.cid;

    --RAISE NOTICE 'multitype cards: %', multitypeCards;
    IF multitypeCards > 0 THEN
        RAISE NOTICE 'Card is already a trap or spell.';
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_card_type_spell() RETURNS trigger AS
$$
DECLARE
    multitypeCards integer;
BEGIN
    SELECT count(*) INTO multitypeCards FROM MonsterCard, TrapCard
    WHERE NEW.cid = MonsterCard.cid
    OR NEW.cid = TrapCard.cid;

    --RAISE NOTICE 'multitype cards: %', multitypeCards;
    IF multitypeCards > 0 THEN
        RAISE NOTICE 'Card is already a monster or trap.';
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_card_type_trap() RETURNS trigger AS
$$
DECLARE
    multitypeCards integer;
BEGIN
    SELECT count(*) INTO multitypeCards FROM MonsterCard, SpellCard
    WHERE NEW.cid = MonsterCard.cid
    OR NEW.cid = SpellCard.cid;

    --RAISE NOTICE 'multitype cards: %', multitypeCards;
    IF multitypeCards > 0 THEN
        RAISE NOTICE 'Card is already a monster or spell.';
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS checkDeckLegality ON Deck_Card;

CREATE TRIGGER checkDeckLegality
    BEFORE UPDATE OR INSERT ON Deck_Card
    FOR EACH ROW
    EXECUTE PROCEDURE checkLegality();

DROP TRIGGER IF EXISTS checkSideDeckLegality ON SideDeck_Card;

CREATE TRIGGER checkSideDeckLegality
    BEFORE UPDATE OR INSERT ON SideDeck_Card
    FOR EACH ROW
    EXECUTE PROCEDURE checkLegality();


DROP TRIGGER IF EXISTS check_deck_size ON Runs;

CREATE TRIGGER check_deck_size
    BEFORE UPDATE OR INSERT OR DELETE ON Runs
    FOR EACH ROW
    EXECUTE PROCEDURE check_deck_size();

DROP TRIGGER IF EXISTS check_side_deck_size ON Deck;

CREATE TRIGGER check_side_deck_size
    BEFORE UPDATE OR INSERT ON Deck
    FOR EACH ROW
    EXECUTE PROCEDURE check_side_deck_size();

DROP TRIGGER IF EXISTS check_dueling_players ON Duel;

CREATE TRIGGER check_dueling_players
    BEFORE UPDATE OR INSERT ON Duel
    FOR EACH ROW
    EXECUTE PROCEDURE check_dueling_players();

DROP TRIGGER IF EXISTS check_card_type_monster ON Duel;

CREATE TRIGGER check_card_type_monster
    BEFORE UPDATE OR INSERT ON MonsterCard
    FOR EACH ROW
    EXECUTE PROCEDURE check_card_type_monster();

DROP TRIGGER IF EXISTS check_card_type_spell ON Duel;

CREATE TRIGGER check_card_type_spell
    BEFORE UPDATE OR INSERT ON SpellCard
    FOR EACH ROW
    EXECUTE PROCEDURE check_card_type_spell();

DROP TRIGGER IF EXISTS check_card_type_trap ON Duel;

CREATE TRIGGER check_card_type_trap
    BEFORE UPDATE OR INSERT ON TrapCard
    FOR EACH ROW
    EXECUTE PROCEDURE check_card_type_trap();

---------- Views --------------

CREATE VIEW MonsterCardView AS 
    SELECT Card.cid,card_name,flavor_text,legality,star_level,hasEffect,attack,defense,attribute,monster_type
    FROM Card, MonsterCard
    WHERE MonsterCard.cid = Card.cid;

CREATE VIEW SpellCardView AS
    SELECT Card.cid,card_name,flavor_text,legality,spell_type
    FROM Card, SpellCard
    WHERE SpellCard.cid = Card.cid;

CREATE VIEW TrapCardView AS
    SELECT Card.cid,card_name,flavor_text,legality,trap_type
    FROM Card, TrapCard
    WHERE TrapCard.cid = Card.cid;

--------- Stored Procedures ----------

-- Gets the cards in a deck by cid --
DROP FUNCTION IF EXISTS getCardsInDeck(integer);

CREATE OR REPLACE FUNCTION getCardsInDeck(integer) RETURNS TABLE(card_name TEXT, qty INTEGER) AS
$$
DECLARE
    deckID ALIAS FOR $1;
BEGIN
     RETURN QUERY
     SELECT Card.card_name, Deck_Card.qty
     FROM Card, Deck, Deck_Card
     WHERE Card.cid = Deck_Card.cid
     AND Deck.did = Deck_Card.did
     AND Deck.did = deckID;
END;
$$ LANGUAGE plpgsql;

-- Gets the cards in a side deck by cid --
DROP FUNCTION IF EXISTS getCardsInSideDeck(integer);

CREATE OR REPLACE FUNCTION getCardsInSideDeck(integer) RETURNS TABLE(card_name TEXT, qty INTEGER)  AS
$$
DECLARE
    sideDeckID ALIAS FOR $1;
BEGIN
     RETURN QUERY
     SELECT Card.card_name, SideDeck_Card.qty
     FROM Card, SideDeck, SideDeck_Card
     WHERE Card.cid = SideDeck_Card.cid
     AND SideDeck.sdid = SideDeck_Card.sdid
     AND SideDeck.sdid = sideDeckID;
END;
$$ LANGUAGE plpgsql;

-- Gets tournaments a player has registered for --
DROP FUNCTION IF EXISTS getTournaments(integer);

CREATE OR REPLACE FUNCTION getTournaments(integer) RETURNS TABLE(tournament_name TEXT) AS
$$
DECLARE
    playerID ALIAS FOR $1;
BEGIN
     RETURN QUERY
     SELECT Tournament.tournament_name
     FROM Tournament, Player, Registration
     WHERE Tournament.tid = Registration.tid
     AND Player.pid = Registration.pid
     AND Player.pid = playerID;
END;
$$ LANGUAGE plpgsql;

------------ Reports ------------------

-- Show most used cards in decks --
SELECT card_name, count(card_name) AS occurences
FROM Deck, Card, Deck_Card
WHERE Deck.did = Deck_Card.did
AND Deck_Card.cid = Card.cid
GROUP BY card_name
ORDER BY occurences DESC;

-- Show all players registered for a tournament. --
SELECT player_name
FROM Player, Registration,Tournament
WHERE Player.pid = Registration.pid
AND Tournament.tid = Registration.tid
AND Tournament.tid = 1;-- <--tournament id here 

------------ Security ----------

DROP ROLE CheckIn;
DROP ROLE Admin;
DROP ROLE Judge;

CREATE ROLE CheckIn;
CREATE ROLE Admin;
CREATE ROLE Judge;

REVOKE ALL PRIVILEGES ON Duel FROM CheckIn;
REVOKE ALL PRIVILEGES ON Player FROM CheckIn;
REVOKE ALL PRIVILEGES ON Registration FROM CheckIn;
REVOKE ALL PRIVILEGES ON Tournament FROM CheckIn;
REVOKE ALL PRIVILEGES ON Places FROM CheckIn;
REVOKE ALL PRIVILEGES ON Runs FROM CheckIn;
REVOKE ALL PRIVILEGES ON SideDeck FROM CheckIn;
REVOKE ALL PRIVILEGES ON SideDeck_Card FROM CheckIn;
REVOKE ALL PRIVILEGES ON Venue FROM CheckIn;
REVOKE ALL PRIVILEGES ON Deck FROM CheckIn;
REVOKE ALL PRIVILEGES ON Deck_Card FROM CheckIn;
REVOKE ALL PRIVILEGES ON Card FROM CheckIn;
REVOKE ALL PRIVILEGES ON MonsterCard FROM CheckIn;
REVOKE ALL PRIVILEGES ON SpellCard FROM CheckIn;
REVOKE ALL PRIVILEGES ON TrapCard FROM CheckIn;

GRANT SELECT, INSERT, UPDATE, DELETE ON Registration TO CheckIn;
GRANT SELECT, INSERT, UPDATE, DELETE ON Player TO CheckIn;
GRANT SELECT ON Tournament TO CheckIn;

REVOKE ALL PRIVILEGES ON Duel FROM Judge;
REVOKE ALL PRIVILEGES ON Player FROM Judge;
REVOKE ALL PRIVILEGES ON Registration FROM Judge;
REVOKE ALL PRIVILEGES ON Tournament FROM Judge;
REVOKE ALL PRIVILEGES ON Places FROM Judge;
REVOKE ALL PRIVILEGES ON Runs FROM Judge;
REVOKE ALL PRIVILEGES ON SideDeck FROM Judge;
REVOKE ALL PRIVILEGES ON SideDeck_Card FROM Judge;
REVOKE ALL PRIVILEGES ON Venue FROM Judge;
REVOKE ALL PRIVILEGES ON Deck FROM Judge;
REVOKE ALL PRIVILEGES ON Deck_Card FROM Judge;
REVOKE ALL PRIVILEGES ON Card FROM Judge;
REVOKE ALL PRIVILEGES ON MonsterCard FROM Judge;
REVOKE ALL PRIVILEGES ON SpellCard FROM Judge;
REVOKE ALL PRIVILEGES ON TrapCard FROM Judge;

GRANT SELECT, INSERT, UPDATE, DELETE ON Duel TO Judge;
GRANT SELECT, DELETE ON Player TO Judge;
GRANT SELECT ON Registration TO Judge;
GRANT SELECT, DELETE ON Runs TO Judge;
GRANT SELECT ON SideDeck TO Judge;
GRANT SELECT ON SideDeck_Card TO Judge;
GRANT SELECT ON Deck TO Judge;
GRANT SELECT ON Deck_Card TO Judge;
GRANT SELECT ON Card TO Judge;

REVOKE ALL PRIVILEGES ON Duel FROM Admin;
REVOKE ALL PRIVILEGES ON Player FROM Admin;
REVOKE ALL PRIVILEGES ON Registration FROM Admin;
REVOKE ALL PRIVILEGES ON Tournament FROM Admin;
REVOKE ALL PRIVILEGES ON Places FROM Admin;
REVOKE ALL PRIVILEGES ON Runs FROM Admin;
REVOKE ALL PRIVILEGES ON SideDeck FROM Admin;
REVOKE ALL PRIVILEGES ON SideDeck_Card FROM Admin;
REVOKE ALL PRIVILEGES ON Venue FROM Admin;
REVOKE ALL PRIVILEGES ON Deck FROM Admin;
REVOKE ALL PRIVILEGES ON Deck_Card FROM Admin;
REVOKE ALL PRIVILEGES ON Card FROM Admin;
REVOKE ALL PRIVILEGES ON MonsterCard FROM Admin;
REVOKE ALL PRIVILEGES ON SpellCard FROM Admin;
REVOKE ALL PRIVILEGES ON TrapCard FROM Admin;

GRANT SELECT, INSERT, UPDATE, DELETE ON Duel TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Player TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Registration TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Tournament TO Admin;  
GRANT SELECT, INSERT, UPDATE, DELETE ON Places TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Runs TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON SideDeck TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON SideDeck_Card TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Venue TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Deck TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Deck_Card TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON Card TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON MonsterCard TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON SpellCard TO Admin;
GRANT SELECT, INSERT, UPDATE, DELETE ON TrapCard TO Admin;
