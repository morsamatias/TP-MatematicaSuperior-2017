function  graficar_matriz2(algo,nombre,estring)
%
pantallaTabla = figure('Name','Detalle del calculo de datos','MenuBar','none','Position',[100 100 600 500]);
%set(pantallaTabla,'Units','normalized');
t = uitable(pantallaTabla,'Data',algo,'Position',[100 200 500 200]);
t.ColumnName = nombre;

texto = uicontrol('parent',pantallaTabla,'Position',[10,10,400,100],'Style','Text','String',estring,'ForegroundColor',[0 0 0],'BackgroundColor', [.94 .94 .94]);
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