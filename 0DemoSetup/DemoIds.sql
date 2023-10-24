use DemoIds2013

--drop table dbo.badgedemoids 

create table dbo.PossibleBadges (Name nvarchar(40) primary key clustered)

insert into dbo.PossibleBadges (name)
select distinct
name + '- New!'
from StackOverflow2013.dbo.Badges
union all select distinct
name
from StackOverflow2013.dbo.Badges 


create table dbo.BadgeDemoIds ([BadgeName] nvarchar(40), UserId int, OrderId uniqueidentifier)

insert into dbo.BadgeDemoIds ([BadgeName], UserId, OrderId)
select top (10000000)
b.name, u.Id as UserId, newId()
from dbo.PossibleBadges b
cross join StackOverflow2013.dbo.Users u

create clustered index cl_Badgedemoids on dbo.BadgeDemoIds (OrderId)


GO



SELECT TOP 500000 CAST(NEWID() AS VARCHAR(100)) AS VoteId
, Id as PostId
INTO dbo.Votes
FROM StackOverflow2013.dbo.Posts


GO
use DemoIds2010



create table dbo.PossibleBadges (Name nvarchar(40) primary key clustered)


insert into dbo.PossibleBadges (name)
select distinct
name + '- New!'
from StackOverflow2010.dbo.Badges
union all select distinct
name
from StackOverflow2010.dbo.Badges 


create table dbo.BadgeDemoIds ([BadgeName] nvarchar(40), UserId int, OrderId uniqueidentifier)

insert into dbo.BadgeDemoIds ([BadgeName], UserId, OrderId)
select top (10000000)
b.name, u.Id as UserId, newId()
from dbo.PossibleBadges b
cross join StackOverflow2010.dbo.Users u

create clustered index cl_Badgedemoids on dbo.BadgeDemoIds (OrderId)


GO



SELECT TOP 500000 CAST(NEWID() AS VARCHAR(100)) AS VoteId
, Id as PostId
INTO dbo.Votes
FROM StackOverflow2010.dbo.Posts


