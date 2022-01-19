<%@ Page Language="AVR" MasterPageFile="~/MasterPageNav.master" AutoEventWireup="false" CodeFile="Index.aspx.vr" Inherits="Index" Title="Untitled Page" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
<%--#
// HttpContext.Current.IsDebuggingEnabled is true when the application 
// is running under debug. This lets you conditionally include different 
// code for debug/production. In this case the same code is included but 
// it would be good if the CSS were combined and minified for production.
// If you did that the combined and minified CSS would be specified 
// for the production version.
#--%>
    <%
    If (HttpContext.Current.IsDebuggingEnabled)     
    %>
    <link rel="stylesheet" href="/public/css/one-column-layout.css">
    <link rel="stylesheet" href="/public/css/grid.css">
    <%
    Else
    %>
    <link rel="stylesheet" href="/public/css/one-column-layout.css">
    <link rel="stylesheet" href="/public/css/grid.css">
    <%
    EndIf 
    %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" Runat="Server">

<div class="container">
   <header>
        header
   </header>
    
   <main>
       main
       <div>
            <div class="form-check">
                <asp:CheckBox ID="TaxExempt" runat="server" CssClass="form-check-input" ClientIDMode="Static" Checked="true"/>
                <label class="form-check-label" for="TaxExempt">
                    Active customer
                </label>
            </div>
        </div>
   </main>

           <div>
               <asp:LinkButton cssClass="mt-5" ID="linkbuttonUnhandledException" runat="server">Cause unhandled exception</asp:LinkButton>
           </div>

  
   <footer>
       footer
    </footer>
</div>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script>
        applib.removeAspNetCheckboxWrapper('input[type="radio"],input[type="checkbox"]');
    </script>
</asp:Content>
