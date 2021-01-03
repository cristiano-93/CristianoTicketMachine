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
    String endStation = request.getParameter("endStation");
    String date = request.getParameter("date");
    response.setIntHeader("Refresh", 30);
    Date currentTime = new Date();
    Date issueDate = null;
    String destinationStation = "";

    boolean validTime = false;
    boolean validFormat = false;
    boolean validStation = true;
    boolean openGate = false;

    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    List<Station> stationsList = new ArrayList<Station>();
    stationsList = stationDAO.findAll();

    //validating ticket XML data
    if (ticketStr != null) {
        try {
            JAXBContext jaxbContext = JAXBContext.newInstance("org.solent.com528.project.model.dto");
            Unmarshaller jaxbUnMarshaller = jaxbContext.createUnmarshaller();
            Ticket ticket = (Ticket) jaxbUnMarshaller.unmarshal(new StringReader(ticketStr));
            ticket.setIssueDate(issueDate);
            destinationStation = ticket.getEndStation();
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
    } catch (Exception e) {
        errorMessage="";
    }

    // checking if ticket is valid and opening gate
    validFormat = TicketEncoderImpl.validateTicket(ticketStr);

    if (endStation == destinationStation) {
        validStation = true;
    } else if (endStation != destinationStation) {
        errorMessage = "Select the end station and make sure its the same as the ticket";
        validStation = false;
    }

    if (validFormat && validStation && validTime) {
        openGate = true;
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
                        <p><%=validTime%></p>
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
                
                <tr>Stations List                       
                <select name="stationSelect" id="stationSelect">	
                    <%
                        for (Station station : stationsList) {
                    %>	
                    <option value="<%=station.getName()%>"><%=station.getName()%></option>	
                    <%
                        }
                    %>     
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