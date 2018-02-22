


function vectorRespuesta = funcionCasteo2(entrada,decimales)

  coordenadas_x = [];
  coordenadas_y = [];
  count = 1;
  contador = 0;
  
   for i= 1:length(entrada)
   
    if((entrada(i) == ',')||(esNumero(entrada(i))== 1 ))
      datos(count) = entrada(i);
      count = count + 1;
    end
   end
  variable = strsplit(datos,',');
  
  for i = 1:length(variable)
    num = str2double(variable(i))
    switch contador
        case 0
        coordenadas_x = [coordenadas_x num];
        contador = 1;
        case 1
        coordenadas_y = [coordenadas_y num];
        contador = 0;
    end
  
  end
  vectorRespuesta = [coordenadas_x ; coordenadas_y];
  vectorRespuesta = round(vectorRespuesta .* (10^decimales) )./ (10^decimales);
  vectorRespuesta = vectorRespuesta';
  return
end
  
      
 
function booleano = esNumero(numero)

  if ((numero == '0')||(numero == '.')||(numero == '-')||(numero == '1')||(numero== '2')||(numero== '3')||(numero== '4')||(numero== '5')||(numero== '6')||(numero== '7')||(numero== '8')||(numero== '9'))
    booleano = 1;
  else
    booleano = 0;
  end
  return
end


