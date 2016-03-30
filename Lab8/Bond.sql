-- Lab 8: Normalization Two. Author: Graham Burek --
DROP TABLE IF EXISTS SpouseOf;
DROP TABLE IF EXISTS ActedIn;
DROP TABLE IF EXISTS DirectorOf;
DROP TABLE IF EXISTS Actors;
DROP TABLE IF EXISTS Movies;
DROP TABLE IF EXISTS Directors;
DROP TABLE IF EXISTS People;
DROP TABLE IF EXISTS Spouses;

-- Table Definitions: --
CREATE TABLE People
(
       pID                 INTEGER NOT NULL, 
       firstName           TEXT NOT NULL,
       lastName            TEXT NOT NULL,
       address             TEXT NOT NULL,
       PRIMARY KEY(pID)
);


CREATE TABLE Actors
(
       pID                 INTEGER NOT NULL REFERENCES People(pID),
       birthDate           DATE NOT NULL,
       hairColor           TEXT,
       eyeColor            TEXT,
       heightInches        NUMERIC(4,1),
       weightLbs           NUMERIC(4,1),
       favoriteColor       TEXT,
       screenGuildAnivDate DATE,
       PRIMARY KEY(pID)
);

CREATE TABLE Directors
(
       pID                    INTEGER NOT NULL REFERENCES People(pID),
       filmSchool             TEXT ,
       directorsGuildAnivDate DATE,
       favoriteLensMaker      TEXT,
       PRIMARY KEY(pID)
);

CREATE TABLE Spouses
(
       sID       INTEGER NOT NULL,
       firstName TEXT NOT NULL,
       lastName  TEXT NOT NULL,
       PRIMARY KEY(sID)
);

CREATE TABLE SpouseOf
(
       pID     INTEGER NOT NULL REFERENCES People(pID),
       sID     INTEGER NOT NULL REFERENCES Spouses(sID),
       PRIMARY KEY(pID,sID)
);


CREATE TABLE Movies
(
       mID                  INTEGER NOT NULL,
       title                TEXT NOT NULL,
       yearReleased         INTEGER NOT NULL,
       mpaaNumber           INTEGER,
       domesticBoxSalesUSD  BIGINT NOT NULL,
       foreignBoxSalesUSD   BIGINT NOT NULL,
       homeVideoSalesUSD    BIGINT NOT NULL,
       PRIMARY KEY(mID)
);

CREATE TABLE DirectorOf
(
       pID INTEGER NOT NULL REFERENCES Directors(pID),
       mID INTEGER NOT NULL REFERENCES Movies(mID),
       PRIMARY KEY(pID,mID)

);

CREATE TABLE ActedIn
(
       mID INTEGER NOT NULL REFERENCES Movies(mID),
       pID INTEGER NOT NULL REFERENCES Actors(pID),
       PRIMARY KEY(mID, pID)
);


-- Sample data for database: --

INSERT INTO People(pID, firstName, lastName,address) 
VALUES (1, 'Sean', 'Connery', '937 Victory Blvd');

INSERT INTO People(pID, firstName, lastName,address) 
VALUES (2, 'George', 'Lucas', '123 Pleasantvile');

INSERT INTO People(pID, firstName, lastName,address) 
VALUES (3, 'Steven', 'Spielberg', 'Unknown St.');

INSERT INTO Actors(pID, birthDate, hairColor,eyeColor, heightInches, weightLbs, favoriteColor, screenGuildAnivDate) 
VALUES (1, '1980-01-08', 'Black', 'Blue', 60, 150, 'Green', NULL);

INSERT INTO Directors(pID, filmSchool, directorsGuildAnivDate, favoriteLensMaker)
VALUES(2, NULL, NULL, NULL);

INSERT INTO Directors(pID, filmSchool, directorsGuildAnivDate, favoriteLensMaker)
VALUES(3, NULL, NULL, NULL);

INSERT INTO Movies(mID, title, yearReleased,mpaaNumber,domesticBoxSalesUSD, foreignBoxSalesUSD, homeVideoSalesUSD)
VALUES(1, 'Star Wars', 1980, 23432,1000000,2000000,3000000);

INSERT INTO Movies(mID, title, yearReleased,mpaaNumber,domesticBoxSalesUSD, foreignBoxSalesUSD, homeVideoSalesUSD)
VALUES(2, 'Goldfinger', 1990, 23432,1000000,2000000,3000000);

INSERT INTO ActedIn(mID,pID)
VALUES(1,1);

INSERT INTO ActedIn(mID,pID)
VALUES(2,1);

INSERT INTO DirectorOf(pID,mID)
VALUES(2, 1);

INSERT INTO DirectorOf(pID,mID)
VALUES(3, 2);

--Write a query to show all the directors with whom actor “Sean Connery” has worked.--

SELECT p.firstName, p.lastName
FROM  People p, Directors d, Movies m, DirectorOf dirOf
WHERE d.pID = p.pID
AND   dirOf.pID = d.pID
AND   dirOf.mID = m.mID
AND m.mID IN (SELECT m.mID
              FROM   People p, Actors a, Movies m, ActedIn actIn
              WHERE  p.pID = a.pID
              AND    actIn.pID = a.pID
              AND    actIn.mID = m.mID
              AND    p.firstName = 'Sean'
              AND    p.lastName  = 'Connery'
             );
                                                                                                            
