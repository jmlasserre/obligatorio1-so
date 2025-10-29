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
    read opc
    opc=$(echo "${opc,,}" | tr -d ' ')
    opc_valida=false
    while [ "$opc_valida" = "false" ]; do
        if [ "$opc" = "y" ]; then
            opc_valida=true
            user_actual=""
            elif [ "$opc" = "n" ]; then
            opc_valida=true
        else
            echo "[ERROR] Opción inválida."
            read opc
        fi
    done
    echo "*** Cerrando sesión... ***"
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
    clear
    echo "*** Ingreso de producto ***"
    ingreso=true
    while [ "$ingreso" = "true" ]; do
        echo "Ingrese el tipo de producto a agregar:"
        read tipo
        tipo=${tipo,,}
        codigo=""
        while true; do
            case "$tipo" in
                "base") codigo=BAS ;;
                "layer") codigo=LAY ;;
                "shade") codigo=SHA ;;
                "dry") codigo=DRY ;;
                "contrast") codigo=CON ;;
                "technical") codigo=TEC ;;
                "texture") codigo=TEX ;;
                "mediums") codigo=MED ;;
                *)
                    echo "[ERROR] Tipo inválido. Ingrese un tipo válido."
                    read tipo
                    tipo=${tipo,,}
                    continue
                ;;
            esac
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
        echo "¿Desea ingresar otro producto (y/n)?"
        read opc
        opc=$(echo "${opc,,}" | tr -d ' ')
        opc_valida=false
        while [ "$opc_valida" = "false" ]; do
            if [ "$opc" = "y" ]; then
                opc_valida=true
                elif [ "$opc" = "n" ]; then
                opc_valida=true
                ingreso=false
            else
                echo "[ERROR] Opción inválida."
                read opc
            fi
        done
    done
    echo "*** Regresando al menú... ***"
    sleep 1;
}

inicializar()
{
    if ! [ -r usuarios.txt ]; then
        touch usuarios.txt
        echo "admin@admin" > usuarios.txt
        user_actual="admin"
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
        if [ "$user_actual" = "" ]; then
            echo "*** Usuario no autenticado. ***"
        else
            echo "¡Bienvenido, ${user_actual}!"
        fi
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
            2)
                if [ "$user_actual" = "" ]; then
                    echo "[ERROR] Debe estar autenticado para acceder a esta función."
                else
                    ingresar_producto
                fi
            sleep 1;;
            3)
                if [ "$user_actual" = "" ]; then
                    echo "[ERROR] Debe estar autenticado para acceder a esta función."
                else
                    vender_producto
                fi
            sleep 1;;
            4)
                if [ "$user_actual" = "" ]; then
                    echo "[ERROR] Debe estar autenticado para acceder a esta función."
                else
                    filtro_productos
                fi
            sleep 1;;
            5)
                if [ "$user_actual" = "" ]; then
                    echo "[ERROR] Debe estar autenticado para acceder a esta función."
                else
                    reporte_pinturas
                fi
            sleep 1;;
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
    clear
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
            if grep -qi "${tipo} - ${modelo}" orden_temp.txt; then
                linea_orden=$(grep -i "${tipo} - ${modelo}" orden_temp.txt)
                cant_compra_ant=$(echo "$linea_orden" | awk -F' - ' '{print $3}' | tr -d ' ')
                cant_compra_nueva=$((cant_compra_ant+cant_compra))
                precio_total_ant=$(echo "$linea_orden" | awk -F' - ' '{print $4}' | tr -d ' $')
                precio_total_nuevo=$((precio_total_ant+precio_total))
                nueva_linea_orden=$(echo "$linea_orden" | sed "s|${cant_compra_ant}|${cant_compra_nueva}|" | sed "s|${precio_total_ant}|${precio_total_nuevo}|")
                sed -i "s|.*${tipo} - ${modelo}.*|${nueva_linea_orden}|" orden_temp.txt
            else
                echo "${tipo} - ${modelo} - ${cant_compra} - $ ${precio_total}" >> orden_temp.txt
            fi
            echo "Venta realizada. Orden hasta el momento:"
            leer_venta
        fi
        i=1
        echo "¿Desea agregar otro producto (y/n)?"
        read opc
        opc=$(echo "${opc,,}" | tr -d ' ')
        opc_valida=false
        while [ "$opc_valida" = "false" ]; do
            if [ "$opc" = "y" ]; then
                opc_valida=true
                elif [ "$opc" = "n" ]; then
                opc_valida=true
                venta=false
            else
                echo "[ERROR] Opción inválida."
                read opc
            fi
        done
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
    filtro=true
    while [ "$filtro" = "true" ]; do
        clear
        busqueda=false
        echo "Ingrese tipo de producto a filtrar:"
        read tipo_producto
        tipo_producto=${tipo_producto,,}
        filtro_valido=false
        if [ "$tipo_producto" = "base" -o "$tipo_producto" = "layer" -o "$tipo_producto" = "shade" -o "$tipo_producto" = "dry" -o "$tipo_producto" = "contrast" -o "$tipo_producto" = "technical" -o "$tipo_producto" = "texture" -o "$tipo_producto" = "mediums" ]; then
            filtro_valido=true
        fi
        if [ "$filtro_valido" = "false" ]; then
            echo "[ERROR] Tipo no reconocido. Mostrando todos los productos:"
            busqueda=true
            leer_productos
        else
            busqueda=true
            while IFS='-' read -r codigo tipo modelo desc stock precio; do
                tipo=$(echo "$tipo" | tr -d ' ')
                # echo "Comparando: tipo_producto='$tipo_producto' con tipo='$tipo'"
                if [ "$tipo_producto" = "$tipo" ]; then
                    echo "${codigo}- ${tipo} -${modelo}-${desc}-${stock}-${precio}"
                fi
            done < productos.txt
        fi
        if [ "$busqueda" = "false" ]; then
            echo "[ERROR] La búsqueda no arrojó resultados."
        fi
        echo "¿Desea realizar otra búsqueda? (y/n)"
        read opc
        opc=$(echo "${opc,,}" | tr -d ' ')
        opc_valida=false
        while [ "$opc_valida" = "false" ]; do
            if [ "$opc" = "y" ]; then
                opc_valida=true
                elif [ "$opc" = "n" ]; then
                opc_valida=true
                filtro=false
            else
                echo "[ERROR] Opción inválida."
                read opc
            fi
        done
    done
    echo "*** Volviendo al menú... ***"
    sleep 2;
}

reporte_pinturas(){
    clear
    > datos.csv
    while IFS='-' read -r codigo tipo modelo descripcion cantidad precio; do
        codigo_csv=$(echo "$codigo" | tr -d ' ')
        tipo_csv=$(echo "$tipo" | tr -d ' ')
        modelo_csv=$(echo "$modelo" | awk '{$1=$1; print}')
        descripcion_csv=$(echo "$descripcion" | awk '{$1=$1; print}')
        cantidad_csv=$(echo "$cantidad" | tr -d ' ')
        precio_csv=$(echo "$precio" | tr -d '$ ')
        echo "${codigo_csv};${tipo_csv};${modelo_csv};${descripcion_csv};${cantidad_csv};${precio_csv}" >> datos.csv
    done < productos.txt
    echo "*** Reporte de pinturas generado exitosamente en 'datos.csv'. ***"
}

leer_productos(){
    while read line; do
        echo $line
    done < productos.txt
}

inicializar