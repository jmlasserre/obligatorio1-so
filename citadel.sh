#!/bin/bash
# TODO: instalar dos2unix en Ubuntu (x algún motivo)

user_actual=""

login() {
    echo "*** Inicio de sesión ***"
    user_found=false
    user_name=""
    user_passwd=""
    while [ "$user_found" = "false" ]; do
        echo "Por favor, ingrese su nombre de usuario."
        read usuario
        if [ "$usuario" = "" ]; then
            echo "[ERROR] El usuario no puede estar vacío."
        else
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
                echo "[ERROR] Usuario no encontrado. Intente nuevamente."
            else
                echo "Contraseña:"
                read -s passwd
                if [ "$passwd" = "" ]; then
                    echo "[ERROR] La contraseña no puede ser vacía."
                    user_found=false
                    elif [ "$user_passwd" = "$passwd" ]; then
                    echo "Bienvenido, $user_name."
                    user_actual="$user_name"
                    break
                else
                    echo "[ERROR] Contraseña incorrecta."
                    user_found=false
                fi
            fi
        fi
    done
    sleep 1;
}

logout() {
    echo "[WARNING] ¿Deseas cerrar la sesión? (y/n)"
    read option
    if [ option = "y" ]; then
        user_actual=""
        echo "*** Cerrando sesión... ***"
        elif [ option = "n" ]; then
        echo "*** Regresando al menú... ***"
    else
        echo "Opción incorrecta."
    fi
    sleep 1;
}

crearUsuario() {
    echo "*** Creación de usuario ***"
    echo "Ingrese el nombre del usuario a crear:"
    read user_name
    user_exists=false
    while IFS='@' read -r user passwd; do
        if [ "$user_name" = "$user" ]; then
            user_exists=true
        fi
    done < usuarios.txt
    if [ "$user_exists" = "false" ]; then
        echo "Ingrese la contraseña a utilizar:"
        read -s passwd_1
        while [ "$passwd_1" = "" ]; do
            echo "[ERROR] La contraseña no puede ser vacía. Vuelve a intentarlo."
            read -s passwd_1
        done
        echo "Confirme la contraseña:"
        read -s passwd_2
        if [ "$passwd_1" = "$passwd_2" ]; then
            echo "${user_name}@${passwd_1}" >> usuarios.txt
            echo "Usuario $user_name registrado con éxito."
        else
            echo "[ERROR] Las contraseñas no son iguales. Vuelve a intentarlo."
        fi
    else
        echo "[ERROR] El usuario ingresado ya existe. Debes elegir un nombre distinto."
    fi
    echo "*** Regresando al menú... ***"
    sleep 1;
}

cambiarContraseña() {
    echo "*** Cambio de contraseña ***"
    echo "Ingrese el nombre de usuario:"
    read username
    user_found=false
    user_name=""
    user_passwd=""
    while IFS='@' read -r user passwd; do
        passwd=$(echo "$passwd" | tr -d '\r\n')
        if [ "$user" = "$username" ]; then
            user_found="true"
            user_passwd="$passwd"
            user_name="$user"
        fi
    done < usuarios.txt
    if [ "$user_found" = "true" ]; then
        echo "Ingrese la contraseña actual."
        read -s contra
        if [ "$contra" = "$user_passwd" ]; then
            echo "Ingrese la nueva contraseña para $user_name."
            read -s new_contra
            sed -i "s|"$user_name@$user_passwd"|"$user_name@$new_contra"|g" usuarios.txt
            echo "Contraseña modificada exitosamente."
        else
            echo "Contraseña incorrecta."
        fi
    else
        echo "Usuario no encontrado."
    fi
    echo "*** Regresando al menú... ***"
    sleep 1;
}

ingresarProducto() {
    echo "*** Ingreso de producto ***"
    echo "Ingrese el código de producto:"
    read codigo
    echo ${#codigo}
    while [ ${#codigo} -ne 3 -o "$codigo" != "${codigo^^}" ]; do
        echo "[ERROR] Formato inválido de código. Vuelve a intentarlo."
        read codigo
    done
    codigo="${codigo^^}"
    echo "Ingrese el tipo de producto a agregar:"
    read tipo
    echo "$codigo"
    while [ "$codigo" != "BAS" -a "$codigo" != "LAY" -a "$codigo" != "SHA" -a "$codigo" != "DRY" -a "$codigo" != "CON" -a "$codigo" != "TEC" -a "$codigo" != "TEX" -a "$codigo" != "MED" ]; do
        echo "[ERROR] El tipo ingresado no corresponde al código ingresado ($codigo). Vuelve a intentarlo."
        read tipo
    done
    echo "Ingrese el nombre de modelo:"
    read modelo
    while [ "$modelo" == "" ]; do
        echo "[ERROR] El modelo no puede ser vacío. Vuelve a intentarlo."
        read modelo
    done
    echo "Ingrese una breve descripción del producto:"
    read descripcion
    while [ "$descripcion" == "" ]; do
        echo "[ERROR] La descripción no puede ser vacía. Vuelve a intentarlo."
    done
    echo "Ingrese la cantidad de stock inicial:"
    read stock_inicial
    while ! [[ "$stock_inicial" =~ ^[+]?[0-9]+$ ]]; do # esta regex filtra únicamente números positivos
        echo "[ERROR] Valor de stock inválido. Vuelva a intentarlo."
        read stock_inicial
    done
    echo "Ingrese el precio por unidad del producto:"
    read precio
    while ! [[ "$precio" =~ ^[+]?[0-9]+$ ]]; do
        echo "[ERROR] Valor de precio inválido (debe ser mayor a 0). Vuelva a intentarlo."
        read precio
    done
    
    echo "Producto ingresado exitosamente."
    echo "${codigo} - ${tipo} - ${modelo} - ${descripcion} - ${stock_inicial} - $ ${precio}" >> productos.txt
    echo "${codigo} - ${tipo} - ${modelo} - ${descripcion} - ${stock_inicial} - $ ${precio}"
    echo "*** Regresando al menú... ***"
    sleep 1;
}

inicializar()
{
    touch usuarios.txt
    if ! [ -r usuarios.txt ]; then
        echo "admin@admin" > usuarios.txt
    fi
    if ! [ -r productos.txt ]; then
        touch productos.txt
    fi
}

menu()
{
    while true; do
        clear
        echo "Citadel"
        echo "--------------------------------------------"
        echo "1 - Gestión de Usuarios"
        echo "2 - Ingresar Producto"
        echo "3 - Vender Producto"
        echo "4 - Filtro De Productos"
        echo "5 - Crear Reporte De Pinturas"
        echo "6 - Salir"
        
        read -p "¿Qué desea hacer? " opcion #read -p es para que sea un prompt
        
        case $opcion in
            1) mUsuario;;
            2) ingresarProducto;;
            3) venderProducto;;
            4) filtroProductos;;
            5) reportePinturas;;
            6)
                echo "*** Cerrando sesión. ¡Hasta luego! ***";
            break;;
            *)
                echo "[ERROR] Opción inválida.";
            sleep 1;;
        esac
    done
}

mUsuario()
{
    while true; do
        clear
        echo "Gestión de Usuarios"
        echo "--------------------------------------------"
        echo "1 - Crear Usuario"
        echo "2 - Cambiar Contraseña"
        echo "3 - Login"
        echo "4 - Logout"
        echo "5 - Salir"
        
        read -p "¿Qué desea hacer? " opcion #read -p es para que sea un prompt
        
        case $opcion in  #opcion,, es para que sea lowercase
            1)
                crearUsuario;
            break;;
            2)
                cambiarContraseña;
            break;;
            3)
                login;
            break;;
            4)
                logout;
            break;;
            5)
                echo "*** Volviendo al menú... ***";
                sleep 1;
            break;;
            *)
                echo "[ERROR] Opción inválida.";
            sleep 1;;
        esac
    done
}

venderProducto()
{
    i=1
    j=$i
    venta="true"
    while [ "$venta" -eq "true" ]; do
        echo "Mostrando los productos en el sistema:"
        while IFS='-' read -r codigo tipo modelo desc stock precio; do
            echo "${i}-${tipo}-${modelo}-${precio}"
            i=$((i+1))
        done < productos.txt
        if [ i -eq 1 ]; then
            echo "[ERROR]: No hay productos ingresados. Volviendo al menú..."
            menu
        fi 
        echo "Ingrese el número del producto a vender."
        read num
        while [ num -le 0 -a num -le i ]; do
            echo "[ERROR]: El número de producto ingresado es incorrecto. Vuelve a intentarlo."
        done
        while IFS='-' read -r codigo tipo modelo desc stock precio; do

        done
        echo "¿Desea agregar otro producto (y/n)?"
        read ans
        if [ $"ans" = "n" ]; then
            venta="false"
        fi
    done
}

venderProducto