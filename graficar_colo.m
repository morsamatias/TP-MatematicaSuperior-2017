
%Recibe coeficientes [a,b] ,flagPuntos,puntos, tipoFuncion,intervalo

function graficar_colo(coeficientes,flagPuntos,puntos,tipoFuncion,inter,decimales)
  
  %inter = [minimo , maximo]
  
  aux = inter(1) + inter(2);
  aux = aux/10 ;
  intervalo = (inter(1)-2:aux:inter(2)+2) ;

  coeficienteA = coeficientes(1);
  coeficienteB = coeficientes(2);
  coeficienteC = 0;
  
  if (tipoFuncion == 2)
    coeficienteC = coeficientes(3);
  end
  
  switch tipoFuncion
    case 1 
      lineal = funcionLineal(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales);
    case 2
      parabolica = funcionParabolica(coeficienteA,coeficienteB,coeficienteC,intervalo,flagPuntos,puntos,decimales);
    case 3
     exponencial = funcionExponencial(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales);
    case 4
      potencial = funcionPotencial(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales);
    case 5
      hiperbolica = funcionHiperbolica(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales);
  end
end


function lineal = funcionLineal(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales)
 lineal = (coeficienteA*(intervalo)) + coeficienteB;
 titulo = ['Recta de minimos cuadrados = ' mat2str(coeficienteA) 'x + ' mat2str(coeficienteB)];
 figure('Name',titulo);
 if flagPuntos
  matrizX = devolverx(puntos);
  matrizY = devolvery(puntos);
  plot(matrizX,matrizY,'rx');
  hold on
 end
 plot(intervalo,lineal);
 grid
 xlabel('Eje X');
 ylabel('eje Y');
 aux = strcat(mat2str(coeficienteA),'x+ ',mat2str(coeficienteB));
 disp(aux);

 return
 end
 
 function parabolica = funcionParabolica(coeficienteA,coeficienteB,coeficienteC,intervalo,flagPuntos,puntos,decimales)   
  parabolica = coeficienteA * ((intervalo).^2) + coeficienteB * (intervalo) + coeficienteC;
  titulo = ['Parabola de de minimos cuadrados = ' mat2str(coeficienteA) 'x^2 + ' mat2str(coeficienteB) 'x + ' mat2str(coeficienteC)];
 figure('Name',titulo);
 if flagPuntos
  matrizX = devolverx(puntos)
  matrizY = devolvery(puntos)
  plot(matrizX,matrizY,'rx');
  hold on
 end
 plot(intervalo,parabolica);
 xlabel('Eje X');
 ylabel('eje Y');

 return
 end
 
 function exponencial = funcionExponencial(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales)
 exponencial = (exp(coeficienteB)*(exp(coeficienteA * intervalo)));
 titulo = ['Aprox exponencial = ' mat2str(round(exp(coeficienteB),decimales)) 'e^ (' mat2str(coeficienteA) '+ x)'];
 figure('Name',titulo);
 if flagPuntos
  matrizX = devolverx(puntos)
  matrizY = devolvery(puntos)
  plot(matrizX,matrizY,'rx');
  hold on
 end
 plot(intervalo,exponencial);
 xlabel('Eje X');
 ylabel('eje Y');
 return
 end
  
 function hiperbolica = funcionHiperbolica(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales)
 b = coeficienteB / coeficienteA;
 a = 1/coeficienteA;
 a = round (a,decimales);
 b= round(b,decimales);
 hiperbolica = ( a ./ (b + intervalo' ));
 titulo = ['Aprox hiperbolica = ' mat2str(a) ' / ('  mat2str(b) ' + x ) '];
 figure('Name',titulo);
 if flagPuntos
  matrizX = devolverx(puntos);
  matrizY = devolvery(puntos);
  plot(matrizX,matrizY,'rx');
  hold on
 end
 plot(intervalo,hiperbolica);
 xlabel('Eje X');
 ylabel('eje Y');
 grid
 return
 end
    
function potencial = funcionPotencial(coeficienteA,coeficienteB,intervalo,flagPuntos,puntos,decimales)
potencial = ((exp( coeficienteB)) *(intervalo.^ coeficienteA ));
 titulo = ['Aprox potencial = ' mat2str(round((exp(coeficienteB)),decimales)) 'x^ ' mat2str(coeficienteA) ];
 figure('Name',titulo);
 if flagPuntos
  matrizX = devolverx(puntos);
  matrizY = devolvery(puntos);
  plot(matrizX,matrizY,'rx');
  hold on
 end
 plot(intervalo,potencial);
 xlabel('Eje X');
 ylabel('eje Y');
 grid
 disp('potencial,graficar_colo');
 return
 end

%Lo que hace es recibir el intervalo y dos funciones, luego las grafica en una misma figura
function graficarVariasFunciones(intervalo,funcionUno,funcionDos)
  figure();
  subplot(211);
  plot(intervalo,funcionUno);
  grid
  subplot(212);
  plot(intervalo,funcionDos);
  grid
  end
 
%Borra el grafico de la figura correspondiente 
function borrarGrafico ()
clf;
end 
 
 
 function marcarPuntosYGraficar(matriz,unaFuncion,intervalo)
 matrizX = devolverx(matriz);
 matrizY = devolvery(matriz);
 figure(1);
 plot(matrizX,matrizY,'rx');
 hold on
 plot(intervalo,unaFuncion);
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