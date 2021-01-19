--functions & procedures
go 
--how to specify that user is student?
create proc studentRegister
@first_name varchar(20), @last_name varchar(20), @password varchar(20), @email varchar(50),
@gender bit, @address varchar(10)
AS
INSERT INTO Users(firstName,lastName,userPassword,email,gender, userAddress)
VALUES(@first_name, @last_name, @password , @email,@gender, @address)
Declare @LASTID int
SET @LASTID = SCOPE_IDENTITY()
INSERT INTO Student(id) VALUES(@LASTID)

EXEC studentRegister "hana","mahdy","hana","h@mail.com",1,"nasr"

go
--how to specify that user is instructor?
create proc instructorRegister
@first_name varchar(20), @last_name varchar(20), @password varchar(20), @email varchar(50),
@gender bit, @address varchar(10)
AS
INSERT INTO Users(firstName,lastName,userPassword,email,gender, userAddress)
VALUES(@first_name, @last_name, @password , @email,@gender, @address)
Declare @LAST int
SET @LAST = SCOPE_IDENTITY()
INSERT INTO Instructor(id) VALUES(@LAST)

EXEC instructorRegister "radwa","magdy","radwa","r@mail.com",1,"Cairo"

go
-- user login
create proc userLogin
@ID int,
@password varchar(20),
@Success bit OUTPUT,
@Type int output
AS
if EXISTS(select * from Users 
where id = @ID and userPassword = @password)
BEGIN
set @Success = 1
END
ELSE
BEGIN
set @Success = 0
END
if Exists(select * from Student where id = @ID)
begin
set @type = 2
end
if Exists(select * from Admins where id = @ID)
begin
set @type = 1
end
if Exists(select * from Instructor where id = @ID)
begin
set @type = 0
end

declare @type int
declare @Succ bit
Exec userLogin 1,hana, @Succ output, @type output
print(@Succ)
print(@type)	

go
--add Mobile
create proc addMobile
@ID int,
@mobile_number varchar(20)
as
if exists(select * from users where @ID = id)
begin
insert into UserMobileNumber(id,mobileNumber)values(@id,@mobile_number)
end
else
begin
print('This id input is not correct')
end

exec addMobile 1,'1111111'

go
--Admin (a)
create proc AdminListInstr
AS
select u.firstName, u.lastName
from Users u INNER JOIN Instructor i ON u.id=i.id

EXEC AdminListInstr

go
--Admin(b)
create proc AdminViewInstructorProfile
@instrId int
AS
select u.firstName, u.lastName, u.userPassword, u.email, u.gender, u.userAddress, i.rating
from Users u INNER JOIN Instructor i ON u.id=i.id
where i.id=@instrId

EXEC AdminViewInstructorProfile 2

go
--Admin(c)
create proc AdminViewAllCourses
AS
select *
from Course

Exec AdminViewAllCourses

go
--Admin(d)
create proc AdminViewNonAcceptedCourses
AS
select creditHours,courseName,price,content
from Course
where Course.accepted = 0 

Exec AdminViewNonAcceptedCourses

go
--Admin(e)
create proc AdminViewCourseDetails
@courseId int
AS
select courseName, creditHours,price , Course.content, accepted
from Course
where Course.id = @courseId

Exec AdminViewCourseDetails 1

go
--Admin(f)
create proc AdminAcceptRejectCourse
@adminId int,
@courseId int
AS
UPDATE Course
SET Course.admin_ID = @adminId, accepted=1
WHERE Course.id = @courseId

EXEC AdminAcceptRejectCourse 3,1

go
--Admin(g)
create proc AdminCreatePromocode
@code varchar(6), 
@issueDate datetime, 
@expiryDate datetime, 
@discount decimal(4,2), 
@adminId int
AS
INSERT INTO Promocode(code, issueDate, expiryDate, discountAmount,adminID)
VALUES (@code, @issueDate, @expiryDate, @discount, @adminID)

Exec AdminCreatePromocode "c12","2020-1-1","2021-1-1",20.5,3

go
--Admin(h)
create proc AdminListAllStudents
AS
SELECT Users.firstName , Users.lastName 
FROM Student INNER JOIN Users ON Student.id = Users.id

Exec AdminListAllStudents

go
--Admin(i)
create proc AdminViewStudentProfile
@sid int
AS
SELECT Student.id , Users.firstName , Users.lastName , Users.email , Users.gender , Users.userAddress, Student.gpa
FROM Student INNER JOIN Users ON Student.id = Users.id
WHERE Student.id = @sid

Exec AdminViewStudentProfile 1

go
--Admin(j)
create proc AdminIssuePromocodeToStudent
@sid int, 
@pid varchar(6)
AS
INSERT INTO studentHasPromocode( s_ID, code)
VALUES (@sid,@pid)

Exec AdminIssuePromocodeToStudent 1,c12

go
--inst(a)
create proc InstAddCourse
@creditHours int, 
@name varchar(10), 
@price DECIMAL(6,2), 
@instructorId int
AS
INSERT INTO Course (creditHours,courseName,price,Instructor_ID)
VALUES (@creditHours , @name , @price, @instructorId);

Exec InstAddCourse 3,'csen5',33,2


go
--inst(b)
create proc UpdateCourseContent
@instrId int, 
@courseId int, 
@content varchar(20)
AS
UPDATE Course
SET Course.content = @content
WHERE Course.id = @courseId and Course.Instructor_ID = @instrId

EXEC UpdateCourseContent 2,3,'hello world'

go
--inst(b)
create proc UpdateCourseDescription
@instrId int, 
@courseId int, 
@courseDescription varchar(200)
AS
UPDATE Course
SET Course.courseDescription = @courseDescription
WHERE Course.id = @courseId and Course.Instructor_ID = @instrId

Exec UpdateCourseDescription 2,3,'database'




go
-- Instructor c (AddAnotherInstructorToCourse)
--create proc AddAnotherInstructorToCourse
--@insid int,
--@cid int,
--@adderIns int
--as
--insert into InstructorTeachCourse values(@insid,@cid)


create proc AddAnotherInstructorToCourse
@insid int,
@cid int,
@adderIns int
as
if exists (select * from InstructorTeachCourse where @adderIns = instId and @cid = cid)
begin
insert into InstructorTeachCourse values(@insid,@cid)
end
else
begin
print('this Instructor does not teach this course')
end

EXEC AddAnotherInstructorToCourse 4,3,2
insert into InstructorTeachCourse(instId,cid)
values(2,3)


go
-- Instructor D (InstructorViewAcceptedCoursesByAdmin)
create proc InstructorViewAcceptedCoursesByAdmin
@instrId int
as
select id,courseName,creditHours
from Course
where Instructor_ID = @instrId and accepted =1

EXEC InstructorViewAcceptedCoursesByAdmin 4

go
-- Instructor e (DefineCoursePrerequisites)
create proc DefineCoursePrerequisites
@cid int, @prerequsiteId int
as insert into CoursePrerequisiteCourse values(@cid,@prerequsiteId)

--EXEC DefineCoursePrerequisites 1,3

go
-- Instructor f (DefineAssignmentOfCourseOfCertianType)
create proc DefineAssignmentOfCourseOfCertianType
@instID int, @cid int,@number int,@type varchar(10),@fullgrade int, @weight decimal(4,1),@deadline datetime, @content varchar(200)
as
if exists(select * from InstructorTeachCourse where instId = @instID)
begin
insert into Assignment values(@cid,@number,@type,@fullgrade,@weight,@deadline,@content)
end
else
begin
print('this instructor does not teach this course')
end

--EXEC DefineAssignmentOfCourseOfCertianType 4,1,1,'quiz',10,2,'2020-12-12',"good luck"

go
-- Instructor G (updateInstructorRate)
create proc updateInstructorRate
@insid int
as
update Instructor
set rating = (select avg(rate) from studentRateInstructor where @insid = instID )
where id = @insid

--EXEC updateInstructorRate 4

go
-- Instructor G again but II (ViewInstructorProfile)
create proc ViewInstructorProfile
@instrId int
as select U.firstName,U.lastName,U.gender,U.email,U.userAddress,I.rating, M.mobileNumber
from Instructor I inner join users U on I.id = U.id  left outer join UserMobileNumber M on U.id=M.id
where I.id = @instrId

--EXEC ViewInstructorProfile 2

go
-- Instructor (H InstructorViewAssignmentsStudents)
create proc InstructorViewAssignmentsStudents
@instrId int, @cid int
as select * from studentTakeAssignment S inner join InstructorTeachCourse I on I.cid = S.cid
where I.cid = @cid

--EXEC InstructorViewAssignmentsStudents 2,3

go
-- Instructor I (InstructorgradeAssignmentOfAStudent)
-- why do i take instructor id as an input?
create proc InstructorgradeAssignmentOfAStudent
@instrID int ,@sid int, @cid int,@assignmentNumber int, @type varchar(10), @grade decimal(5,2)
as
if exists(select * from InstructorTeachCourse where instId = @instrId and @cid = cid)
begin
update studentTakeAssignment
set grade = @grade
where @sid = s_ID and @cid = cid and assignmentNumber = @assignmentNumber and @type = assignmentType and @assignmentNumber = assignmentNumber
end
else
begin
print('this instructor does not teach this course')
end

--EXEC InstructorgradeAssignmentOfAStudent 2,1,3,1,'quiz',6


go
-- Instructor J (ViewFeedbacksAddedByStudentsOnMyCourse)
-- why do i take instructor id as an input?
create proc ViewFeedbacksAddedByStudentsOnMyCourse
@instrId int, @cid int
as
if exists(select * from InstructorTeachCourse where instId = @instrId and @cid = cid)
begin
select number,comments,numberOfLikes from Feedback where @cid = cid
end
else
begin
print('this instructor does not teach this course')
end

--EXEC ViewFeedbacksAddedByStudentsOnMyCourse 4,3

go
--Instructor(k)
create proc calculateFinalGrade
@cid INT, @sid INT, @insId INT
AS
declare @grade int
select @grade = sum(A.assignWeight*SA.grade/A.fullGrade) from  studentTakeAssignment SA inner join Assignment A on A.cid = SA.cid
where SA.cid = @cid and SA.s_ID=@sid

INSERT INTO studentTakeCourse(s_ID,cid, instid, grade)
VALUES(@sid,@cid,@insId,@grade)
--SET grade = @grade
--where cid = @cid and s_ID=@sid

EXEC calculateFinalGrade 1,5,2

go
--Instructor(k2)
create proc InstructorIssueCertificateToStudent
@sid INT, @cid INT, @instid INT, @issue datetime
AS
if exists(select * from InstructorTeachCourse where instId = @instid and @cid = cid)
begin
INSERT INTO studentCertifyCourse(s_ID,cid,issueDate)
VALUES(@sid,@cid,@issue)
end
else
begin
print('this instructor does not teach this course')
end

EXEC InstructorIssueCertificateToStudent 1,3,4,'2020-1-1'


--Student..

go

create PROC viewMyProfile
@id int
AS
SELECT  u.id ,s.gpa ,u.firstName ,u.lastName ,u.userPassword ,u.gender,u.email ,u.userAddress
FROM Users u INNER JOIN Student s ON u.id=s.id
WHERE @id=s.id

EXEC viewMyProfile 1

go

create PROC editMyProfile
@id int,
@firstName varchar(10), 
@lastName varchar(10), 
@password varchar(10), 
@gender binary,
@email varchar(10), 
@address varchar(10)
AS
if(@firstName is not null)
BEGIN
UPDATE Users 
SET firstName=@firstName
WHERE id=@id
END

if(@lastName is not null)
BEGIN
UPDATE Users 
SET lastName=@lastName
WHERE id=@id
END

if(@password is not null)
BEGIN
UPDATE Users 
SET userPassword=@password
WHERE id=@id
END

if(@gender is not null)
BEGIN
UPDATE Users 
SET gender=@gender
WHERE id=@id
END

if(@email is not null)
BEGIN
UPDATE Users 
SET email=@email
WHERE id=@id
END

if(@address is not null)
BEGIN
UPDATE Users 
SET userAddress=@address
WHERE id=@id
END

--EXEC editMyProfile 1,null,null,null,null,null,'york'

go
CREATE PROC availableCourses
AS
SELECT Course.courseName
FROM Course
WHERE Course.accepted=1

--EXEC availableCourses

go
CREATE PROC courseInformation
@id int
AS
SELECT C.id ,C.creditHours, C.courseName ,C.courseDescription, C.price,C.content,C.admin_ID,C.Instructor_ID,C.accepted,U.firstName,U.lastName
FROM Course C INNER JOIN Users U ON C.Instructor_ID=U.ID
WHERE C.id=@id

--EXEC courseInformation 3

go
CREATE PROC enrollInCourse
@sid INT, 
@cid INT, 
@instr int
AS
INSERT INTO StudentTakeCourse(s_ID,cid,instId)
VALUES (@sid,@cid,@instr)

--EXEC enrollInCourse 5,3,4

go
----credit card mawgoda wla gdeda?-----
CREATE PROC addCreditCard
@sid int, 
@number varchar(15), 
@cardHolderName varchar(16), 
@expiryDate datetime, 
@cvv varchar(3)
AS
INSERT INTO CreditCard(number ,cardHolderName,exiryDate,cvv )
VALUES (@number, @cardHolderName, @expiryDate, @cvv)
INSERT INTO StudentAddCreditCard(s_ID,creditCardNumber)
VALUES (@sid,@number)

--EXEC addCreditCard 1,'123','name','2020-1-1','111'

go
CREATE PROC viewPromocode
@sid int
AS
SELECT p.*
FROM Promocode p INNER JOIN  studentHasPromocode s ON p.code=s.code
WHERE s.s_ID=@sid

--EXEC viewPromocode 1

go
CREATE PROC payCourse
@cid INT, 
@sid INT
AS
UPDATE StudentTakeCourse
SET StudentTakeCourse.payedFor=1 
WHERE StudentTakeCourse.s_ID=@sid AND StudentTakeCourse.cid=@cid

--EXEC payCourse 3,1

go

CREATE PROC enrollInCourseViewContent
@id int, 
@cid int
AS
SELECT C.id ,C.creditHours, C.courseName ,C.courseDescription, C.price,C.content 

FROM Course C INNER JOIN StudentTakeCourse S ON C.id=S.cid AND S.s_ID=@id
WHERE C.id=@cid 

--EXEC enrollInCourseViewContent 1,3

go

CREATE PROC viewAssign
@courseId int, 
@Sid VARCHAR(10)
AS
SELECT  a.cid,a.number,a.assignType,a.fullGrade,a.assignWeight,a.deadline,a.content
FROM Assignment a INNER JOIN StudentTakeAssignment s ON a.cid=s.cid AND a.number = s.assignmentNumber
WHERE a.cid=@courseId AND s.s_ID = CAST(@Sid AS int) 

--EXEC viewAssign 3,1

go

CREATE PROC submitAssign
 @assignType VARCHAR(10), 
 @assignnumber int, 
 @sid INT, 
 @cid INT
 AS
 INSERT INTO StudentTakeAssignment(s_ID,cid,assignmentNumber,assignmentType,grade)
 VALUES (@sid,@cid,@assignNumber,@assignType ,0)

 --EXEC submitAssign 'quiz',1,1,3

 go

 CREATE PROC addFeedback
@comment VARCHAR(100), 
@cid INT, 
@sid INT
 AS
 declare @number INT
 SELECT @number = max(number) +1
 FROM Feedback 
 WHERE cid = @cid

 if(@number is null)
 SET @number = 1

 INSERT INTO Feedback (cid,comments,s_ID,number) 
 VALUES (@cid,@comment,@sid,@number)

-- EXEC addFeedback 'g',1,1

go
--Student(l)
create proc viewAssignGrades
@assignnumber INT, @assignType VARCHAR(10), @cid INT, @sid INT,
@grade INT OUTPUT
AS
select @grade=grade from studentTakeAssignment
where cid=@cid AND s_ID=@sid AND assignmentNumber=@assignnumber AND assignmentType=@assignType

--DECLARE @grade INT
--EXEC viewAssignGrades 1,'quiz',3,1 ,@grade OUTPUT
--PRINT @grade


--insert into Course(courseName,accepted)
--values('math',1)
--INSERT INTO Assignment(cid, number, assignType, fullGrade)
--VALUES(1,1,'project', 20.0)

--INSERT INTO studentTakeAssignment(s_ID, cid, assignmentNumber, assignmentType, grade)
--VALUES(1,1,1,'project', 10.0)

go
--Student(m)
--sum of all assignment grades * their weight
create proc viewFinalGrade
@cid INT, @sid INT,
@finalGrade decimal(10,2) OUTPUT
AS
select @finalGrade=grade from studentTakeCourse
where cid=@cid AND s_ID=@sid

DECLARE @finalGrade INT
EXEC viewFinalGrade 3,1 ,@finalGrade OUTPUT
PRINT @finalGrade



go
--Student(o)
create proc rateInstructor
@rate DECIMAL (2,1), @sid INT, @insid INT
AS
INSERT INTO studentRateInstructor(s_ID,instId,rate)
VALUES(@sid,@insid,@rate)

--EXEC rateInstructor 1.5,5,4

go
--Student(p)
create proc viewCertificate
@sid INT, @cid INT
AS
select * from studentCertifyCourse
where s_ID=@sid AND cid=@cid

--EXEC viewCertificate 1,3


