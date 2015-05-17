using Toybox.WatchUi as Ui;
using Toybox.Time;
using Toybox.System;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian;

class Transport
{
	var routes;
	var departureTime;
}


class Timetable
{
	// PH for 2016
	//var publicHolidays = {1 => [1], 2 => [8, 9, 10], 3 => [25, 26, 28],
	//					  4 => [4], 5 => [2, 14], 6 => [9], 7 => [1], 9 => [16],
	//					  10 => [1, 10], 12 => [26, 27]};
	// PH for 2015
	var publicHolidays = {1 => [1], 2 => [19, 20, 21], 4 => [3, 4, 6, 7],
						  5 => [1, 25], 6 => [20], 7 => [1], 9 => [28],
						  10 => [1, 21], 12 => [25, 26]};
	// positionTo - coordinates of PI stop
	// positionFrom - coordinates of destination
	// buses
	var busTsingYi = {:position => [], :timetable => []};
	var busTsuenWan = {:position => [], :timetable => []};
	var busTsuenWanWest = {:position => [], :timetable => []};
	var busKwaiFong = {:position => [], :timetable => []};
	var busAirport = {:position => [], :timetable => []};
	// ferries
	var ferryTsuenWanWest = {:name => "Tsuen Wan",
							 :positionTo => [],
							 :positionFrom => [],
							 :timetableTo => [1115, 1315, 1515],
							 :timetableFrom => [1145, 1345, 1545]};
	var ferryCentral = {:name => "Central",
						:positionTo => [22.353919, 114.063980],
						:positionFrom => [22.288446, 114.156534],
						:timetableTo => [630, 700, 715, 730, 745, 800, 815, 830, 845, 900, 915, 930,
										 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1730, 1800,
										 1830, 1900, 1930, 2000, 2030, 2100, 2200, 2300],
						:timetableFrom => [700, 730, 745, 800, 815, 830, 845, 900, 915, 930, 945,
										   1000, 1030, 1130, 1230, 1330, 1430, 1530, 1630, 1730,
										   1800, 1830, 1900, 1930, 2000, 2030, 2100, 2130, 2230, 2330]};
	
	//var stations = [busTsingYi, busTsuenWan, busTsuenWanWest, busKwaiFong, busAirport, ferryTsuenWanWest, ferryCentral];
	var stations = [ferryTsuenWanWest, ferryCentral];
}


class TransportModel
{
	hidden var notify;
	hidden var timetable = new Timetable();

	function initialize(handler)
	{
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
		notify = handler;
	}

	function distance(lat1, lon1, lat2, lon2)
	{
		var R = 6371;
		var distance = Math.acos(Math.sin(lat1)*Math.sin(lat2)+ Math.cos(lat1)*Math.cos(lat2)*Math.cos(lon2-lon1)) * R;
		return Math.abs(distance);
	}

	function getNearestStations(lat, lon)
	{
	}

	function isHoliday(now)
	{
		var isHoliday = false;
		var nowInfo = Gregorian.info(now, Time.FORMAT_SHORT);

		// check Sat and Sun
		var dayOfWeekStr = nowInfo.day_of_week.toString();
		if (dayOfWeekStr.equals("Sun") || dayOfWeekStr.equals("Sat"))
		{
 			isHoliday = true;
		}
		
		// check PH		
		var holidayDays = timetable.publicHolidays[nowInfo.month];
		if (holidayDays)
		{
			for(var i=0; i < holidayDays.size()-1; i++)
			{
				if (nowInfo.day.equals(holidayDays[i]))
				{
					isHoliday = true;
				}
			}
		}
 		return isHoliday;
 	}
 
 	function getRoutes(info)
 	{
 		// get current position (TODO)
 		var latLon = info.position.toDegrees();
 		System.println(latLon);
 		var latitude = latLon[0];
 		var longitude = latLon[1];
 		
		// get nearest routes (TODO)
 		
 		return timetable.stations;
 	}
 	
 	function getDepartureTimes(routes)
 	{
 	 		
 		// get now object
 		var now = Time.now();
 		var nowInfo = Gregorian.info(now, Time.FORMAT_LONG);

 		// check if today is Holiday or Public Holiday
		var isHoliday = isHoliday(now);

		// get list of departures times (TODO)

		// take next 2 departures (TODO)

		// calculate remaining time for next departures (TODO)

 		// format departures time (TODO: make possible to view many routes)
		var departureTime = Lang.format("$1$:$2$", [nowInfo.hour, nowInfo.min]);
		return departureTime;
 	}
 
 	function onPosition(info)
 	{
 		var transport = new Transport();
 		transport.routes = getRoutes(info);
 		transport.departureTime = getDepartureTimes(transport.routes);
 		
 		// update widget
		notify.invoke(transport);
  	}
}


class TransportView extends Ui.View {

	hidden var mModel;
	hidden var mTransport = "";
	
    //! Load your resources here
    function onLayout(dc) {
    	mTransport = "Waiting for GPS";
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Restore the state of the app and prepare the view to be shown
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
		dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_WHITE);
		dc.clear();
        //View.onUpdate(dc);

		var width = dc.getWidth();
		var lenght = dc.getHeight();
		
    	//var now = Time.now();
    	//var info = Gregorian.info(now, Time.FORMAT_LONG);
    	
    	//var dateStr = Lang.format("$1$ $2$ $3$", [info.day_of_week, info.month, info.day]);
    	dc.drawText(width/2, lenght/2, Gfx.FONT_MEDIUM, mTransport, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

	function onTransport(transport) {
		var routeNames = [];
		for (var i=0; i<transport.routes.size()-1; i++)
		{
			//TODO
			//routeNames.add(transport.routes[i][:name]);
		}
		
		mTransport = Lang.format("Route: $1$ \n Departure: $2$", [transport.routes, transport.departureTime]);
		Ui.requestUpdate();
	}
}