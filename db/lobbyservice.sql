IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'LobbyDB')
BEGIN
    CREATE DATABASE LobbyDB;
END
GO

USE LobbyDB;
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Difficulties' AND xtype='U')
BEGIN
CREATE TABLE Difficulties (
                              Id INT PRIMARY KEY IDENTITY,
                              Name NVARCHAR(100) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Ghosts' AND xtype='U')
BEGIN
CREATE TABLE Ghosts (
                        Id INT PRIMARY KEY IDENTITY,
                        Name NVARCHAR(100) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Participants' AND xtype='U')
BEGIN
CREATE TABLE Participants (
                              Id INT PRIMARY KEY IDENTITY,
                              Name NVARCHAR(100) NOT NULL,
                              Sanity INT NOT NULL,
                              IsDead BIT NOT NULL DEFAULT 0
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Items' AND xtype='U')
BEGIN
CREATE TABLE Items (
                       Id INT PRIMARY KEY IDENTITY,
                       Name NVARCHAR(100) NOT NULL,
                       OwnerId INT NOT NULL,
                       CurrentHolderId INT NOT NULL,
                       FOREIGN KEY (OwnerId) REFERENCES Participants(Id) ON DELETE CASCADE,
                       FOREIGN KEY (CurrentHolderId) REFERENCES Participants(Id) ON DELETE CASCADE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GameSessions' AND xtype='U')
BEGIN
CREATE TABLE GameSessions (
                              Id INT PRIMARY KEY IDENTITY,
                              DifficultyId INT NOT NULL,
                              GhostTypeId INT NOT NULL,
                              MapId INT NOT NULL,
                              FOREIGN KEY (DifficultyId) REFERENCES Difficulties(Id) ON DELETE CASCADE,
                              FOREIGN KEY (GhostTypeId) REFERENCES Ghosts(Id) ON DELETE CASCADE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GameSessionParticipants' AND xtype='U')
BEGIN
CREATE TABLE GameSessionParticipants (
                                         GameSessionId INT NOT NULL,
                                         ParticipantId INT NOT NULL,
                                         PRIMARY KEY (GameSessionId, ParticipantId),
                                         FOREIGN KEY (GameSessionId) REFERENCES GameSessions(Id) ON DELETE CASCADE,
                                         FOREIGN KEY (ParticipantId) REFERENCES Participants(Id) ON DELETE CASCADE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='GameSessionItems' AND xtype='U')
BEGIN
CREATE TABLE GameSessionItems (
                                  GameSessionId INT NOT NULL,
                                  ItemId INT NOT NULL,
                                  PRIMARY KEY (GameSessionId, ItemId),
                                  FOREIGN KEY (GameSessionId) REFERENCES GameSessions(Id) ON DELETE CASCADE,
                                  FOREIGN KEY (ItemId) REFERENCES Items(Id) ON DELETE CASCADE
);
END
GO

IF NOT EXISTS (SELECT 1 FROM Difficulties)
BEGIN
INSERT INTO Difficulties (Name) VALUES
                                    ('Easy'),
                                    ('Medium'),
                                    ('Hard');
END
GO

IF NOT EXISTS (SELECT 1 FROM Ghosts)
BEGIN
INSERT INTO Ghosts (Name) VALUES
                              ('Phantom'),
                              ('Banshee'),
                              ('Wraith');
END
GO

IF NOT EXISTS (SELECT 1 FROM Participants)
BEGIN
INSERT INTO Participants (Name, Sanity, IsDead) VALUES
                                                    ('Player1', 100, 0),
                                                    ('Player2', 80, 0),
                                                    ('Player3', 50, 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM Items)
BEGIN
INSERT INTO Items (Name, OwnerId, CurrentHolderId) VALUES
                                                       ('Flashlight', 1, 1),
                                                       ('EMF Reader', 2, 2),
                                                       ('Candle', 3, 3);
END
GO

IF NOT EXISTS (SELECT 1 FROM GameSessions)
BEGIN
INSERT INTO GameSessions (DifficultyId, GhostTypeId, MapId) VALUES
    (1, 1, 1); 
END
GO

IF NOT EXISTS (SELECT 1 FROM GameSessionParticipants)
BEGIN
INSERT INTO GameSessionParticipants (GameSessionId, ParticipantId) VALUES
                                                                       (1, 1),
                                                                       (1, 2);
END
GO

IF NOT EXISTS (SELECT 1 FROM GameSessionItems)
BEGIN
INSERT INTO GameSessionItems (GameSessionId, ItemId) VALUES
                                                         (1, 1),
                                                         (1, 2);
END
GO