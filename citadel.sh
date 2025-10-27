#!/bin/bash
# TODO: instalar dos2unix en Ubuntu (x algún motivo)

user_actual=""
first_login=false

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

crear_usuario() {
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

cambiar_contraseña() {
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

ingresar_producto() {
    echo "*** Ingreso de producto ***"
    echo "Ingrese el código de producto:"
    read codigo
    while [ ${#codigo} -ne 3 -o "$codigo" != "${codigo^^}" ]; do
        echo "[ERROR] Formato inválido de código. Vuelve a intentarlo."
        read codigo
    done
    codigo="${codigo^^}"
    echo "Ingrese el tipo de producto a agregar:"
    read tipo
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
    if ! [ -r usuarios.txt ]; then
        touch usuarios.txt
        echo "admin@admin" > usuarios.txt
    fi
    if ! [ -r productos.txt ]; then
        touch productos.txt
    fi
    login
    menu
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
            1) menu_usuario;;
            2) ingresar_producto;;
            3) vender_producto;;
            4) filtro_productos;;
            5) reporte_pinturas;;
            6)
                echo "*** Cerrando sesión. ¡Hasta luego! ***";
            break;;
            *)
                echo "[ERROR] Opción inválida.";
            sleep 1;;
        esac
    done
}

menu_usuario()
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
                crear_usuario;
            break;;
            2)
                cambiar_contraseña;
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

vender_producto()
{
    > orden_temp.txt
    hay_productos=false
    venta=true
    i=1
    while [ "$venta" = "true" ]; do
        echo "Mostrando los productos en el sistema:"
        while IFS='-' read -r codigo tipo modelo desc stock precio; do
            if [ $stock -eq 0 ]; then
                echo "${i}) ${codigo}-${tipo}-${modelo}-${precio} [AGOTADO]"
            else
                echo "${i}) ${codigo}-${tipo}-${modelo}-${precio}"
            fi
            ((i++))
            hay_productos=true
        done < productos.txt
        if [ ${hay_productos} = "false" ]; then
            echo "[ERROR]: No hay productos ingresados. Volviendo al menú..."
            break
        fi
        echo "Ingrese el número del producto a vender."
        read num
        while [ $num -le 0 -a $num -le $i ]; do
            echo "[ERROR]: El número de producto ingresado es incorrecto. Vuelve a intentarlo."
            read num
        done
        
        # Este comando usa sed, la opción -n para no imprimir también todo el resto del archivo y
        # le pasamos "${num}p" para decirle que tome la línea "num" de productos.txt.
        linea=$(sed -n "${num}p" productos.txt)
        
        # Aquí tomamos línea y lo pipeamos a un awk. La opción -F es para indicar el 'field' o delimitador,
        # que en nuestro caso es ' - '. Para el quinto campo de la línea, imprimirlo y guardarlo en stock.
        
        stock=$(echo "$linea" | awk -F' - ' '{print $5}' | tr -d ' ')
        if [ $stock -eq 0 ]; then
            echo "[ERROR] No hay stock disponible de este producto."
        else
            # Acá es lo mismo pero le sacamos el '$' y el ' '.
            precio_por_unidad=$(echo "$linea" | awk -F' - ' '{print $6}' | tr -d ' $')
            
            tipo=$(echo "$linea" | awk -F' - ' '{print $2}' | tr -d '  ')
            modelo=$(echo "$linea" | awk -F' - ' '{print $3}')
            
            echo "Ingrese la cantidad a comprar. Stock actual: "$stock"."
            read cant_compra
            
            while [ $cant_compra -le 0 -o $cant_compra -gt $stock ]; do
                echo "[ERROR] La cantidad a comprar es inválida. Stock disponible: "$stock""
                read cant_compra
            done
            nuevo_stock=$((stock-cant_compra))
            nueva_linea=$(echo $linea | sed "s|$stock|$nuevo_stock|")
            sed -i "${num}s|.*|${nueva_linea}|" productos.txt
            precio_total=$((cant_compra*precio_por_unidad))
            echo "${tipo} - ${modelo} - ${cant_compra} - $ ${precio_total}" >> orden_temp.txt
            echo "Venta realizada. Orden hasta el momento:"
            leer_venta
        fi
        i=1
        echo "¿Desea agregar otro producto (y/n)?"
        read ans
        if [ "$ans" = "n" ]; then
            venta="false"
        fi
    done
    echo "*** Resumen de venta ***"
    leer_venta
    echo "*** Volviendo al menú... ***"
    > orden_temp.txt
    sleep 3
}

leer_venta(){
    while read line; do
        echo $line;
    done < orden_temp.txt
}

filtro_productos(){
    #TODO
}

reporte_pinturas(){
    #TODO
}

inicializar