IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'MapDB')
BEGIN
    CREATE DATABASE MapDB;
END
GO

USE MapDB;
GO


IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Houses' AND xtype='U')
BEGIN
CREATE TABLE Houses (
                        Id INT PRIMARY KEY IDENTITY,
                        Name NVARCHAR(100) NOT NULL
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Rooms' AND xtype='U')
BEGIN
CREATE TABLE Rooms (
                       Id INT PRIMARY KEY IDENTITY,
                       HouseId INT NOT NULL,
                       FOREIGN KEY (HouseId) REFERENCES Houses(Id) ON DELETE CASCADE
);
END
GO

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Objects' AND xtype='U')
BEGIN
CREATE TABLE Objects (
                         Id INT PRIMARY KEY IDENTITY,
                         RoomId INT NOT NULL,
                         Name NVARCHAR(100) NOT NULL,
                         IsHiding BIT NOT NULL,
                         FOREIGN KEY (RoomId) REFERENCES Rooms(Id) ON DELETE CASCADE
);
END
GO


IF NOT EXISTS (SELECT 1 FROM Houses)
BEGIN
INSERT INTO Houses (Name) VALUES ('Haunted Mansion');
END
GO

IF NOT EXISTS (SELECT 1 FROM Rooms)
BEGIN
INSERT INTO Rooms (HouseId) VALUES (1);
END
GO

IF NOT EXISTS (SELECT 1 FROM Objects)
BEGIN
INSERT INTO Objects (RoomId, Name, IsHiding) VALUES
                                                 (1, 'Old Chest', 0),
                                                 (1, 'Magic Mirror', 1),
                                                 (1, 'Candle', 0);
END
GO
