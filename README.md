# ASP.NET WebForms concepts 2 #

### Master pages

Set document type to HTML 5 on all master pages

```
<!DOCTYPE html>
```

Recommended content placeholders

- "Head" - at bottom of master page Head tag. This is for injecting anything from a content page that needs to be in the Head tag.
- "Content" - main content placeholder. Location dictated by CSS and HTML
- "pageScripts" - just above Body tag. This is primarily for injecting JavaScript from a content page.

Content page events fire first then master page events fire

Add ChildPage property

- By default, a master page doesn't know what content page it is displaying. Adding a public ChildPage property fixes that. Add this code in the master page's PageLoad event hander:

```
// gets page in this format: ~/views/Index.aspx
*This.ChildPage = Page.AppRelativeVirtualPath.ToLower()
```

Discuss conditional code (`<% ... %>`) in the master page.

Install Bootstap from download

Add JavaScript for master page

- The `removeAspNetCheckboxWrapper` method removes some markup that ASP.NET checkbox and radio buttons generate. This lets those two controls work with Bootstrap CSS. If you're not using Bootstrap, this may not be necessary.
- We'll see this code in action in the `login.aspx` page.

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

You fetch appSettings with the `System.Configuration.ConfigurationManager` class's appSettings property (which is a NameValueCollection type)

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

It is very important to set `debug` to `false` before deploying the application to production. Debug mode disables all caching and a production application runs faster with caching enabled.

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

### User authentication

Change web.config

- Add this code as an immediately child of the `<configuration>` element:

```
<system.webServer>
    <modules runAllManagedModulesForAllRequests="true" />
</system.webServer>
```

Note: If there is already a `<system.webServer>` element in your web.config, add the `<modules...` element inside it.

Add this code immediately under the `<system.web>` element:

```
<authentication mode="Forms">
  <forms name="Loginform" loginUrl="views/login.aspx" timeout="30"/>
  <!-- 
    // The timeout value is specified in minutes. 
    // This value also determines how long the authentication cookie, if used,
    // persists.
    -->
</authentication>
```

The session timeout value is specified in minutes. Generally you'll want this to be at least 20 minutes.

Add this code immediately after the `<authentication>` element. It disables _all_ pages from unauthenticated users.

```
<authorization>
    <deny users="?"/>
</authorization>
```

Where `?` means "unauthenticated users"

Add this code immediately after the `<system.web>` element. It adds exceptions to what pages are available to unauthenticated users.

```  
<location path="public">
    <system.web>
      <authorization>
        <allow users="?"/>
      </authorization>
    </system.web>
</location>
```

[MS forms authentication docs](https://docs.microsoft.com/en-US/troubleshoot/developer/webapps/aspnet/development/forms-based-authentication)

Add login page with UI

- Discuss validator controls
   - [MS Validator control docs](https://docs.microsoft.com/en-us/previous-versions/aspnet/debza5t0(v=vs.100))

Add logic for authenticating user

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