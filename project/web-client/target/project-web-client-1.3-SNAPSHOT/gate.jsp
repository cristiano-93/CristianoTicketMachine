<%-- 
    Document   : gate
    Created on : 20 Dec 2020, 16:20:34
    Author     : Cristiano Local
--%>
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
<%--<%@page import="solent.ac.uk.com504.examples.ticketgate.model.util.DateTimeAdapter"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.GateEntryServiceImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.GateManagementServiceImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.service.ServiceFactoryImpl"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.service.GateEntryService"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.service.GateManagementService"%>
<%@page import="solent.ac.uk.com504.examples.ticketgate.model.dto.Ticket"%>--%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%
    String errorMessage = "";
    Date currentTime = new Date();
    String ticketStr = request.getParameter("ticketStr");
    boolean openGate = false;
    response.setIntHeader("Refresh", 20);
    Date issueDate = null;
    String destinationStation = null;
    boolean validDateTime = false;
    boolean validFormat = false;
    boolean validStation = false;
    String endStationStr = request.getParameter("endStation");

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
        newCalendar.add(Calendar.HOUR_OF_DAY, 24);
        validDateTime = currentTime.before(newCalendar.getTime());
    } catch (Exception e) {
    }

    validFormat = TicketEncoderImpl.validateTicket(ticketStr);

    try {

        validStation = endStationStr.equals(destinationStation);

    } catch (Exception e) {
    }
    boolean valid;
    
    if (TicketEncoderImpl.validateTicket(ticketStr)) {
        valid = true;
    } else {
        valid = false ;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Open gate</title>
    </head>
    <body>
        <h1>Open Gate with Ticket</h1>        
        <div style="color:red;"><%=errorMessage%></div> <!--error message-->
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
                        <p><%=validDateTime%></p>
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
        <form action="./ticketGate.jsp"  method="post" >
            <table>
                <tr>
                    <td>Ending Station:</td>
                    <td><input type="text" name="endStation" value="<%=endStationStr%>"></td>
                </tr>
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
        <BR>
        <% if (valid) { %>
        <%  openGate = true;%>
        <div style="color:green;font-size:x-large">Valid Ticket, Gate Opening</div>
        <%  } else {  %>
        <div style="color:red;font-size:x-large">Invalid Ticket, Gate will remain Closed</div>
        <% }%>
    </body>
</html>