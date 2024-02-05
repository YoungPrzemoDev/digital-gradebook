--WYLACZENIE WERSJONOWANIA
ALTER TABLE dbo.Ocena
	set (system_versioning=off);

ALTER TABLE dbo.Klasa
	set (system_versioning=off);

ALTER TABLE dbo.Uczen
	set (system_versioning=off);
	

ALTER TABLE dbo.Ocena
	drop PERIOD FOR SYSTEM_TIME ;

ALTER TABLE dbo.Klasa
	drop PERIOD FOR SYSTEM_TIME ;

ALTER TABLE dbo.Uczen
	drop PERIOD FOR SYSTEM_TIME ;
	


	--WlACZENIE WERSJONOWANIA
ALTER TABLE dbo.Ocena
	add PERIOD FOR SYSTEM_TIME(dataOd, dataDo);

ALTER TABLE dbo.Klasa
	add PERIOD FOR SYSTEM_TIME(dataOd, dataDo);

ALTER TABLE dbo.Uczen
	add PERIOD FOR SYSTEM_TIME(dataOd, dataDo);
	


ALTER TABLE dbo.Ocena
	set (system_versioning=on(history_table = dbo.OcenaHistory));

ALTER TABLE dbo.Klasa
	set (system_versioning=on(history_table = dbo.KlasaHistory));

ALTER TABLE dbo.Uczen
	set (system_versioning=on(history_table = dbo.UczenHistory));
	

