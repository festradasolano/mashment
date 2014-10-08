/**
 * 
 */
package net.mashment.drools.entities;

/**
 * @author festradasolano
 */
public class NetworkOperatingSystem {
	
	/**
	 * 
	 */
	private String ip;
	
	/**
	 * 
	 */
	private String port;
	
	/**
	 * 
	 */
	private String type;

	/**
	 * 
	 */
	public NetworkOperatingSystem() {
		super();
	}
	
	/**
	 * @param ip
	 * @param port
	 * @param type
	 */
	public NetworkOperatingSystem(String ip, String port, String type) {
		super();
		this.ip = ip;
		this.port = port;
		this.type = type;
	}

	/**
	 * @return the ip
	 */
	public String getIp() {
		return ip;
	}

	/**
	 * @param ip the ip to set
	 */
	public void setIp(String ip) {
		this.ip = ip;
	}

	/**
	 * @return the port
	 */
	public String getPort() {
		return port;
	}

	/**
	 * @param port the port to set
	 */
	public void setPort(String port) {
		this.port = port;
	}

	/**
	 * @return the type
	 */
	public String getType() {
		return type;
	}

	/**
	 * @param type the type to set
	 */
	public void setType(String type) {
		this.type = type;
	}

}
