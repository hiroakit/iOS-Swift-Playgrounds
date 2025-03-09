# ExampleApi

- .NET v8 (with [Homebrew](https://github.com/Homebrew/homebrew-core/blob/HEAD/Formula/d/dotnet@8.rb))

# Self-signed certificate

Web APIs are expected to operate over HTTPS.  
Similarly, iOS applications can only access Web APIs that function over HTTPS as a general rule.  

When verifying connectivity between an application and a Web API over a local area network during development, the Web API must be hosted on a domain or IP address that is valid within the local area network, and a self-signed certificate corresponding to that hosting destination must be used.  

For example, suppose an actual iPhone device and a Mac are on the same local area network, and the iPhone needs to access a Web API running on the Mac. Let’s assume your Mac’s IPv4 address is `192.0.2.1` (※1). If the Web API is hosted on `localhost` on the Mac, the iPhone will not be able to access it. Therefore, let’s assume it is hosted at `192.0.2.1` instead.  

ASP.NET Core (and likely other frameworks as well) provides the `dotnet dev-certs https --trust` command, which issues a self-signed certificate assuming hosting on `localhost` during development. However, issuing a self-signed certificate for a specific domain or IP address on a local network requires a different procedure.  

The following sections explain how to generate and apply a self-signed certificate.

## Steps

First, check the IP address of the Mac running the Web API.

```zsh
% ipconfig getifaddr en0
192.0.2.1
```

Next, create a self-signed certificate.

```zsh
cd ./iOS-Swift-Playgrounds/Samples/ExampleApi

openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=192.0.2.1"
openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

# e.g., Password is YourPassword
openssl pkcs12 -export -out server.pfx -inkey server.key -in server.crt -password pass:YourPassword
```

Once that is done, to update iOS-Swift-Playgrounds/Samples/ExampleApi/appsettings.Development.json

```json
  "Kestrel": {
    "Endpoints": {
      "HttpsInlineCertFile": {
        "Url": "https://192.0.2.1:7282", // Here
        "Certificate": {
          "Path": "server.pfx",
          "Password": "YourPassword"     // Here
        }
      }
    }
  }  
```

Finally, Transfer the generated server.csr file to the iPhone. Possible transfer methods include iCloud Drive and AirDrop. When the iPhone receives the file, an installation prompt will appear on the screen.

The installed .csr file can be found in the Settings app under VPN & Device Management.

※1: [RFC5737 TEST-NET-1](https://datatracker.ietf.org/doc/html/rfc5737#section-3)