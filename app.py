# https://code.tutsplus.com/tutorials/creating-a-web-app-from-scratch-using-python-flask-and-mysql--cms-22972
from flask import Flask, render_template, json, request
from flaskext.mysql import MySQL

from dotenv import dotenv_values
from os.path import exists
from datetime import date

user = 'root'
password = ' '
if (exists(".env")):
    config = dotenv_values(".env")
    user = config['USER']
    password = config['PASSWORD']

app = Flask(__name__)
mysql = MySQL()
 
# MySQL configurations
app.config['MYSQL_DATABASE_USER'] = user
app.config['MYSQL_DATABASE_PASSWORD'] = password
app.config['MYSQL_DATABASE_DB'] = 'bank_management'
app.config['MYSQL_DATABASE_HOST'] = 'localhost'
mysql.init_app(app)

conn = mysql.connect()
cursor = conn.cursor()

@app.route("/tutorial")
def tutorial():
    return render_template('tutorial_index.html')

@app.route("/")
def main():
    return render_template('index.html')

# Updating data
@app.route('/1')
def screen_1():
    return render_template('1_create_corporation.html')

@app.route('/2')
def screen_2():
    cursor.execute("select corpID from corporation")
    rows = list(cursor.fetchall())
    corpIDs = [row[0] for row in rows]

    cursor.execute("select perID from employee")
    rows = list(cursor.fetchall())
    employees = [row[0] for row in rows]
    # TODO: make dropdowns only have employees who aren't already managers?

    return render_template('2_create_bank.html', corpIDs=corpIDs, managers=employees, bankEmployees=employees)

@app.route('/3')
def screen_3():
    cursor.execute("select perID from bank_user")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]
    return render_template('3_create_employee_role.html', perIDs=perIDs)

@app.route('/4')
def screen_4():
    cursor.execute("select perID from bank_user")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]
    return render_template('4_create_customer_role.html', perIDs=perIDs)

@app.route('/5_1')
def screen_5_1():
    cursor.execute("select perID from employee")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]
    return render_template('5_1_stop_employee_role.html', perIDs=perIDs)

@app.route('/5_2')
def screen_5_2():
    cursor.execute("select perID from customer")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]
    return render_template('5_2_stop_customer_role.html', perIDs=perIDs)

@app.route('/6')
def screen_6():
    cursor.execute("select bankID from bank")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select * from employee")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]

    return render_template('6_hire_worker.html', bankIDs=bankIDs, perIDs=perIDs)

@app.route('/7')
def screen_7():
    cursor.execute("select bankID from bank")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select perID from employee")
    rows = list(cursor.fetchall())
    perIDs = [row[0] for row in rows]

    return render_template('7_replace_manager.html', bankIDs=bankIDs, perIDs=perIDs)

@app.route('/8_1')
def screen_8_1():
    cursor.execute("select bankID, accountID from bank_account") # TODO: only have accounts accessible to currently logged in user
    rows = list(cursor.fetchall())
    accounts = [(row[0], row[1]) for row in rows]

    cursor.execute("select perID from customer")
    rows = list(cursor.fetchall())
    customers = [row[0] for row in rows]

    return render_template('8_1_manage_accounts_customer.html', accounts=accounts, customers=customers)

# TODO: admin should have separate submit buttons for two portions maybe??
@app.route('/8_2')
def screen_8_2():
    cursor.execute("select bankID from bank")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    accountTypes = ['Savings', 'Market', 'Checking']

    return render_template('8_2_manage_accounts_admin.html', bankIDs=bankIDs, accountTypes=accountTypes)

@app.route('/9')
def screen_9():
    # TODO: only include interest-bearing accounts
    cursor.execute("select bankID from bank_account")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select accountID from bank_account")
    rows = list(cursor.fetchall())
    accountIDs = [row[0] for row in rows]

    return render_template('9_create_fee.html', bankIDs=bankIDs, accountIDs=accountIDs)

# TODO: make savings accounts appear only when adding, not removing
@app.route('/10')
def screen_10():
    cursor.execute("select bankID, accountID from checking")
    rows = list(cursor.fetchall())
    checkingAccounts = [(row[0], row[1]) for row in rows]

    cursor.execute("select bankID, accountID from savings")
    rows = list(cursor.fetchall())
    savingsAccounts = [(row[0], row[1]) for row in rows]

    # TODO: make savings account option only appear if button checked
    return render_template('10_start_stop_overdraft.html', checkingAccounts=checkingAccounts, savingsAccounts=savingsAccounts)

@app.route('/11_1')
def screen_11_1():
    cursor.execute("select bankID from bank_account")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select accountID from bank_account")
    rows = list(cursor.fetchall())
    accountIDs = [row[0] for row in rows]

    return render_template('11_1_deposit.html', bankIDs=bankIDs, accountIDs=accountIDs)

@app.route('/11_2')
def screen_11_2():
    cursor.execute("select bankID from bank_account")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select accountID from bank_account")
    rows = list(cursor.fetchall())
    accountIDs = [row[0] for row in rows]

    return render_template('11_2_withdraw.html', bankIDs=bankIDs, accountIDs=accountIDs)

@app.route('/12')
def screen_12():
    cursor.execute("select bankID from bank_account")
    rows = list(cursor.fetchall())
    bankIDs = [row[0] for row in rows]

    cursor.execute("select accountID from bank_account")
    rows = list(cursor.fetchall())
    accountIDs = [row[0] for row in rows]

    return render_template('12_transfer.html', fromBankIDs=bankIDs, fromAccountIDs=accountIDs, toBankIDs=bankIDs, toAccountIDs=accountIDs)

@app.route('/13')
def screen_13():
    return render_template('13_pay_employees.html')

# Displaying data
@app.route('/14')
def screen_14():
    return display_table("display_account_stats")

@app.route('/15')
def screen_15():
    return display_table("display_bank_stats")

@app.route('/16')
def screen_16():
    return display_table("display_corporation_stats")

@app.route('/17')
def screen_17():
    return display_table("display_customer_stats")

@app.route('/18')
def screen_18():
    return display_table("display_employee_stats")

def display_table(table):
    cursor.execute("select * from " + table)
    rows = list(cursor.fetchall())
    cols = []
    for col in cursor.description:
        cols.append(col[0])
    return render_template('display_table.html', title=table, rows=rows, cols=cols)

# Navigation
@app.route('/19')
def screen_19():
    return render_template('19_login.html')

@app.route('/20')
def screen_20():
    return render_template('20_admin_navigation.html')

@app.route('/21')
def screen_21():
    return render_template('21_manage_users.html')

@app.route('/22')
def screen_22():
    return render_template('22_view_stats.html')

@app.route('/23')
def screen_23():
    return render_template('23_manager_navigation.html')

@app.route('/24')
def screen_24():
    return render_template('24_customer_navigation.html')


# APIs

@app.route('/api/1',methods=['POST'])
def screen_1_submit():
    _corpID = request.form['corpID']
    _shortName = request.form['shortName']
    _longName = request.form['longName']
    _resAssets = request.form['resAssets']

    cursor.callproc('create_corporation', [_corpID, _shortName, _longName, _resAssets])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/2',methods=['POST'])
def screen_2_submit():
    _bankID = request.form['bankID']
    _bankName = request.form['bankName']
    _street = request.form['street']
    _city = request.form['city']
    _state = request.form['state']
    _zip = request.form['zip']
    _resAssets = request.form['resAssets']
    _corpID = request.form['corpID']
    _manager = request.form['manager']
    _bankEmployee = request.form['bankEmployee']

    cursor.callproc('create_bank', [_bankID, _bankName, _street, _city, _state, _zip, _resAssets, _corpID, _manager, _bankEmployee])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/3',methods=['POST'])
def screen_3_submit():
    _perID = request.form['perID']

    cursor.execute("select pwd from person where perID = \'" + _perID + "\'")
    rows = list(cursor.fetchall())
    pwd = rows[0][0]

    cursor.execute("select * from bank_user where perID = \'" + _perID + "\'")
    rows = list(cursor.fetchall())
    bank_user = rows[0]

    _taxID = bank_user[1]
    _firstName = bank_user[3]
    _lastName = bank_user[4]
    _birthdate = bank_user[2]
    _street = bank_user[6]
    _city = bank_user[7]
    _state = bank_user[8]
    _zip = bank_user[9]
    _dtJoined = bank_user[5]
    _salary = request.form['salary']
    _payments = request.form['numPayments']
    _earned = request.form['earnings']
    _password = pwd
    
    cursor.callproc('start_employee_role', [_perID, _taxID, _firstName, _lastName, _birthdate, _street, _city, _state, _zip, _dtJoined, _salary, _payments, _earned, _password])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/4',methods=['POST'])
def screen_4_submit():
    _perID = request.form['perID']

    cursor.execute("select pwd from person where perID = \'" + _perID + "\'")
    rows = list(cursor.fetchall())
    pwd = rows[0][0]

    cursor.execute("select * from bank_user where perID = \'" + _perID + "\'")
    rows = list(cursor.fetchall())
    bank_user = rows[0]

    _taxID = bank_user[1]
    _firstName = bank_user[3]
    _lastName = bank_user[4]
    _birthdate = bank_user[2]
    _street = bank_user[6]
    _city = bank_user[7]
    _state = bank_user[8]
    _zip = bank_user[9]
    _dtJoined = bank_user[5]
    _password = pwd
    
    cursor.callproc('start_customer_role', [_perID, _taxID, _firstName, _lastName, _birthdate, _street, _city, _state, _zip, _dtJoined, _password])      # NOT WORKING YET

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/5_1',methods=['POST'])
def screen_5_1_submit():
    _perID = request.form['perID']
    
    cursor.callproc('stop_employee_role', [_perID])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/5_2',methods=['POST'])
def screen_5_2_submit():
    _perID = request.form['perID']
    
    cursor.callproc('stop_customer_role', [_perID])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/6',methods=['POST'])
def screen_6_submit():
    _bankID = request.form['bankID']
    _perID = request.form['perID']
    _salary = request.form['salary']
    
    cursor.callproc('hire_worker', [_perID, _bankID, _salary])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/7',methods=['POST'])
def screen_7_submit():
    _bankID = request.form['bankID']
    _perID = request.form['perID']
    _salary = request.form['salary']
    
    cursor.callproc('replace_manager', [_perID, _bankID, salary])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/8_1',methods=['POST'])
def screen_8_1_submit():
    # 'mmoss7', 'atrebek1', 'savings', 'TD_GT', 'new_savings', 4000, 10, null, 0, null, null, '2022-03-03'
    _requester = 'mmoss7' # TODO: requester needs to be currently logged in user
    _customer = request.form['customer']
    _account = request.form['account'] # TODO: need to parse differently once styling is done 
    mid = _account.index('\', \'')
    _bankID = _account[2:mid]
    _accountID = _account[mid+4:len(_account)-2]

    # get account type
    cursor.execute('select * from savings where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'savings'
    cursor.execute('select * from checking where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'checking'
    cursor.execute('select * from market where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'market'

    cursor.execute('select balance from bank_account where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    _balance = rows[0][0]
    
    _interestRate = None
    _dtDeposit = None
    _minBalance = None
    _numWithdrawals = None
    _maxWithdrawals = None
    _dtShareStart = str(date.today())

    if _accountType == 'savings':
        cursor.execute('select minBalance from savings where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _minBalance = rows[0][0]
    elif _accountType == 'market':
        cursor.execute('select maxWithdrawals, numWithdrawals from market where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _maxWithdrawals = rows[0][0]
        _numWithdrawals = rows[0][1]

    if _accountType == 'savings' or _accountType == 'market':
        cursor.execute('select interest_rate, dtDeposit from interest_bearing where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _interestRate = rows[0][0]
        _dtDeposit = rows[0][1]

    _adding = request.form['addingRemoving'] == 'Adding' # True if adding, False if removing


    if _adding:
        cursor.callproc('add_account_access', [_requester, _customer, _accountType, _bankID, _accountID, _balance, _interestRate, _dtDeposit, _minBalance, _numWithdrawals, _maxWithdrawals, _dtShareStart])
    else:
        cursor.callproc('remove_account_access', [_requester, _customer, _bankID, _accountID])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/8_2',methods=['POST'])
def screen_8_2_submit():
    # 'mmoss7', 'atrebek1', 'savings', 'TD_GT', 'new_savings', 4000, 10, null, 0, null, null, '2022-03-03'
    _requester = 'mmoss7' # TODO: requester needs to be currently logged in user
    _customer = request.form['customer']
    _account = request.form['account'] # TODO: need to parse differently once styling is done 
    mid = _account.index('\', \'')
    _bankID = _account[2:mid]
    _accountID = _account[mid+4:len(_account)-2]

    # get account type
    cursor.execute('select * from savings where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'savings'
    cursor.execute('select * from checking where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'checking'
    cursor.execute('select * from market where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    if len(rows) > 0:
        _accountType = 'market'

    cursor.execute('select balance from bank_account where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
    rows = list(cursor.fetchall())
    _balance = rows[0][0]
    
    _interestRate = request.form['balance']
    _dtDeposit = None
    _minBalance = request.form['minBalance']
    _numWithdrawals = request.form['numWithdrawals']
    _maxWithdrawals = request.form['maxWithdrawals']
    _dtShareStart = str(date.today())

    if _accountType == 'savings':
        cursor.execute('select minBalance from savings where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _minBalance = rows[0][0]
    elif _accountType == 'market':
        cursor.execute('select maxWithdrawals, numWithdrawals from market where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _maxWithdrawals = rows[0][0]
        _numWithdrawals = rows[0][1]

    if _accountType == 'savings' or _accountType == 'market':
        cursor.execute('select interest_rate, dtDeposit from interest_bearing where (bankID, accountID) = (\'' + _bankID + '\', \'' + _accountID + '\')')
        rows = list(cursor.fetchall())
        _interestRate = rows[0][0]
        _dtDeposit = rows[0][1]

    _adding = request.form['addingRemoving'] == 'Adding' # True if adding, False if removing


    if _adding:
        cursor.callproc('add_account_access', [_requester, _customer, _accountType, _bankID, _accountID, _balance, _interestRate, _dtDeposit, _minBalance, _numWithdrawals, _maxWithdrawals, _dtShareStart])
    else:
        cursor.callproc('remove_account_access', [_requester, _customer, _bankID, _accountID])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/9',methods=['POST'])
def screen_9_submit():
    _bankID = request.form['bankID']
    _accountID = request.form['accountID']
    _feeType = request.form['feeType']

    cursor.callproc('create_fee', [_bankID, _accountID, _feeType])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/10',methods=['POST'])
def screen_10_submit():
    # start: 'tjtalbot4', 'TD_Online', 'company_checking', 'WF_2', 'savings_A'
    # stop: "owalter6", "BA_West", "checking_A"
    _requester = 'tjtalbot4'
    # TODO: requester needs to be currently logged in user
    _checkingAccount = request.form['checkingAccount'] # TODO: need to parse differently once styling is done 
    mid = _checkingAccount.index('\', \'')
    _checkingBankID = _checkingAccount[2:mid]
    _checkingAccountID = _checkingAccount[mid+4:-2]
    _start = request.form['startStop'] == 'Start' # True if start, False if stop
    _savingsAccount = request.form['savingsAccount'] # TODO: need to parse differently once styling is done 
    mid = _savingsAccount.index('\', \'')
    _savingsBankID = _savingsAccount[2:mid]
    _savingsAccountID = _savingsAccount[mid+4:-2]

    if _start:
        cursor.callproc('start_overdraft', [_requester, _checkingBankID, _checkingAccountID, _savingsBankID, _savingsAccountID])
    else:
        cursor.callproc('stop_overdraft', [_requester, _checkingBankID, _checkingAccountID])


    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/11_1',methods=['POST'])
def screen_11_1_submit():
    _requester = ''
    # TODO: requester needs to be currently logged in user
    _amount = request.form['amount']
    _bankID = request.form['bankID']
    _accountID = request.form['accountID']
    _dtAction = str(date.today())

    cursor.callproc('account_deposit', [_requester, _amount, _bankID, _accountID, _dtAction])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/11_2',methods=['POST'])
def screen_11_2_submit():
    _requester = ''
    # TODO: requester needs to be currently logged in user
    _amount = request.form['amount']
    _bankID = request.form['bankID']
    _accountID = request.form['accountID']
    _dtAction = str(date.today())

    cursor.callproc('account_withdrawal', [_requester, _amount, _bankID, _accountID, _dtAction])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/12',methods=['POST'])
def screen_12_submit():
    _requester = ''
    # TODO: requester needs to be currently logged in user
    _fromBankID = request.form['fromBankID']
    _fromAccountID = request.form['fromAccountID']
    _amount = request.form['amount']
    _toBankID = request.form['toBankID']
    _toAccountID = request.form['toAccountID']
    _dtAction = str(date.today())

    cursor.callproc('account_transfer', [_requester, _amount, _fromBankID, _fromAccountID, _toBankID, _toAccountID, _dtAction])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/13',methods=['POST'])
def screen_13_submit():
    cursor.callproc('pay_employees', [])

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})



# execute a sql file
def exec_sql_file(cursor, sql_file):
    print("\n[INFO] Executing SQL script file: '%s'" % (sql_file))
    statement = ""

    import re
    for line in open(sql_file):
        if re.match(r'--', line):  # ignore sql comment lines
            continue
        if not re.search(r';$', line):  # keep appending lines that don't end in ';'
            statement = statement + " " + line.strip()
        else:  # when you get a line ending in ';' then exec statement and reset for next statement
            statement = statement + " " + line.strip()
            # print("\n\n[DEBUG] Executing SQL statement:\n%s" % (statement))
            try:
                cursor.execute(statement)
            except (OperationalError, ProgrammingError) as e:
                print("\n[WARN] MySQLError during execute statement \n\tArgs: '%s'" % (str(e.args)))

            statement = ""
    conn.commit()

# Method to reset the database contents (does NOT reset the stored procedures)
@app.route('/api/reset',methods=['POST'])
def reset_db():
    print('Resetting the database...')
    exec_sql_file(cursor, "reset.sql")
    print('Reset the database.')

    return json.dumps({'message':'Reset database'})

# if you want to initialize database when the first request is receieved after startup:
# @app.before_first_request
# def _():
#     reset_db()

if __name__ == "__main__":
    app.run()



# TODO: make add_person method/page that adds a person to person and bank_user (and maybe add admin as an option?)
# TODO: logout screen