using Toybox.WatchUi as Ui;
using Toybox.Time;
using Toybox.System;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian;

class Transport
{
	var route;
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
						:position => [22.351323, 114.059387],
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
                          :position => [22.358435, 114.107290],
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
	
	var busToTsuenWanWest = {:name => "To TW West",
                             :position => [22.351297, 114.059446],
                             :holidaytimetable => [645, 715, 745, 815, 845, 915, 945, 1015, 1045, 1115, 1145, 1215, 
                                                   1245, 1315, 1345, 1415, 1445, 1515, 1545, 1615, 1645, 1715, 1745, 
                                                   1815, 1845, 1915, 1945, 2015, 2045, 2115, 2215],
                             :timetable => [645, 715, 745, 815, 845, 915, 1015, 1115, 1215, 1315, 1415,
                                            1515, 1615, 1715, 1745, 1815, 1845, 1915, 1945, 2015, 2115, 2215]};
	var busFromTsuenWanWest = {:name => "From TW West",
                               :position => [22.368396, 114.112106],
                               :holidaytimetable => [710, 740, 810, 840, 910, 940, 1010, 1040, 1110, 1140, 1210,
                                                     1240, 1310, 1340, 1410, 1440, 1510, 1540, 1610, 1640, 1710,
                                                     1740, 1810, 1840, 1910, 1940, 2010, 2040, 2110, 2140, 2240],
                               :timetable => [710, 740, 810, 840, 910, 940, 1040, 1140, 1240, 1340, 1440,
                                              1540, 1640, 1740, 1810, 1840, 1910, 1940, 2010, 2040, 2140, 2240]};

	var busToTsuenWan = {:name => "To Tsuen Wan",
                         :position => [22.351297, 114.059446],
                         :holidaytimetable => [000, 600, 630, 700, 730, 800, 830, 900, 920, 940, 1000, 1020, 1040,
                                               1100, 1120, 1140, 1200, 1220, 1240, 1300, 1320, 1340, 1400, 1420, 1440,
                                               1500, 1520, 1540, 1600, 1620, 1640, 1700, 1720, 1740, 1800, 1820, 1840,
                                               1900, 1930, 2000, 2030, 2100, 2130, 2200, 2230, 2300, 2330],
                         :timetable => [000, 600, 630, 700, 720, 740, 800, 820, 840, 900, 930, 1000, 1030, 1100, 1130,
                                        1200, 1230, 1300, 1330, 1400, 1430, 1500, 1530, 1600, 1630, 1700, 1720, 1740,
                                        1800, 1820, 1840, 1900, 1920, 1940, 2000, 2030, 2100, 2130, 2200, 2230, 2300, 2330]};
    var busFromTsuenWan = {:name => "From Tsuen Wan",
                           :position => [22.372861, 114.118959],
                           :holidaytimetable => [020, 620, 650, 720, 750, 820, 850, 920, 940, 1000, 1020, 1040, 1100, 1120,
                                                 1140, 1200, 1220, 1240, 1300, 1320, 1340, 1400, 1420, 1440, 1500, 1520,
                                                 1540, 1600, 1620, 1640, 1700, 1720, 1740, 1800, 1820, 1840, 1900, 1920,
                                                 1950, 2020, 2050, 2120, 2150, 2220, 2250, 2320, 2350],
                           :timetable => [020, 620, 650, 720, 740, 800, 820, 840, 900, 920, 950, 1020, 1050, 1120, 1150,
                                          1220, 1250, 1320, 1350, 1420, 1450, 1520, 1550, 1620, 1650, 1720, 1740, 1800,
                                          1820, 1840, 1900, 1920, 1940, 2000, 2020, 2050, 2120, 2150, 2220, 2250, 2320, 2350]};

	var busToKwaiFong = {:name => "To KwaiFong",
                         :position => [22.351575, 114.059567],
                         :holidaytimetable => [000, 015, 045, 115, 145, 215, 245, 315, 345, 415, 445,515, 545,
                                               600, 615, 630, 640, 650, 700, 710, 720, 730, 740, 750,
                                               800, 810, 820, 830, 840, 850, 900, 910, 920, 930, 945,
                                               1000, 1012, 1024, 1036, 1048, 1100, 1112, 1124, 1136, 1148,
                                               1200, 1212, 1224, 1236, 1248, 1300, 1312, 1324, 1336, 1348,
                                               1400, 1412, 1424, 1436, 1448, 1500, 1512, 1524, 1536, 1548,
                                               1600, 1612, 1624, 1636, 1648, 1700, 1710, 1720, 1730, 1740, 1750,
                                               1800, 1810, 1820, 1820, 1830, 1840, 1850, 1900, 1912, 1924, 1936, 1948,
                                               2000, 2012, 2024, 2036, 2048, 2100, 2112, 2124, 2136, 2148,
                                               2200, 2212, 2224, 2236, 2248, 2300, 2315, 2330, 234],
                         :timetable => [000, 015, 045, 115, 145, 215, 245, 315, 345, 415, 445,515, 545,
                                        600, 615, 630, 640, 650, 700, 710, 720, 730, 738, 746, 754,
                                        802, 810, 818, 826, 834, 842, 850, 900, 910, 920, 930, 940, 950,
                                        1000, 1012, 1024, 1036, 1048, 1100, 1112, 1124, 1136, 1148,
                                        1200, 1212, 1224, 1236, 1248, 1300, 1312, 1324, 1336, 1348,
                                        1400, 1412, 1424, 1436, 1448, 1500, 1512, 1524, 1536, 1548,
                                        1600, 1612, 1624, 1636, 1648, 1700, 1710, 1720, 1730, 1740, 1750,
                                        1800, 1810, 1820, 1830, 1840, 1850, 1900, 1912, 1924, 1936, 1948,
                                        2000, 2012, 2024, 2036, 2048, 2100, 2112, 2124, 2136, 2148,
                                        2200, 2212, 2224, 2236, 2248, 2300, 2315, 2330, 2345]};
	var busFromKwaiFong = {:name => "From KwaiFong",
                           :position => [22.357076, 114.126444],
                           :holidaytimetable => [000, 030, 100, 130, 200, 230, 300, 330, 400, 430, 500, 530,
                                                 600, 620, 635, 645, 655, 705, 715, 725, 735, 745, 755,
                                                 805, 815, 825, 835, 845, 855, 905, 915, 925, 935, 945,
                                                 1000, 1012, 1024, 1036, 1048, 1100, 1112, 1124, 1136, 1148,
                                                 1200, 1212, 1224, 1236, 1248, 1300, 1312, 1324, 1336, 1348,
                                                 1400, 1412, 1424, 1436, 1448, 1500, 1512, 1524, 1536, 1548,
                                                 1600, 1612, 1624, 1636, 1648, 1700, 1710, 1720, 1730, 1740, 1750,
                                                 1800, 1810, 1820, 1830, 1838, 1846, 1854,
                                                 1902, 1910, 1918, 1926, 1934, 1942, 1950, 1958,
                                                 2006, 2014, 2022, 2030, 2038, 2046, 2054,
                                                 2102, 2110, 2118, 2126, 2134, 2142, 2150, 2158,
                                                 2206, 2214, 2222, 2230, 2238, 2246, 2254, 2302, 2315, 2330, 2345],
                           :timetable => [000, 030, 100, 130, 200, 230, 300, 330, 400, 430, 500, 530,
                                          600, 620, 635, 645, 655, 705, 715, 725, 735, 745, 755,
                                          805, 815, 825, 835, 845, 855, 905, 915, 925, 935, 945,
                                          1000, 1012, 1024, 1036, 1048, 1100, 1112, 1124, 1136, 1148,
                                          1200, 1212, 1224, 1236, 1248, 1300, 1312, 1324, 1336, 1348,
                                          1400, 1412, 1424, 1436, 1448, 1500, 1512, 1524, 1536, 1548,
                                          1600, 1612, 1624, 1636, 1648, 1700, 1710, 1720, 1730, 1740, 1750, 1758,
                                          1806, 1814, 1822, 1830, 1838, 1846, 1854,
                                          1902, 1910, 1918, 1926, 1934, 1942, 1950, 1958,
                                          2006, 2014, 2022, 2030, 2038, 2046, 2054,
                                          2102, 2110, 2118, 2126, 2134, 2142, 2150, 2158,
                                          2206, 2214, 2222, 2230, 2238, 2246, 2254, 2302, 2315, 2330, 2345]};

	var busToAirport = {:name => "To Airport",
                        :position => [22.351297, 114.059446],
                        :timetable => [000, 600, 630, 700, 730, 800, 830, 900, 930, 1000, 1030, 1100, 1130,
                                       1200, 1230, 1300, 1330, 1400, 1430, 1500, 1530, 1600, 1630, 1700, 1730,
                                       1800, 1830, 1900, 1930, 2000, 2030, 2100, 2130, 2200, 2230, 2300, 2330]};
	var busFromAirport = {:name => "From Airport",
                          :position => [22.316235, 113.937259],
                          :timetable => [000, 030, 630, 700, 730, 800, 830, 900, 930, 1000, 1030, 1100, 1130, 1200,
                                         1230, 1300, 1330, 1400, 1430, 1500, 1530, 1600, 1630, 1700, 1730, 1800, 1830,
                                         1900, 1930, 2000, 2030, 2100, 2130, 2200, 2230, 2300, 2330]};

	// ferries
	var ferryToTsuenWanWest = {:name => "Ferry To Tsuen Wan",
							   :position => [22.352870, 114.064371],
							   :timetable => [1115, 1315, 1515]};

	var ferryFromTsuenWanWest = {:name => "Ferry From Tsuen Wan",
								 :position => [22.366719, 114.110642],
						  		 :timetable => [1145, 1345, 1545]};
								 
	var ferryToCentral = {:name => "Ferry To Central",
						  :position => [22.352870, 114.064371],
						  :holidaytimetable => [700, 800, 900, 1000, 1100, 1200, 1300, 1400, 1500,
						  						 1600, 1700, 1800, 1900, 2000, 2100, 2200, 2300],
						  :timetable => [630, 700, 715, 730, 745, 800, 815, 830, 845, 900, 915, 930,
										 1000, 1100, 1200, 1300, 1400, 1500, 1600, 1700, 1730, 1800,
										 1830, 1900, 1930, 2000, 2030, 2100, 2200, 2300]};
						
	var ferryFromCentral = {:name => "Ferry From Central",
							:position => [22.288608, 114.156656],
							:holidaytimetable => [730, 830, 930, 1030, 1130, 1230, 1330, 1430, 1530,
												  1630, 1730, 1830, 1930, 2030, 2130, 2230, 2330],
							:timetable => [700, 730, 745, 800, 815, 830, 845, 900, 915, 930, 945,
										   1000, 1030, 1130, 1230, 1330, 1430, 1530, 1630, 1730,
										   1800, 1830, 1900, 1930, 2000, 2030, 2100, 2130, 2230, 2330]};
	
	
	var stations = [ferryToCentral, ferryFromCentral, 
                    ferryToTsuenWanWest, ferryFromTsuenWanWest,
                    busToTsingYi, busFromTsingYi,
                    busToTsuenWanWest, busFromTsuenWanWest,
                    busToTsuenWan, busFromTsuenWan,
                    busToKwaiFong, busFromKwaiFong,
                    busToAirport, busFromAirport];
}


class TransportModel
{
	hidden var notify;
	hidden var timetable = new Timetable();

	function initialize(handler) {
		Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
		notify = handler;
	}

    function rad(x) {
        var PIx = 3.141592653589793;
        return x * PIx / 180;
    }
	function getDistance(lat1, lon1, lat2, lon2) {
		var R = 6378.16; //km
        var dlon = rad(lon2 - lon1);
        var dlat = rad(lat2 - lat1);
        var a = (Math.sin(dlat/2) * Math.sin(dlat/2)) + Math.cos(rad(lat1)) * Math.cos(rad(lat2)) * (Math.sin(dlon/2) * Math.sin(dlon/2));
        var angle = 2 * Math.atan(Math.sqrt(a), Math.sqrt(1 - a));
        return angle * R;
	}

	function isHoliday(now) {
		var isHoliday = false;
		var nowInfo = Gregorian.info(now, Time.FORMAT_SHORT);

		// check Sat and Sun
		var dayOfWeekStr = nowInfo.day_of_week.toString();
		if (dayOfWeekStr.equals("1") || dayOfWeekStr.equals("7"))
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
 
 	function getRoutes(info) {
 		// get current position
 		var latLon = info.position.toDegrees();
 		//latLon = [22.288608, 114.156656];

		// sort stations by distance
		var stations = {};
 		for (var i=0; i<timetable.stations.size(); i++)
 		{
 			var station = timetable.stations[i][:position];
 			var distance = getDistance(latLon[0], latLon[1], station[0], station[1]);

 			stations.put(timetable.stations[i][:name], distance);
 		}
 		
 		for (var i=0; i<timetable.stations.size(); i++)
 		{
 			for (var j=0; j<timetable.stations.size() - 1; j++)
 			{
 				if (stations.get(timetable.stations[j][:name]) > stations.get(timetable.stations[j+1][:name]))
 				{
 					var temp = timetable.stations[j+1];
 					timetable.stations[j+1] = timetable.stations[j];
 					timetable.stations[j] = temp;
 				}
 			}
 		}
		return timetable.stations;
 	}
 
 	function getNearestTime(currentTime, times) {
		var departures = [null, null, null];
		for (var t=0; t<times.size(); t++)
		{
			// find next time
			if (times[t] > currentTime.toNumber())
			{
				departures[1] = formatTime(times[t]);
				// find previous time
				if (t != 0)
				{
					departures[0] = formatTime(times[t-1]);
				}
				// find next after nearest time
				if (t != times.size() - 1)
				{
					departures[2] = formatTime(times[t+1]);
				}
				return departures;
			}
		}
		departures[0] = formatTime(times[times.size()-1]);
		departures[1] = "Last";
		return departures;
 	}
 	
 	function formatTimeForCompare(hour, min) {
 		var format = "$1$$2$";
 		if (min < 10)
 		{
 			format = "$1$0$2$";
 		}
 		return format;
 	}
 	
 	function formatTime(t) {
 		var hour;
 		var min;
 		if (t == "")
 		{
 			return "Last";
 		} else 
 		{
 			var tStr = t.toString();
 			if (tStr.length() == 3)
 			{
		 		hour = tStr.substring(0, 1);
		 		min = tStr.substring(1, 3);
 			
 			} else
 			{
 				hour = tStr.substring(0, 2);
 				min = tStr.substring(2, 4);
 			}
 			var now = Time.now();
 			var nowInfo = Gregorian.info(now, Time.FORMAT_LONG);
 			var n = Lang.format(formatTimeForCompare(nowInfo.hour, nowInfo.min), [nowInfo.hour, nowInfo.min]);
 			var delta = t.toNumber() - n.toNumber();
 			return Lang.format("$1$:$2$ ($3$ min)", [hour, min, delta.toString()]);
 		}
 	}
 
 	function getDepartureTimes(route) {
 	 		
 		// get now object
 		var now = Time.now();
 		var nowInfo = Gregorian.info(now, Time.FORMAT_LONG);

 		// check if today is Holiday or Public Holiday
		var isHoliday = isHoliday(now);

		// get list of departures times
		var times = {};
		// format current time for compare with timetable
		var n = Lang.format(formatTimeForCompare(nowInfo.hour, nowInfo.min), [nowInfo.hour, nowInfo.min]);
		
		var todaysTimetable;
		// get timetable for holiday or regular
		if (isHoliday == true && route.hasKey(:holidaytimetable))
		{
			todaysTimetable = route[:holidaytimetable];
		} else {
			todaysTimetable = route[:timetable];
		}
		// take next departure
		var departures = getNearestTime(n, todaysTimetable);
		return departures;
 	}
 	
 	function onPosition(info) {
 		var transport = new Transport();
 		transport.routes = getRoutes(info);  // sorted routes
 		transport.route = transport.routes[p]; // show one route on page
 		transport.departureTime = getDepartureTimes(transport.route);
 		
 		// update widget
		notify.invoke(transport);
  	}
}

var p = 0;
class BaseInputDelegate extends Ui.BehaviorDelegate {

    function onKey(evt){
        if (evt.getKey() == WatchUi.KEY_ENTER)
        {
		    if (p == 13) {
		    	p = 0;
		    } else {
		    	p = p + 1;
		    }
		    Ui.requestUpdate();
        }
    }
}

class TransportView extends Ui.View {

	hidden var mModel;
	hidden var mTransport = "";
	hidden var prevDeparture = "";
	hidden var nearestDeparture = "";
	hidden var nextAfterNearestDeparture = "";
	
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
    	dc.drawText(width/2, lenght/5, Gfx.FONT_MEDIUM, mTransport, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.drawText(width/2, lenght/5 * 2, Gfx.FONT_TINY, prevDeparture, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.drawText(width/2, lenght/5 * 3, Gfx.FONT_MEDIUM, nearestDeparture, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    	dc.drawText(width/2, lenght/5 * 4, Gfx.FONT_TINY, nextAfterNearestDeparture, Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER);
    }

    //! Called when this View is removed from the screen. Save the
    //! state of your app here.
    function onHide() {
    }

	function onTransport(transport) {
		mTransport = transport.route[:name];
		prevDeparture = Lang.format("Previous: $1$", [transport.departureTime[0]]);
		nearestDeparture = Lang.format("NOW: $1$", [transport.departureTime[1]]);
		if (transport.departureTime[2] == null)
		{
			nextAfterNearestDeparture = "";
		} else {
			nextAfterNearestDeparture = Lang.format("Next: $1$", [transport.departureTime[2]]);
		}
		
		Ui.requestUpdate();
	}
}
