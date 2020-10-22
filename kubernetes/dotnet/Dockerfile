FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine AS build-env
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish --runtime linux-musl-x64 -c Release -o out 

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-alpine
WORKDIR /app
COPY --from=build-env /app/out .

EXPOSE 3000
ENV ASPNETCORE_URLS=http://*:3000
ENTRYPOINT ["dotnet", "dotnet.dll"]