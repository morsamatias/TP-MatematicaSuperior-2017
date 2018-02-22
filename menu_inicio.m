
%((1,5),(2,6),(3,9),(4,8),(6,10))
%((1,2.6),(1.2,3.8),(2.5,7.1),(2.9,8),(9.6,26.7)) 
%((-1.6,8.999),(43.9999,8.3),(1,9),(2.897,44))

%Cargo los packages que me van a servir despues
%pkg load control;
%pkg load signal;

%Inicializo las variables de navegacion
volver_atras = 0;
volver_menu_ppal = 1;
sel_menu_ppal = 0;


%mensaje=msgbox(aux1,'bienvenido');
%btn = dialog ('hola', 'bienvenido', 'btn1', 'btn2', 'btn3', 'btn1');

%Inicializo variables para pedir datos despues
prompt = {'Cantidad de decimales','Por favor ingrese los datos de la forma (x1,y1),...,(xn,yn)'};
defaults = {'2','((1,5),(2,6),(3,9),(4,8),(6,10))'};
rowscols = [1;1.10];

%Verifico que no elija la opcion finalizar


while (sel_menu_ppal~= 4) 
  
  %Verifico que volvio al menu ppal
  if(volver_menu_ppal == 1)
    sel_menu_ppal = menu('Seleccione una opcion','-Ingresar datos','-Comparar aproximaciones','-Limpiar grafico','-Finalizar');
      volver_atras = 0;
      opcion = 0 ;
      volver_menu_ppal = 0;
  end
  
  
  switch sel_menu_ppal
      case 1
          switch opcion          
              case 0
                  opcion = 1;
                  sel_menu_ppal = 1; 
                  dims = inputdlg (prompt,'Ingreso de datos',2, defaults);
              case 1
                  sel_menu1 = menu('Por favor seleccione un metodo de aproximacion:','1) Recta de cuadrados min.','2) Parabola de cuadrados minimos','3) Exponencial','4) Potencial','5) Hiperbola',' - Volver atras - ',' - Ir al menu principal -');
                  switch sel_menu1 
                      case 6
                          volver_atras=1;
                          volver_menu_ppal = 0;
                          opcion = 0;
                      case 7
                          volver_menu_ppal = 1;
                          volver_atras = 0;
                      otherwise
                        opcion = 2;                
                  end
              case 2
                  sel_menu12 = menu('Seleccione una opcion','1) Ver el grafico','2) Ver el grafico y la distribucion de puntos','3) Obtener detalle del calculo',' - Volver atras -',' - Ir al menu principal - ');
                  switch sel_menu12
                      case 1
                          datos_casteados = funcionCasteo2(dims{2},str2num(dims{1}));
                          disp(datos_casteados);
                          aproximacion = calcular_aproximaciones(datos_casteados,sel_menu1,dims{1},1);
                          volver_menu_ppal = 1;
                      case 2
                          datos_casteados = funcionCasteo2(dims{2},str2num(dims{1}));
                          disp(datos_casteados);
                          aproximacion = calcular_aproximaciones(datos_casteados,sel_menu1,dims{1},2);
                          volver_menu_ppal = 1;
                      case 3
                          datos_casteados = funcionCasteo2(dims{2},str2double(dims{1}));
                          disp(datos_casteados);
                          aproximacion = calcular_aproximaciones(datos_casteados,sel_menu1,dims{1},0);
                          %graficar2(aproximacion);
                          volver_menu_ppal = 1;
                      case 4
                          volver_atras=1;
                          volver_menu_ppal = 0;
                          opcion = 1;
                      case 5
                          volver_menu_ppal = 1;
                          volver_atras = 0;
                  end
              end
              
              
      case 2
          disp('Opcion 2');
          dims = inputdlg (prompt,'Ingreso de datos',2, defaults);
          datos_casteados = funcionCasteo2(dims{2},dims{1});
          comparar_errores(datos_casteados,dims{1});
          volver_menu_ppal = 1;
      case 3
          disp('Opcion 3')
          limpiar_grafico();
          volver_menu_ppal = 1;
      case 4
           %despedida=msgbox('Hasta Luego','Finalizar');
      otherwise
        disp('Opcion incorrecta, por favor vuelva a seleccionar otra opcion');
  end
end


