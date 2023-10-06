CREATE OR ALTER PROC InsertPosts

AS
INSERT Posts(Body,CreationDate,LastActivityDate,PostTypeId,Score,ViewCount)
SELECT '<p>TEST RECORD<p>' as Body
, GETDATE()
, GETDATE()
, 1
, 5
, 0