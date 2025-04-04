import string
import random
import os
caracteres = list(string.ascii_letters + string.digits + "&~#{}()[]-|`_^@°=+¨$£%*,?;.:/!²")
def passwd_python():
    random.shuffle(caracteres)
    passwd = []
    for i in range(100):
        passwd.append(random.choice(caracteres))
    random.shuffle(passwd)
    return "".join(passwd)
def save_password(password):
    filename = "password.txt"
    with open(filename, "a") as file:
        file.write(password + "\n") 
generated_password = passwd_python()
print(generated_password)
save_password(generated_password)
