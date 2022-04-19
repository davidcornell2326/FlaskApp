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




