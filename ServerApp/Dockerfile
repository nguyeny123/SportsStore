#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1.302-buster AS build
WORKDIR /src
COPY ["ServerApp.csproj", ""]
RUN dotnet restore "./ServerApp.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "ServerApp.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ServerApp.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "ServerApp.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet ServerApp.dll