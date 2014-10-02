package util;
import java.util.Scanner;
import java.util.Vector;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class AStoIP {
	
	public static Vector<String> findIPRange(String as){
		String asn = as;
		Vector<String> resultsFound = new Vector<String>();
		String response = Conn.getResponse("http://www.potaroo.net/cgi-bin/as-report?as=as"+asn);
		String aux;
		Pattern p = Pattern.compile(">\\d*\\p{Punct}\\d*\\p{Punct}\\d*\\p{Punct}\\d*\\p{Punct}\\d*\\s*<");
		Matcher m;		
		int count = 0;
		m = p.matcher(response);
		while(m.find()){
			aux = m.group().replaceAll("\\s*", "").replaceAll("<|>", "");
			System.out.println(aux);
			resultsFound.add(aux);
			count++;
		}		
		
		/*
		while(s.hasNext()){
				m = p.matcher(aux);
				if (m.find()) {					
					aux = aux.replaceAll("class=\"\\w*\">", "");
					aux = aux.replaceAll("</.*>", "");
					aux = aux.replaceAll("as-report", "");
					System.out.println(aux);
					resultsFound.add(aux);
					count++;
				}	
				aux = s.next();
		}
		*/
		
		
		System.out.println(count);
		System.out.println("---");
		return resultsFound;		
		
	}
	
	public static void main(String args[]){
		Scanner s = new Scanner(System.in);
		String input;
		input = s.next();
		while(!input.equals("s")){
			findIPRange(input);
			input = s.next();
		}
		
	}

}
