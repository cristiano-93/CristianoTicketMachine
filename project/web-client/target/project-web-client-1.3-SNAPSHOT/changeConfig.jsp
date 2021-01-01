<%-- 
    Document   : changeConfig
    Created on : 29 Dec 2020, 15:16:04
    Author     : Cristiano Local
--%>


<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="java.util.Date"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>

<%
    // used to place error message at top of page 
    String errorMessage = "";
    
    // accessing service 
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    
    // accessing request parameters
    String actionStr = request.getParameter("action");
    String updateUuidStr = request.getParameter("updateUuid");
    String selectStation = request.getParameter("updateStationName");//not used

    String stationName = WebClientObjectFactory.getStationName();
    Integer stationZone = WebClientObjectFactory.getStationZone();
    String ticketMachineUuid = WebClientObjectFactory.getTicketMachineUuid();
    Date lastUpdate = WebClientObjectFactory.getLastClientUpdateTime();
    Date lastUpdateAttempt = WebClientObjectFactory.getLastClientUpdateAttempt();
    String lastUpdateStr = (lastUpdate==null) ? "not known" : lastUpdate.toString();
    String lastUpdateAttemptStr = (lastUpdateAttempt==null) ? "not known" : lastUpdateAttempt.toString();
    
    
    
    if ("changeTicketMachineUuid".equals(actionStr)) {
        WebClientObjectFactory.setTicketMachineUuid(updateUuidStr);
        
    }
//    else if ("changeStationName".equals(actionStr)){
//       WebClientObjectFactory.setStationName(selectStation);
//       stationZone = WebClientObjectFactory.getStationZone();
//    }
//    if (updateUuidStr.isEmpty() || updateUuidStr.isBlank()){
//        errorMessage = "No Uuid provided";
//    } else {
//        WebClientObjectFactory.setTicketMachineUuid(updateUuidStr);
//        stationName = WebClientObjectFactory.getStationName();
//        stationZone = WebClientObjectFactory.getStationZone();
//        machineId = WebClientObjectFactory.getTicketMachineUuid();
//                
//    }

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Ticket Machine Configuration</title>
    </head>
    <body>

        <h1>Change Ticket Machine Configuration</h1>

        <table>
            <tr>
                <td>Last Update Attempt</td>
                <td><%=lastUpdateAttemptStr %></td>
                <td></td>
            </tr>
            <tr>
                <td>Last Successfull Update </td>
                <td><%=lastUpdateStr %></td>
                <td></td>
            </tr>
            
            <form action="./changeConfig.jsp" method="get">
                <tr>
                    <td>Station Name</td>
                    <td><input type="text" size="36" name="updateStationName" value="<%=stationName%>"></td>
                    <td>
                        <input type="hidden" name="action" value="changeStationName">
                        <button type="submit" >Change Station</button>
                    </td>
                </tr>
            </form>
            <tr>
                <td>Station Zone</td>
                <td><%=stationZone%></td>
                <td></td>
            </tr>
            <form action="./changeConfig.jsp" method="get">
                <tr>
                    <td>Ticket Machine Uuid</td>

                    <td><input type="text" size="36" name="updateUuid" value="<%=ticketMachineUuid%>"></td>
                    <td>
                        <input type="hidden" name="action" value="changeTicketMachineUuid">
                        <button type="submit" >Change Ticket Machine Uuid</button>
                    </td>

                </tr>
            </form>
        </table> 
        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>

    </body>
</html>