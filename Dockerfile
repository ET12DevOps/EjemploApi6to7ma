# Build - imagen
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

WORKDIR /codigofuente

# copia la carpeta EjemploApi6to7ma a la carpeta CodigoFuente
COPY ./EjemploApi6to7ma ./

# Se bajan dependencias de proyecto
RUN dotnet restore

# Se genera el codigo compilado
RUN dotnet publish -c Release -o /Aplicacion

# Container
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Abre el puerto 5000 hacia afuera del container
EXPOSE 5000

# Se fija el puerto 5000 en la webapi
ENV ASPNETCORE_URLS="http://0.0.0.0:5000"

# 
WORKDIR /AplicacionAspNet

COPY --from=build-env /Aplicacion ./

ENTRYPOINT [ "dotnet", "EjemploApi6to7ma.dll" ]