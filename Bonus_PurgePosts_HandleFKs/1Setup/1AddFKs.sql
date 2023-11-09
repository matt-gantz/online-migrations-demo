CREATE INDEX IX_PostLinks_PostId ON dbo.PostLinks (PostId)
CREATE INDEX IX_PostLinks_RelatedPostId ON dbo.PostLinks (RelatedPostId)

ALTER TABLE dbo.PostLinks WITH NOCHECK ADD CONSTRAINT FK_PostLinks_PostId FOREIGN KEY  (PostId) REFERENCES dbo.Posts(Id) 
ALTER TABLE dbo.PostLinks WITH NOCHECK ADD CONSTRAINT FK_PostLinks_RelatedPostId FOREIGN KEY  (RelatedPostId) REFERENCES dbo.Posts(Id) 

