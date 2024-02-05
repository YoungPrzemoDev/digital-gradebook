CREATE TABLE Kategoria (
    id INT NOT NULL PRIMARY KEY,
    nazwa VARCHAR(20) NOT NULL,
    waga INT NOT NULL,
);

CREATE TABLE Nauczyciel (
    id INT NOT NULL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(20) NOT NULL,
	stopien_Naukowy varchar(20)
);

CREATE TABLE Klasa (
    id INT NOT NULL PRIMARY KEY,
    nazwa VARCHAR(20) NOT NULL,
    wychowawca Int,
	dataOd datetime2(0) GENERATED ALWAYS AS ROW START NOT NULL,
	dataDo datetime2(0) GENERATED ALWAYS AS ROW END NOT NULL,
	Foreign key (wychowawca) references Nauczyciel(id),
PERIOD FOR SYSTEM_TIME (dataOd, dataDo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.KlasaHistory));

CREATE TABLE Dziennik (
    id INT NOT NULL PRIMARY KEY,
    nazwa VARCHAR(20) NOT NULL,
	uwagi INT,
	zwolnienia INT,
	id_klasy INT,
	Foreign key (id_klasy) references Klasa(id)
);


CREATE TABLE Uczen (
    id INT NOT NULL PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(20) NOT NULL,
	numerTel INT NOT NULL,
	zachowanie INT NOT NULL,
	dataOd datetime2(0) GENERATED ALWAYS AS ROW START NOT NULL,
	dataDo datetime2(0) GENERATED ALWAYS AS ROW END NOT NULL,
	id_klasy INT,
	Foreign key (id_klasy) references Klasa(id),
	 PERIOD FOR SYSTEM_TIME (dataOd, dataDo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.UczenHistory));



CREATE TABLE Przedmiot (
    id INT NOT NULL PRIMARY KEY,
    nazwa VARCHAR(50) NOT NULL,
	opis VARCHAR(100)
);

CREATE TABLE Ocena (
   id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
   ocena DECIMAL(2,1) NOT NULL,
   dataOd datetime2(0) GENERATED ALWAYS AS ROW START NOT NULL,
   dataDo datetime2(0) GENERATED ALWAYS AS ROW END NOT NULL,
   id_przedmiotu INT,
   id_nauczyciela INT,
   id_dziennika INT,
   id_kategorii INT,
   id_ucznia INT,
   Foreign key (id_przedmiotu) references Przedmiot(id),
   Foreign key (id_nauczyciela) references Nauczyciel(id),
   Foreign key (id_dziennika) references Dziennik(id),
   Foreign key (id_kategorii) references Kategoria(id),
   Foreign key (id_ucznia) references Uczen(id),
   PERIOD FOR SYSTEM_TIME (dataOd, dataDo)
) WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.OcenaHistory));