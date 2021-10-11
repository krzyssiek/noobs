#!/usr/bin/env bash
# Tworzenie nowego uzytkownika, z dostepem do sudo i kopia authorized_keys
# Autor: Radoslaw Karasinski, Grzegorz Ćwikliński

_check_if_user_exits() {
    given_user=$1
    if sudo id "${given_user}" &>/dev/null; then
            echo "Użytkownik ${given_user} już istnieje!"
            exit 1
    fi
}

_check_if_user_blank() {
    given_user=$1
    if [ -z "$1" ]; then
        echo "Nie podałeś nazwy użytkownia!"
        exit 1
fi
}

if ! [ -z "$1" ]; then
    username=$1
else
    echo "Podaj nazwę użytkownika:"
    read username
fi

_check_if_user_blank $username
_check_if_user_exits $username

# stworz nowego uzytkownika
sudo adduser $username

# dodaj nowego uzytkownika do sudo
sudo usermod -aG sudo $username

ssh_dir="/home/$username/.ssh"

# stworz folder na ustawienia ssh oraz ustaw odpowiednie prawa
sudo mkdir -p $ssh_dir
sudo chmod 700 $ssh_dir

# stworz authorized_keys oraz ustaw odpowiednie prawa
sudo touch $ssh_dir/authorized_keys
sudo chmod 600 $ssh_dir/authorized_keys

# zmien wlasciciela folderu i plikow
sudo chown -R $username:$username $ssh_dir

# skopiuj klucze obecnego uzytkownika do nowo stworzoneg
cat ~/.ssh/authorized_keys | sudo tee -a $ssh_dir/authorized_keys >/dev/null

echo "Pomyślnie stworzono użytkownia ${username}."
