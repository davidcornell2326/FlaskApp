-- CS4400: Introduction to Database Systems
-- Bank Management Project Phase 3 Physical Schema
-- Converting Relational Schema into a Database & Inserting Data
-- March 18th, 2022

drop database if exists bank_management;
create database if not exists bank_management;
use bank_management;

create table person (
	perID varchar(100),
    pwd varchar(100) not null,
    primary key (perID)
) engine=innodb;

insert into person values
('mmoss7','password1'),
('tmcgee1','password2'),
('dscully5','password3'),
('fmulder8','password4'),
('arwhite6','password5'),
('ealfaro4','password6'),
('mmcgill4','password7'),
('sville19','password8'),
('rnairn5','password9'),
('smcgill17','password10'),
('tjtalbot4','password11'),
('owalter6','password12'),
('rsanchez','password13'),
('msmith','password14'),
('lgibbs4','password15'),
('ghopper9','password16'),
('asantiago99','password17'),
('rholt99','password18'),
('jperalta99','password19'),
('glinetti99','password20'),
('cboyle99','password21'),
('rdiaz99','password22'),
('atrebek1','password23'),
('kjennings66','password24'),
('gburdell','password25'),
('pbeesly17','password26'),
('beyonce','password27');

create table system_admin (
	perID varchar(100),
    primary key (perID),
    constraint fk2 foreign key (perID) references person(perID)
) engine=innodb;

insert into system_admin values
('mmoss7'),
('tmcgee1'),
('dscully5'),
('fmulder8');

create table bank_user (
	perID varchar(100),
    taxID char(11) not null,
    birthdate date default null,
    firstName varchar(100) default null,
    lastName varchar(100) default null,
    dtJoined date default null,
    street varchar(100) default null,
    city varchar(100) default null,
    state char(2) default null,
    zip char(5) default null,
    primary key (perID),
    unique key (taxID),
    constraint fk3 foreign key (perID) references person(perID)
) engine=innodb;

insert into bank_user values
('arwhite6','053-87-1120','1960-06-06','Amelia-Rose','Whitehead','2021-12-03','60 Nightshade Court','Baltimore','MD','21217'),
('ealfaro4','278-78-7676','1960-06-06','Evie','Alfaro','2021-12-27','314 Five Fingers Way','Atlanta','GA','30301'),
('mmcgill4','623-09-0887','1955-06-23','Maheen','McGill','2020-09-08','741 Pan American Trace','East Cobb','GA','30304'),
('sville19','354-10-6263','1965-03-16','Sahar','Villegas','2020-06-16','10 Downing Road','East Cobb','GA','30304'),
('rnairn5','404-51-1036','1959-07-13','Roxanne','Nairn','2021-08-16','2048 Transparency Road','Atlanta','GA','30301'),
('smcgill17','238-40-5070','1954-06-02','Saqlain','McGill','2020-09-11','741 Pan American Trace','East Cobb','GA','30304'),
('tjtalbot4','203-46-3005','1978-05-10','TJ','Talbot','2020-03-25','101 Snoopy Woodstock Circle','Salt Lake City','UT','84108'),
('owalter6','346-51-9139','1971-10-23','Om','Walter','2020-04-29','143 Snoopy Woodstock Circle','Salt Lake City','UT','84108'),
('rsanchez','012-34-5678','1936-08-22','Rick','Sanchez',null,'137 Puget Run','Seattle','WA','98420'),
('msmith','246-80-1234','1999-04-04','Morty','Smith','2017-08-21','137 Puget Run','Seattle','WA','98420'),
('lgibbs4','304-39-1098','1954-11-21','Leroy','Gibbs','2021-06-16','50 Mountain Spur','Stillwater','PA','17878'),
('ghopper9','101-00-1111','1906-12-09','Grace','Hopper','2019-12-25','1 Broadway','New York','NY','10004'),
('asantiago99','765-43-2109','1983-07-04','Amy','Santiago','2018-03-09','1477 Park Avenue Apt. 82','New York','NY','11217'),
('rholt99','111-22-3333','1955-01-01','Raymond','Holt','2022-01-01','123 Main Street','Perth Amboy','NJ','08861'),
('jperalta99','775-33-6054','1981-09-04','Jake','Peralta','2018-03-09','1477 Park Avenue Apt. 82','New York','NY','11217'),
('glinetti99','233-76-0019','1986-03-20','Gina','Linetti','2019-04-04','75 Allure Drive','New York','NY','11220'),
('cboyle99','433-12-1200','1982-09-04','Charles','Boyle','2018-03-10','1477 Park Avenue Apt. 65','New York','NY','11217'),
('rdiaz99','687-54-1033','1984-11-30','Rosa','Diaz','2020-12-24','3 East Park Loop','Yonkers','NY','10112'),
('atrebek1','000-00-0000','1940-07-22','Alex','Trebek','2014-03-22','10202 West Washington Boulevard','Culver City','CA','90232'),
('kjennings66','004-52-2700','1974-05-23','Ken','Jennings','2005-09-07','74 Champions Heights','Edmonds','WA','98020'),
('gburdell','404-00-0000',null,null,null,null,null,null,null,null),
('pbeesly17','664-98-7654',null,'Pam','Beesly','2021-06-06',null,null,null,null),
('beyonce','444-55-666','1981-09-04','Beyonce',null,'2014-02-02','222 Star Grove','Houston','TX','77077');

create table employee (
	perID varchar(100),
    salary integer default null,
    payments integer default null,
    earned integer default null,
    primary key (perID),
    constraint fk4 foreign key (perID) references bank_user(perID),
    constraint employee_salary_positive check (salary >= 0)
) engine=innodb;

insert into employee values
('arwhite6',4700,6,28200),
('ealfaro4',5600,3,17100),
('mmcgill4',9400,3,29100),
('sville19',8000,4,35000),
('rnairn5',5100,5,27400),
('smcgill17',8800,3,33700),
('rsanchez',49500,10,654321),
('lgibbs4',null,null,null),
('ghopper9',49500,5,447999),
('rholt99',null,null,null),
('jperalta99',5400,3,5900),
('glinetti99',null,null,null),
('cboyle99',null,null,1200),
('kjennings66',2000,9,43000),
('gburdell',null,null,null),
('pbeesly17',8400,2,14000),
('beyonce',9800,6,320985);

create table customer (
	perID varchar(100),
    primary key (perID),
    constraint fk5 foreign key (perID) references bank_user(perID)
) engine=innodb;

insert into customer values
('arwhite6'),
('tjtalbot4'),
('owalter6'),
('rsanchez'),
('msmith'),
('asantiago99'),
('rholt99'),
('glinetti99'),
('cboyle99'),
('rdiaz99'),
('atrebek1'),
('kjennings66'),
('pbeesly17');

create table customer_contacts (
	perID varchar(100),
    contact_type varchar(100),
    info varchar(100),
    primary key (perID, contact_type, info),
    constraint fk6 foreign key (perID) references customer(perID)
) engine=innodb;

insert into customer_contacts values
('arwhite6','mobile','333-182-9303'),
('arwhite6','email','amelia_whitehead@me.com'),
('tjtalbot4','mobile','845-101-2760'),
('tjtalbot4','home','236-464-1023'),
('tjtalbot4','email','tj_forever@aol.com'),
('owalter6','home','370-186-5341'),
('rsanchez','phone','000-098-7654'),
('msmith','email','morty@rm.com'),
('asantiago99','email','asantiago99@nypd.org'),
('asantiago99','fax','334-444-1234 x276'),
('pbeesly17','email','pb@dunder.com'),
('pbeesly17','email','jh@dunder.com'),
('msmith','phone','000-098-7654');

create table corporation (
	corpID varchar(100),
    shortName varchar(100) not null,
    longName varchar(100) not null,
    resAssets integer default null,
    primary key (corpID),
    unique key (shortName),
    unique key (longName)
) engine=innodb;

insert into corporation values
('WF','Wells Fargo','Wells Fargo Bank National Association',33000000),
('BA','Bank of America','Bank of America Corporation',51000000),
('ST','Sun Trust','Sun Trust Banks/Truist Financial Corporation',39000000),
('NASA','NASA FCU','NASA Federal Credit Union',11000000),
('TD','TD Ameritrade','TD Ameritrade Holding Corporation',0),
('GS','Goldman Sachs','Goldman Sachs Group, Inc.',null);

create table bank (
	bankID varchar(100),
    bankName varchar(100) default null,
    street varchar(100) default null,
    city varchar(100) default null,
    state char(2) default null,
    zip char(5) default null,
    resAssets integer default null,
    corpID varchar(100) not null,
    manager varchar(100) not null,
    primary key (bankID),
    unique key (street, city, state, zip),
    unique key (manager),
    constraint fk12 foreign key (corpID) references corporation(corpID),
    constraint fk15 foreign key (manager) references employee(perID)
) engine=innodb;

insert into bank values
('WF_1','Wells Fargo #1 Bank','1010 Binary Way','Seattle','WA','98101',127000,'WF','sville19'),
('WF_2','Wells Fargo #2 Bank','337 Firefly Lane','Seattle','WA','98101',553000,'WF','mmcgill4'),
('BA_West','Bank of America West Region Bank','865 Black Gold Circle','Dallas','TX','75116',267000,'BA','smcgill17'),
('NASA_Goddard','NASA FCU at Goddard SFC','8800 Greenbelt Road','Greenbelt','MD','20771',140000,'NASA','rsanchez'),
('TD_Online',null,null,null,null,null,0,'TD','kjennings66'),
('TD_GT','TD Ameritrade Midtown Branch','47 Tech Parkway','Atlanta','GA','30333',null,'TD','gburdell'),
('NASA_KSC','NASA FCU at Kennedy Space Center','1 Space Commerce Way','Cape Canaveral','FL','45678',0,'NASA','rholt99'),
('BA_South','Bank of America Plaza-Midtown','600 Peachtree Street NE','Atlanta','GA','30333',42000,'BA','ghopper9'),
('NASA_HAL','NASA FCU at US Space & Rocket Center','1 Tranquility Base Suite 203','Huntsville','AL','35805',null,'NASA','pbeesly17');

create table bank_account (
	bankID varchar(100),
    accountID varchar(100),
    balance integer default null,
    primary key (bankID, accountID),
    constraint fk1 foreign key (bankID) references bank(bankID)
) engine=innodb;

insert into bank_account values
('WF_2','checking_A',2700),
('BA_West','checking_A',1000),
('NASA_Goddard','company_checking',null),
('NASA_KSC','company_checking',150000),
('TD_Online','company_checking',0),
('WF_2','market_X',27000),
('TD_Online','Roth_IRA',167000),
('TD_GT','Roth_IRA',15000),
('BA_South','GT_investments',16000),
('WF_2','savings_A',19400),
('BA_West','savings_B',8000),
('NASA_Goddard','company_savings',1000000),
('TD_GT','savings_A',8500),
('BA_South','GT_savings',9999);

create table interest_bearing (
	bankID varchar(100),
	accountID varchar(100),
    interest_rate integer default null,
    dtDeposit date default null,
    primary key (bankID, accountID),
    constraint fk8 foreign key (bankID, accountID) references bank_account(bankID, accountID)
) engine=innodb;

insert into interest_bearing values
('WF_2', 'market_X', 20, '2021-12-23'),
('TD_Online', 'Roth_IRA', 12, '2022-01-03'),
('TD_GT', 'Roth_IRA', 8, '2021-01-01'),
('BA_South', 'GT_investments', 4, '2020-03-11'),
('WF_2', 'savings_A', 10, '2021-11-05'),
('BA_West', 'savings_B', 6,' 2021-09-01'),
('NASA_Goddard', 'company_savings', null, null),
('TD_GT', 'savings_A', null, null),
('BA_South', 'GT_savings', 2, null);

create table interest_bearing_fees (
	bankID varchar(100),
    accountID varchar(100),
    fee varchar(100),
    primary key (bankID, accountID, fee),
    constraint fk9 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into interest_bearing_fees values
('WF_2','savings_A','low balance'),
('BA_West','savings_B','low balance'),
('BA_West','savings_B','overdraft'),
('WF_2','market_X','administrative'),
('WF_2','market_X','frequency'),
('WF_2','market_X','fee'),
('TD_Online','Roth_IRA','low balance'),
('TD_Online','Roth_IRA','withdrawal'),
('NASA_Goddard','company_savings','credit union'),
('BA_South','GT_investments','withdrawal');

create table savings (
	bankID varchar(100),
    accountID varchar(100),
    minBalance integer default null,
    primary key (bankID, accountID),
    constraint fk10 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into savings values
('WF_2','savings_A',15000),
('BA_West','savings_B',10000),
('NASA_Goddard','company_savings',0),
('TD_GT','savings_A',0),
('BA_South','GT_savings',2000);

create table market (
	bankID varchar(100),
    accountID varchar(100),
    maxWithdrawals integer default null,
    numWithdrawals integer default null,
    primary key (bankID, accountID),
    constraint fk11 foreign key (bankID, accountID) references interest_bearing(bankID, accountID)
) engine=innodb;

insert into market values
('WF_2','market_X',2,1),
('TD_Online','Roth_IRA',0,0),
('TD_GT','Roth_IRA',null,null),
('BA_South','GT_investments',10,5);

create table checking (
	bankID varchar(100),
    accountID varchar(100),
    protectionBank varchar(100) default null,
    protectionAccount varchar(100) default null,	
    amount integer default null,
    dtOverdraft date default null,
    primary key (bankID, accountID),
    unique key (protectionBank, protectionAccount),
    constraint fk7 foreign key (bankID, accountID) references bank_account(bankID, accountID),
    constraint fk18 foreign key (protectionBank, protectionAccount) references savings(bankID, accountID)
) engine=innodb;

insert into checking values
('WF_2','checking_A', null, null, null, null),
('BA_West','checking_A','BA_West', 'savings_B', 600, '2021-12-08'),
('NASA_Goddard','company_checking', null, null, null, null),
('NASA_KSC','company_checking', null, null, null, null),
('TD_Online','company_checking', null, null, null, null);

create table workFor (
	bankID varchar(100),
    perID varchar(100),
    primary key (bankID, perID),
	constraint fk13 foreign key (bankID) references bank(bankID),
	constraint fk14 foreign key (perID) references employee(perID)
) engine=innodb;

insert into workFor values
('WF_2','arwhite6'),
('WF_1','ealfaro4'),
('WF_2','ealfaro4'),
('BA_West','rnairn5'),
('BA_South','beyonce'),
('NASA_Goddard','beyonce'),
('TD_Online','beyonce'),
('TD_GT','jperalta99'),
('TD_GT','cboyle99'),
('NASA_KSC','jperalta99'),
('NASA_KSC','cboyle99'),
('NASA_HAL','jperalta99'),
('BA_West','glinetti99'),
('TD_Online','glinetti99');

create table access (
	perID varchar(100),
	bankID varchar(100),
    accountID varchar(100),
    dtShareStart date not null,
    dtAction date default null,
    primary key (bankID, perID, accountID),
	constraint fk16 foreign key (perID) references customer(perID),
    constraint fk17 foreign key (bankID, accountID) references bank_account(bankID, accountID)
) engine=innodb;

insert into access values
('arwhite6','WF_2','checking_A','2021-08-10','2022-01-26'),
('arwhite6','WF_2','savings_A','2021-08-10','2021-11-11'),
('tjtalbot4','WF_2','savings_A','2021-08-17','2022-02-03'),
('owalter6','BA_West','checking_A','2020-09-02',null),
('owalter6','BA_West','savings_B','2020-09-02',null),
('msmith','NASA_Goddard','company_checking','2018-10-11',null),
('rsanchez','NASA_Goddard','company_checking','2018-10-10','2022-02-04'),
('rsanchez','NASA_KSC','company_checking','2018-10-10','2022-01-13'),
('tjtalbot4','TD_Online','company_checking','2020-12-07','2020-12-07'),
('rholt99','WF_2','market_X','2022-02-02','2020-02-04'),
('asantiago99','WF_2','market_X','2020-02-02','2020-02-04'),
('cboyle99','TD_Online','Roth_IRA','2021-09-26',null),
('glinetti99','TD_Online','Roth_IRA','2019-12-24',null),
('msmith','TD_GT','Roth_IRA','2021-01-01','2022-01-01'),
('kjennings66','BA_South','GT_investments','2009-08-09',null),
('rsanchez','NASA_Goddard','company_savings','2014-08-16',null),
('pbeesly17','TD_GT','savings_A','2021-09-09',null),
('atrebek1','BA_South','GT_savings','2015-12-31','2017-03-22'),
('kjennings66','BA_South','GT_savings','2010-08-09','2022-02-21');

-- Team 25: David Cornll, Amelia Fatykhova, Michael Ryan, Katie Beuchel

-- CS4400: Introduction to Database Systems
-- Bank Management Project - Phase 3 (v2)
-- Generating Stored Procedures & Functions for the Use Cases
-- April 4th, 2022

-- implement these functions and stored procedures on the project database
use bank_management;

-- [1] create_corporation()
-- This stored procedure creates a new corporation
drop procedure if exists create_corporation;
delimiter //
create procedure create_corporation (in ip_corpID varchar(100),
    in ip_shortName varchar(100), in ip_longName varchar(100),
    in ip_resAssets integer)
begin
	insert into corporation values (ip_corpID, ip_shortName, ip_longName, cast(ip_resAssets as signed));
end //
delimiter ;

-- call create_corporation("CHASE", "Chase", "Chase Bank", "22000000");

-- [2] create_bank()
-- This stored procedure creates a new bank that is owned by an existing corporation
-- The corporation must also be managed by a valid employee [being a manager doesn't leave enough time for other jobs]
drop procedure if exists create_bank;
delimiter //
create procedure create_bank (in ip_bankID varchar(100), in ip_bankName varchar(100),
	in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_resAssets integer, in ip_corpID varchar(100),
    in ip_manager varchar(100), in ip_bank_employee varchar(100))
begin
	-- Implement your code here

-- checking to make sure corporation ID exists in the corporation table
    IF ((ip_corpID IN (
			SELECT corpID FROM corporation))
	-- checking to make sure the manager's ID is in the employee table
	AND (ip_manager IN (
			select perID FROM employee))
	-- checking to make sure the manager doesn't already manage another bank, aka exists in workfor table
	AND (ip_manager NOT IN (
		    select perID FROM workfor)))
	THEN 
		-- create a new bank
		INSERT INTO bank (bankID, bankName, street, city, state, zip, resAssets, corpID, manager)
		VALUES (ip_bankID, ip_bankName, ip_street, ip_city, ip_state, ip_zip, ip_resAssets, ip_corpID, ip_manager);
		
        -- add employee-bank relation to workfor
        INSERT INTO workfor (bankID, perID) VALUES (ip_bankID, ip_bank_employee);
        
        
	END IF;
    
    -- add the bank employee to the employees table
    if (
		ip_bank_employee NOT IN (select perID FROM employee)
	) THEN
		INSERT INTO employee (perID, salary, payments, earned)
		VALUES (ip_bank_employee, NULL, NULL, NULL);
    
    END IF;


end //
delimiter ;

-- [3] start_employee_role()
-- If the person exists as an admin or employee then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new employee
-- If the person exists as a customer then the employee data is added to create the joint customer-employee role
drop procedure if exists start_employee_role;
delimiter //
create procedure start_employee_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in ip_salary integer,
    in ip_payments integer, in ip_earned integer, in emp_password  varchar(100))
sp_3: begin
	-- If the person exists as an admin or employee then don't change the database state
    IF ((ip_perID) IN (SELECT perID FROM system_admin)) OR ((ip_perID) IN (SELECT perID FROM employee)) THEN 
		LEAVE sp_3;
    END IF;
    -- If the person exists as a customer then the employee data is added to create the joint customer-employee role
    IF ((ip_perID) IN (SELECT perID FROM customer)) THEN
		-- Since the person already exists update their password
		UPDATE person
			SET pwd=emp_password
        WHERE perID=ip_perID;
		-- Since the user already exists update the user fields
		UPDATE bank_user
			SET birthdate=ip_birthdate,
				firstname=ip_firstName,
                lastname=ip_lastName,
                dtJoined=ip_dtJoined,
                street=ip_street,
                city=ip_city,
                state=ip_state,
                zip=ip_zip
		WHERE perID=ip_perID AND taxID = ip_taxID;
        -- Create a new employee entry
		INSERT INTO employee VALUES
			(ip_perID, ip_salary, ip_payments, ip_earned);
	-- This person does not yet exist
	ELSE
		-- Create a new person
        INSERT INTO person VALUES
			(ip_perID,emp_password);
		-- Create a new user
        INSERT INTO bank_user VALUES
			(ip_perID,ip_taxID,ip_birthdate,ip_firstName,ip_lastName,ip_dtJoined,ip_street,ip_city,ip_state,ip_zip);
		-- Create a new employee
        INSERT INTO employee VALUES
			(ip_perID, ip_salary, ip_payments, ip_earned);
    END IF;
end //
delimiter ;

-- [4] start_customer_role()
-- If the person exists as an admin or customer then don't change the database state [not allowed to be admin along with any other person-based role]
-- If the person doesn't exist then this stored procedure creates a new customer
-- If the person exists as an employee then the customer data is added to create the joint customer-employee role
drop procedure if exists start_customer_role;
delimiter //
create procedure start_customer_role (in ip_perID varchar(100), in ip_taxID char(11),
	in ip_firstName varchar(100), in ip_lastName varchar(100), in ip_birthdate date,
    in ip_street varchar(100), in ip_city varchar(100), in ip_state char(2),
    in ip_zip char(5), in ip_dtJoined date, in cust_password varchar(100))
sp_4: begin
	-- If the person exists as an admin or customer then don't change the database state
	IF ((ip_perID) IN (SELECT perID FROM system_admin)) OR ((ip_perID) IN (SELECT perID FROM customer)) THEN 
		LEAVE sp_4;
    END IF;
    -- If the person exists as an employee then the customer data is added to create the joint customer-employee role
    IF ((ip_perID) IN (SELECT perID FROM employee)) THEN
		-- Since the person already exists update their password
		UPDATE person
			SET pwd=cust_password
        WHERE perID=ip_perID;
		-- Since the user already exists update the user fields
		UPDATE bank_user
			SET birthdate=ip_birthdate,
				firstname=ip_firstName,
                lastname=ip_lastName,
                dtJoined=ip_dtJoined,
                street=ip_street,
                city=ip_city,
                state=ip_state,
                zip=ip_zip
		WHERE perID=ip_perID AND taxID = ip_taxID;
        -- Create a new employee entry
		INSERT INTO customer VALUES
			(ip_perID);
	-- This person does not yet exist
	ELSE
		-- Create a new person
        INSERT INTO person VALUES
			(ip_perID,cust_password);
		-- Create a new user
        INSERT INTO bank_user VALUES
			(ip_perID,ip_taxID,ip_birthdate,ip_firstName,ip_lastName,ip_dtJoined,ip_street,ip_city,ip_state,ip_zip);
		-- Create a new customer
        INSERT INTO customer VALUES
			(ip_perID);
    END IF;
end //
delimiter ;

-- [5] stop_employee_role()
-- If the person doesn't exist as an employee then don't change the database state
-- If the employee manages a bank or is the last employee at a bank then don't change the database state [each bank must have a manager and at least one employee]
-- If the person exists in the joint customer-employee role then the employee data must be removed, but the customer information must be maintained
-- If the person exists only as an employee then all related person data must be removed
drop procedure if exists stop_employee_role;
delimiter //
create procedure stop_employee_role (in ip_perID varchar(100))
sp_5: begin
	-- If the person doesn't exist as an employee then don't change the database state
	IF ((ip_perID) NOT IN (SELECT perID FROM employee)) THEN
		LEAVE sp_5;
    END IF;
    -- If the employee manages a bank then don't change the database state
    IF ((ip_perID) IN (SELECT manager FROM bank)) THEN
		LEAVE sp_5;
    END IF;
    -- If the employee is the last employee at a bank then don't change the database state
    IF (1 in (SELECT count(perID) FROM workFor WHERE bankID IN (SELECT bankID FROM workFor WHERE perID=ip_perID) GROUP BY bankID)) THEN
		LEAVE sp_5;
    END IF;
    -- If the person exists in the joint customer-employee role then the employee data must be removed, but the customer information must be maintained
    IF ((ip_perID) IN (SELECT perID FROM customer)) THEN
		DELETE FROM workFor WHERE perID = ip_perID;
		DELETE FROM employee WHERE perID = ip_perID;
    -- If the person exists only as an employee then all related person data must be removed
    ELSE
		DELETE FROM workFor WHERE perID = ip_perID;
		DELETE FROM employee WHERE perID = ip_perID;
        DELETE FROM customer WHERE perID = ip_perID;
        DELETE FROM customer_contacts WHERE perID = ip_perID;
        DELETE FROM bank_user WHERE perID = ip_perID;
        DELETE FROM system_admin WHERE perID = ip_perID;
        DELETE FROM person WHERE perID = ip_perID;
    END IF;
end //
delimiter ;


-- [6] stop_customer_role()
-- If the person doesn't exist as an customer then don't change the database state
-- If the customer is the only holder of an account then don't change the database state [each account must have at least one holder]
-- If the person exists in the joint customer-employee role then the customer data must be removed, but the employee information must be maintained
-- If the person exists only as a customer then all related person data must be removed
drop procedure if exists stop_customer_role;
delimiter //
create procedure stop_customer_role (in ip_perID varchar(100))
sp_6:begin
	-- If the person doesn't exist as an customer then don't change the database state
    IF ((ip_perID) NOT IN (SELECT perID FROM customer)) THEN
		LEAVE sp_6;
    END IF;
    -- If the customer is the only holder of an account then don't change the database state
    IF (1 in (SELECT count(perID) FROM access WHERE CONCAT(bankID, '_', accountID) IN (SELECT CONCAT(bankID, '_', accountID) FROM access WHERE perID=ip_perID) GROUP BY bankID, accountID)) THEN
        LEAVE sp_6;
    END IF;
    -- If the person exists in the joint customer-employee role then the customer data must be removed, but the employee information must be maintained
    IF ((ip_perID) IN (SELECT perID FROM employee)) THEN
		DELETE FROM access WHERE perID = ip_perID;
        DELETE FROM customer_contacts WHERE perID = ip_perID;
		DELETE FROM customer WHERE perID = ip_perID;
    -- If the person exists only as a customer then all related person data must be removed
    ELSE
		DELETE FROM access WHERE perID = ip_perID;
        DELETE FROM customer_contacts WHERE perID = ip_perID;
        DELETE FROM customer WHERE perID = ip_perID;
        DELETE FROM employee WHERE perID = ip_perID;
        DELETE FROM bank_user WHERE perID = ip_perID;
        DELETE FROM system_admin WHERE perID = ip_perID;
        DELETE FROM person WHERE perID = ip_perID;
    END IF;
end //
delimiter ;


-- [7] hire_worker()
-- If the person is not an employee then don't change the database state
-- If the worker is a manager then then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, the person will now work at the assigned bank in addition to any other previous work assignments
-- Also, adjust the employee's salary appropriately
drop procedure if exists hire_worker;
delimiter //
create procedure hire_worker (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
begin
		if ip_perID in (select perID from employee) and ip_perID not in (select manager from bank)
	then
		insert into workfor values (ip_bankID, ip_perID);
		update employee set salary = ifnull(salary,0) + ip_salary where perID = ip_perID;
	end if;

end //
delimiter ;

-- [8] replace_manager()
-- If the new person is not an employee then don't change the database state
-- If the new person is a manager or worker at any bank then don't change the database state [being a manager doesn't leave enough time for other jobs]
-- Otherwise, replace the previous manager at that bank with the new person
-- The previous manager's association as manager of that bank must be removed
-- Adjust the employee's salary appropriately
drop procedure if exists replace_manager;
delimiter //
create procedure replace_manager (in ip_perID varchar(100), in ip_bankID varchar(100),
	in ip_salary integer)
begin
	if ip_perID in (select perID from employee) and ip_perID not in (select manager from bank) and ip_perID not in (select perID from workfor)
	then 
		-- delete from user where user_id in (select manager_id from bank where bank_id = ip_bankID);
		update bank set manager = ip_perID where bankID = ip_bankID;
        update employee set salary = ip_salary where perID = ip_perID;
	end if; 
end //
delimiter ;


-- [9] add_account_access()
-- If the account does not exist, create a new account. If the account exists, add the customer to the account
-- When creating a new account:
    -- If the person opening the account is not an admin then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, create a new account owned by the designated customer
    -- The account type will be determined by the enumerated ip_account_type variable
    -- ip_account_type in {checking, savings, market}
-- When adding a customer to an account:
    -- If the person granting access is not an admin or someone with access to the account then don't change the database state
    -- If the intended customer (i.e. ip_customer) is not a customer then don't change the database state
    -- Otherwise, add the new customer to the existing account
drop procedure if exists add_account_access;
delimiter //
create procedure add_account_access (in ip_requester varchar(100), in ip_customer varchar(100),
	in ip_account_type varchar(10), in ip_bankID varchar(100),
    in ip_accountID varchar(100), in ip_balance integer, in ip_interest_rate integer,
    in ip_dtDeposit date, in ip_minBalance integer, in ip_numWithdrawals integer,
    in ip_maxWithdrawals integer, in ip_dtShareStart date)
begin
	-- Implement your code here
 -- verifies that account exists
    IF (
		(ip_accountID IN ( SELECT accountID FROM bank_account))
		-- checks if the person granting access is as admin OR they are an ID that has access to the account
		AND ((ip_requester IN ( SELECT perID FROM system_admin)) OR (ip_requester IN (SELECT perID from access WHERE (accountID = ip_accountID))))
		-- checks to make sure that the intended customer is in the customer table
		AND (ip_customer IN (SELECT perID FROM customer))
	) THEN -- add access:
		INSERT INTO access (perID, bankID, accountID, dtShareStart, dtAction)
		VALUES (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, NULL);
    ELSEIF( -- account does not exist, create a new account
		(ip_accountID NOT IN ( SELECT accountID FROM bank_account))
		AND  -- checks if the person granting access is as admin OR they are an ID that has access to the account
        ((ip_requester IN ( SELECT perID FROM system_admin)) OR (ip_requester IN (SELECT perID from access WHERE accountID = ip_accountID)))
        -- checks to make sure that the intended customer is in the customer table
		AND (ip_customer IN (SELECT perID FROM customer))
    ) THEN
		IF (ip_account_type = "checking") THEN
            -- update bank account table
			INSERT INTO bank_account (bankID, accountID, balance)
            VALUES (ip_bankID, ip_accountID, ip_balance);
            -- update access table
            INSERT INTO access (perID, bankID, accountID, dtShareStart, dtAction)
            VALUES (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, NULL);
            -- update checking table
			INSERT INTO checking (bankID, accountID, protectionBank, protectionAccount, amount, dtOverdraft)
			VALUES (ip_bankID, ip_accountID, NULL, NULL, NULL, NULL);
        ELSEIF (ip_account_type = "savings") THEN 
            -- update bank account table
            INSERT INTO bank_account (bankID, accountID, balance)
            VALUES (ip_bankID, ip_accountID, ip_balance);
            -- update access table
            INSERT INTO access (perID, bankID, accountID, dtShareStart, dtAction)
            VALUES (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, NULL);
            -- update interest bearing table
			INSERT INTO interest_bearing (bankID, accountID, interest_rate, dtDeposit)
			VALUES (ip_bankID, ip_accountID, ip_interest_rate, ip_dtDeposit);
            -- update savings table
			INSERT INTO savings (bankID, accountID, minBalance)
            VALUES (ip_bankID, ip_accountID, ip_minBalance);
        ELSEIF (ip_account_type = "market") THEN 
            -- update bank account table
            INSERT INTO bank_account (bankID, accountID, balance)
            VALUES (ip_bankID, ip_accountID, ip_balance);
            -- update access table
            INSERT INTO access (perID, bankID, accountID, dtShareStart, dtAction)
            VALUES (ip_customer, ip_bankID, ip_accountID, ip_dtShareStart, NULL);
            -- update interest bearing table
			INSERT INTO interest_bearing (bankID, accountID, interest_rate, dtDeposit)
            VALUES (ip_bankID, ip_accountID, ip_interest_rate, ip_dtDeposit);
            -- update market table
            INSERT INTO market (bankID, accountID, maxWithdrawals, numWithdrawals) 
            VALUES (ip_bankID, ip_accountID, ip_maxWithdrawals, ip_numWithdrawals); 
        END IF;
    END IF;


end //
delimiter ;

-- [10] remove_account_access()
-- Remove a customer's account access. If they are the last customer with access to the account, close the account
-- When just revoking access:
    -- If the person revoking access is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, remove the designated sharer from the existing account
-- When closing the account:
    -- If the customer to be removed from the account is NOT the last remaining owner/sharer then don't close the account
    -- If the person closing the account is not an admin or someone with access to the account then don't change the database state
    -- Otherwise, the account must be closed
drop procedure if exists remove_account_access;
delimiter //
create procedure remove_account_access (in ip_requester varchar(100), in ip_sharer varchar(100),
	in ip_bankID varchar(100), in ip_accountID varchar(100))
begin
	-- Implement your code here

 -- count how many customers have access to the account
    declare num_with_access integer;
    set num_with_access = (SELECT COUNT(DISTINCT(perID)) FROM access WHERE (accountID, bankID) = (ip_accountID, ip_bankID));
    
    -- check to see that more then one customer has access to the account
    IF (num_with_access > 1) THEN 
		
			-- revoking access
		-- assert that the requestor is an admin
		IF ((ip_requester IN ( SELECT perID FROM system_admin))
			OR -- assert that the requestor has access to the account
			(ip_requester IN (SELECT perID FROM access WHERE (accountID = ip_accountID)))
		) THEN
			DELETE FROM access WHERE (accountID, bankID, perID) = (ip_accountID, ip_bankID, ip_sharer);
		END IF;
	-- check to see if only one customer has access to the account
	ELSE IF (num_with_access = 1) THEN
		
		-- close the account
		IF ( -- assert that the requestor is an admin
			(ip_requester IN ( SELECT perID FROM system_admin))
			OR -- assert that the requestor has access to the account
			(ip_requester IN (SELECT perID FROM access WHERE (accountID = ip_accountID)))
		) THEN
			
            
			-- revoke the last of the account access
			DELETE FROM access WHERE (accountID, bankID, perID) = (ip_accountID, ip_bankID, ip_sharer);
            -- delete the account from all tables where it may be stored
            DELETE FROM market WHERE (accountID, bankID) = (ip_accountID, ip_bankID);
            DELETE FROM savings WHERE (accountID, bankID) = (ip_accountID, ip_bankID);
            DELETE FROM checking WHERE (accountID, bankID) = (ip_accountID, ip_bankID);
            DELETE FROM interest_bearing WHERE (accountID, bankID) = (ip_accountID, ip_bankID);
            DELETE FROM bank_account WHERE (accountID, bankID) = (ip_accountID, ip_bankID);
		END IF;
    
    END IF;
    END IF;



end //
delimiter ;

-- [11] create_fee()
drop procedure if exists create_fee;
delimiter //
create procedure create_fee (in ip_bankID varchar(100), in ip_accountID varchar(100),
	in ip_fee_type varchar(100))
begin
	-- Implement your code here

 -- check to make sure that the account given is an interest bearing account, aka market or savings
    IF ( ip_accountID IN (SELECT accountID FROM market) OR ip_accountID IN (select accountID FROM savings)) 
    THEN
		INSERT INTO interest_bearing_fees(bankID, accountID, fee)
		VALUES (ip_bankID, ip_accountID, ip_fee_type);
	END IF;



end //
delimiter ;

-- [12] start_overdraft()
drop procedure if exists start_overdraft;
delimiter //
create procedure start_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100),
    in ip_savings_bankID varchar(100), in ip_savings_accountID varchar(100))
begin
	-- Implement your code here

  
    -- make sure that the checking account does not already have a protecting account/bank: 
    declare protAcct varchar(100);
    declare protBank varchar(100);
    set protAcct = ifnull((SELECT protectionAccount FROM checking where (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID)), 0);
    set protBank = ifnull((SELECT protectionBank FROM checking where (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID)), 0);
    
    IF (
		-- check to see that the checking bank exists in the checking table
		(ip_checking_bankID IN (SELECT bankID from checking)) 
        AND 
        -- check to see if the checking account exists in the checking table
        (ip_checking_accountID IN (SELECT accountID from checking))
		AND
        -- check to see if the savings bank exists in the savings table
        (ip_savings_bankID IN (SELECT bankID from savings))
        AND
        -- check to see if the savings account exists in the savings table
        (ip_savings_accountID IN (SELECT accountID from savings))
		AND
        -- make sure that the savings account isn't already protecting an account
        (ip_savings_accountID NOT IN (SELECT protectionAccount from checking where protectionAccount IS NOT NULL))
        AND
        -- make sure that the checking account doesn't already have a protecting account
		(protAcct = 0)
        AND
        -- make sure that the checking account doesn't already have a protecting bank
		(protBank = 0)
        -- make sure that the requestor has access to both the checking account and the savings account OR is an admin
		AND ((
				-- check to see that the requestor has access to the checking account
				(ip_requester IN (SELECT perID from access WHERE (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID)))
				AND
				-- check to see that the requestor has access to the savings account
				(ip_requester IN (SELECT perID from access WHERE (accountID, bankID) = (ip_savings_accountID, ip_savings_bankID))) )
			OR
				-- check to see if the requestor is an admin
				(ip_requester IN ( SELECT perID FROM system_admin))
			)
        ) THEN 
            -- update the protection bank column in the checking table
            UPDATE checking 
			SET protectionAccount = ip_savings_accountID
			WHERE (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID);
		
			UPDATE checking 
			SET protectionBank = ip_savings_bankID
			WHERE (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID);
    
    END IF;


end //
delimiter ;

-- [13] stop_overdraft()
drop procedure if exists stop_overdraft;
delimiter //
create procedure stop_overdraft (in ip_requester varchar(100),
	in ip_checking_bankID varchar(100), in ip_checking_accountID varchar(100))
begin
	-- Implement your code here
 IF (-- check to see if the requestor has access to the checking account and savings account
			(ip_requester IN (SELECT perID from access WHERE (accountID = ip_checking_accountID))) 
            OR (ip_requester IN ( SELECT perID FROM system_admin))
	) THEN
        -- set protecting account to NULL in the checking table
		UPDATE checking 
		SET protectionAccount = NULL
		WHERE (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID);
        -- set protecting bank to NULL in the checking table
        UPDATE checking 
		SET protectionBank = NULL
		WHERE (accountID, bankID) = (ip_checking_accountID, ip_checking_bankID);
    END IF;



end //
delimiter ;

-- [14] account_deposit()
-- If the person making the deposit does not have access to the account then don't change the database state
-- Otherwise, the account balance and related info must be modified appropriately
drop procedure if exists account_deposit;
delimiter //
create procedure account_deposit (in ip_requester varchar(100), in ip_deposit_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
sp_14:begin
	-- Implement your code here	
    
    
    -- NOTE: should this update interest_bearing?
    
    
    if (ip_requester not in (select perID from access where (ip_bankID, ip_accountID) = (bankID, accountID)))
	then leave sp_14; end if;

	update bank_account set
		balance = balance + ip_deposit_amount where (ip_bankID, ip_accountID) = (bankID, accountID);
	update access set
		dtAction = ip_dtAction where (ip_bankID, ip_accountID) = (bankID, accountID);
        
    end //
delimiter ;

-- call account_deposit("owalter6", 500, "BA_West", "checking_A", "2022-02-02");
-- select * from bank_account;
 -- select * from access;

-- [15] account_withdrawal()
-- If the person making the withdrawal does not have access to the account then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the primary account first, and second from the overdraft account as needed)
drop procedure if exists account_withdrawal;
delimiter //
create procedure account_withdrawal (in ip_requester varchar(100), in ip_withdrawal_amount integer,
	in ip_bankID varchar(100), in ip_accountID varchar(100), in ip_dtAction date)
sp_15:begin
	-- Implement your code here

	-- declare variables
    declare protecting_account_bal integer;
    declare protecting_account_bankID varchar(100);
    declare protecting_account_accountID varchar(100);
    declare bal integer;
    declare overdraft_needed integer;
	
    if ip_requester not in (select perID from access where (bankID, accountID) = (ip_bankID, ip_accountID)) then
		leave sp_15; end if;
    
    if exists (select * from checking where (bankID, accountID) = (ip_bankID, ip_accountID)) then
		-- checking case
        set bal = ifnull((select balance from bank_account where (bankID, accountID) = (ip_bankID, ip_accountID)), 0);
        set protecting_account_bankID = (select protectionBank from checking where (bankID, accountID) = (ip_bankID, ip_accountID));
        set protecting_account_accountID = (select protectionAccount from checking where (bankID, accountID) = (ip_bankID, ip_accountID));
        set protecting_account_bal = ifnull((select balance from checking left join bank_account on (checking.protectionBank, checking.protectionAccount) = (bank_account.bankID, bank_account.accountID) where (checking.bankID, checking.accountID) = (ip_bankID, ip_accountID)), 0);
        
        if ip_withdrawal_amount < 0 then
			leave sp_15; end if;
		if (select numWithdrawals from market where (bankID, accountID) = (ip_bankID, ip_accountID)) >= (select maxWithdrawals from market where (bankID, accountID) = (ip_bankID, ip_accountID)) then
			leave sp_15; end if;
        
		if ip_withdrawal_amount <= bal then
			-- checking account has enough money, don't need overdraft
            -- set balance to balance - withdrawal
			update bank_account set
				balance = balance - ip_withdrawal_amount where (bankID, accountID) = (ip_bankID, ip_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_bankID, ip_accountID);
            leave sp_15; end if;
        
        set overdraft_needed = ip_withdrawal_amount - bal;
        if overdraft_needed <= protecting_account_bal then
			-- need overdraft and can do overdraft
			-- set checking to 0, then pull from protecting account
			update bank_account set
				balance = 0 where (bankID, accountID) = (ip_bankID, ip_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_bankID, ip_accountID);
			update checking set
				amount = overdraft_needed where (bankID, accountID) = (ip_bankID, ip_accountID);
            update checking set
				dtOverdraft = ip_dtAction where (bankID, accountID) = (ip_bankID, ip_accountID);
			update bank_account set
				balance = balance - overdraft_needed where (bankID, accountID) = (protecting_account_bankID, protecting_account_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (protecting_account_bankID, protecting_account_accountID);
			leave sp_15; end if;

	else
		-- savings/market case
        set bal = ifnull((select balance from bank_account where (bankID, accountID) = (ip_bankID, ip_accountID)), 0);
        
        if ip_withdrawal_amount > bal or bal < 0 or ip_withdrawal_amount < 0 then
			leave sp_15; end if;
		
        if exists (select * from savings where (bankID, accountID) = (ip_bankID, ip_accountID)) then
			-- savings case
            if bal - ip_withdrawal_amount < (select minBalance from savings where (bankID, accountID) = (ip_bankID, ip_accountID)) then
				leave sp_15; end if; end if;
        
        update bank_account set
			balance = balance - ip_withdrawal_amount where (bankID, accountID) = (ip_bankID, ip_accountID);
		update access set
			dtAction = ip_dtAction where (bankID, accountID) = (ip_bankID, ip_accountID);
		update market set
			-- will do nothing if it's a savings account
			numWithdrawals = ifnull(numWithdrawals, 0) + 1 where (bankID, accountID) = (ip_bankID, ip_accountID);
	end if;
end //
delimiter ;

--  call account_withdrawal("rsanchez", 200, "NASA_Goddard", "company_savings", "2022-02-02");
--  select * from bank_account;
--  select * from access;

-- [16] account_transfer()
-- If the person making the transfer does not have access to both accounts then don't change the database state
-- If the withdrawal amount is more than the account balance for a savings or market account then don't change the database state [the account balance must be positive]
-- If the withdrawal amount is more than the account balance + the overdraft balance (i.e., from the designated savings account) for a checking account then don't change the database state [the account balance must be positive]
-- Otherwise, the account balance and related info must be modified appropriately (amount deducted from the withdrawal account first, and second from the overdraft account as needed, and then added to the deposit account)
drop procedure if exists account_transfer;
delimiter //
create procedure account_transfer (in ip_requester varchar(100), in ip_transfer_amount integer,
	in ip_from_bankID varchar(100), in ip_from_accountID varchar(100),
    in ip_to_bankID varchar(100), in ip_to_accountID varchar(100), in ip_dtAction date)
sp_16:begin
	-- Implement your code here
    
    -- declare variables
    declare protecting_account_bal integer;
    declare protecting_account_bankID varchar(100);
    declare protecting_account_accountID varchar(100);
    declare bal integer;
    declare overdraft_needed integer;
    
    if ip_requester not in (select perID from access where (bankID, accountID) = (ip_from_bankID, ip_from_accountID))
		or ip_requester not in (select perID from access where (bankID, accountID) = (ip_to_bankID, ip_to_accountID)) then
		leave sp_16; end if;
    
    if exists (select * from checking where (bankID, accountID) = (ip_from_bankID, ip_from_accountID)) then
		-- checking case
        set bal = ifnull((select balance from bank_account where (bankID, accountID) = (ip_from_bankID, ip_from_accountID)), 0);
        set protecting_account_bankID = (select protectionBank from checking where (bankID, accountID) = (ip_from_bankID, ip_from_accountID));
        set protecting_account_accountID = (select protectionAccount from checking where (bankID, accountID) = (ip_from_bankID, ip_from_accountID));
        set protecting_account_bal = ifnull((select balance from bank_account where (bankID, accountID) = (ip_from_bankID, ip_from_accountID)), 0);
        
        if ip_transfer_amount < 0 then
			leave sp_16; end if;
        
		if ip_transfer_amount <= bal then
			-- checking account has enough money, don't need overdraft
            -- set balance to balance - withdrawal, and deposit
			update bank_account set
				balance = balance - ip_transfer_amount where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update bank_account set
				balance = ifnull(balance, 0) + ip_transfer_amount where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
            leave sp_16; end if;
        
        set overdraft_needed = ip_transfer_amount - bal;
        if overdraft_needed <= protecting_account_bal then
			-- need overdraft and can do overdraft
			-- set checking to 0, then pull from protecting account, then deposit
			update bank_account set
				balance = 0 where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update checking set
				amount = overdraft_needed where (bankID, accountID) = (ip_bankID, ip_accountID);
            update checking set
				dtOverdraft = ip_dtAction where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update bank_account set
				balance = balance - overdraft_needed where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (protecting_account_bankID, protecting_account_accountID);
                
			update bank_account set
				balance = ifnull(balance, 0) + ip_transfer_amount where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
			update access set
				dtAction = ip_dtAction where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
			leave sp_16; end if;

	else
		-- savings/market case
        set bal = ifnull((select balance from bank_account where (bankID, accountID) = (ip_from_bankID, ip_from_accountID)), 0);
        
        if ip_transfer_amount > bal or bal < 0 or ip_transfer_amount < 0 then
			leave sp_16; end if;
		
        update bank_account set
			balance = balance - ip_transfer_amount where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
		update access set
			dtAction = ip_dtAction where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
		update bank_account set
			balance = ifnull(balance, 0) + ip_transfer_amount where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
		update access set
			dtAction = ip_dtAction where (bankID, accountID) = (ip_to_bankID, ip_to_accountID);
		update market set
			-- will do nothing if it's a savings account
			numWithdrawals = ifnull(numWithdrawals, 0) + 1 where (bankID, accountID) = (ip_from_bankID, ip_from_accountID);
	end if;
end //
delimiter ;

-- call account_transfer('arwhite6', 2000, 'WF_2', 'checking_A', 'WF_2', 'savings_A', '2022-02-02');
-- select * from bank_account;

-- [17] pay_employees()
-- Increase each employee's pay earned so far by the monthly salary
-- Deduct the employee's pay from the banks reserved assets
-- If an employee works at more than one bank, then deduct the (evenly divided) monthly pay from each of the affected bank's reserved assets
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists pay_employees;
delimiter //
create procedure pay_employees ()
begin
   	create or replace view temp_pay as
		select bank.bankID as bank_id, ifnull(resAssets,0) - sum as final from (select bankID, sum(each_salary) as sum from (select workfor.perID as ID, truncate(ifnull(salary,0) / count(*), 0) as each_salary from workfor join employee on workfor.perID = employee.perID group by workfor.perID) as temp join workfor on temp.ID = workfor.perID group by bankID) as temp2 join bank on temp2.bankID = bank.bankID;
	update employee set earned = ifnull(earned,0) + ifnull(salary,0);
    update employee set payments = ifnull(payments,0) + 1;
	update bank left join temp_pay on bank.bankID = temp_pay.bank_id set bank.resAssets = temp_pay.final;
    update employee set earned = null where earned = 0;
	drop view temp_pay;


end //
delimiter ;

-- [18] penalize_accounts()
-- For each savings account that is below the minimum balance, deduct the smaller of $100 or 10% of the current balance from the account
-- For each market account that has exceeded the maximum number of withdrawals, deduct the smaller of $500 per excess withdrawal or 20% of the current balance from the account
-- Add all deducted amounts to the reserved assets of the bank that owns the account
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists penalize_accounts;
delimiter //
create procedure penalize_accounts ()
begin
	-- Implement your code here
    
    -- savings accounts
    update bank natural join (
		select bank.bankID, sum(case when truncate(1/10 * balance, 0) > 100 then 100 else truncate(1/10 * balance, 0) end) as sum_to_add from bank
		join bank_account on bank_account.bankID = bank.bankID
		join savings on (bank_account.bankID, bank_account.accountID) = (savings.bankID, savings.accountID)
			and balance < minBalance
		group by bank.bankID
	) as temp
	set resAssets = ifnull(resAssets + sum_to_add, 0);
    
    update bank_account
	join savings on (bank_account.bankID, bank_account.accountID) = (savings.bankID, savings.accountID)
		and balance < minBalance
	set balance = balance - case when truncate(1/10 * balance, 0) > 100 then 100 else truncate(1/10 * balance, 0) end;
    
    -- market accounts
    update bank natural join (
		select bank.bankID, sum(case when truncate(1/5 * balance, 0) > 500 * (numWithdrawals - maxWithdrawals) then 500 else truncate(1/5 * balance, 0) > 500 * (numWithdrawals - maxWithdrawals) end) as sum_to_add from bank
		join bank_account on bank_account.bankID = bank.bankID
		join market on (bank_account.bankID, bank_account.accountID) = (market.bankID, market.accountID)
			and numWithdrawals > maxWithdrawals
		group by bank.bankID
	) as temp
	set resAssets = ifnull(resAssets + sum_to_add, 0);
    
    update bank_account
	join market on (bank_account.bankID, bank_account.accountID) = (market.bankID, market.accountID)
		and numWithdrawals > maxWithdrawals
	set	balance = balance - case when truncate(1/5 * balance, 0) > 500 * (numWithdrawals - maxWithdrawals) then 500 else truncate(1/5 * balance, 0) > 500 * (numWithdrawals - maxWithdrawals) end;
    
    update bank set
		resAssets = 0 where resAssets is null;
end //
delimiter ;

-- [19] accrue_interest()
-- For each interest-bearing account that is "in good standing", increase the balance based on the designated interest rate
-- A savings account is "in good standing" if the current balance is equal to or above the designated minimum balance
-- A market account is "in good standing" if the current number of withdrawals is less than or equal to the maximum number of allowed withdrawals
-- Subtract all paid amounts from the reserved assets of the bank that owns the account                                                                       
-- Truncate any fractional results to an integer before further calculations
drop procedure if exists accrue_interest;
delimiter //
create procedure accrue_interest ()
begin
	-- Implement your code here
    
    -- savings accounts
    update bank natural join (
		select bank.bankID, sum(truncate(ifnull(balance, 0) * (ifnull(interest_rate, 0) / 100), 0)) as sum_to_subtract from bank
		join bank_account on bank_account.bankID = bank.bankID
		join interest_bearing on (bank_account.bankID, bank_account.accountID) = (interest_bearing.bankID, interest_bearing.accountID)
        join savings on (bank_account.bankID, bank_account.accountID) = (savings.bankID, savings.accountID)
			and ifnull(balance, 0) >= ifnull(minBalance, 0)
		group by bank.bankID
	) as temp
	set resAssets = ifnull(resAssets - sum_to_subtract, 0);
    
    update bank_account
	join interest_bearing on (bank_account.bankID, bank_account.accountID) = (interest_bearing.bankID, interest_bearing.accountID)
    join savings on (bank_account.bankID, bank_account.accountID) = (savings.bankID, savings.accountID)
		and ifnull(balance, 0) >= ifnull(minBalance, 0)
	set balance = truncate(balance * (1 + interest_rate / 100), 0);
    
    -- market accounts
    update bank natural join (
		select bank.bankID, sum(truncate(ifnull(balance, 0) * (ifnull(interest_rate, 0) / 100), 0)) as sum_to_subtract from bank
		join bank_account on bank_account.bankID = bank.bankID
        join interest_bearing on (bank_account.bankID, bank_account.accountID) = (interest_bearing.bankID, interest_bearing.accountID)
		join market on (bank_account.bankID, bank_account.accountID) = (market.bankID, market.accountID)
			and ifnull(numWithdrawals, 0) <= ifnull(maxWithdrawals, 0)
		group by bank.bankID
	) as temp
	set resAssets = ifnull(resAssets - sum_to_subtract, 0);
    
    update bank_account
    join interest_bearing on (bank_account.bankID, bank_account.accountID) = (interest_bearing.bankID, interest_bearing.accountID)
	join market on (bank_account.bankID, bank_account.accountID) = (market.bankID, market.accountID)
		and ifnull(numWithdrawals, 0) <= ifnull(maxWithdrawals, 0)
	set	balance = truncate(balance * (1 + interest_rate / 100), 0);
    
    update bank set
		resAssets = 0 where resAssets is null;
end //
delimiter ;

-- [20] display_account_stats()
-- Display the simple and derived attributes for each account, along with the owning bank
create or replace view display_account_stats as
    -- Uncomment above line and implement your code here
    select bankName as name_of_bank, bank_account.accountID as account_identifier, balance as account_assets, count(*)
    from bank_account natural join bank
    join access on (bank_account.bankID, bank_account.accountID) = (access.bankID, access.accountID)
    group by bank_account.bankID, bank_account.accountID;

-- [21] display_bank_stats()
-- Display the simple and derived attributes for each bank, along with the owning corporation
create or replace view display_bank_stats as
    -- Uncomment above line and implement your code here
	select bank.bankID as bank_identifier, corporation.shortName as name_of_corporation, bank.bankName as name_of_bank, bank.street, bank.city, bank.state, bank.zip, num_accounts.num as number_of_accounts, bank.resAssets as bank_assets, ifnull(bank.resAssets, 0) + ifnull(sum(bank_account.balance), 0) as total_assets
	from bank natural left join (
		select bankID, count(*) as num from bank_account
		group by bankID
	) as num_accounts
	natural left join bank_account
	left join corporation on bank.corpID = corporation.corpID
	group by bank.bankID;
    

-- [22] display_corporation_stats()
-- Display the simple and derived attributes for each corporation
create or replace view display_corporation_stats as
    -- Uncomment above line and implement your code here
	select corporation.corpID as corporation_identifier, corporation.shortName as short_name, corporation.longName as formal_name, num_banks.num as number_of_banks, corporation.resAssets as corporation_assets, corporation.resAssets + ifnull(sum(bank_assets.total_assets), 0) as total_assets
	from corporation left join (
		select bank.bankID, corporation.corpID, ifnull(bank.resAssets, 0) + ifnull(sum(bank_account.balance), 0) as total_assets
		from bank natural left join bank_account
		left join corporation on bank.corpID = corporation.corpID
		group by bank.bankID
	) as bank_assets
	on corporation.corpID = bank_assets.corpID
	left join (
		select corpID, count(*) as num from bank
		group by corpID
	) as num_banks
	on num_banks.corpID = corporation.corpID
	group by corporation.corpID;

-- [23] display_customer_stats()
-- Display the simple and derived attributes for each customer
create or replace view display_customer_stats as
    -- Uncomment above line and implement your code here
	select bank_user.perID as person_identifier, bank_user.taxID as tax_identifier, concat(bank_user.firstName, ' ', bank_user.lastName) as customer_name,
		bank_user.birthDate as date_of_birth, bank_user.dtJoined as joined_system, bank_user.street, bank_user.city, bank_user.state, bank_user.zip,
		case when count(access.perID) = 0 then null else count(access.perID) end as number_of_accounts,ifnull(sum(bank_account.balance), 0) as customer_assets
	from customer natural left join bank_user
	natural left join access
	left join bank_account on (access.bankID, access.accountID) = (bank_account.bankID, bank_account.accountID)
	group by bank_user.perID;
	-- the case stuff is because they seemingly want null instead of 0 when number_of_accounts should be 0

-- [24] display_employee_stats()
-- Display the simple and derived attributes for each employee
create or replace view display_employee_stats as
    -- Uncomment above line and implement your code here
	select bank_user.perID as person_identifier, bank_user.taxID as tax_identifier, concat(bank_user.firstName, ' ', bank_user.lastName) as employee_name,
		bank_user.birthDate as date_of_birth, bank_user.dtJoined as joined_system, bank_user.street, bank_user.city, bank_user.state, bank_user.zip,
		case when count(workfor.perID) = 0 then null else count(workfor.perID) end as number_of_accounts,
        sum(display_bank_stats.total_assets) as bank_assets
	from employee natural left join bank_user
	natural left join workfor
    left join display_bank_stats on workfor.bankID = display_bank_stats.bank_identifier
	group by bank_user.perID;




