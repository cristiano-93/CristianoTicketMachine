<%-- 
    Document   : gate
    Created on : 13 Dec 2020, 16:20:34
    Author     : Cristiano Local
--%>
<%@page import="java.util.Set"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="java.io.StringReader"%>
<%@page import="javax.xml.bind.Unmarshaller"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%
    String errorMessage = "";
    String message = "";
    String ticketStr = request.getParameter("ticketStr");
    String endStation = null;
    Integer endZone = 1;
    response.setIntHeader("Refresh", 60);
    Date currentTime = new Date();
    Date issueDate = null;
    Integer zoneLimit = 1;
    String endStationName = request.getParameter("endStationName");

    boolean validTime = false;
    boolean validFormat = false;
    boolean validStation = true;
    boolean openGate = false;

    //setting up the service
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    List<Station> stationsList = new ArrayList<Station>();
    Set<Integer> zones = stationDAO.getAllZones();
    stationsList = stationDAO.findAll();

    //validating ticket XML data
    if (ticketStr != null) {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance("org.solent.com528.project.model.dto");
            Unmarshaller jaxbUnMarshaller = jaxbContext.createUnmarshaller();
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(ticketStr));
            issueDate = ticket.getIssueDate();
            endStation = ticket.getEndStation();
            zoneLimit = ticket.getEndZone();
        } catch (Exception ex) {
            throw new IllegalArgumentException("could not marshall to Ticket ticketXML=" + ticketStr);
        }
    }

    // setting up date to check if ticket time within valid 4 hours
    try {
        Calendar newCalendar = Calendar.getInstance();
        newCalendar.setTime(issueDate);
        newCalendar.add(Calendar.HOUR_OF_DAY, 4);
        validTime = currentTime.before(newCalendar.getTime());
        if (!validTime) {
            errorMessage = "invalid time";
        }
    } catch (Exception e) {
        errorMessage = "couldnt validate time";
    }

    // checking if ticket is valid and opening gate
    validFormat = TicketEncoderImpl.validateTicket(ticketStr);
    if (!validFormat) {
        errorMessage = "invalid ticket format";
    }
    
    
    
    try{
    Integer.parseInt(request.getParameter("endZone"));
    }catch(Exception ex){
        errorMessage = ex + " error parsing endzone";
    }
    if (endZone <= zoneLimit) {
        validStation = true;
    } else {
        errorMessage = "make sure the ticket is within its limit zone";
        validStation = false;
    }

    if (validFormat && validStation && validTime) {
        openGate = true;
        message = "Format, Date and Zone all valid";
    } else {
        openGate = false;
    }



%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gate Lock System</title>
    </head>
    <body>
        <h1>Open Gate with Ticket</h1>        
        <div style="color:red;"><%=errorMessage%></div> 
        <div style="color:green;"><%=message%></div>
        <table>
            <tr>
                <td>Arrival Zone:</td>
                <td>
                    <select>
                    <%
                        for (Integer selectZone : zones) {
                    %>
                    <form action="./ticketGate.jsp" method="get">
                        <input type="hidden" name="endZone" value="<%= selectZone%>">
                        <button type="submit" >Zone&nbsp;<%= selectZone%></button>
                    </form> 
                    <%
                        }
                    %>

                    </select>
                </td>
            </tr>
        </table>
        <form action="./gate.jsp"  method="post" >
                <tr><td>Stations List</td> 
                    <td>
                        <select name="endStationName" id="endStationName">	
                            <%
                                for (Station station : stationsList) {
                            %>	
                            <option value="<%=station.getName()%>"><%=station.getName()%></option>	
                            <%
                                }
                            %>     
                    </td>
                </tr>
                <tr>
                    <td>Current Time</td>
                    <td>
                        <p><%= currentTime.toString()%> (auto refreshing every 30 seconds)</p>
                    </td>
                </tr>
                <tr>
                    <td>Ticket Data:</td>
                    <td><textarea name="ticketStr" rows="14" cols="90"><%=ticketStr%></textarea></td>
                </tr>
            </table>
            <button type="submit" >Open Gate</button>
        </form>

        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>
        <BR>
        <% if (openGate) { %>
        <% %>
        <div style="color:green;font-size:x-large">Valid Ticket, Gate Opening</div>                 <!--find a way of hiding this untill the user checks the ticket XML-->
        <%  } else {  %>
        <div style="color:red;font-size:x-large">Invalid Ticket, Gate will remain Closed</div>      <!--find a way of hiding this untill the user checks the ticket XML-->
        <% }%>
    </body>
</html>