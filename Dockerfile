# Estágio de construção
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["FilmesApi.csproj", "./"]
RUN dotnet restore "FilmesApi.csproj"

COPY . .
RUN dotnet build "FilmesApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FilmesApi.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS migrations
WORKDIR /src
COPY ["FilmesApi.csproj", "./"]
RUN dotnet restore "FilmesApi.csproj"
COPY . .
RUN dotnet tool install --version 8.0.0 --global dotnet-ef
ENV PATH="$PATH:/root/.dotnet/tools"


FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
EXPOSE 80
ENTRYPOINT ["dotnet", "FilmesApi.dll"]
