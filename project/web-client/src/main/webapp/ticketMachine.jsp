<%-- 
    Document   : ticketMachine
    Created on : 20 Dec 2020, 16:20:47
    Author     : Cristiano Local
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page import="org.solent.com528.project.impl.dao.jaxb.PriceCalculatorDAOJaxbImpl"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%
    String validFromStr = request.getParameter("validFrom");
    String validToStr = request.getParameter("validTo");
    
    String startZoneStr = request.getParameter("zoneStart");    
    String startStationStr = request.getParameter("startStation");
    
    String endZoneStr = request.getParameter("zoneEnd");    
    String endStationStr = request.getParameter("endStation");
    String errorMessage = "";
    String currentTimeStr = new Date().toString();
    
    String fileName = "target/priceCalculatorDAOJaxbImplFile.xml";
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb = new PriceCalculatorDAOJaxbImpl(fileName);
    
    Calendar newCalendar = Calendar.getInstance();
    newCalendar.setTime(new Date());
    newCalendar.add(Calendar.HOUR_OF_DAY, 24);
    String validToTimeStr = newCalendar.getTime().toString();
    
    String ticketStr = request.getParameter("ticketStr");
    
    Double pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(new Date());
    Rate rate = priceCalculatorDAOJaxb.getRate(new Date());
    
    Ticket ticket = new Ticket();
    ticket.setCost(pricePerZone);
    ticket.setStartStation(startStationStr);
    ticket.setIssueDate(new Date());
    ticket.setRate(rate);
    ticket.setEndStation(endStationStr);;
    String encodedTicketStr = TicketEncoderImpl.encodeTicket(ticket);
    ticketStr = encodedTicketStr;
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage gate Locks</title>
    </head>
    <body>
        <h1>Generate a New Ticket</h1>
        <!-- print error message if there is one -->
        <div style="color:red;"><%=errorMessage%></div>

        <form action="./ticketMachine.jsp"  method="post">
            <table>
                <tr>
                    <td>Start Zones:</td>
                    <td><input type="text" name="zoneStart" value="<%=startZoneStr%>"></td>
                </tr>
                <tr>
                    <td>Starting Station:</td>
                    <td><input type="text" name="startStation" value="<%=startStationStr%>"></td>
                </tr>
                <tr>
                    <td>End Zone:</td>
                    <td><input type="text" name="zoneEnd" value="<%=endZoneStr%>"></td>
                </tr>
                <tr>
                    <td>Ending Station:</td>
                    <td><input type="text" name="endStation" value="<%=endStationStr%>"></td>
                </tr>
                <tr>
                    <td>Valid From Time:</td>
                    <td>
                        <p><%=currentTimeStr%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid To Time:</td>
                    <td>
                        <p><%=validToTimeStr%></p>
                    </td>
                </tr>
            </table>
            <button type="submit" >Create Ticket</button>
        </form> 
        <h1>generated ticket XML</h1>
        <textarea id="ticketTextArea" rows="14" cols="120"><%=ticketStr%></textarea>

    </body>
</html>