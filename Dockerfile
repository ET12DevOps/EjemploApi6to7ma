# Construccion de imagen --------------------------------------------------------------

# imagen que se toma de base - build-env es un alias que se usa para hacer referencia desde otra imagen
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# crea y establece el nombre del directorio "codigofuente", aqui se va a copiar mi codigo fuente C#
# tiene el mismo comportamiento que el comando "mkdir" y "cd" de linux
WORKDIR /codigofuente

# copia la carpeta "EjemploApi6to7ma" a la carpeta "CodigoFuente"
COPY ./EjemploApi6to7ma ./

# Se bajan dependencias de proyecto "EjemploApi6to7ma"
RUN dotnet restore

# Se genera el codigo compilado del proyecto "EjemploApi6to7ma" dentro de la carpeta "Aplicacion"
RUN dotnet publish -c Release -o /Aplicacion

# Construccion de container -----------------------------------------------------------
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Se abre el puerto 5000 hacia afuera del container
EXPOSE 5000

# Se fija el puerto 5000 en la webapi, para que la webapi escuche en el puerto 5000
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"

# crea y establece el nombre del directorio "codigofuente", aqui se va a copiar mi codigo fuente C#
WORKDIR /AplicacionAspNet

# se copia el contenido del la carpeta "Aplicacion" (linea 16) en "AplicacionAspNet" dentro de la imagen actual
# notar que la carpeta "Aplicacion" se encuentra en la imagen "mcr.microsoft.com/dotnet/sdk:8.0" y la unica forma de hacer 
# referencia es mediante el alias de la linea 4
COPY --from=build-env /Aplicacion ./

# se indica que comando se debe ejecutar dentro del container al realizar el "docker run"
ENTRYPOINT [ "dotnet", "EjemploApi6to7ma.dll" ]