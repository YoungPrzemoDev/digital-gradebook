--ZAPYTANIA 


--LICZENIE ŚREDNIEJ DLA OKRESLONEGO UCZNIA ZE WSZYSTKICH LAT NAUKI Z PODZIALEM NA SEMESTRY
-------------------------------------------------
Create or alter procedure sredniaSem @uczenId  INT
As

DECLARE @TEMP DATE
DECLARE @sem DATE
DECLARE @kolejnySem DATE
SET @sem = (SELECT MIN(u.dataOd) FROM dbo.UczenHistory u)
SET @kolejnySem = DATEADD(MONTH, 5, @sem)
WHILE @sem <= GETDATE()
BEGIN
    SELECT 
		CAST(
			ROUND(
				(
				    SELECT (SUM(CASE WHEN ka.waga = 2 THEN o.ocena END) * 2)
				         + (SUM(CASE WHEN ka.waga = 3 THEN o.ocena END) * 3)
				    FROM dbo.Kategoria ka
				    INNER JOIN dbo.Ocena for System_Time  CONTAINED IN (@sem , @kolejnySem) o ON o.id_kategorii = ka.id
				    WHERE o.id_ucznia = @uczenId
				   
				) 
				/
				(
				    SELECT (COUNT(CASE WHEN ka.waga = 2 THEN o.ocena END) * 2)
				         + (COUNT(CASE WHEN ka.waga = 3 THEN o.ocena END) * 3)
				    FROM dbo.Kategoria ka
				    INNER JOIN dbo.Ocena for System_Time  CONTAINED IN (@sem , @kolejnySem) o ON o.id_kategorii = ka.id
				    WHERE o.id_ucznia =@uczenId
			),2) AS decimal(10,2)) AS 'Srednia wazona' , CONCAT(u.imie,' ',u.nazwisko) as 'Uczen', CONCAT(YEAR(@sem),' / ',YEAR(@kolejnySem)) as 'Rok',
		(Case when Month(@sem) >= '08' Then 'Zimowy' 
			  else 'Letni' END) as 'Semestr' 
		
		from dbo.Uczen u
		where u.id = @uczenId
		order by 'Semestr'

		SET @TEMP = @sem
	    SET @sem = @kolejnySem
	    SET @kolejnySem = DATEADD(YEAR,1,@TEMP)
END

EXEC dbo.sredniaSem 5

Go

--LICZENIE ŚREDNIEJ DLA WSZYSTKICH UCZNIÓW ZE WSZYSTKICH LAT NAUKI Z PODZIALEM NA SEMESTRY
----------------------------------------------------------------------------------------------------

DECLARE @uczenId INT 
DECLARE @sem DATE
DECLARE @kolejnySem DATE
DECLARE @TEMP DATE


DECLARE uczenCursor CURSOR FOR
SELECT TOP 24 id
FROM dbo.Uczen
OPEN uczenCursor 
FETCH NEXT FROM uczenCursor INTO @uczenId
WHILE @@FETCH_STATUS = 0 
BEGIN
SET @sem = (SELECT MIN(u.dataOd) FROM dbo.UczenHistory u)
SET @kolejnySem = DATEADD(MONTH, 5, @sem)

	WHILE @sem <= GETDATE()
	BEGIN
	    SELECT 
			CAST(
				ROUND(
					(
					    SELECT (ISNULL(SUM(CASE WHEN ka.waga = 2 THEN o.ocena END),0) * 2)
					         + (ISNULL(SUM(CASE WHEN ka.waga = 3 THEN o.ocena END),0) * 3)
					    FROM dbo.Kategoria ka
					    INNER JOIN dbo.Ocena for System_Time  CONTAINED IN( @sem , @kolejnySem) o ON o.id_kategorii = ka.id
					    WHERE o.id_ucznia = @uczenId
					   
					) 
					/
					(
					    SELECT (ISNULL(COUNT(CASE WHEN ka.waga = 2 THEN o.ocena END),0) * 2)
					         + (ISNULL(COUNT(CASE WHEN ka.waga = 3 THEN o.ocena END),0) * 3)
					    FROM dbo.Kategoria ka
					    INNER JOIN dbo.Ocena for System_Time  CONTAINED IN( @sem , @kolejnySem) o ON o.id_kategorii = ka.id
					    WHERE o.id_ucznia =@uczenId
				),2) AS decimal(10,2)) AS 'Srednia wazona' ,CONCAT(u.imie,' ',u.nazwisko) as 'Uczen', CONCAT(YEAR(@sem),' / ',YEAR(@kolejnySem)) as 'Rok',
			(Case when Month(@sem) >= '08' Then 'Zimowy' 
				  else 'Letni' END) as 'Semestr' 
			
			from dbo.Uczen u
			where u.id = @uczenId
			order by 'Semestr'
		
		SET @TEMP = @sem
	    SET @sem = @kolejnySem
	    SET @kolejnySem = DATEADD(YEAR,1,@TEMP)
	END
	FETCH NEXT FROM uczenCursor INTO @uczenId
END

CLOSE uczenCursor
DEALLOCATE uczenCursor

GO

--Sprawdzenie ze CONTAINED IN dziala nie dublując wartosci z przedziałow
--wynik z kazdej daty to 37 bo tyle kazdy ma ocen w semestrze
DECLARE @uczenId INT 
DECLARE @TEMP DATE
SET @uczenId = 4
DECLARE @sem DATE
DECLARE @kolejnySem DATE
SET @sem = (SELECT MIN(u.dataOd) FROM dbo.UczenHistory u)
SET @kolejnySem = DATEADD(MONTH, 5, @sem)
WHILE @sem <= GETDATE()
BEGIN
    SELECT 
		COUNT(1) from dbo.Ocena  for System_Time CONTAINED IN( @sem , @kolejnySem) o
		where o.id_ucznia =@uczenId

		SET @TEMP = @sem
	    SET @sem = @kolejnySem
	    SET @kolejnySem = DATEADD(YEAR,1,@TEMP)
END

GO

--EWIDENCJA OCEN Z ZACHOWAANIA DLA KAZDEWGO UCZNIA NA PRZESTRZENI LAT Z KAZDEGO SEMESTRU
----------------------------------------------------------------------------------------------------------
DECLARE @uczenId INT 
DECLARE @sem DATE
DECLARE @kolejnySem DATE
DECLARE @TEMP DATE


SET @sem = (SELECT MIN(kl.dataOd) FROM dbo.KlasaHistory kl)
SET @kolejnySem = DATEADD(MONTH, 5, @sem)
WHILE @sem <= GETDATE()
	BEGIN
		Select kl.nazwa as 'Klasa',CONCAT(u.imie,' ',u.nazwisko) as 'Uczen', u.zachowanie as 'Ocena z zachowania',
		CONCAT(YEAR(@sem),' / ',YEAR(@kolejnySem)) as 'Rok'
		from dbo.Klasa  kl
		INNER JOIN 	dbo.Uczen  for System_Time CONTAINED IN (@sem,@kolejnySem) u ON kl.id = u.id_klasy
		
		order by kl.nazwa asc

		
	    SET @TEMP = @sem
	    SET @sem = @kolejnySem
	    SET @kolejnySem = DATEADD(YEAR,1,@TEMP)
END

GO

--EWIDENCJA NAJLEPSZYCH 10 UCZNIÓW Z KAZDEGO PRZEDMNIOTU Z KAZDEGO SEMESTRU NA PRZESTRZENI LAT
-----------------------------------------------------------------------------------------------------

Create or alter procedure bestSredniaFromEveryPrzedmniot @sem DATE
As
DECLARE @kolejnySem DATE
DECLARE @TEMP DATE
DECLARE @przedmiotId INT

SET @przedmiotId =1
SET @kolejnySem = DATEADD(MONTH, 7, @sem)

WHILE @przedmiotId < 19
BEGIN
	SELECT TOP 10 (

        (ISNULL(SUM(CASE WHEN ka.waga = 2 THEN o.ocena END),0) * 2)
        + (ISNULL(SUM(CASE WHEN ka.waga = 3 THEN o.ocena END),0) * 3)
		)
		/
		(
        (ISNULL(COUNT(CASE WHEN ka.waga = 2 THEN o.ocena END),0) * 2)
        + (ISNULL(COUNT(CASE WHEN ka.waga = 3 THEN o.ocena END),0) * 3)
    ) AS 'Srednia z przedmiotu', CONCAT(u.imie, ' ', u.nazwisko) AS 'Uczen', p.nazwa as 'Przedmiot',CONCAT(YEAR(@sem),' / ',YEAR(@kolejnySem)) as 'Rok'
		FROM dbo.Uczen u
		INNER JOIN dbo.Ocena for System_Time CONTAINED IN (@sem, @kolejnySem) o ON u.id = o.id_ucznia
		INNER JOIN dbo.Kategoria ka ON o.id_kategorii = ka.id
		INNER JOIN dbo.Przedmiot p ON p.id = o.id_przedmiotu
		WHERE o.id_przedmiotu = @przedmiotId
		GROUP BY u.imie, u.nazwisko, p.nazwa,u.id
		Order by 'Srednia z przedmiotu' desc

		
		SET @przedmiotId = @przedmiotId +1
		
END


EXEC dbo.bestSredniaFromEveryPrzedmniot '2016-02-01 00:00:00'

Go


--KLASA Z NAJWIEKSZA ILSOCIA ZWOLNIEŃ I UWAG W CAŁYM CZASIE NAUKi
--------------------------------------------------------------------------

DECLARE @sem DATE
DECLARE @kolejnySem DATE

SET @sem = (SELECT MIN(u.dataOd) FROM dbo.UczenHistory u)
SET @kolejnySem = GETDATE()

SELECT TOP 1
dz.nazwa AS 'KLASA',CONCAT(na.imie, '', na.nazwisko) AS 'Wychowawca', dz.uwagi AS 'Liczba uwag', dz.zwolnienia AS 'Liczba zwolnien',  COUNT(*) AS 'Liczba wpisow'
FROM dbo.Dziennik dz
INNER JOIN dbo.Klasa kl ON kl.id = dz.id_klasy
INNER JOIN dbo.Nauczyciel na ON na.id = kl.wychowawca
WHERE dz.id IN (
		SELECT TOP 1 dz.id
		FROM dbo.Dziennik dz
		WHERE dz.uwagi = (SELECT MAX(uwagi) FROM dbo.Dziennik)
)

GROUP BY dz.nazwa, CONCAT(na.imie, '', na.nazwisko), dz.uwagi, dz.zwolnienia
ORDER BY COUNT(*) DESC -- Order by the count of entries in descending order


GO
--PIVOT NA EWIDENCJE OCENY 2 PREZEZ KAZFEGO UCZNIA
--------------------------------------------------------
SELECT Uczen, [rok1], [rok2], [rok3], [rok4],[rok5],[rok6],[rok7],[rok8]
FROM (
    SELECT CONCAT(u.imie, ' ', u.nazwisko) AS 'Uczen', ocena,
	CASE WHEN o.dataOd>='2015-09-01 00:00:00' AND o.dataDo<='2016-08-31 23:59:59' THEN 'rok1'
	     WHEN o.dataOd>='2016-09-01 00:00:00' AND o.dataDo<='2017-08-31 23:59:59' THEN 'rok2'
		 WHEN o.dataOd>='2017-09-01 00:00:00' AND o.dataDo<='2018-08-31 23:59:59' THEN 'rok3'
		 WHEN o.dataOd>='2018-09-01 00:00:00' AND o.dataDo<='2019-08-31 23:59:59' THEN 'rok4'
		 WHEN o.dataOd>='2019-09-01 00:00:00' AND o.dataDo<='2020-08-31 23:59:59' THEN 'rok5'
		 WHEN o.dataOd>='2020-09-01 00:00:00' AND o.dataDo<='2021-08-31 23:59:59' THEN 'rok6'
		 WHEN o.dataOd>='2021-09-01 00:00:00' AND o.dataDo<='2022-08-31 23:59:59' THEN 'rok7'
		 WHEN o.dataOd>='2022-09-01 00:00:00' AND o.dataDo<='9999-12-31 23:59:59' THEN 'rok8'
		 ELSE 'rok9'
		END AS 'Rok'
	FROM Ocena FOR SYSTEM_TIME ALL o
	INNER JOIN Uczen for system_time ALL u ON u.id=o.id_ucznia
	WHERE o.dataDo>=u.dataOd AND o.dataOd<=u.dataDo AND o.ocena=2 and u.id_klasy =1
) AS SourceData
PIVOT (
    COUNT(ocena)  
    FOR [Rok] IN ([rok1], [rok2], [rok3], [rok4],[rok5],[rok6],[rok7],[rok8])
) AS PivotTable;


GO
---UCZEN KTORY NIE SIE UCZY (NAJWIEKSZA ILOSC OCENY 2)
--------------------------------------------------------
DECLARE @uczenId INT
DECLARE @sem DATE
DECLARE @kolejnySem DATE
DECLARE @TEMP DATE

SET @sem = (SELECT MIN(kl.dataOd) FROM dbo.KlasaHistory kl)
SET @kolejnySem = DATEADD(MONTH, 5, @sem)

WHILE @sem <= GETDATE()
BEGIN
    SELECT TOP 1 CONCAT(u.imie, '', u.nazwisko) AS 'Uczen', CONCAT(YEAR(@sem),' / ',YEAR(@kolejnySem)) as 'Rok'
    FROM dbo.Uczen FOR SYSTEM_TIME CONTAINED IN (@sem, @kolejnySem) u
    WHERE u.id IN (SELECT o.id_ucznia
				   FROM dbo.Ocena FOR SYSTEM_TIME CONTAINED IN (@sem, @kolejnySem) o
				   WHERE o.ocena = 5
				   GROUP BY o.id_ucznia
				   HAVING COUNT(o.ocena) = (SELECT MAX(gradeCount)
											FROM (SELECT id_ucznia, COUNT(*) AS gradeCount
											      FROM dbo.Ocena FOR SYSTEM_TIME CONTAINED IN (@sem, @kolejnySem) o
											      WHERE o.ocena = 5
											      GROUP BY id_ucznia
												  ) AS counts
											)
					)
GROUP BY
        u.id, u.imie, u.nazwisko
    SET @TEMP = @sem
    SET @sem = @kolejnySem
    SET @kolejnySem = DATEADD(YEAR, 1, @TEMP)
END