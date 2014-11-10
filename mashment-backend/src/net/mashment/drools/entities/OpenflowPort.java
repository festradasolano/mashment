/**
 * 
 */
package net.mashment.drools.entities;

/**
 * @author festradasolano
 * 
 */
public class OpenflowPort {

	/**
	 * 
	 */
	private OpenflowSwitch openflowSwitch;

	/**
	 * 
	 */
	private String number;

	/**
	 * 
	 */
	private float percentReceivedDropped;

	/**
	 * 
	 */
	private float percentTransmittedDropped;

	/**
	 * 
	 */
	private float percentReceivedError;

	/**
	 * 
	 */
	private float percentTransmittedError;
	
	// FIXME to delete
	private long receivedPackets;

	/**
	 * 
	 */
	public OpenflowPort() {
		super();
	}

	/**
	 * @param openflowSwitch
	 * @param number
	 * @param percentReceivedDropped
	 * @param percentTransmittedDropped
	 * @param percentReceivedError
	 * @param percentTransmittedError
	 */
	public OpenflowPort(OpenflowSwitch openflowSwitch, String number,
			float percentReceivedDropped, float percentTransmittedDropped,
			float percentReceivedError, float percentTransmittedError) {
		super();
		this.openflowSwitch = openflowSwitch;
		this.number = number;
		this.percentReceivedDropped = percentReceivedDropped;
		this.percentTransmittedDropped = percentTransmittedDropped;
		this.percentReceivedError = percentReceivedError;
		this.percentTransmittedError = percentTransmittedError;
	}

	/**
	 * @return the openflowSwitch
	 */
	public OpenflowSwitch getOpenflowSwitch() {
		return openflowSwitch;
	}

	/**
	 * @param openflowSwitch
	 *            the openflowSwitch to set
	 */
	public void setOpenflowSwitch(OpenflowSwitch openflowSwitch) {
		this.openflowSwitch = openflowSwitch;
	}

	/**
	 * @return the number
	 */
	public String getNumber() {
		return number;
	}

	/**
	 * @param number
	 *            the number to set
	 */
	public void setNumber(String number) {
		this.number = number;
	}

	/**
	 * @return the percentReceivedDropped
	 */
	public float getPercentReceivedDropped() {
		return percentReceivedDropped;
	}

	/**
	 * @param percentReceivedDropped
	 *            the percentReceivedDropped to set
	 */
	public void setPercentReceivedDropped(float percentReceivedDropped) {
		this.percentReceivedDropped = percentReceivedDropped;
	}

	/**
	 * @return the percentTransmittedDropped
	 */
	public float getPercentTransmittedDropped() {
		return percentTransmittedDropped;
	}

	/**
	 * @param percentTransmittedDropped
	 *            the percentTransmittedDropped to set
	 */
	public void setPercentTransmittedDropped(float percentTransmittedDropped) {
		this.percentTransmittedDropped = percentTransmittedDropped;
	}

	/**
	 * @return the percentReceivedError
	 */
	public float getPercentReceivedError() {
		return percentReceivedError;
	}

	/**
	 * @param percentReceivedError
	 *            the percentReceivedError to set
	 */
	public void setPercentReceivedError(float percentReceivedError) {
		this.percentReceivedError = percentReceivedError;
	}

	/**
	 * @return the percentTransmittedError
	 */
	public float getPercentTransmittedError() {
		return percentTransmittedError;
	}

	/**
	 * @param percentTransmittedError
	 *            the percentTransmittedError to set
	 */
	public void setPercentTransmittedError(float percentTransmittedError) {
		this.percentTransmittedError = percentTransmittedError;
	}
	
	// FIXME 3 methods to delete

	public String toString() {
		OpenflowSwitch ofsw = this.openflowSwitch;
		return "Port = " + this.number + "; Switch = " + ofsw.getDpid()
				+ "; Controller = " + ofsw.getOpenflowController().getIp()
				+ ":" + ofsw.getOpenflowController().getPort();
	}

	/**
	 * @return the receivedPackets
	 */
	public long getReceivedPackets() {
		return receivedPackets;
	}

	/**
	 * @param receivedPackets the receivedPackets to set
	 */
	public void setReceivedPackets(long receivedPackets) {
		this.receivedPackets = receivedPackets;
	}

}
