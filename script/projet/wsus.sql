sqlcmd -S np:\\.\pipe\MICROSOFT##WID\tsql\query
USE SUSDB;
GO

-- Supprime les mises à jour obsolètes
DECLARE @var1 INT;
DECLARE @msg NVARCHAR(100);
SELECT @var1 = COUNT(*)
FROM SUSDB.dbo.tbEventInstance;
SET @msg = 'Deleting ' + CAST(@var1 AS NVARCHAR(100)) + ' obsolete updates...';
RAISERROR(@msg, 0, 1) WITH NOWAIT;
EXEC spDeleteObsoleteUpdates;
GO

-- Réindexation des tables pour améliorer les performances
DECLARE @tableName NVARCHAR(256);
DECLARE tableCursor CURSOR FOR
SELECT '[' + s.name + '].[' + t.name + ']'
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id;

OPEN tableCursor;
FETCH NEXT FROM tableCursor INTO @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        PRINT 'Reindexing ' + @tableName;
        EXEC ('ALTER INDEX ALL ON ' + @tableName + ' REBUILD');
    END TRY
    BEGIN CATCH
        PRINT 'Error reindexing ' + @tableName;
    END CATCH;
    FETCH NEXT FROM tableCursor INTO @tableName;
END

CLOSE tableCursor;
DEALLOCATE tableCursor;
GO

-- Nettoyage de la base de données pour libérer de l'espace
EXEC sp_Configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_Configure 'xp_cmdshell', 1;
RECONFIGURE;
EXEC xp_cmdshell 'wsusutil reset';
GO
