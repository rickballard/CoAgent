FROM mcr.microsoft.com/powershell:7.4-alpine-3.19
RUN apk add --no-cache ttyd
EXPOSE 7681
CMD ["ttyd","-p","7681","pwsh","-NoLogo","-NoProfile"]
