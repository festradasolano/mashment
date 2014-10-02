package core;
import java.rmi.RemoteException;

import javax.xml.rpc.ServiceException;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;

public class WebServiceClient {

    public static String callService(String endpoint, String operation,
	    Object[] params) throws ServiceException, RemoteException {

	Call call = (Call) new Service().createCall();
	call.setTargetEndpointAddress(endpoint);
	call.setOperationName(operation);
	Object response = call.invoke(params);
	String result = "[";
	if (response instanceof String)
	    result += (String) response;
	else {
	    String[] responseArray = (String[]) response;
	    for (int i = 0; i < responseArray.length; i++) {
		result += responseArray[i];
		if (i<(responseArray.length-1)) result+=",";
	    }
	}
	result += "]" ;
	
	return result;
    }

    public static void main(String args[]) throws RemoteException,
	    ServiceException {
	/*
	String[] OIDs = { "1.3.6.1.2.1.15.3.1.9.200.19.246.244"};
	Object[] params = { OIDs,
		"200.132.0.1", "esr-rnp" };

	System.out.println(WebServiceClient.callService(
		"http://localhost:8080/axis/SNMPWrapper.jws", "getBulk", params));
	*/
	
	
	
	
	String[] ip = {"200.132.0.1", "www.google.com" };
	Object[] params = new Object[1];
	params[0] = ip;
	
	System.out.println(WebServiceClient.callService("http://localhost:8080/axis/Geolocator.jws", "getResult", params));
    }

}
