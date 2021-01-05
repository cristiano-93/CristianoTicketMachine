# Ticket Machine Test Plan



# station/stationList/changeConfig test plan  CHANGE!!!!!!!

| 1 | getCurrentStation   | To get the current station from the ticket machine config; based on the provided UUID.                       | Gets the current station.                                      | null                                                       |
|---|---------------------|--------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------|------------------------------------------------------------|
| 2 | createStation       | Creates a new station.                                                                                       | Creates a new station with a UUID set as its name.             | Creates a new station with a UUID set as its name.         |
| 3 | createTicketMachine | Adds a new ticket machine to the station - associated to the station by the provided UUID.                   | Creates a new ticket machine for the station.                  | Creates a new ticket machine for the station.              |
| 4 | listStations        | List of all the stations created.                                                                            | Lists all stations.                                            | Lists all stations.                                        |
| 5 | listTicketMachines  | List all of the ticket machines associated with the station by the provided station UUID.                    | Lists all of the ticket machines for the selected station.     | Lists all of the ticket machines for the selected station. |
| 6 | updateStation       | Change the name of the station, by using the provided UUID for the station, and the new station name string. | Changes the name of the selected station.                      | Changes the name of the selected station.                  |
| 7 | deleteStation       | Delete the provided station by the provided UUID.                                                            | Deletes the selected station, and all of it's ticket machines. | error                                                      |
| 8 | deleteTicketMachine | Delete the ticket machine at the station, by the UUID of the station, and the UUID of the ticket machine.    | Deletes the selected ticket machine from the station.          | Deletes the selected ticket machine from the station.      |
| 9 | changeConfig        | Set the current ticketMachine to the one associated by the provided UUID                                     | The ticket machine is set to the selected one.                 | The ticket machine does not get set.                       |


# ticket machine test plan  CHANGE!!!!!!!!!!!!!!!

|#| Name|Purpose|Expected|Actual|
|---|---|---|---|---|
|1|getCurrentStationName|To get current station name from the ticket machine config based on corresponding uuid|It will get the correct station name and display it|Displays null value in current station|
|2|getCurrentStationNameFix|Display Station Name based on uuid instead of null value by correctly configuring ticket machine before|Display correct Station Name|Displays set Station Name|
|3|getCurrentStationZone|Get the corresponding station zone from the uuid that was set in ticket config|Displays the corresponding station Zone|Displays the correct station Zone|
|4|listDestinationZones|Creates a list of destination Zone buttons based on existing data|Creates and displays a list of buttons|Creates a list of destination zone buttons|
|5|selectDestinationZone|Click a destination zone button to change url with corresponding zone information|Adds the zone information to url|Adds the selected zone number to the url|
|6|stationListDropbox|Create a dropdown that is populated by all stations according to existing data|Creates a dropbox that lists stations|Creates a dropdown that lists stations|
|7|populateDropdown|When zone button is clicked, populate dropdown with corresponding zones|Correctly Populates Dropdown according to selected zone|Does not display the proper station according to zone|
|8|populateDropdown|Populate dropdown based on zone input through finding the station list values by zone value|Populates dropdown based on destination zone|Populates properly based on Zone input|
|9|creditCardCheckTrue|Compare and the input on the credit field to a regex pattern and see if valid|Return True if the entered value is correctly formatted|Returns True for inputted value|
|10|creditCardCheckFalse|Compare and the input on the credit field to a regex pattern and see if invalid|Return False if the entered value is incorrectly formatted|Returns False for inputted value|
|11|calculatePriceZones|Minus destination zone from starting zone|Produce a positive value to be used for calculation|Produced a positive or negative value depending on zones|
|12|calculatePriceZonesFix|Use an absolute to minus destination zone from starting zone|Produce a positive value to be used for calculation|Produced a positive value|
|13|calculatePriceTicket|Multiply zones travelled value by rate to get price|produces the proper price of a ticket|Produced appropriate ticket price|
|14|generateTicket|Produces a valid ticket to be used for ticketGate|Produces a ticket with all fields filled|Produces a valid ticket|


# -> gate.jsp test plan

|#|Name|Purpose|Expected|Actual|
|-|-|-|-|-|
|1|GetArrivalStation| Get the arrival station name from user input to then match the destination station on the ticket|get a valid station name and display it|displays the station name|
|2|GetArrivalStationError|get the arrival station name from user input, but the user has left the field blank OR with invalid station name|the station name will be invalid|Valid Station boolean will be false|
|3|DecodeTicket|get the ticket XML data from user and decode it to check if the Hash matches and the ticket is valid|display the ticket data|display ticket XML data|
|4|DecodeTicketError|get ticket data from user and change a letter in the ticket Hash|decoding will fail |gate remains closed as Hash doesnt match|
|5|ValidateDate|check the arrival time and check against the time the ticket was issued and check if its valid|get the current time and compare with ticket and if  valid, open the gate|display gate is open|
|6|ValidateDateNotValid|set the arrival time to more than 4 hours after the ticket issue date and check if valid|expected to fail because the arrival time is after the 4 hour limit for a ticket|display gate is locked| 
|7|ValidateStation|get the destination station from the ticket and check if it matches the arrival station|Stations match and boolean validStation is true|validStation is true|
|8|ValidateStationError|get the destination station from the ticket and set a different station as arrival station|Stations dont match and boolean validStation will remain false|validStation is false and gate will remain closed|
|9|OpenGate| check if the booleans validStation, validDate and validFormat are all true and open gate|booleans are all valid and gate will open|Gate opens|
|10|OpenGateError|one the booleans is false and gate will not open|gate will remain closed as not all booleans are valid|Gate remains closed|
