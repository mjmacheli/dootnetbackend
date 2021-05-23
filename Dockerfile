FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /app
# COPY ["src/Backend.Foodxhange.Api/Backend.Foodxhange.Api.csproj", "src/Backend.Foodxhange.Api/"]
COPY . .


WORKDIR "/app/src/Backend.Foodxhange.Api"

RUN dotnet restore "Backend.Foodxhange.Api.csproj"

RUN dotnet build "Backend.Foodxhange.Api.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "Backend.Foodxhange.Api.csproj" -c Release -o /app/publish

FROM base AS final

WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://+:8080
HEALTHCHECK --interval=60s --timeout=3s --retries=3 \
    CMD wget localhost:8080/health -q -O - > /dev/null 2>&1
ENTRYPOINT ["dotnet", "Backend.Foodxhange.Api.dll"]
