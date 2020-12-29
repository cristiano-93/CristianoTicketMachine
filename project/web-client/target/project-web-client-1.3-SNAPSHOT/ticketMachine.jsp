<%-- 
    Document   : ticketMachine
    Created on : 13 Dec 2020, 16:20:47
    Author     : Cristiano Local
--%>

<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="org.solent.com528.project.model.dto.PaymentCalculator"%>
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
    String validFrom = request.getParameter("validFrom");
    String validTo = request.getParameter("validTo");
    String startStation = request.getParameter("startStation");
    String startZone = request.getParameter("startZone");
    String endZone = request.getParameter("endZone");
    String endStation = request.getParameter("endStation");
    String destination = request.getParameter("destinationStation");
    String creditCard = request.getParameter("creditCard");

    boolean validCard = false;

    ServiceFacade serviceFacade = (ServiceFacade) WebClientObjectFactory.getServiceFacade();
    String startStationName = WebClientObjectFactory.getStationName();
    Integer startStationZone = WebClientObjectFactory.getStationZone();
    PaymentCalculator payCalculator = new PaymentCalculator();

    //Service
    String errorMessage = "";
    StationDAO stationDAO = serviceFacade.getStationDAO();
    Set<Integer> zones = stationDAO.getAllZones();
    List<Station> stationsList = new ArrayList<Station>();
    String actionStr = request.getParameter("action");
    String zoneStr = request.getParameter("zone");
    
    stationsList = stationDAO.findAll();
    
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
    } // do nothing
    //    } else if ("XXX".equals(actionStr)) {
    //        // put your actions here } 
    else {
        errorMessage = "ERROR: page called for unknown action";
    }

    // checking if card number is valid
    try {
        long cardNumber = Long.parseLong(creditCard, 10);
        validCard = PaymentCalculator.validNumber(cardNumber);
    } catch (Exception e) {
        errorMessage += e + " check the card number";
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
     
    if(endStation == startStation){
            Ticket newTicket = new Ticket();
            newTicket.setCost(pricePerZone);
            newTicket.setStartStation(startStation);
            newTicket.setEndStation(endStation);
            newTicket.setIssueDate(new Date());
            newTicket.setRate(rate);   

            String encodedTicket = TicketEncoderImpl.encodeTicket(newTicket);
            ticket = encodedTicket;
    }
    else if(endStation != startStation){
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
                    <td><input type="text" name="startStation" value="_"></td>
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
                    <td><input type="text" name="endStation" value="-"></td>         
                <tr>
                    <td>Credit Card:</td>
                    <td>
                        <input type="text" name="creditCard" value="">
                       
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