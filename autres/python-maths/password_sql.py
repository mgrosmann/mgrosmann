import random
import string
import mysql.connector

def generate_password(length):
    digits = string.digits
    lower_case = string.ascii_lowercase
    upper_case = string.ascii_uppercase
    symbols = "!\"#$%&()*+,-./:;<=>?@[\\]^_`{|}~"
    all_characters = digits + lower_case + upper_case + symbols
    password_characters = random.sample(all_characters, len(all_characters))
    while len(password_characters) < length:
        next_char = random.choice(all_characters)
        if next_char not in password_characters[-2:]:
            password_characters.append(next_char)
    random.shuffle(password_characters)
    password = ''.join(password_characters[:length])
    return password

def insert_password(password):
    connection = mysql.connector.connect(
        host='127.0.0.1',       # Adresse du serveur MySQL
        user='admin',   # Nom d'utilisateur MySQL
        password='admin', # Mot de passe MySQL
        database='passwd_python'  # Nom de la base de données
    )

    cursor = connection.cursor()

    query = "INSERT INTO passwd_list (passwd_100) VALUES (%s)"
    cursor.execute(query, (password,))

    connection.commit()

    print("Mot de passe inséré avec succès dans la base de données.")

    cursor.close()
    connection.close()

password = generate_password(100)
print("Mot de passe généré :", password)

insert_password(password)