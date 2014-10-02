package util;

import java.net.InetAddress;
import java.net.UnknownHostException;

/**
 * This class encapsulates static configurations, mostly related to the installation of the NMMS. 
 * @author RafaelSBZ
 *
 */
public class Configuration {
    
    public static String getLocalhost(){
	try {
	    return InetAddress.getLocalHost().getHostAddress();
	} catch (UnknownHostException e) {
	    return "";
	}
    }
    
    
    public static void main(String args[]){
	System.out.println(Configuration.getLocalhost());
    }
}
