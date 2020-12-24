<%-- 
    Document   : ticketMachine
    Created on : 13 Dec 2020, 16:20:47
    Author     : Cristiano Local
--%>

<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.*"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>

<%@page import="java.util.Calendar"%>
<%@page import="org.solent.com528.project.clientservice.impl.TicketEncoderImpl"%>
<%@page import="org.solent.com528.project.model.dto.Ticket"%>
<%@page import="org.solent.com528.project.model.dto.Rate"%>
<%@page import="org.solent.com528.project.impl.dao.jaxb.PriceCalculatorDAOJaxbImpl"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="javax.xml.bind.JAXBContext"%>
<%@page import="java.io.StringWriter"%>
<%@page import="javax.xml.bind.Marshaller"%>

<%    
    // Setting up Zones/Stations values
    String validFrom = request.getParameter("validFrom");
    String validTo = request.getParameter("validTo"); 
    String startStation = request.getParameter("startStation");     
    String startZone = request.getParameter("startZone");          
    String endZone = request.getParameter("endZone");    
    String endStation = request.getParameter("endStation");
    String destination = request.getParameter("destinationStation");
    
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    String startStationName = WebClientObjectFactory.getStationName();
    Integer startStationZone = WebClientObjectFactory.getStationZone();
    
    //Service
    String errorMessage = "";
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
    List<Station> stationsList = new ArrayList<Station>();
    String actionStr = request.getParameter("action");
    String zoneStr = request.getParameter("zone");
    // return station list for zone
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
    // basic error checking before making a call
    if (actionStr == null || actionStr.isEmpty()) {
        // do nothing
    } else if ("XXX".equals(actionStr)) {
        // put your actions here
    } else {
        errorMessage = "ERROR: page called for unknown action";
    }
    
    
        
    
    
    // Setting up Date/Time values
    Calendar newCalendar = Calendar.getInstance();
    newCalendar.setTime(new Date());
    newCalendar.add(Calendar.HOUR_OF_DAY, 4);
    String currentTime = new Date().toString();
    String validUntill = newCalendar.getTime().toString();
    
    String ticket = request.getParameter("ticketStr");
    
    // Getting the Price and Rate
    String fileName = "target/priceCalculatorDAOJaxbImplFile.xml";
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb = new PriceCalculatorDAOJaxbImpl(fileName);
    Double pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(new Date());
    Rate rate = priceCalculatorDAOJaxb.getRate(new Date());
    
    // Setting up a new Ticket
    Ticket newTicket = new Ticket();
    newTicket.setCost(pricePerZone);
    newTicket.setStartStation(startStation);
    newTicket.setIssueDate(new Date());
    newTicket.setRate(rate);
    newTicket.setEndStation(endStation);;
    String encodedTicket = TicketEncoderImpl.encodeTicket(newTicket);
    ticket = encodedTicket;
    

    


%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage gate Locks</title>
    </head>
    <body>
        <h1>Create a New Ticket</h1>
        
        <div style="color:red;"><%=errorMessage%></div>

        <form action="./ticketMachine.jsp"  method="post">
            <table>
                <tr>
                    <td>Start Zones:</td>
                    <td><input type="text" name="startZone" value="<%=startZone%>"></td>
                </tr>
                <tr>
                    <td>Starting Station:</td>
                    <td><input type="text" name="startStation" value="<%=startStation%>"></td>
                </tr>
                <tr>
                    <td>Destination Zone:</td>
                    <td><input type="text" name="endZone" value="<%=endZone%>"></td>                <!-- ask ethan-->
                </tr>
                <tr>
                    <td>Ending Station:</td>
                    <td><input type="text" name="endStation" value="<%=endStation%>"></td>
                </tr>
                <tr>
                    <td>Valid From Time:</td>
                    <td>
                        <p><%=currentTime%></p>
                    </td>
                </tr>
                <tr>
                    <td>Valid Untill:</td>
                    <td>
                        <p><%=validUntill%></p>
                    </td>
                </tr>
            </table>
            <button type="submit" >Create Ticket</button>
        </form> 
        <h1>Generated ticket XML</h1>
        <textarea id="ticketTextArea" rows="14" cols="120"><%=ticket%></textarea>

    </body>
</html>