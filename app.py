# https://code.tutsplus.com/tutorials/creating-a-web-app-from-scratch-using-python-flask-and-mysql--cms-22972
from flask import Flask, render_template, json, request
from flaskext.mysql import MySQL

from dotenv import dotenv_values
from os.path import exists

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

    cursor.execute("select perID from person")
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
    cursor.execute("select bankID, accountID from bank_account")
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
    return display_table("display_account_stats", "Display account stats", ["Bank", "Account ID", "Account Balance ($)", "Number of Owners"])

@app.route('/15')
def screen_15():
    return display_table("display_bank_stats", "Display bank stats", ["Bank ID", "Corporation Name", "Bank Name", "Street", "City", "State", "Zip", "Number of Accounts", "Bank Assets ($)", "Total Assets ($)"])

@app.route('/16')
def screen_16():
    return display_table("display_corporation_stats", "Display corporation stats", ["Corporation ID", "Short Name", "Formal Name", "Number of Banks", "Corporation Assets ($)", "Total Assets ($)"])

@app.route('/17')
def screen_17():
    return display_table("display_customer_stats", "Display customer stats", ["Customer ID", "Tax ID", "Customer Name", "Date of Birth", "Date Joined", "Street", "City", "State", "Zip", "Number of Accounts", "Customer Assets ($)"])

@app.route('/18')
def screen_18():
    return display_table("display_employee_stats", "Employee Stats", ["Per ID", "Tax ID", "Name", "Date of Birth", "Date Joined", "Street", "City", "State", "Zip", "Number of Banks", "Bank Assets ($)"])

def display_table(table, pretty_title="", col_override=[]):
    cursor.execute("select * from " + table)
    rows = list(cursor.fetchall())
    cols = []
    if col_override != []:
        cols = col_override
    else:
        for col in cursor.description:
            cols.append(col[0])
    if pretty_title != "":
        table = pretty_title
    
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
    _salary = request.form['salary']
    _numPayments = request.form['numPayments']
    _earnings = request.form['earnings']
    
    cursor.callproc('start_employee_role', [])      # NOT WORKING YET

    data = cursor.fetchall()
    if len(data) == 0:
        conn.commit()
        return json.dumps({'message':'Success'})
    else:
        return json.dumps({'error':str(data[0])})

@app.route('/api/4',methods=['POST'])
def screen_4_submit():
    _perID = request.form['perID']
    
    cursor.callproc('start_customer_role', [])      # NOT WORKING YET

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
    
    cursor.callproc('hire_worker', [])      # NOT WORKING YET

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
    
    cursor.callproc('replace_manager', [_perID, _bankID, salary])      # NOT WORKING YET

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