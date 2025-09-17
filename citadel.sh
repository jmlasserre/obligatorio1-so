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
                menuUsuario;
                break;
            2) 
                menuIngresar;
                break;
            3) 
                menuProducto;
                break;
            4) 
                menuFiltro;
                break;
            5) 
                menuReporte;
                break;
            "salir") 
                echo "Saliendo";
                break;
            *) 
                echo "Opcion no valida";
                sleep 1;
        esac
    done

    
}

login