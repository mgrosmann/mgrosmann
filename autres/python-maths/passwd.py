import string,random,mysql.connector
caracteres = list(string.ascii_letters + string.digits + "&~#{}()[]-|`_^@°=+¨$£%*,?;.:/!²")
def passwd_python():
    random.shuffle(caracteres)
    passwd = []
    for i in range(100):
        passwd.append(random.choice(caracteres))
    random.shuffle(passwd)
    return "".join(passwd)
generated_password = passwd_python()
print(generated_password)
mydb = mysql.connector.connect(
  host="127.0.0.1",
  user="root",
  password="root",
  database="passwd_python"  # Spécifier la base de données ici
)
mycursor = mydb.cursor()
query = "INSERT INTO passwd_list (passwd_100) VALUES (%s)"
mycursor.execute(query, (generated_password,))
mydb.commit()
mycursor.close()
mydb.close()
