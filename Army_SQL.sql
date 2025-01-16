CREATE DATABASE ��������������_�������_��������_������;
GO

USE ��������������_�������_��������_������;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '���_�����')
BEGIN
CREATE TABLE ���_�����
(
    ���_���_����� INT PRIMARY KEY,
    ��������_����_����� VARCHAR(50) UNIQUE NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '�����_����������')
BEGIN
CREATE TABLE �����_����������
(
    ���_�����_���������� INT PRIMARY KEY,
    ������ VARCHAR(50) NOT NULL,
    ����� VARCHAR(50) NOT NULL,
    ����� VARCHAR(50) NOT NULL,
    ����������_������� VARCHAR(50) NOT NULL,
    ����������_���������� INT NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '�����')
BEGIN
CREATE TABLE �����
(
    ���_����� INT PRIMARY KEY,
    �����_����� INT NOT NULL,
    ���_�����_���������� INT NOT NULL,
    ���_���_����� INT NOT NULL,
    �����_��� INT NOT NULL,
    ����������_������� INT NOT NULL,
    ����������_���������� INT NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '�������')
BEGIN
CREATE TABLE �������
(
    ���_������� INT PRIMARY KEY,
    ��������_������� VARCHAR(50) NOT NULL,
    ���_����� INT NOT NULL,
    �������������� VARCHAR(100) NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = '����������')
BEGIN
CREATE TABLE ����������
(
    ���_���������� INT PRIMARY KEY,
    ��������_���������� VARCHAR(50) NOT NULL,
    ���_����� INT NOT NULL,
    �������������� VARCHAR(100) NOT NULL
)
END;
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_�����_���_�����')
BEGIN
    ALTER TABLE �����
    ADD CONSTRAINT FK_�����_���_����� FOREIGN KEY (���_���_�����) REFERENCES ���_�����(���_���_�����);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_�����_�����_����������')
BEGIN
    ALTER TABLE �����
    ADD CONSTRAINT FK_�����_�����_���������� FOREIGN KEY (���_�����_����������) REFERENCES �����_����������(���_�����_����������);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_�������_�����')
BEGIN
    ALTER TABLE �������
    ADD CONSTRAINT FK_�������_����� FOREIGN KEY (���_�����) REFERENCES �����(���_�����);
END
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE name = 'FK_����������_�����')
BEGIN
    ALTER TABLE ����������
    ADD CONSTRAINT FK_����������_����� FOREIGN KEY (���_�����) REFERENCES �����(���_�����);
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

USE ��������������_�������_��������_������;
GO

CREATE DATABASE AUDIT SPECIFICATION DatabaseAuditSpec
FOR SERVER AUDIT ServerAudit
ADD (INSERT, UPDATE, DELETE ON ���_����� BY public)
WITH (STATE = ON);
GO