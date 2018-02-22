function comparar_errores(matriz,decimales)

decimales = str2double(decimales)

%prueba

% Create figure
h.f = figure('Name','Seleccione los modelos de aproximacion:','units','pixels','position',[200,200,250,300],...
             'toolbar','none','menu','none');
% Create yes/no checkboxes
h.c(1) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,30,200,15],'string','1) Modelo Lineal');
h.c(2) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,60,300,25],'string','2) Modelo Parabolico');
            
h.c(3) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,90,400,35],'string','3) Modelo Exponencial');
h.c(4) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,120,500,45],'string','4) Modelo Potencial');   
            
h.c(5) = uicontrol('style','checkbox','units','pixels',...
                'position',[10,150,600,55],'string','5) Modelo Hiperbolico');
  
% Create OK pushbutton   
h.p = uicontrol('style','pushbutton','units','pixels',...
                'position',[40,200,200,20],'string','OK',...
                'callback',@p_call);
            
    % Pushbutton callback
    function p_call(varargin)
        vals = get(h.c,'Value');
        disp(vals);
        checked = find([vals{:}]);
        if isempty(checked)
            checked = 'none';
        end
        if (~isempty(checked))
            disp(checked);
            close(h.f);
            comparar_errores2(matriz,decimales,checked);
        end
    end
end

%end
%endprueba

function comparar_errores2(matriz,decimales,checked)

sumaerror = [0];
for a = 2:length(checked)
    sumaerror = [sumaerror , 0];
end
tabla = [];
listax = devolverx(matriz);
listay = devolvery(matriz);

name = ["1) Error lineal ","2) Error Parabolico","3) Error Exponencial","4) Error Potencial","5) Error Hiperbolico"];
nombre = ["xi","yi"]
for con = 1:length(checked)
    nombre = [nombre, name(checked(con))];
end 
 for i = 1:length(listax)
     % resolverEcMinimosCuadrados(matriz,tipo_de_aproximacion,decimales)
     %(matriz,intervalo,decimales,tipo)
     aux = [listax(i),listay(i)];
    disp("seleccionados: ");
     disp(checked);
    for ii = 1:length(checked)
        error = ylineal( resolverEcMinimosCuadrados(matriz,checked(ii),decimales),listax(i),decimales,checked(ii));
        error = listay(i) - error;
        error = error ^2;
        error = round(error,decimales);
        aux = [aux ,error];
        sumaerror(ii) = sumaerror(ii) + error;
    end
        tabla = [tabla;aux];
 end
 tabla = [tabla ; 0,0, sumaerror];
 resultado = compararErrores(sumaerror);
 estring = ["El error cuadratico minimo lo tiene el modelo" mat2str(checked(resultado))];
 graficar_matriz3(tabla,nombre,estring);
 
 %graficar_colo(coeficientes,flagPuntos,puntos,tipoFuncion,inter,decimales)
 graficar_colo(resolverEcMinimosCuadrados(matriz,checked(resultado),decimales),1,matriz,checked(resultado),intervalo(matriz),decimales);
end


function ret = compararErrores(vector)
   ret = 0;
   for i = 1:length(vector)
    if min(vector) == vector(i)
        ret = i;
    end
   end
    return
end

function  graficar_matriz3(algo,nombre,estring)
%
pantallaTabla = figure('Name','Tabla de comparacion de errores','MenuBar','none');
%set(pantallaTabla,'Units','normalized');
t = uitable(pantallaTabla,'Data',algo,'Position',[0 200 800 200]);
t.ColumnName = nombre;

texto = uicontrol('parent',pantallaTabla,'Position',[10,10,400,100],'Style','Text','String',estring,'ForegroundColor',[0 0 0],'BackgroundColor', [.94 .94 .94]);
end

%yLineal recibe una matriz y 'x' y devuelve la funcion especificada en ese valor.
function ret = ylineal(matriz,intervalo,decimales,tipo)


coeficienteA = matriz(1);
coeficienteB = matriz(2);
if tipo == 2
    coeficienteC = matriz(3);
end
  switch tipo
    case 1 %aproximacion por recta de cuadrados minimos
       ret= (coeficienteA*(intervalo)) + coeficienteB;
    case 2 %aproximacion por parabola de cuadrados minimos
      ret =coeficienteA * ((intervalo).^2) + coeficienteB * (intervalo) + coeficienteC;
    case 3 %aproximacion exponencial
      ret = (exp(coeficienteB)*(exp(coeficienteA * intervalo)));
    case 4 %aproximacion potencial
      ret = ((exp( coeficienteB)) *(intervalo.^ coeficienteA ));
    case 5 %aproxima hiperbola
       b = coeficienteA / coeficienteB;
       a = 1/coeficienteB;
       a = round (a,decimales);
       b= round(b,decimales);
       ret = ( a ./ (b + intervalo' ));  
  end
  ret = round(ret,decimales);
  return
end







%Esta funcion recibe una matriz y un tipo de aproximacion y devuleve los valores, a , b y c de la funcion;
%Si mostrar = 1 => muestra la funcion aproximante ; si mostrar = 0 => obtiene detalle del calculo 
%si mostrar = 2 => muestra la funcion y los puntos


%recibe una matriz de la manera ([X] [Y]) y devuelve un vector con los valores a y b
function ret = resolverEcMinimosCuadrados(matriz,tipo_de_aproximacion,decimales)
  x = devolverx(matriz);
  y = devolvery(matriz);
  
  switch tipo_de_aproximacion
    case 1
      matriz_A = [round(sumaCuadrados(x),decimales),round(sumaVector(x),decimales);round(sumaVector(x),decimales),length(y)];
      matriz_B = [round(sumaVector(multiplicacionXY(matriz)),decimales);round(sumaVector(y),decimales)];
  
      ret = inv(matriz_A)* matriz_B;
      
    case 2 %ParÃ¡bola de mÃ­nimos cuadrados: ð?‘¦ = ð?‘Žð?‘¥^2+ ð?‘?ð?‘¥ + ð?‘?
      matriz_A = [round(sumaCuarta(devolverx(matriz)),decimales),sumaCubo(devolverx(matriz)),sumaCuadrados(devolverx(matriz));
                  sumaCubo(devolverx(matriz)),sumaCuadrados(devolverx(matriz)),sumaVector(devolverx(matriz));
                  sumaCuadrados(devolverx(matriz)),sumaVector(devolverx(matriz)),length(devolverx(matriz))];
      matriz_B = [sumaVector(multiplicacionXXY(matriz));sumaVector(multiplicacionXY(matriz));sumaVector(devolvery(matriz))];
  
      ret = inv(matriz_A)* matriz_B;
    
   
      case 3 %caso exponencial
      aux = devolverx(matriz).*(log(devolvery(matriz)));
      ylog = log(devolvery(matriz));
      
      matriz_A = [sumaCuadrados(devolverx(matriz)),sumaVector(devolverx(matriz));sumaVector(devolverx(matriz)),length(devolverx(matriz))]
      matriz_B = [ sumaVector(aux) ;sumaVector(ylog)]
      
      ret = inv(matriz_A)* matriz_B
      
      case 4 %caso potencial
      
      
       ylog = log(devolvery(matriz));
       xlog = log(devolverx(matriz));
       aux = xlog.*ylog;
      
      matriz_A = [sumaCuadrados(xlog),sumaVector(xlog);sumaVector(xlog),length(devolverx(matriz))]
      matriz_B = [ sumaVector(aux) ;sumaVector(ylog)]
      
      ret = inv(matriz_A)* matriz_B
      
      case 5 %caso hiperbola
       
      aux = hiperbolaxy(matriz);
      auxy = hiperbolay(devolvery(matriz));
      
      matriz_A = [sumaCuadrados(devolverx(matriz)),sumaVector(devolverx(matriz));sumaVector(devolverx(matriz)),length(devolverx(matriz))]
      matriz_B = [ sumaVector(aux) ;sumaVector(auxy)];
      
      ret = inv(matriz_A)* matriz_B
    
      
    end
    
    ret = round(ret,decimales);

  return
end


%Tuve que hacer esta funcion para encontrar la solucion a un error
function ret = elevar(i)
  var = 0;
  z=1;
  disp(i);
  disp(str2num(i));
  if i > 0
    var = 10;
    while (z < str2num(i))
      var = var *10;
      z=z+1;
    end
  else
    var = 1;
  end
  ret = var;
  return
end

function retorno = error1aprox(matriz,aprox,decimales,tipo)
  retorno = 0;
  matrizy= devolvery(matriz);
  matrizx=devolverx(matriz);
  for i = 1:length(matriz);
    retorno = retorno + ylineal(aprox,matrizx(i),decimales,tipo) - matrizy(i);
  end
  retorno = round(retorno,decimales);
  return
end


function retorno = error2aprox(matriz,aprox,decimales,tipo)
  retorno = 0;
  matrizy= devolvery(matriz);
  matrizx=devolverx(matriz);
  for i = 1:length(matriz);
    retorno = retorno + (ylineal(aprox,matrizx(i),decimales,tipo) - matrizy(i)) ^ 2 ;
  end
  retorno = round(retorno ,decimales);
  return
end




%sumaVector recibe un vector y devuelve un numero = la suma de sus valores
function numero = sumaVector(vector)  
  var = 0;
  for i = 1:length(vector)
    var = var + vector(i);
  end
  numero = var;
  return
end

%sumaCuadrados recibe un vector y devuelve un numero  = la suma de los valores x^2
function numero = sumaCuadrados(vector)
  var = 0;
  
  for i = 1:length(vector)
    var = var + vector(i) * vector(i);
  end
  numero = var;
  return
end

function var = hiperbolay(vector)
var = [];

for i = 1:length(vector)
    if (vector(i) ~= 0)
        var = [var , 1 / vector(i)];
    end
end
return 
end


function var = hiperbolaxy(vector)
x = devolverx(vector);
y = devolvery(vector);
yinv = hiperbolay(y);
var = [];

for i = 1:length(vector)
    if (vector(i) ~= 0)
        var = [var ; (x(i)*yinv(i))];
    end
end
return 
end


function numero = sumaCubo(vector)
  var = 0;
  
  for i = 1:length(vector)
    var = var + vector(i) * vector(i) * vector(i);
  end
  numero = var;
  return
end

function numero = sumaCuarta(vector)
  var = 0;
  
  for i = 1:length(vector)
    var = var + vector(i) * vector(i) * vector(i) * vector(i);
  end
  numero = var;
  return
end

%sumax recime una matriz de la manera [[x] [y]] y devuelve la suma de los valores x
function numero = sumax(matriz_sumaX)

  matriz_sumaX = transpose( matriz_sumaX);
  x = matriz_sumaX(1,:);
  numero = sumaVector(x);
  return
end

%sumay recime una matriz de la manera [[x] [y]] y devuelve la suma de los valores x
function numero = sumay(matriz_sumay)
  matriz_sumay = devolvery(matriz_sumay);
  numero = sumaVector(y);
  return
end

%funcion devolvery recibe una matriz  de la manera [[x] [y]] y devuelve un vector con los valores y 
function y = devolvery(matris)

  matris = transpose( matris);
  y = matris(2,:);
  
  return 
end

%funcion devolverx recibe una matriz  de la manera [[x] [y]] y devuelve un vector con los valores x
function x = devolverx(matris)

  matris = transpose( matris);
  x = matris(1,:);
  
  return 
end

%recibe una matriz [[X] [Y]] y devuelve un numero = suma de ( X * Y)
function returnValue = multiplicacionXY (matrix)

  x = devolverx(matrix) ;
  y = devolvery(matrix) ;
 
  respu = x.*y ;
  
  %Devuelve una fila con la multiplicacion
  returnValue = sumaVector(respu);
  return 
end 

%recibe una matriz [[X] [Y]] y devuelve un numero = suma de ( X * Y)
function returnValue = multiplicacionXXY (matrix)

  x = devolverx(matrix) ;
  y = devolvery(matrix) ;
 
  respu = x.*x.*y ;
  
  %Devuelve una fila con la multiplicacion
  returnValue = sumaVector(respu);
  return 
end 

%devuelve la mayorCoordenada del eje x , va a servir para graficar
function retorno = mayorCoordenadaX(matrix)
  x = devolverx(matrix);
  retorno = max(x);
  return
end

%devuelve la menorCoordenada del eje x , va a servir para graficar
function retorno = menorCoordenadaX(matrix)
  x = devolverx(matrix);
  retorno = min(x);
  return
end
 
function retorno = intervalo(matrix)
  x = devolverx(matrix);
  retorno = [min(x),max(x)];
  return
end
 
