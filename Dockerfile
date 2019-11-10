FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["NetCoreWeb.csproj", ""]
RUN dotnet restore "./NetCoreWeb.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "NetCoreWeb.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NetCoreWeb.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NetCoreWeb.dll"]