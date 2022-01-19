﻿<%@ Page Language="AVR" AutoEventWireup="false" CodeFile="Error.aspx.vr" Inherits="Error" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>    
    <style>
        .error-icon-container {
            width: 6rem;
        }

        .error-detail-container {
            font-size: 1.4em;
            height: 48rem;
            overflow: auto;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="error-icon-container">
            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 448 512"><path fill="currentColor" d="M439.15 453.06L297.17 384l141.99-69.06c7.9-3.95 11.11-13.56 7.15-21.46L432 264.85c-3.95-7.9-13.56-11.11-21.47-7.16L224 348.41 37.47 257.69c-7.9-3.95-17.51-.75-21.47 7.16L1.69 293.48c-3.95 7.9-.75 17.51 7.15 21.46L150.83 384 8.85 453.06c-7.9 3.95-11.11 13.56-7.15 21.47l14.31 28.63c3.95 7.9 13.56 11.11 21.47 7.15L224 419.59l186.53 90.72c7.9 3.95 17.51.75 21.47-7.15l14.31-28.63c3.95-7.91.74-17.52-7.16-21.47zM150 237.28l-5.48 25.87c-2.67 12.62 5.42 24.85 16.45 24.85h126.08c11.03 0 19.12-12.23 16.45-24.85l-5.5-25.87c41.78-22.41 70-62.75 70-109.28C368 57.31 303.53 0 224 0S80 57.31 80 128c0 46.53 28.22 86.87 70 109.28zM280 112c17.65 0 32 14.35 32 32s-14.35 32-32 32-32-14.35-32-32 14.35-32 32-32zm-112 0c17.65 0 32 14.35 32 32s-14.35 32-32 32-32-14.35-32-32 14.35-32 32-32z"></path></svg>
        </div> 
        <h2>CRITICAL ERROR</h2>
        <h3>
            <asp:Label ID="labelErrorHeading" runat="server" Text="Label"></asp:Label>
        </h3>
        <% If (HttpContext.Current.IsDebuggingEnabled) %>  
        <h4>Error details (exceptions are shown inner-most first)</h4>
        <div class="error-detail-container">
            <pre><asp:Literal ID="literalErrorDetail" runat="server"></asp:Literal></pre>
        </div>
        <% Else %>
        <p>A critical error occurred. Please contact your network administrator.</p>
        <% EndIf  %>
    </div>
    </form>
</body>
</html>
