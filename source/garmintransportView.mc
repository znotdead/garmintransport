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
	// To - coordinates of PI stop
	// From - coordinates of destination
	// buses
	var busToTsingYi = {:name => "To Tsing Yi",
						:position => [],
						:holidaytimetable => [000, 015, 030,
                                            100, 130, 200, 230, 300, 330, 400, 430, 500, 530,
                                            600, 615, 630, 640, 650,
                                            700, 710, 720, 730, 740, 750,
                                            800, 810, 820, 830, 840, 850,
                                            900, 906, 912, 918, 924, 930, 936, 942, 948, 954,
                                            1000, 1006, 1012, 1018, 1024, 1030, 1036, 1042, 1048, 1054,
                                            1100, 1105, 1110, 1115, 1120, 1125, 1130, 1135, 1140, 1145, 1150, 1155,
                                            1200, 1205, 1210, 1215, 1220, 1225, 1230, 1235, 1240, 1245, 1250, 1255,
                                            1300, 1306, 1312, 1318, 1324, 1330, 1336, 1342, 1348, 1354,
                                            1400, 1406, 1412, 1418, 1424, 1430, 1436, 1442, 1448, 1454,
                                            1500, 1506, 1512, 1518, 1524, 1530, 1536, 1542, 1548, 1554,
                                            1600, 1606, 1612, 1618, 1624, 1630, 1636, 1642, 1648, 1654,
                                            1700, 1705, 1710, 1715, 1720, 1725, 1730, 1735, 1740, 1745, 1750, 1755,
                                            1800, 1805, 1810, 1815, 1820, 1825, 1830, 1835, 1840, 1845, 1850, 1855,
                                            1900, 1906, 1912, 1918, 1924, 1930, 1936, 1942, 1948, 1954,
                                            2000, 2012, 2024, 2036, 2048,
                                            2100, 2112, 2124, 2136, 2148,
                                            2200, 2212, 2224, 2236, 2248,
                                            2300, 2315, 2330, 2345],
						:timetable => [000, 015, 030,
                                       100, 130, 200, 230, 300, 330, 400, 430, 500, 530,
                                       600, 615, 630, 635, 640, 645, 650, 655,
                                       700, 705, 710, 715, 720, 725, 730, 734, 738, 742, 746, 750, 754, 758,    
                                       802, 806, 810, 814, 818, 822, 826, 830, 835, 840, 845, 850, 855,
                                       900, 905, 910, 915, 920, 925, 930, 935, 940, 945, 950, 955, 
                                       1000, 1010, 1020, 1030, 1040, 1050, 
                                       1100, 1110, 1120, 1130, 1140, 1150, 
						               1200, 1210, 1220, 1230, 1240, 1250, 
                                       1300, 1310, 1320, 1330, 1340, 1350, 
                                       1400, 1410, 1420, 1430, 1440, 1450, 
                                       1500, 1510, 1520, 1530, 1540, 1550, 
                                       1600, 1610, 1620, 1630, 1636, 1642, 1648, 1654, 
                                       1700, 1706, 1712, 1718, 1724, 1730, 1736, 1742, 1748, 1754, 
                                       1800, 1806, 1812, 1818, 1824, 1830, 1836, 1842, 1848, 1854, 
                                       1900, 1906, 1912, 1918, 1924, 1930, 1936, 1942, 1948, 1954, 
                                       2000, 2012, 2024, 2036, 2048, 
                                       2100, 2112, 2124, 2136, 2148, 
                                       2200, 2212, 2224, 2236, 2248, 
                                       2300, 2315, 2330, 2345]};
    var busFromTsingYi = {:name => "From Tsing Yi",
                          :position => [],
						  :holidaytimetable => [000, 015, 030, 045, 
                                                115, 145, 215, 245, 315, 345, 415, 445, 515, 545, 
                                                615, 630, 640, 650,
                                                700, 710, 720, 730, 740, 750, 
                                                800, 810, 820, 830, 840, 850,
                                                900, 910, 920, 930, 940, 950, 
                                                1000, 1006, 1012, 1018, 1024, 1030, 1036, 1042, 1048, 1054,
                                                1100, 1105, 1110, 1115, 1120, 1125, 1130, 1135, 1140, 1145, 1150, 1155,
                                                1200, 1205, 1210, 1215, 1220, 1225, 1230, 1235, 1240, 1245, 1250, 1255,
                                                1300, 1306, 1312, 1318, 1324, 1330, 1336, 1342, 1348, 1354,
                                                1400, 1406, 1412, 1418, 1424, 1430, 1436, 1442, 1448, 1454,
                                                1500, 1506, 1512, 1518, 1524, 1530, 1536, 1542, 1548, 1554,
                                                1600, 1606, 1612, 1618, 1624, 1630, 1636, 1642, 1648, 1654,
                                                1700, 1705, 1710, 1715, 1720, 1725, 1730, 1735, 1740, 1745, 1750, 1755,
                                                1800, 1805, 1810, 1815, 1820, 1825, 1830, 1835, 1840, 1845, 1850, 1855,
                                                1900, 1906, 1912, 1918, 1924, 1930, 1936, 1942, 1948, 1954,
                                                2000, 2006, 2012, 2018, 2024, 2030, 2036, 2042, 2048, 2054,
                                                2100, 2106, 2112, 2118, 2124, 2130, 2136, 2142, 2148, 2154,
                                                2200, 2206, 2212, 2218, 2224, 2230, 2236, 2242, 2248, 2254,
                                                2300, 2306, 2312, 2318, 2324, 2330, 2340, 2350],
	    				  :timetable => [000, 015, 030, 045, 
                                         115, 145, 215, 245, 315, 345, 415, 445, 515, 545, 
                                         615, 630, 640, 650, 
                                         700, 710, 720, 730, 740, 750, 
                                         800, 810, 820, 830, 840, 850,
                                         900, 910, 920, 930, 940, 950, 
                                         1000, 1010, 1020, 1030, 1040, 1050, 
                                         1100, 1110, 1120, 1130, 1140, 1150, 
                                         1200, 1210, 1220, 1230, 1240, 1250, 
                                         1300, 1310, 1320, 1330, 1340, 1350, 
                                         1400, 1410, 1420, 1430, 1440, 1450, 1500, 1510, 1520, 1530, 1540, 1550, 
                                         1600, 1610, 1620, 1630, 1636, 1642, 1648, 1654, 
                                         1700, 1706, 1712, 1718, 1724, 1730, 1736, 1742, 1748, 1754, 
                                         1800, 1805, 1810, 1815, 1820, 1825, 1830, 1835, 1840, 1845, 1850, 1855, 
                                         1900, 1905, 1910, 1915, 1920, 1925, 1930, 1935, 1940, 1945, 1950, 1955, 
                                         2000, 2005, 2010, 2015, 2020, 2025, 2030, 2036, 2042, 2048, 2054, 
                                         2100, 2106, 2112, 2118, 2124, 2130, 2136, 2142, 2148, 2154, 
                                         2200, 2206, 2212, 2218, 2224, 2230, 2236, 2242, 2248, 2254, 
                                         2300, 2306, 2312, 2318, 2324, 2330, 2340, 2350]};
	
	var busTsuenWan = {:position => [], :holidaytimetable => [], :timetable => []};
	var busTsuenWanWest = {:position => [], :timetable => []};
	var busKwaiFong = {:position => [], :timetable => []};
	var busAirport = {:position => [], :timetable => []};
	// ferries
	var ferryToTsuenWanWest = {:name => "To Tsuen Wan",
							   :position => [],
							   :timetable => [1115, 1315, 1515]};

	var ferryFromTsuenWanWest = {:name => "From Tsuen Wan",
								 :position => [],
						  		 :timetable => [1145, 1345, 1545]};
								 
	var ferryToCentral = {:name => "To Central",
						  :position => [22.353919, 114.063980],
						  :holidaytimetable => [700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
						  						 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300],
						  :timetable => [630, 700, 715, 730, 745, 800, 815, 830, 845, 900, 915, 930,
										 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1730, 1800,
										 1830, 1900, 1930, 2000, 2030, 2100, 2200, 2300]};
						
	var ferryFromCentral = {:name => "From Central",
							:position => [22.288446, 114.156534],
							:holidaytimetable => [730, 830, 930, 1030, 1130, 1230, 1330, 1430, 1530,
												  1630, 1730, 1830, 1930, 2030, 2130, 2230, 2330],
							:timetable => [700, 730, 745, 800, 815, 830, 845, 900, 915, 930, 945,
										   1000, 1030, 1130, 1230, 1330, 1430, 1530, 1630, 1730,
										   1800, 1830, 1900, 1930, 2000, 2030, 2100, 2130, 2230, 2330]};
	
	
	//var stations = [busTsingYi, busTsuenWan, busTsuenWanWest, busKwaiFong, busAirport, ferryTsuenWanWest, ferryCentral];
	var stations = [ferryToCentral, ferryFromCentral, 
                    ferryToTsuenWanWest, ferryFromTsuenWanWest,
                    busToTsingYi, busFromTsingYi];
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
			for(var i=0; i < holidayDays.size(); i++)
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
 
 	function getNearestTime(currentTime, times)
 	{
		for (var t=0; t<times.size(); t++)
		{
			if (times[t] > currentTime.toNumber())
			{
				return times[t];
			}
		}
		return null;
 	
 	}
 	
 	function formatTimeForCompare(hour, min)
 	{
 		var format = "$1$$2$";
 		if (min < 10)
 		{
 			format = "$1$0$2$";
 		}
 		return format;
 	}
 	
 	function formatTime(t)
 	{
 		var hour;
 		var min;
 		var tStr = t.toString();
 		if (tStr.length() == 3)
 		{
	 		hour = tStr.substring(0, 1);
	 		min = tStr.substring(2, 3);
 			
 		} else
 		{
 			hour = tStr.substring(0, 2);
 			min = tStr.substring(2, 4);
 		}
 		return Lang.format("$1$:$2$", [hour, min]);
 	}
 
 	function getDepartureTimes(routes)
 	{
 	 		
 		// get now object
 		var now = Time.now();
 		var nowInfo = Gregorian.info(now, Time.FORMAT_LONG);

 		// check if today is Holiday or Public Holiday
		var isHoliday = isHoliday(now);

		// get list of departures times
		var times = {};
		for (var i=0; i<routes.size(); i++)
		{	
			// format current time for compare with timetable
			var n = Lang.format(formatTimeForCompare(nowInfo.hour, nowInfo.min), [nowInfo.hour, nowInfo.min]);
			var todaysTimetable;
			// get timetable for holiday or regular
			if (isHoliday == true && routes[i].hasKey(:holidaytimetable))
			{
				todaysTimetable = routes[i][:holidaytimetable];
			} else
			{
				todaysTimetable = routes[i][:timetable];
			}
			// take next departure
			var nextDeparture = getNearestTime(n, todaysTimetable);
			times.put(routes[i][:name], formatTime(nextDeparture));
		}
		
		return times;
 	}
 	
 	function formatDepartureTime(t)
 	{
 		// format departures time
 		var formatStr;
 		var result = "$1$\n$2$";
 		for (var i=0; i<t.size(); i++)
 		{
 			var route = t.keys()[i];
 			var time = t[route];
 			if (i < t.size()-1)
 			{
 				result = Lang.format(result, [Lang.format("$1$: $2$", [route, time]), "$1$\n$2$"]);
 			} else
 			{
 				result = Lang.format(result, [Lang.format("$1$: $2$", [route, time]), ""]);
 			}
 		}
		return result.substring(0, result.length()-1);
 	}
 
 	function onPosition(info)
 	{
 		var transport = new Transport();
 		transport.routes = getRoutes(info);
 		transport.departureTime = formatDepartureTime(getDepartureTimes(transport.routes));
 		
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
    	dc.drawText(width/2, lenght/2, Gfx.FONT_XTINY, mTransport, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

	function onTransport(transport) {
		var routeNames = [];
		for (var i=0; i<transport.routes.size(); i++)
		{
			var a;
			//TODO
			//routeNames.add(transport.routes[i][:name]);
		}
		
		mTransport = transport.departureTime;
		Ui.requestUpdate();
	}
}
