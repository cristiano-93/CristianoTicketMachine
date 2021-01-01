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
    String creditCard = request.getParameter("creditCard");
    int cardInt = 0;
    //cardInt = Integer.parseInt(creditCard);
    boolean validCard = false;
    String errorMessage = "";

    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    String startStationName = WebClientObjectFactory.getStationName();
    Integer startStationZone = WebClientObjectFactory.getStationZone();

    //Service
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
    List<Station> stationsList = new ArrayList<Station>();
    stationsList = stationDAO.findAll();

    String actionStr = request.getParameter("action");

//    if (zoneStr.isEmpty()) {
//        stationsList = stationDAO.findAll();
//    } else {
//        try {
//            Integer zone = Integer.parseInt(zoneStr);
//            stationsList = stationDAO.findByZone(zone);
//        } catch (Exception ex) {
//            errorMessage = ex.getMessage();
//        }
//    }
    // checking for error
    if (actionStr == null || actionStr.isEmpty()) {
    } else {
        errorMessage = "ERROR: page called for unknown action";
    }

    // checking if card number is valid --not working
//    if(creditCard.length() == 16){
//        validCard = true;
//    }
//    else {
//        errorMessage = "INVALID CARD NUMBER, card must be 16 digits";
//    }
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

    //calculating the ticket price   
//    Station station1 = new Station();
//    Station station2 = new Station();
//    
//    station1 = stationDAO.findByName(startStation);   
//    station2 = stationDAO.findByName(endStation);
//    double zone1;
//    double zone2;
//
//    zone1 = station1.getZone();
//    zone2 = station2.getZone();
//
//    double price = zone2 - zone1 + 1;
//    Math.abs(price);
//    double totalPrice = price * pricePerZone;

//    if (price < 0) {
//        price = price - (price * 2);
//        totalPrice = pricePerZone * price;
//    } else {
//        totalPrice = pricePerZone * price;
//    }
//        DateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
//
//        Rate rate1;
//        Double pricePerZone;
//
//        Date date1 = df.parse("2020-01-01 00:00");
//
//        rate1 = priceCalculatorDAOJaxb.getRate(date1);
//        assertEquals(Rate.OFFPEAK, rate1);
//        pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(date1);
//        assertEquals(2.50, pricePerZone, 0.0001);
//
//        date1 = df.parse("2020-03-01 08:25");
//
//        rate1 = priceCalculatorDAOJaxb.getRate(date1);
//        assertEquals(Rate.PEAK, rate1);
//        pricePerZone = priceCalculatorDAOJaxb.getPricePerZone(date1);
//        assertEquals(5.00, pricePerZone, 0.0001);
    // Setting up a new Ticket
    if (endStation != startStation) {
        Ticket newTicket = new Ticket();
        newTicket.setCost(pricePerZone);
        newTicket.setRate(rate);
        newTicket.setStartStation(startStation);
        newTicket.setEndStation(endStation);
        newTicket.setIssueDate(new Date());

        String encodedTicket = TicketEncoderImpl.encodeTicket(newTicket);
        ticket = encodedTicket;
    } else if (endStation == startStation) {
        errorMessage = "start station cannot be the same as the destination station";
    }

%>
<!DOCTYPE html>
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
                    <td><input type="text" name="startStation" value="Abbey Road"></td>
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
                    <td><input type="text" name="endStation" value="Croxley"></td>     
                </tr>
                <tr>
                    <td>Credit Card:</td>
                    <td>
                        <input type="text" name="creditCard" value="0">

                    </td>
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