--DROPOWANIE TABEL


ALTER TABLE dbo.Ocena
	set (system_versioning=off);

GO

ALTER TABLE dbo.Klasa
	set (system_versioning=off);

GO

ALTER TABLE dbo.Uczen
	set (system_versioning=off);
	
GO

ALTER TABLE dbo.Ocena
	drop PERIOD FOR SYSTEM_TIME ;

GO

ALTER TABLE dbo.Klasa
	drop PERIOD FOR SYSTEM_TIME ;

GO

ALTER TABLE dbo.Uczen
	drop PERIOD FOR SYSTEM_TIME ;

GO

DROP TABLE dbo.Ocena;
DROP TABLE dbo.Przedmiot;
DROP TABLE dbo.Dziennik;
DROP TABLE dbo.Uczen;
DROP TABLE dbo.Kategoria;
DROP TABLE dbo.Klasa;
DROP TABLE dbo.Nauczyciel;


DROP TABLE dbo.OcenaHistory;
DROP TABLE dbo.UczenHistory;
DROP TABLE dbo.KlasaHistory;
