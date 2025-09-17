inicializar()
{
    touch usuarios.txt
    if [! -r usuarios.txt ]; then
        echo "admin:admin" > usuarios.txt
    fi
     if [! -r usuarios.txt ]; then
        touch productos.txt
    fi
}

menu()
{
    while true; do
        clear
        echo "Obligatorio"
        echo "--------------------------------------------"
        echo "1 - Usuario"
        echo "2 - Ingresar Producto"
        echo "3 - Vender Producto"
        echo "4 - Filtro De Productos"
        echo "5 - Crear Reporte De Pinturas"
        echo "Salir" 

        read -p "Ingrese su opcion (1,2,3,4,5 o salir) " opcion #read -p es para que sea un prompt
        
        case "${opcion,,}" in  #opcion,, es para que sea lowercase
            1) 
                mUsuario;
            2) 
                ingresarP;
            3) 
                venderP;
            4) 
                filtroP;
            5) 
                reporteP;
            "salir") 
                echo "Saliendo";
                break;
            *) 
                echo "Opcion no valida";
                sleep 1;
        esac
    done

    
}

mUsuario()
{
    while true; do
        clear
        echo "Obligatorio - Usuario"
        echo "--------------------------------------------"
        echo "A - Crear Usuario"
        echo "B - Cambiar Contraseña"
        echo "C - Login"
        echo "D - Logout"
        echo "Salir" 

        read -p "Ingrese su opcion (A,B,C,D o salir) " opcion #read -p es para que sea un prompt
        
        case "${opcion,,}" in  #opcion,, es para que sea lowercase
            a) 
                crearU;
                break;
            b) 
                cambiarC;
                break;
            c) 
                login;
                break;
            d) 
                logout;
                break;
            "salir") 
                echo "Saliendo a menu";
                break;
            *) 
                echo "Opcion no valida";
                sleep 1;
        esac
    done
}

ingresarP()
{
    
}

inicializar
login