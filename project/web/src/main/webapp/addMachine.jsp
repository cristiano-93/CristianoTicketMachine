<%-- 
    Document   : addMachine
    Created on : 26 Dec 2020, 18:24:28
    Author     : Cristiano Local
--%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.solent.com528.project.model.dao.TicketMachineDAO"%>
<%@page import="java.util.List"%>
<%@page import="org.solent.com528.project.model.dto.TicketMachine"%>
<%@page import="org.solent.com528.project.model.dto.Station"%>
<%@page import="org.solent.com528.project.impl.web.WebObjectFactory"%>
<%@page import="org.solent.com528.project.model.service.ServiceFacade"%>
<%@page import="org.solent.com528.project.model.dao.StationDAO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
    // used to place error message at top of page 
    String errorMessage = "";
    String message = "";

    // used to set html header autoload time. This automatically refreshes the page
    // Set refresh, autoload time every 20 seconds
    response.setIntHeader("Refresh", 20);

    // accessing service 
    ServiceFacade serviceFacade = (ServiceFacade) WebObjectFactory.getServiceFacade();
    StationDAO stationDAO = serviceFacade.getStationDAO();
    TicketMachineDAO ticketMachineDao = null;
    
    // accessing request parameters
    String actionStr = request.getParameter("action");
    String stationName = request.getParameter("stationName");
    
    // variables
    Long updateMachineId = null;
    StationDAO stationDao = null;
    Station station = null;
    
    
    List<TicketMachine> ticketMachineList = ticketMachineDAO.findByStationName(stationName);

     for (Integer i = 0; i < 10; i++) {
            TicketMachine t = new TicketMachine();
            t.setId(updateMachineId);
            t.setStation(station);
            t = ticketMachineDao.save(t);
            ticketMachineList.add(t);
        }
     
     
//  create one ticket machine per station
//        for(Station station: stationList){
//            dummyStation = stationDao.save(dummyStation);
//            TicketMachine exampleTicketMachine = new TicketMachine();
//            exampleTicketMachine.setStation(dummyStation);
//            ticketMachineDao.save(exampleTicketMachine);
    
// basic error checking before making a call
    //if (actionStr == null || actionStr.isEmpty()) {};
    
//    public void createStationsWithTicketMachinesTest() {
//        LOG.debug("start of createStationsWithTicketMachinesTest");
//
//        ticketMachineDao.deleteAll();
//        List<TicketMachine> testTicketMachineList = ticketMachineDao.findAll();
//        assertTrue(testTicketMachineList.isEmpty());
//
//        // this loads a list of stations to use in tests
//        // loads from model/src/test/resources on class path
//        // NOTE this should but does not load from a file saved in the model jar
//        URL res = getClass().getClassLoader().getResource("londonStations.xml");
//        String fileName = res.getPath();
//        System.out.println("loading from london underground fileName:   " + fileName);
//        StationDAOJaxbImpl stationDAOjaxb = new StationDAOJaxbImpl(fileName);
//        List<Station> dummyStationList = stationDAOjaxb.findAll();
//        
//        // create one ticket machine per station
//        for(Station dummyStation: dummyStationList){
//            dummyStation = stationDao.save(dummyStation);
//            TicketMachine exampleTicketMachine = new TicketMachine();
//            exampleTicketMachine.setStation(dummyStation);
//            ticketMachineDao.save(exampleTicketMachine);
//        }
//        
//        testTicketMachineList = ticketMachineDao.findAll();
//        assertEquals(dummyStationList.size(),testTicketMachineList.size());
//        
//        testTicketMachineList = ticketMachineDao.findByStationName("Acton Town");
//        assertEquals(1,testTicketMachineList.size());
//        assertTrue("Acton Town".equals(testTicketMachineList.get(0).getStation().getName()));
//        assertEquals(Integer.valueOf(3),testTicketMachineList.get(0).getStation().getZone());
//        
//
//        LOG.debug("end of createStationsWithTicketMachinesTest");
//    }
    
   
    
%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>New Machine</title>
    </head>
    <body>
        <h1>Generating a new ticket machine for station : <%=stationName%></h1>
        
        <form action="./station.jsp" method="get">
            <p>Machine ID: <input type="text" size="36" name="updateMachineId" value="">
                <button type="submit" >Update Machine ID</button>
            </p>
        </form>
        
        
        <p>List of all Machines: <%=ticketMachineList%></p>
        
        
        <form action="./stationList.jsp" method="get">
            <button type="submit" >Return to Station List</button>
        </form> 
        
        <form action="index.html">
            <input type="submit" value="Return to index page" />
        </form>
    </body>
</html>
