
%Esta funcion recibe una matriz y un tipo de aproximacion y devuleve los valores, a , b y c de la funcion;
%Si mostrar = 1 => muestra la funcion aproximante ; si mostrar = 0 => obtiene detalle del calculo 
%si mostrar = 2 => muestra la funcion y los puntos

function funcion = calcular_aproximaciones(matriz,tipo_de_aproximacion,decimales,mostrar)
  decimales = str2double(decimales);
  
  funcion = resolverEcMinimosCuadrados(matriz,tipo_de_aproximacion,decimales);
  funcion = round(funcion,decimales);
  disp(mostrar);
  switch mostrar 
    case 1
      graficar_colo(funcion,0,0,tipo_de_aproximacion,intervalo(matriz),decimales);
    case 0
      funcion = calcularMatrizCalculos(matriz,tipo_de_aproximacion,decimales);
    case 2
      %Recibe coeficientes [a,b] ,flagPuntos,puntos, tipoFuncion,intervalo
      graficar_colo(funcion,1,matriz,tipo_de_aproximacion,intervalo(matriz),decimales);
  end
    
  return
end

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




%yLineal recibe una matriz y 'x' y devuelve la funcion especificada en ese valor.
function ret = ylineal(matriz,x,decimales,tipo)
  switch tipo
    case 1 %aproximacion por recta de cuadrados minimos
      ret = matriz(1) * x + matriz (2);
    case 2 %aproximacion por parabola de cuadrados minimos
      ret = matriz(1)* (x^2) + matriz(2) * x + matriz(3);
    case 3 %aproximacion exponencial
      ret = (e.^matriz(2))*(e.^ (matriz(1) * x));
    case 4 %aproximacion potencial
      ret = (e.^ matriz(2)) *(x.^matriz(1));
    case 5 %aproxima hiperbola
      b = coeficienteA / coeficienteB;
      a = 1/coeficienteB;
      ret = a / (b + x);  
  end
  ret = round(ret,decimales);
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
 
function estring = calcularMatrizCalculos(matriz,tipofuncion,decimales)

  matriz = round(matriz,decimales);
  listax = devolverx(matriz);
  listay = devolvery(matriz);
  
  switch tipofuncion
    case 1
      nombres = ["xi","yi","xiyi","xi^2"]
      tabla = [];
      sumaxy = 0;
      sumaxx = 0;
      sumay = 0;
      sumax = 0;
      for i = 1:length(listax)
        x = listax(i);
        y = listay(i);
        xy = x*y;
        xx = x^2;
        
        sumaxy = sumaxy + xy;
        sumaxx =sumaxx + xx;
        sumay = sumay + y ;
        sumax = sumax + x;
        
        xy = round(xy,decimales);
        xx = round(xx,decimales);
        tabla = [tabla ;x,y,xy,xx]; 
      end 
      
       tabla = [tabla;sumax,sumay,sumaxy,sumaxx];
       aux = ['Sistema utilizado:' newline '  a' mat2str(sumaxx) ' +  b' mat2str(sumax) ' = ' mat2str(sumaxy) newline '  a' mat2str(sumax) ' + b' mat2str(length(listax)) ' = ' mat2str(sumay)];            
    
      
    case 2
      nombres = ["xi","yi","xi^2","xi^3","xi^4","yixi","yix^2"];
      tabla = [];
      sumax = 0;
      sumaxx = 0;
      sumaxxx = 0;
      sumaxxxx = 0;
      sumay = 0;
      sumaxy = 0;
      sumaxxy = 0;
      for i = 1:length(listax)
        x = listax(i);
        y = listay(i);
        xy = x*y;
        xxy = y*x^2;
        xx = x^2;
        xxx = x^3;
        xxxx = x^4;
        
        xy = round(xy,decimales);
        xx = round(xx,decimales);
        xxx = round(xxx,decimales);
        xxxxx = round(xxxx,decimales);
        xxy = round(xxy,decimales);
        
       sumax = sumax + x;
       sumaxx = sumaxx + xx;
       sumaxxx = sumaxxx + xxx;
       sumaxxxx = sumaxxxx + xxxx;
       sumay = sumay + y;
       sumaxy = sumaxy + xy;
       sumaxxy = sumaxxy + xxy;
        
       %['xi','yi','xi^2','xi^3','xi^4','yixi','yix^2']
       tabla = [tabla ; x,y,xx,xxx,xxxx,xy,xxy];
      
      end 
      tabla = [tabla; sumax,sumay,sumaxx,sumaxxx,sumaxxxx,sumaxy,sumaxxy];
      aux = ['Sistema utilizado:' newline '  a' mat2str(sumaxxxx) ' +  b' mat2str(sumaxxx) ' + c' mat2str(sumaxx) ' = ' mat2str(sumaxxy) newline '  a' mat2str(sumaxxx) ' + b' mat2str(sumaxx) ' + c' mat2str(sumax) ' = ' mat2str(sumaxy) newline '  a' mat2str(sumaxx) ' + b' mat2str(sumax) ' + c' mat2str(length(listax)) ' = ' mat2str(sumay) ];            
  
        
      case 3
      nombres = ["xi","yi","Yi=ln(yi)","xiYi","xi^2"];
      tabla = [];
      sumaxy = 0;
      sumaylog = 0;
      sumaxylog = 0;
      sumaxx = 0;
      sumay = 0;
      sumax = 0;
      for i = 1:length(listax)
        x = listax(i);
        listaylog = log(listay);
        ylog = listaylog(i)
        y = listay(i);
        xylog = x*ylog;
        xx = x^2;
        
        xylog = round(xylog,decimales);
        xx = round(xx,decimales);
        y = round(y,decimales);
        ylog = round(ylog,decimales)
        x = round(x,decimales);
        
        sumaxylog = sumaxylog + xylog;
        sumaxx =sumaxx + xx;
        sumay = sumay + y ;
        sumaylog = sumaylog + ylog;
        sumax = sumax + x;
        tabla = [tabla ; x,y,ylog,xylog,xx];
        
        sumaxylog = round(sumaxylog,decimales);
        sumaxx = round(sumaxx,decimales);
        sumay = round(sumay,decimales);
        sumaylog = round(sumaylog,decimales);
        sumax = round(sumax,decimales);
      end 
        tabla = [tabla;sumax,sumay,sumaylog,sumaxylog,sumaxx];
        aux = ['Sistema utilizado:' newline '  a' mat2str(sumaxx) ' +  b' mat2str(sumax) ' = ' mat2str(sumaxylog) newline '  a' mat2str(sumax) ' + b' mat2str(length(listax)) ' = ' mat2str(sumaylog)];            
      
      case 4
       
      nombres = ["xi","yi","Yi=ln(yi)","Xi=ln(xi)","XiYi","Xi^2"];
      tabla = [];
      sumaxy = 0;
      sumaylog = 0;
      sumaxylog = 0;
      sumaxx = 0;
      sumay = 0;
      sumaxlog = 0;
      sumax = 0;
      listaylog = log(listay);
      listaxlog = log(listax);
      for i = 1:length(listax)
        x = listax(i);
        xlog = listaxlog(i);
        
        ylog = listaylog(i);
        y = listay(i);
        xylog = xlog*ylog;
        xx = xlog^2;
        
        xylog = round(xylog,decimales);
        xx = round(xx,decimales);
        y = round(y,decimales);
        ylog = round(ylog,decimales);
        xlog = round(xlog,decimales);
        x = round(x,decimales);
        
        sumaxylog = sumaxylog + xylog;
        sumaxx =sumaxx + xx;
        sumaylog = sumaylog + ylog;
        sumax = sumax +x;
        sumay = sumay + y ;
        sumaxlog = sumaxlog + xlog;
        
        %nombres = ["xi","yi","Yi=ln(yi)","Xi=ln(xi)","XiYi","Xi^2"];
        
        sumaxylog = round(sumaxylog,decimales);
        sumaxx = round(sumaxx,decimales);
        sumay = round(sumay,decimales);
        sumaylog = round(sumaylog,decimales);
        sumax = round(sumax,decimales);
        sumaxlog =  round(sumaxlog,decimales);
        
        tabla = [tabla ; x,y,ylog,xlog,xylog,xx];
      end 
        tabla = [tabla; sumax,sumay,sumaylog,sumaxlog,sumaxylog,sumaxx];
        aux = ['Sistema utilizado:' newline '  a' mat2str(sumaxx) ' +  b' mat2str(sumaxlog) ' = ' mat2str(sumaxylog) newline '  a' mat2str(sumaxlog) ' + b' mat2str(length(listax)) ' = ' mat2str(sumaylog)];            
      
    case 5
       
      nombres = ["xi","yi","Yi=1/yi","xiYi","Xi^2"];
      tabla = [];
      sumax = 0;
      sumay = 0;
      sumax = 0;
      sumayinv = 0;
      sumaxx = 0;
      sumaxy = 0;
      listayinv = hiperbolay(listay);
      listaxyinv = hiperbolaxy(matriz);
      
      for i = 1:length(listax)
        x = listax(i);
        xx = x^2;
        y = listay(i);
        yinv= listayinv(i);
        xy = listaxyinv(i);
        
        
        xy = round(xy,decimales);
        xx = round(xx,decimales);
        y = round(y,decimales);
        yinv = round(yinv,decimales);
        x = round(x,decimales);
        
        sumaxy = sumaxy + xy;
        sumaxx =sumaxx + xx;
        sumay = sumay + y;
        sumayinv = sumayinv + yinv;
        sumax = sumax +x;
        
        %nombres = ["xi","yi","Yi=1/yi","xiYi","Xi^2"];
        tabla = [tabla ; x,y,yinv,xy,xx];
        
        sumaxy = round(sumaxy,decimales);
        sumaxx = round(sumaxx,decimales);
        sumay = round(sumay,decimales);
        sumayinv = round(sumayinv,decimales);
        sumax = round(sumax,decimales);
      end 
        tabla = [tabla;sumax,sumay,sumayinv,sumaxy,sumaxx];
        aux = ['Sistema utilizado:' newline '  a' mat2str(sumaxx) ' +  b' mat2str(sumax) ' = ' mat2str(sumaxy) newline '  a' mat2str(sumax) ' + b' mat2str(length(listax)) ' = ' mat2str(sumayinv)];            
      
        
  end
    graficar_matriz2(tabla,nombres,aux);
    estring = "A";
    return
end

