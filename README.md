# GUCERA-Database
###### Table SQL file represents MSSQL queries that create a database for a teaching website.
###### and procedures file for queries creating corresponding procedures.

#### the database keeps track of the info of 3 types of users:
1. Admin
1. Instructor
1. Student

#### the database also keeps track of -but not limited to-  :
- courses
- assignments
- students feedbacks
- students creditcard info
- promocodes
- certificates
- which instructor teaches which course
- which student take which course
- assignments of a specific course
- even more things
	###### (please check EERD for details)

#### the procedures include -but not limited to- :
- User Registering (Instructor and Student)
- User Login
- Adding a mobile number for a user
	####(Admin)
- Displaying list of instructors 
- Viewing an Instructor profile
- View all courses
- View non accepted courses
- View course details
- Accept courses
- Create promocode
- list all students
- view student profile
- issue promocode to a student
	### (Instructor)
- add a course
- update course content and description
- add another instructor to a course
- view accepted courses by an admin
- define course prerequisites
- define assignment of a course of a certain type
- update Instructor rate
- view assignments submitted by students
- grade assignments submitted by students
- view feedbacks added by students on his courses
- calculate final grade of a student in a course he teaches
- issue a certificate to a student
	### (Student)
- view profile
- edit profile
- view available courses that he can apply in
- view courses information
- enroll in a course
- add a credit card
- view promocodes issues to him by admin
- pay for a course
- enroll in a course
- view assignments of a course
- submit assignments of a course
- view grades of submitted assignements (after being graded by instructor)
- view final grade in a course
- add feedback to a course
- rate an Instructor
- view certificates

we also created a basic gui (website using asp. net) that benefits from the database but it's very basic and not the prettiest so I might or might not add the code for it later.

