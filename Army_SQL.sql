CREATE DATABASE Информационная_система_военного_округа;
GO

USE Информационная_система_военного_округа;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Вид_войск')
BEGIN
CREATE TABLE Вид_войск
(
    Код_вид_войск INT PRIMARY KEY,
    Название_вида_войск VARCHAR(50) UNIQUE NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Места_дислокации')
BEGIN
CREATE TABLE Места_дислокации
(
    Код_места_дислокации INT PRIMARY KEY,
    Страна VARCHAR(50) NOT NULL,
    Город VARCHAR(50) NOT NULL,
    Адрес VARCHAR(50) NOT NULL,
    Занимаемая_площадь VARCHAR(50) NOT NULL,
    Количество_сооружений INT NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Часть')
BEGIN
CREATE TABLE Часть
(
    Код_части INT PRIMARY KEY,
    Номер_части INT NOT NULL,
    Код_места_дислокации INT NOT NULL,
    Код_вид_войск INT NOT NULL,
    Колво_рот INT NOT NULL,
    Количество_техники INT NOT NULL,
    Количество_вооружений INT NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Техника')
BEGIN
CREATE TABLE Техника
(
    Код_техники INT PRIMARY KEY,
    Название_техники VARCHAR(50) NOT NULL,
    Код_части INT NOT NULL,
    Характеристики VARCHAR(100) NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Вооружение')
BEGIN
CREATE TABLE Вооружение
(
    Код_вооружения INT PRIMARY KEY,
    Название_вооружения VARCHAR(50) NOT NULL,
    Код_части INT NOT NULL,
    Характеристики VARCHAR(100) NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Часть_Вид_войск')
BEGIN
    ALTER TABLE Часть
    ADD CONSTRAINT FK_Часть_Вид_войск FOREIGN KEY (Код_вид_войск) REFERENCES Вид_войск(Код_вид_войск);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Часть_Места_дислокации')
BEGIN
    ALTER TABLE Часть
    ADD CONSTRAINT FK_Часть_Места_дислокации FOREIGN KEY (Код_места_дислокации) REFERENCES Места_дислокации(Код_места_дислокации);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Техника_Часть')
BEGIN
    ALTER TABLE Техника
    ADD CONSTRAINT FK_Техника_Часть FOREIGN KEY (Код_части) REFERENCES Часть(Код_части);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_Вооружение_Часть')
BEGIN
    ALTER TABLE Вооружение
    ADD CONSTRAINT FK_Вооружение_Часть FOREIGN KEY (Код_части) REFERENCES Часть(Код_части);
END
GO

USE master;
GO

EXEC xp_create_subdir 'C:\SQLAudit\';
GO

CREATE SERVER AUDIT ServerAudit
TO FILE (FILEPATH = 'C:\SQLAudit\')
WITH (ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT ServerAudit
WITH (STATE = ON);
GO

CREATE SERVER AUDIT SPECIFICATION ServerAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (FAILED_LOGIN_GROUP),
ADD (BACKUP_RESTORE_GROUP),
ADD (USER_CHANGE_PASSWORD_GROUP)
WITH (STATE = ON);
GO

USE Информационная_система_военного_округа;
GO

CREATE DATABASE AUDIT SPECIFICATION DatabaseAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (INSERT, UPDATE, DELETE ON Вид_войск BY public)
WITH (STATE = ON);
GO