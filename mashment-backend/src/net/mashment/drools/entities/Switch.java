/**
 * 
 */
package net.mashment.drools.entities;

/**
 * @author festradasolano
 */
public class Switch {
	
	/**
	 * 
	 */
	private NetworkOperatingSystem nos;
	
	/**
	 * 
	 */
	private String dpid;

	/**
	 * 
	 */
	public Switch() {
		super();
	}
	
	/**
	 * @param nos
	 * @param id
	 */
	public Switch(NetworkOperatingSystem nos, String dpid) {
		super();
		this.nos = nos;
		this.dpid = dpid;
	}

	/**
	 * @return the nos
	 */
	public NetworkOperatingSystem getNos() {
		return nos;
	}

	/**
	 * @param nos the nos to set
	 */
	public void setNos(NetworkOperatingSystem nos) {
		this.nos = nos;
	}

	/**
	 * @return the dpid
	 */
	public String getDpid() {
		return dpid;
	}

	/**
	 * @param dpid the dpid to set
	 */
	public void setDpid(String dpid) {
		this.dpid = dpid;
	}

}
