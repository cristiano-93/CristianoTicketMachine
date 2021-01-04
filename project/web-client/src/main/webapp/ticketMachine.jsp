<%-- 
    Document   : ticketMachine
    Created on : 13 Dec 2020, 16:20:47
    Author     : Cristiano Local
--%>

<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="java.util.*"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page import="org.solent.com528.project.impl.webclient.WebClientObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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

<!DOCTYPE html>
<%
    // Setting up variables
    String startStation = request.getParameter("startStation");
    String endStation = request.getParameter("endStation");
    Integer endZone = 0;
    Integer zonesTravelled = 0;
    String errorMessage = "";

    try {
        if (request.getParameter("zonesTravelled") != null) {
            zonesTravelled = Integer.parseInt(request.getParameter("zonesTravelled"));
        }
    } catch (Exception ex) {
        errorMessage = ex.getMessage() + request.getParameter("zonesTravelled");
    }
    try {
        if (request.getParameter("endZone") != null) {
            endZone = Integer.parseInt(request.getParameter("endZone"));
        }
    } catch (Exception ex) {
        errorMessage = ex.getMessage() + request.getParameter("endZone"); //printing the value 

    }

    //Service    
    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    List<Station> stationsList = new ArrayList<Station>();
    stationsList = stationDAO.findAll();

    String actionStr = request.getParameter("action");

    // checking for error
    if (actionStr == null || actionStr.isEmpty()) {
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

    //checking travelled zones
    // Getting the Price and Rate
    String fileName = "target/priceCalculatorDAOJaxbImplFile.xml";
    PriceCalculatorDAOJaxbImpl priceCalculatorDAOJaxb = new PriceCalculatorDAOJaxbImpl(fileName);
    Rate rate = priceCalculatorDAOJaxb.getRate(new Date());
    Double pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(new Date());
    double ticketPrice = 500.0;
    ticketPrice = pricePerZone * zonesTravelled;

    // Setting up a new Ticket
    if (endStation != startStation) {
        Ticket newTicket = new Ticket();
        newTicket.setCost(ticketPrice);
        newTicket.setRate(rate);
        newTicket.setStartStation(startStation);
        newTicket.setEndStation(endStation);
        newTicket.setEndZone(endZone);
        newTicket.setIssueDate(new Date());

        String encodedTicket = TicketEncoderImpl.encodeTicket(newTicket);
        ticket = encodedTicket;
    } else if (endStation == startStation) {
        errorMessage = "start station cannot be the same as the destination station";
    }

%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Ticket Machine</title>
    </head>
    <body>
        <h1>Create a New Ticket</h1>

        <div style="color:red;"><%=errorMessage%></div>

        <form action="./ticketMachine.jsp"  method="post">
            <table>
                <tr>
                    <td>Starting Station:</td>
                    <td><input type="text" name="startStation" value="<%=startStation%>"></td>
                    <td>Stations List                       
                        <select name="stationSelect" id="stationSelect">	
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
                    <td>Stations List                       
                        <select name="stationSelect" id="stationSelect">	
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
                    <td>Ending Station:</td>
                    <td><input type="text" name="endStation" value="<%=endStation%>"></td>     
                </tr>
                <tr>
                    <td>Ending Zone:</td>
                    <td><input type="text" name="endZone" value="0"></td>     
                </tr>
                <tr>
                    <td>Zones Travelled:</td>
                    <td><input type="text" name="zonesTravelled" value=""></td>     
                </tr>
                <tr>
                    <td>Issued on:</td>
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

        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>
        <h1>Generated ticket XML</h1>
        <textarea id="ticketTextArea" rows="14" cols="120"><%=ticket%></textarea>

    </body>
</html>