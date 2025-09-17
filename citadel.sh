#!/bin/bash
# TODO: instalar dos2unix en Ubuntu (x algún motivo)


login() {
    echo "Bienvenido a Citadel."
    user_found=false
    user_name=""
    user_passwd=""
    while [ "$user_found" = "false" ]; do
        echo "Por favor, ingrese su nombre de usuario."
        read usuario
        while IFS='@' read -r user passwd; do
            passwd=$(echo "$passwd" | tr -d '\r\n') # esto es para eliminar los caracteres \n al final de cada línea.
            if [ "$usuario" = "$user" ] && [ "$user_found" = "false" ]; then
                user_found=true
                user_name="$user"
                user_passwd="$passwd"
                break
            fi
        done < usuarios.txt
        if [ "$user_found" = "false" ]; then
            echo "Usuario no encontrado. Intente nuevamente."
        else
            echo "Contraseña:"
            read -s passwd
            if [ "$user_passwd" = "$passwd" ]; then
                echo "Bienvenido, $user_name."
                break
            else
                echo "Contraseña incorrecta."
                user_found=false
            fi
        fi
    done
}

login