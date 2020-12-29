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
    String ticketStr = request.getParameter("ticketStr");
    boolean openGate = false;
    response.setIntHeader("Refresh", 20);
    Date currentTime = new Date();
    Date issueDate = null;
    boolean validUntill = false;
    boolean validFormat = false;
    String destinationStation = null;
    boolean validStation = false;
    String endStation = request.getParameter("endStation");
    
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
    List<Station> stationsList = new ArrayList<Station>();
    String zoneStr = request.getParameter("zone");

    if (zoneStr == null || zoneStr.isEmpty()) {
        stationsList = stationDAO.findAll();
    } else {
        try {
            Integer zone = Integer.parseInt(zoneStr);
            stationsList = stationDAO.findByZone(zone);
        } catch (Exception ex) {
            errorMessage = ex.getMessage();
        }
    }
    
    if (ticketStr != null) {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance("org.solent.com528.project.model.dto");
            Unmarshaller jaxbUnMarshaller = jaxbContext.createUnmarshaller();
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(ticketStr));
            issueDate = ticket.getIssueDate();
            destinationStation = ticket.getEndStation();
        } catch (Exception ex) {
            throw new IllegalArgumentException("could not marshall to Ticket ticketXML=" + ticketStr);
        }
    }

    try {
        Calendar newCalendar = Calendar.getInstance();
        newCalendar.setTime(issueDate);
        newCalendar.add(Calendar.HOUR_OF_DAY, 4);
        validUntill = currentTime.before(newCalendar.getTime());
    } catch (Exception e) {
    }

    validFormat = TicketEncoderImpl.validateTicket(ticketStr);

    try {

        validStation = endStation.equals(destinationStation);

    } catch (Exception e) {
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
        <form>
            <table>
                <tr>
                    <td>Valid Format:</td>
                    <td>
                        <p><%=validFormat%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Date</td>
                    <td>
                        <p><%=validUntill%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Station</td>
                    <td>
                        <p><%=validStation%></p>
                    </td>
                </tr>
            </table>
        </form> 
        <form action="./gate.jsp"  method="post" >
            <table>
                <td>End Station: </td>
                <td>                        
                        <select name="endStation" id="endStation">	
                            <%
                                for (Station station : stationsList) {
                            %>	
                            <option value="<%=station.getName()%>"><%=station.getName()%></option>	
                            <%
                                }
                            %>                        
                </td>
                <tr>
                    <td>Current Time</td>
                    <td>
                        <p><%= currentTime.toString()%> (auto refreshing every 20 seconds)</p>
                    </td>
                </tr>
                <tr>
                    <td>Ticket Data:</td>
                    <td><textarea name="ticketStr" rows="14" cols="120"><%=ticketStr%></textarea></td>
                </tr>
            </table>
            <button type="submit" >Open Gate</button>
        </form>

        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>
        <BR>
        <% if (validFormat) { %>
        <%  openGate = true;%>
        <div style="color:green;font-size:x-large">Valid Ticket, Gate Opening</div>                 <!--find a way of hiding this untill the user checks the ticket XML-->
        <%  } else {  %>
        <div style="color:red;font-size:x-large">Invalid Ticket, Gate will remain Closed</div>      <!--find a way of hiding this untill the user checks the ticket XML-->
        <% }%>
    </body>
</html>