
CREATE DATABASE Gym;
USE Gym;

CREATE TABLE Person(
				pid INT(7) AUTO_INCREMENT NOT NULL, 
				first VARCHAR(20) NOT NULL, 
				middle VARCHAR(20), 
				last VARCHAR(20) NOT NULL, 
				social_security_number BIGINT(9),
				phone_number BIGINT(10), 
				email VARCHAR(30) NOT NULL, 
				date_of_birth DATE NOT NULL, 
				street_number INT(10), 
				street_name VARCHAR(20), 
				city VARCHAR(20), 
				state VARCHAR(20), 
				zip INT(5), 
				gender BOOLEAN,
				PRIMARY KEY (pid));

CREATE TABLE Member(
				pid INT(7) NOT NULL, 
				member_Since DATE, 
				preferances VARCHAR(80), 				
				membership_end DATE,
				active BOOLEAN DEFAULT 1,
				PRIMARY KEY(pid), 
				FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE);

CREATE TABLE Monthly_Membership_Fee(
				rate_code VARCHAR(10) NOT NULL,
				price DECIMAL(5,2) NOT NULL,  
				PRIMARY KEY (rate_code));
			
CREATE TABLE Account(
				account_id INT(7) AUTO_INCREMENT NOT NULL,
				primary_pid INT(7) NOT NULL, 
				member_id INT(7) NOT NULL,
				membership_type VARCHAR(10), 
				membership_price DECIMAL(5,2), 
				FOREIGN KEY (membership_type) REFERENCES Monthly_Membership_Fee(rate_code),
				PRIMARY KEY (account_Id, member_id));
			
Create TABLE Uses(
				account_Id INT(7) NOT NULL, 
				pid INT(7) NOT NULL, 
				Primary KEY(account_Id, pid), 
				FOREIGN KEY (pid) REFERENCES Person(pid) ON DELETE CASCADE, 
				FOREIGN KEY (account_Id) REFERENCES account(account_Id) ON DELETE CASCADE);
				
CREATE TABLE Chargedm(
				rate_code VARCHAR(5) NOT NULL, 
				account_Id INT(7) NOT NULL, 
				FOREIGN KEY (rate_code) REFERENCES Monthly_Membership_Fee(rate_code) ON DELETE CASCADE, 
				FOREIGN KEY (account_Id) REFERENCES account(account_Id) ON DELETE CASCADE, 
				PRIMARY KEY (rate_code));
				
CREATE TABLE Saved_Credit_Card(
				cc_number BIGINT(16) NOT NULL, 
				expiration DATE NOT NULL, 
				cvv INT(3) NOT NULL, 
				account_Id INT(7) NOT NULL,
				Primary Key (cc_number));
				
CREATE TABLE SavedCC(
				cc_number INT(16) NOT NULL, 
				account_Id INT(7) NOT NULL,  
				Primary Key (cc_number,account_Id));
				
CREATE TABLE Saved_Check(
				check_account_number INT(10) NOT NULL, 
				routing_Number INT(9) NOT NULL, 
				Primary Key (check_account_number, routing_Number));
				
				
CREATE TABLE SavedCH(
				check_account_number INT(10) NOT NULL, 
				routing_Number INT(9) NOT NULL, 
				account_Id INT(7) NOT NULL, 
				FOREIGN KEY (account_Id) REFERENCES account(account_Id) ON DELETE CASCADE,
				FOREIGN KEY (check_account_number, routing_Number) REFERENCES Saved_Check(check_account_number, routing_Number) ON DELETE CASCADE, 
				PRIMARY KEY (check_account_number, routing_number, account_Id));

CREATE TABLE Transactions(
				account_Id INT(7) NOT NULL, 
				t_Date DATE NOT NULL, 
				t_Time TIME NOT NULL, 
				amount DECIMAL(5,2) NOT NULL, 
				reason VARCHAR(30), 
				receipt_number INT(10) AUTO_INCREMENT NOT NULL, 
				FOREIGN KEY (account_Id) REFERENCES account(account_Id) ON DELETE CASCADE,  
				PRIMARY KEY(receipt_number));
				
CREATE TABLE BilledCC(
				cc_number INT(10) NOT NULL, 
				receipt_number INT(10) NOT NULL,  
				FOREIGN KEY (receipt_number) REFERENCES Transactions(receipt_number) ON DELETE CASCADE, 
				Primary Key(cc_number, receipt_number));
				
CREATE TABLE BilledCheck(
				check_account_number INT(10) NOT NULL, 
				routing_number INT(9) NOT NULL, 
				receipt_number INT(10) NOT NULL, 
				FOREIGN KEY (receipt_number) REFERENCES Transactions(receipt_number) ON DELETE CASCADE, 
				FOREIGN KEY (check_account_number, routing_Number) REFERENCES Saved_Check(check_account_number, routing_Number) ON DELETE CASCADE,  
				Primary Key(check_account_number, routing_number, receipt_number));
				
CREATE TABLE Trainer(
				trainer_id INT(7) NOT NULL, 
				employee_since  DATE, 				 
				bio_website VARCHAR(40), 
				FOREIGN KEY (trainer_id) REFERENCES Person(pid) ON DELETE CASCADE, 
				PRIMARY KEY(trainer_id));
				
CREATE TABLE Trainer_Cert(
				trainer_id INT(7) NOT NULL, 
				cert VARCHAR(50) NOT NULL, 
				FOREIGN KEY (trainer_id) REFERENCES Person(pid) ON DELETE CASCADE, 
				Primary Key(trainer_id, cert));
				
CREATE TABLE Trainer_Avail(
				trainer_id INT(7) NOT NULL, 
				avail_Day INT(1), 
				avail_Start INT(2), 
				day_of_month INT(2),
				FOREIGN KEY (trainer_id) REFERENCES Person(pid) ON DELETE CASCADE,
				Primary Key(trainer_id, avail_Day, avail_Start));
				
				
CREATE TABLE DECIDES(
				trainer_id INT(7) NOT NULL, 
				avail_Day DATE NOT NULL, 
				avail_Start TIME NOT NULL, 
				FOREIGN KEY (trainer_id) REFERENCES Person(pid) ON DELETE CASCADE, 
				PRIMARY KEY(trainer_id, avail_Day, avail_Start));
				
CREATE TABLE sched_Appointments(
				app_id INT(10) AUTO_INCREMENT NOT NULL, 
				member_id INT(7) NOT NULL, 
				Trainer_id INT(7) NOT NULL,
				app_Date DATE NOT NULL,
				app_Time TIME NOT NULL,
				duration DECIMAL(3,2),
				FOREIGN KEY (member_id) REFERENCES Member(pid), 
				FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id), 
				Primary Key(app_id));
				
CREATE TABLE completed_Appointments(
				app_id INT(10) AUTO_INCREMENT NOT NULL, 
				member_id INT(7) NOT NULL, 
				Trainer_id INT(7) NOT NULL,
				app_Date DATE NOT NULL,
				app_Time TIME NOT NULL,
				duration DECIMAL(3,2),
				Executed BOOLEAN,
				advanced_canced BOOLEAN,
				reciept_num Int,
				FOREIGN KEY (member_id) REFERENCES Member(pid), 
				FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id), 
				Primary Key(app_id));
				
CREATE TABLE SET_App(
				avail_Day DATE NOT NULL, 
				avail_Start TIME NOT NULL, 
				app_id INT(10) NOT NULL, 
				Primary Key(avail_Day,avail_Start, app_id));
				
CREATE TABLE Session_Fee(
				trainer_rate DECIMAL(5,2) NOT NULL, 
				Sched_session_Length DECIMAL(3,2) NOT NULL, 
				number_of_apt INT(3), 
				Primary Key(trainer_rate));
				
CREATE TABLE Establish( 
				Sched_session_Length DECIMAL(3,2) NOT NULL, 
				trainer_id INT(7) NOT NULL, 
				FOREIGN KEY(Trainer_id) REFERENCES Trainer(Trainer_id),				
				Primary Key(Trainer_id, Sched_session_Length));
				
CREATE TABLE ChargedS(
				account_id INT(10) NOT NULL, 
				trainer_rate DECIMAL(5,2) NOT NULL, 
				session_Length DECIMAL(3,2) NOT NULL, 
				trainer_id INT(7) NOT NULL, 
				FOREIGN KEY(account_id) REFERENCES account(account_id), 
				FOREIGN KEY(Trainer_id) REFERENCES Trainer(Trainer_id),					
				Primary Key(trainer_rate, session_Length, trainer_id, account_id));
				
CREATE TABLE Purchase_Session(
				receipt_number INT(10) NOT NULL, 
				pid INT(7) NOT NULL, 
				Trainer_id INT(7) NOT NULL, 
				number_of_Sessions INT(2), 
				Session_counter INT(2), 
				FOREIGN KEY (trainer_id) REFERENCES Trainer(trainer_id) ON DELETE CASCADE, 
				FOREIGN KEY (receipt_number) REFERENCES Transactions(receipt_number) ON DELETE CASCADE, 
				FOREIGN KEY (pid) REFERENCES Member(pid) ON DELETE CASCADE, Primary Key(receipt_number));
				
CREATE TABLE Checked(
				receipt_number INT(10) NOT NULL, 
				app_id INT(10) NOT NULL,
				FOREIGN KEY (receipt_number) REFERENCES Transactions(receipt_number) ON DELETE CASCADE,
				Primary Key(receipt_number, app_id)); 

				
insert into Monthly_Membership_Fee values("Individual", 45);
insert into Monthly_Membership_Fee values("Couple", 80);
insert into Monthly_Membership_Fee values("Family", 110);





insert into person(first, middle, last, street_number, street_name, city, state, zip, date_of_birth, email, social_security_number, gender) 
	values("John", "A", "Daniels", 350, "Main St.", "Falls City", "VA", 22040, 19740415,"jdaniels@elite.org", 2021231234, 1);
	
set @tempId = (select pid from person where first="John");

insert into trainer(trainer_id)
	value(@tempId);
	
insert into trainer_cert(trainer_id,cert)
	values(@tempId,"strength and conditioning specialist (CSCS)");
	
insert into person(first, middle, last, street_number, street_name, city, state, zip, date_of_birth, email, social_security_number, gender)
	values("Mariel", "Sandra", "Fernandez", 1024, "Lost Circle", "Ferris Village", "VA", 22043, 19861006,"mfernand@elite.org", 2029879879,0);
	
	set @tempId = (select pid from person where first="Mariel");

insert into trainer(trainer_id)
	value(@tempId);
	
insert into trainer_cert(trainer_id,cert)
	values(@tempId,"certified conditioning specialist (CCS)");
	
	
insert into person(first, last, street_number, street_name, city, state, zip, date_of_birth, email, social_security_number, gender)
	values("Terry", "Baker", 65, "Riverside Apt. 304", "Step Cross City", "VA", 22045, 19760512,"stbaker@elite.org", 2024376987, 1);
	
set @tempId = (select pid from person where first="Terry");

insert into trainer(trainer_id)
	value(@tempId);
	
insert into trainer_cert(trainer_id,cert)
	values(@tempId,"strength and conditioning specialist (CSCS)");
	
insert into person(first, middle, last, date_of_birth, email, social_security_number, gender) 
	values("Michael", "P", "Edwards", 19670409, "mpedwards@elite.org", 7037590322,1);
	
set @tempId = (select pid from person where first="Michael");

insert into trainer(trainer_id)
	value(@tempId);
	
insert into trainer_cert(trainer_id,cert)
	values(@tempId,"strength specialist (CSS)");
	

	
	
	


insert into person(first, middle, last, street_number, street_name, city, state, zip, date_of_birth, email , social_security_number, gender)
	values("Donald", "S", "Markov", 504, "Middle Circle St", "Step Cross City", "VA", 22045, 19650703, "donald@gmail.com", 2025467787,1);
	
set @tempId = (select pid from person where first="Donald");
set @tempRate = (select rate_code from monthly_membership_fee where rate_code = "Family");
set @tempPrice = (select price from monthly_membership_fee where rate_code=@tempRate);

insert into account(primary_pid, member_Id, membership_type, membership_price)
	values(@tempId, @tempId, @tempRate, @tempPrice);

set @tempAccount = (select account_Id from account where primary_pid=@tempId);

insert into member(pid, member_Since, preferances)
	values(@tempId, 20120201, "working out with male trainer over the age of 30");
	
	
insert into Saved_Credit_Card(account_Id, cc_number, expiration,cvv)
	values(@tempAccount,1234123412341234, 20200601, 123);
	
	
insert into person(first, last, street_number, street_name, city, state, zip, date_of_birth, email , social_security_number, gender)
	values("Sarah", "Markov",504, "Middle Circle St", "Step Cross City", "VA", 22045, 19680602, "donald@gmail.com",2025551234,0);
	
set @tempId = (select pid from person where first="Sarah");

insert into member(pid, member_Since)
	values(@tempId, 20120201);

set @tempPId = (select pid from person where first="Donald");

set @tempAccount = (select account_Id from account where primary_pid=@tempPId);
set @tempRate = (select membership_type from account where account_Id = @tempAccount);

	
insert into account(account_Id, primary_pid, member_Id, membership_type, membership_price)
	values(@tempAccount, @tempPId, @tempId, @tempRate, @tempPrice);
	
	
insert into person(first, middle, last, street_number, street_name, city, state, zip, date_of_birth, email , social_security_number, gender)
	values("Mark", "Donald", "Markov",504, "Middle Circle St", "Step Cross City", "VA", 22045, 20000122, "mark@gmail", 2025456789,1);
	
set @tempId = (select pid from person where first="Mark");	
	
insert into account(account_Id, primary_pid, member_Id, membership_type, membership_price)
	values(@tempAccount, @tempPId, @tempId, @tempRate, @tempPrice);
	
insert into member(pid)
	values(@tempId);	
	
	
insert into person(first, last, street_number, street_name, city, state, zip, date_of_birth, email, gender)
	values("Steve", "Hunter", 32, "Stain St", "Ferris Village", "VA", 22043, 19750106, "stevehunter@yahoo.com",1);
	
set @tempId = (select pid from person where first="Steve");	

insert into member(pid, member_Since)
	values(@tempId, 20100315);
	
set @tempRate = (select rate_code from monthly_membership_fee where rate_code = "Individual");
set @tempPrice = (select price from monthly_membership_fee where rate_code=@tempRate);
	
insert into account(primary_pid, member_Id, membership_type, membership_price)
	values(@tempId, @tempId, @tempRate, @tempPrice);	
	

set @tempAccount = (select account_Id from account where primary_pid=@tempId);

insert into Saved_Credit_Card(account_Id, cc_number, expiration,cvv)
	values(@tempAccount,4343434343434343,20160701,4343);	


insert into person(first, last, street_number, street_name, city, state, zip, date_of_birth, social_security_number, email, gender)
	values("Daniella", "Curtis", 123, "Satellite Circle", "Falls City", "VA", 22041, 19771222, 4109874321, "daniella@uva.edu",0);
	
set @tempId = (select pid from person where first="Daniella");	

insert into member(pid, member_Since, preferances, membership_end, active)
	values(@tempId, 20100315, "female trainer under the age of 30", 20151201, false);
	
set @tempRate = (select rate_code from monthly_membership_fee where rate_code = "Individual");
set @tempPrice = (select price from monthly_membership_fee where rate_code=@tempRate);
	
insert into account(primary_pid, member_Id, membership_type, membership_price)
	values(@tempId, @tempId, @tempRate, @tempPrice);	
	

set @tempAccount = (select account_Id from account where primary_pid=@tempId);

insert into Saved_Check(check_account_number, routing_Number)
		values(0123456789, 987654321);

		
		
		
		
		
		
		
		
		
		
set @tempAmount = (select max(membership_price) from account where account_Id =1);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(1, 20151001, 080101, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =1);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(1, 20151101, 080101, @tempAmount, "Monthly Fee");	
	
set @tempAmount = (select max(membership_price) from account where account_Id =1);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(1, 20151201, 080101, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =2);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(2, 20151001, 080201, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =2);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(2, 20151101, 080201, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =2);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(2, 20151201, 080201, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =3);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(3, 20151001, 080301, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =3);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(3, 20151101, 080301, @tempAmount, "Monthly Fee");
	
set @tempAmount = (select max(membership_price) from account where account_Id =3);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(3, 20151201, 080301, @tempAmount, "Monthly Fee");	
	
	
	
	
	
	
	
	
	
	
insert into Session_Fee(trainer_rate, Sched_session_Length, number_of_apt)
	values(45.00, 0.50, 1);
	
insert into Session_Fee(trainer_rate, Sched_session_Length, number_of_apt)
	values(480.00, 0.50, 12);
	
insert into Session_Fee(trainer_rate, Sched_session_Length, number_of_apt)
	values(70.00, 1, 1);
	
insert into Session_Fee(trainer_rate, Sched_session_Length, number_of_apt)
	values(720.00, 1, 12);
	

	

   
   DELIMITER //
   CREATE PROCEDURE fill_Days(in id INT, in startDay INT, in endDay INT, in startTime INT, in endTime INT)
   BEGIN
		WHILE startDay < (endDay +1) DO
				call fill_Avail(id,startDay,startTime, endTime);
				SET startDay = startDay+1;		
        END WHILE;
   END 
   //
   DELIMITER ;
   
   
   DELIMITER //
   CREATE PROCEDURE fill_Avail(in id INT, in startDay INT, in startTime INT, in endTime INT)
   BEGIN
			WHILE startTime<(endTime +1) DO
				insert into Trainer_Avail(trainer_id, avail_Day, avail_Start)
					values(id, startDay,startTime);
			
				set startTime = startTime + 1;
			END WHILE;
   END 
   //
   DELIMITER ;
   
   
   
set @tempid = (select pid from person where first="Donald");
set @tempAccount = (select account_Id from account where member_id=@tempid);
set @tempAmount = (select trainer_rate from Session_Fee where Sched_session_Length = 1 and number_of_apt = 12);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(@tempAccount, 20151001, 080701, @tempAmount, "personal trainer session");
	
set @tempId = (select pid from person where first ="John");	
call fill_Days(@tempId, 2,6,7,20);
call fill_avail(@tempId,7,8,13);

	
set @tempId = (select pid from person where first ="Mariel");
call fill_avail(@tempId,2,8,18);
call fill_avail(@tempId,4,8,18);
call fill_avail(@tempId,5,8,18);
call fill_avail(@tempId,6,8,18);
call fill_avail(@tempId,7,9,12);

	
set @tempId = (select pid from person where first ="Terry");	
call fill_Days(@tempId, 3,7,8,15);

	
set @tempId = (select pid from person where first ="Michael");	
call fill_Days(@tempId, 2,6,18,21);
call fill_Days(@tempId, 2,6,6,14);











set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Donald");

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151111, 080000, 1);

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151114, 070000, 1);

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151205, 080000, 1);	

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151208, 070000, 1);


	
set @tempTrainer = (select pid from person where first ="Mariel");
set @tempMember = (select pid from person where first="Daniella");

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151113, 110000, 0.5);
	
insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151114, 110000, 0.5);

	
set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Mark");

insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151114, 080000, 1);
	
	
set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Sarah");		
	
insert into sched_Appointments(member_id, trainer_id, app_Date, app_Time, duration)
	values(@tempMember, @tempTrainer, 20151114, 090000, .5);
	
	
	
	
	
set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Donald");		
	
insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed)
	values(@tempMember, @tempTrainer, 20151111, 080000, 1, true);

insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed)
	values(@tempMember, @tempTrainer, 20151114, 070000, 1, true);	

	
set @tempTrainer = (select pid from person where first ="Mariel");
set @tempMember = (select pid from person where first="Daniella");

insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed)
	values(@tempMember, @tempTrainer, 20151114, 110000, 0.5, true);
	
set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Mark");

insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed)
	values(@tempMember, @tempTrainer, 20151114, 080000, 1, true);
	
set @tempTrainer = (select pid from person where first ="John");
set @tempMember = (select pid from person where first="Sarah");		
	
insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed)
	values(@tempMember, @tempTrainer, 20151114, 090000, .5, true);
	
	
	
set @tempTrainer = (select pid from person where first ="Mariel");
set @tempMember = (select pid from person where first="Daniella");	
set @tempAccount= (select account_id from account where member_id = @tempMember);

insert into Transactions(account_Id, t_Date, t_Time, amount, reason) 
	Values(@tempAccount, 20151113, 090101, 20, "Cancelation Fee");
	
set @tempreceipt = (select receipt_number from transactions where account_id = @tempAccount and t_Date = 20151113 and t_Time = 090101);

insert into completed_Appointments(member_id, trainer_id, app_Date, app_Time, duration, Executed, advanced_canced, reciept_num)
	values(@tempMember, @tempTrainer, 20151113, 110000, 0.5, false, false, @tempreceipt);
	

	
