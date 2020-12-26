<%-- 
    Document   : listMachines
    Created on : 26 Dec 2020, 17:50:47
    Author     : Cristiano Local
--%>

<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    
    // accessing service 
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    
    String ticketMachineUuid = WebClientObjectFactory.getTicketMachineUuid();
    

%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket machines list</title>
    </head>
    <body>
        <h1><%=ticketMachineUuid%></h1>
        
        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>
        
    </body>
</html>
