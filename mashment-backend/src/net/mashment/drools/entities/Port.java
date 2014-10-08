/**
 * 
 */
package net.mashment.drools.entities;

/**
 * @author felipe
 *
 */
public class Port {
	
	/**
	 * 
	 */
	private Switch sw;
	
	/**
	 * 
	 */
	private int number;
	
	/**
	 * 
	 */
	private long receivePackets;

	/**
	 * 
	 */
	private long transmitPackets;
	
	/**
	 * 
	 */
	public Port() {
		super();
	}
	
	public Port(Switch sw, int number, long receivePackets, long transmitPackets) {
		super();
		this.sw = sw;
		this.number = number;
		this.receivePackets = receivePackets;
		this.transmitPackets = transmitPackets;
	}

	/**
	 * @return the sw
	 */
	public Switch getSw() {
		return sw;
	}

	/**
	 * @param sw the sw to set
	 */
	public void setSw(Switch sw) {
		this.sw = sw;
	}

	/**
	 * @return the number
	 */
	public int getNumber() {
		return number;
	}

	/**
	 * @param number the number to set
	 */
	public void setNumber(int number) {
		this.number = number;
	}

	/**
	 * @return the receivePackets
	 */
	public long getReceivePackets() {
		return receivePackets;
	}

	/**
	 * @param receivePackets the receivePackets to set
	 */
	public void setReceivePackets(long receivePackets) {
		this.receivePackets = receivePackets;
	}

	/**
	 * @return the transmitPackets
	 */
	public long getTransmitPackets() {
		return transmitPackets;
	}

	/**
	 * @param transmitPackets the transmitPackets to set
	 */
	public void setTransmitPackets(long transmitPackets) {
		this.transmitPackets = transmitPackets;
	}

}
