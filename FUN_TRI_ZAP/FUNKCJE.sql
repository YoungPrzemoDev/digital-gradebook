--FUNKCJE

--FUNKCJA NA SPRAWDZENIE POPRAWNOŚCI WPISANEJ OCENY

CREATE or alter FUNCTION SprawdzPrzedzialOceny(@ocena DECIMAL(2,1)) 
RETURNS BIT
AS
BEGIN
    DECLARE @wynik BIT;
    
    IF @ocena >= 1.0 AND @ocena <= 6.0
        SET @wynik = 1; -- Ocena mieści się w przedziale
    ELSE
        SET @wynik = 0; -- Ocena nie mieści się w przedziale
    
    RETURN @wynik;
END;

GO 
--SPRAWDZENIE FUNKCJONALNOŚCI

Select dbo.SprawdzPrzedzialOceny(7) as 'ocena  meisci sie w przedziale';
Select dbo.SprawdzPrzedzialOceny(4) as 'ocena  meisci sie w przedziale';
Select dbo.SprawdzPrzedzialOceny(3.5) as 'ocena  meisci sie w przedziale';
Select dbo.SprawdzPrzedzialOceny(0) as 'ocena  meisci sie w przedziale';
Select dbo.SprawdzPrzedzialOceny(-1) as 'ocena  meisci sie w przedziale';

--FUNKCJA NA SPRAWDZENIE CZY PRZYPISANIE NAZWY DO DZIENNIKA KLASY JEST POPRAWNE
 GO 

CREATE or alter FUNCTION SprawdzDziennik(@nazwa VARCHAR(10)) RETURNS BIT
AS
BEGIN
    DECLARE @wynik BIT;

    IF @nazwa LIKE '[1-8][A-E]'
        SET @wynik = 1; -- Nazwa jest akceptowana 
    ELSE
        SET @wynik = 0; -- Nazw nie jest akceptowana 
    
    RETURN @wynik;
END;
GO 
--SPRAWDZENIE FUNKCJONALNOŚCI

Select dbo.SprawdzDziennik('8A') as 'Zaakceptowano';
Select dbo.SprawdzDziennik('1A') as 'Zaakceptowano';
Select dbo.SprawdzDziennik('4C') as 'Zaakceptowano';
Select dbo.SprawdzDziennik('8G') as 'zaakceptowano';
Select dbo.SprawdzDziennik('15') as 'zaakceptowano';
Select dbo.SprawdzDziennik('15A') as 'zaakceptowano';
GO 

--FUNKCJA NA SPRAWDZENIE POPRAWNOŚCI ZACHOWANIA
CREATE or alter FUNCTION SprawdzZachowanie(@zachowanie INT) 
RETURNS BIT
AS
BEGIN
    DECLARE @wynik BIT;
    
    IF @zachowanie >= 3 AND @zachowanie <= 6
        SET @wynik = 1; -- Ocena mieści się w przedziale
    ELSE
        SET @wynik = 0; -- Ocena nie mieści się w przedziale
    
    RETURN @wynik;
END;
GO 
--SPRAWDZENIE FUNKCJONALNOŚCI

SELECT dbo.SprawdzZachowanie(2)  as 'Poprawne';
SELECT dbo.SprawdzZachowanie(3)  as 'Poprawne';
GO 
CREATE or alter FUNCTION koniecRoku() 
RETURNS INT
AS
BEGIN
	DECLARE @data DATE;
    DECLARE @koniecRoku DATE;
    DECLARE @liczbaDni INT;

	SET @data = GETDATE();
    SET @koniecRoku = DATEFROMPARTS(YEAR(@data), 6, 30);
    SET @liczbaDni = DATEDIFF(DAY, @data, @koniecRoku);

    IF @liczbaDni < 0
        SET @liczbaDni = 0;

    RETURN @liczbaDni;
END;
GO 

--SPRAWDZENIE
Select dbo.koniecRoku() as 'KONIEC ROKU ZA';
GO 

CREATE or alter FUNCTION SprawdzOcene(@wartosc VARCHAR(100)) RETURNS BIT
AS
BEGIN
    DECLARE @czyLiczba BIT;
    
    SET @czyLiczba = CASE WHEN ISNUMERIC(@wartosc) = 1 
	AND @wartosc NOT LIKE '%[^0-9.]%' THEN 1 ELSE 0 END;
    
    RETURN @czyLiczba;
END;
GO 
--SPRAWDZENIE
Select dbo.SprawdzOcene(2.5) as 'Poprawne';
Select dbo.SprawdzOcene('2.0 sa') as 'Poprawne';
Select dbo.SprawdzOcene('asd') as 'Poprawne';
Select dbo.SprawdzOcene('2.5') as 'Poprawne';



