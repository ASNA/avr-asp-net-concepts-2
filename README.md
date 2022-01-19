# ASP.NET WebForms concepts 2 #

### web.config

AppSettings

- web.config's AppSettings section provides a way to soft-code values (usually configuration values) for your app.

```
<appSettings>
  <!-- 
  // Define database names and assign default database name
  -->
  <add key="DefaultDBName" value="Leyland"/>
  <add key="Local" value="*Public/DG NET Local"/>
  <add key="Leyland" value="*Public/Leyland"/>
  <!-- 
  // Disable MS's [BrowserLink feature.]
  (https://efficientuser.com/2017/07/06/browser-link-option-in-visual-studio/) 
  -->
  <add key="vs:EnableBrowserLink" value="false"/>
</appSettings>
```

You fetch AppSettings with the System.Configuration.ConfigurationManager class's AppSettings property (which is a NameValueCollection type)

```
DclFld ActiveDBNameKey  Type(*String)

ActiveDBNameKey = System.Configuration.ConfigurationManager.AppSettings["DefaultDBName"]
```

Enabling debug in web.config

- Debug is enabled in web.config like this:

```
  <system.web>
    <compilation debug="true"/>
```

It is very important to set ```debug``` to ```false``` before deploying the application to production. Debug mode disables all caching and a production application runs faster with caching enabled.

Disable Microsoft's BrowserLink

- Microsoft's BrowserLink was intended as a way to keep your browser refreshed during development but it is buggy and annoying. I always explicitly disable it with:

```
<appSettings>   
    ....
    <add key="vs:EnableBrowserLink" value="false"/>
    ...
```

We'll learn more about web.config in the "User authentication" section.

### Global.asax

The Global.asax file provides access to the application- and session-side event handlers.

To add a Global.asax file, use "Add->New Item" and selection "Global Application Class"

Including

- Application_Start
- Application_End
- Application_Error
- Session_Start
- Session_End

For example, this code gets the active database name from the appSettings in web.config and puts the database name in a application variable named 'dbname.'

```
DclFld ActiveDBNameKey  Type(*String)
DclFld DBName        Type(*String) 

ActiveDBNameKey = System.Configuration.ConfigurationManager.AppSettings["DefaultDBName"]
DBName = System.Configuration.ConfigurationManager.AppSettings[ActiveDBNameKey]
Application['dbname'] = DBName
```

Global.asax links

- https://docs.microsoft.com/en-us/previous-versions/dotnet/netframework-4.0/2027ewzw(v=vs.100)?redirectedfrom=MSDN
- https://stackoverflow.com/questions/2340572/what-is-the-purpose-of-global-asax-in-asp-net
- https://docs.microsoft.com/en-us/previous-versions/aspnet/ms178473(v=vs.100)

### Master pages

Content page events fire first then master page events fire

Content placeholders

Set document type to HTML 5 on all master pages

```
<!DOCTYPE html>
```

### User authentication

Change web.config

Add login page with UI

### Global error handling

C:\Users\roger\Documents\Programming\AVR\test-web-config

Add Error.aspx and Error.aspx.vr

- This page includes some CSS in a 'style' tag that should probably be moved to a separate CSS file.

Add PageNotFound.aspx and PageNotFound.aspx.vr

Add 'homer.png' image

Add "error" folder immediately off of root

- Errors are logged here

Nothing needed in web.config

Add this code to Global.asax's Application_Error event handler

```
DclFld OuterError Type(System.Exception)
DclFld InnerError Type(System.Exception)
DclFld guid Type(System.Guid)
DclFld ErrorKey Type(*String) 
DclFld HttpStatusCode Type(*Integer4) 

OuterError = Server.GetLastError()

HttpStatusCode = (OuterError *As HttpException).GetHttpCode()
If HttpStatusCode = 404
    Server.ClearError()
    Response.Redirect('PageNotFound.aspx?page=' + Context.Request.FilePath) 
EndIf 

If OuterError.InnerException <> *Nothing 
    InnerError = OuterError.InnerException
EndIf 
Server.ClearError()

guid = System.Guid.NewGuid()
ErrorKey = guid.ToString()

If OuterError *Is System.Web.HttpUnhandledException
    Application[ErrorKey] = InnerError <> *Nothing ? InnerError : OuterError
    Server.TransferRequest('Error.aspx?error=' + ErrorKey, *True)
EndIf
```