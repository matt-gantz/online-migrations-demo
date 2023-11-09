IF (COL_LENGTH('dbo.Comments','ScoreAsVarchar')) IS NULL
ALTER TABLE dbo.Comments
	ADD ScoreAsVarchar VARCHAR(100) NOT NULL
	CONSTRAINT DF_Comments_ScoreAsVarchar DEFAULT ('ToBeMigrated')