FROM dotnet22-base AS build
USER 0
#WORKDIR /app
ENV WORKDIR /opt/app
WORKDIR /opt/app
ENV ASPNETCORE_ENVIRONMENT Development
SHELL [ "/bin/bash" , "-c"]
# Copy csproj and restore as distinct layers
RUN mkdir -p $WORKDIR
COPY *.csproj $WORKDIR
RUN dotnet restore
# Copy everything else and build
COPY . $WORKDIR
RUN dotnet publish -c Release -o out
# Build runtime image
FROM dotnet22-base AS runtime
COPY --from=build $WORKDIR .
EXPOSE 80
USER 1001
ENV ASPNETCORE_ENVIRONMENT Development
#ENV PATH /opt/rh/rh-nodejs10/root/usr/bin:/opt/rh/rh-dotnet22/root/usr/bin:/opt/rh/rh-dotnet22/root/usr/sbin:/opt/app-root/src/.local/bin:/opt/app-root/src/bin:/opt/app-root/node_modules/.bin:/opt/app-root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/app-root/.dotnet/tools
ENTRYPOINT ["/opt/rh/rh-dotnet22/root/usr/bin/dotnet", "prime.dll"]
