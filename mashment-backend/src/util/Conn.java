package util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class Conn {
	
	public static String getResponse(String link) {
		
		try {
				
			URL url = new URL(link);
			
			HttpURLConnection connection = (HttpURLConnection) url.openConnection();
			
			connection.setRequestProperty("Request-Method",    "GET");
			
			connection.setDoInput(true);
			
			connection.setDoOutput(false);
			
			connection.connect();
			
			BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
			
			StringBuffer newData = new StringBuffer(10000);
			
			String s = "";
			
			while (null != ((s = br.readLine()))) {
				
				newData.append(s+"\n");
				
			}
			
			br.close();
			
			return new String(newData);
			
		} catch (Exception e) {
			return null;
		}
		
	}

}
