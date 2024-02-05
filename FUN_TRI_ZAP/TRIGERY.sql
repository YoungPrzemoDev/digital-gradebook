--TRIGERY


--Trigery na wprowadzanie poprawnej oceny zarówno Insert jak i Update
CREATE TRIGGER poprawnaOcena ON dbo.Ocena
AFTER INSERT AS
IF(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =1 
and (Select dbo.SprawdzOcene(ocena) from inserted) =1 Return 
If(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =0 
and (Select dbo.SprawdzOcene(ocena) from inserted) =1
Begin
Raiserror ('Błedny format oceny, Poprawny przedział: [1.0-6.0]',2,1)
Rollback Transaction
Return
END
If(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =1 
and (Select dbo.SprawdzOcene(ocena) from inserted) =0
Begin
Raiserror ('Zostały podane błędne znaki, Tylko liczby!',2,1)
Rollback Transaction
Return
END;

GO

CREATE TRIGGER poprawnaOcena_2 ON dbo.Ocena
AFTER Update AS
IF(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =1 
and (Select dbo.SprawdzOcene(ocena) from inserted) =1 Return 
If(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =0 
and (Select dbo.SprawdzOcene(ocena) from inserted) =1
Begin
Raiserror ('Błedny format oceny, Poprawny przedział: [1.0-6.0]',2,1)
Rollback Transaction
Return
END
If(Select dbo.SprawdzPrzedzialOceny(ocena) FROM inserted) =1 
and (Select dbo.SprawdzOcene(ocena) from inserted) =0
Begin
Raiserror ('Zostały podane błędne znaki, Tylko liczby!',2,1)
Rollback Transaction
Return
END;

Go
----------------- TRIGER NA OCENE Z ZACHOWANIA

CREATE TRIGGER poprawneZachowanie ON dbo.Uczen
AFTER INSERT AS
IF(Select dbo.SprawdzZachowanie(zachowanie) FROM inserted) =1 Return 
If(Select dbo.SprawdzZachowanie(zachowanie) FROM inserted) =0 Begin
Raiserror ('Błedny format oceny z zachowania, Poprawny przedział: [3-6]',2,0)
Rollback Transaction
Return
END

Go

CREATE TRIGGER poprawneZachowanie2 ON dbo.Uczen
AFTER Update AS
IF(Select dbo.SprawdzZachowanie(zachowanie) FROM inserted) =1 Return 
If(Select dbo.SprawdzZachowanie(zachowanie) FROM inserted) =0 Begin
Raiserror ('Błedny format oceny z zachowania, Poprawny przedział: [3-6]',2,0)
Rollback Transaction
Return
END