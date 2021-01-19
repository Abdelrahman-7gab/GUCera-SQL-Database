create database GUCera

go

Use GUCera

create table Users( id int primary key Identity,
firstName varchar(20),
lastName varchar(20),
userPassword varchar(20),
gender bit,
email varchar(50),
userAddress varchar(10))

create table Instructor( id int primary key,
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE,
rating decimal(2,1))

create table UserMobileNumber( id int,
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE,
mobileNumber varchar(20),
PRIMARY KEY(id, mobileNumber))

create table Student( id int primary key,
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE,
gpa decimal(2,1))

create table Admins( id int primary key,
FOREIGN KEY(id) REFERENCES Users ON DELETE CASCADE ON UPDATE CASCADE)

create table Course( id int primary key Identity,
creditHours int,
courseName varchar(20),
courseDescription varchar(200),
price decimal(6,2),
content varchar(200),
accepted bit,
admin_ID int,
Instructor_ID int,
FOREIGN KEY(admin_ID) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(Instructor_ID) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE)

create table Assignment( cid int,
number int,
assignType varchar(10),
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(cid, number , assignType),
fullGrade int,
assignWeight decimal(4,1),
deadline datetime,
content varchar(200) )

create table Feedback( cid int,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
number int,
PRIMARY KEY(cid, number),
comments varchar(100),
numberOfLikes int,
s_ID int,
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE)

create table Promocode( code varchar(6) primary key,
issueDate datetime,
expiryDate datetime,
discountAmount decimal(4,2),
adminID int,
FOREIGN KEY(adminID) REFERENCES Admins ON DELETE CASCADE ON UPDATE CASCADE)

create table studentHasPromocode( s_ID int,
code varchar(6),
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(code) REFERENCES Promocode ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, code))

create table CreditCard(number varchar(15) primary key,
cardHolderName varchar(16),
exiryDate datetime,
cvv varchar(3))

create table studentAddCreditCard( s_ID int,
creditCardNumber varchar(15),
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(creditCardNumber) REFERENCES CreditCard ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, creditCardNumber))


create table studentTakeCourse( s_ID int,
cid int,
instid int,
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(instid) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, cid, instid),
payedfor bit,
grade decimal(5,2) )

create table studentTakeAssignment( s_ID int,
cid int,
assignmentNumber int,
assignmentType varchar(10),
grade decimal(5,2),
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES Course ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(assignmentNumber) REFERENCES Assignment.number ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(assignmentType) REFERENCES Assignment.assignType ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, cid, assignmentNumber,assignmentType ,grade ))

create table studentRateInstructor( s_ID int,
instId int,
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, instId),
rate decimal(2,1))

create table studentCertifyCourse( s_ID int,
cid int,
FOREIGN KEY(s_ID) REFERENCES Student ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES course ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(s_ID, cid),
issueDate datetime)

create table CoursePrerequisiteCourse(cid int,
prerequisiteID int,
FOREIGN KEY(cid) REFERENCES course ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(prerequisiteID) REFERENCES course ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(cid, prerequisiteID))

create table InstructorTeachCourse( instId int,
cid int,
FOREIGN KEY(instId) REFERENCES Instructor ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY(cid) REFERENCES course ON DELETE CASCADE ON UPDATE CASCADE,
PRIMARY KEY(instId, cid))
