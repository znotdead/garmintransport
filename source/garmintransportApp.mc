using Toybox.Application as App;

class garmintransportApp extends App.AppBase {

	hidden var mModel;
	hidden var mView;
	
    //! onStart() is called on application start up
    function onStart() {
    	mView = new TransportView();
    	mModel = new TransportModel(mView.method(:onTransport));
    }

    //! onStop() is called when your application is exiting
    function onStop() {
    }

    //! Return the initial view of your application here
    function getInitialView() {
        return [ mView ];
    }

}