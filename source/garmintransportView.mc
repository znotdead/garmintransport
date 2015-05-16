using Toybox.WatchUi as Ui;
using Toybox.Time;
using Toybox.System;
using Toybox.Graphics as Gfx;
using Toybox.Time.Gregorian;

class Transport
{
	var route;
	var departureTime;
}

class TransportModel
{
	hidden var notify;

	function initialize(handler)
	{
		Position.enableLocationEvents(Position.LOCATION_ONE_SHOT, method(:onPosition));
		notify = handler;
	}

 	function onPosition(info)
 	{
 		var latLon = info.position.toDegrees();
 		System.println(info);
 		var transport = new Transport();
 		transport.route = 1;
 		transport.departureTime = "12:00";
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
		System.println(transport);
		mTransport = Lang.format("Route: $1$ \n Departure: $2$", [transport.route, transport.departureTime]);
		Ui.requestUpdate();
	}
}