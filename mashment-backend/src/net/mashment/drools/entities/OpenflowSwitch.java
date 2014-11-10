/**
 * 
 */
package net.mashment.drools.entities;

/**
 * @author festradasolano
 */
public class OpenflowSwitch {

	/**
	 * 
	 */
	private OpenflowController openflowController;

	/**
	 * 
	 */
	private String dpid;

	/**
	 * 
	 */
	public OpenflowSwitch() {
		super();
	}

	/**
	 * @param openflowController
	 * @param dpid
	 */
	public OpenflowSwitch(OpenflowController openflowController, String dpid) {
		super();
		this.openflowController = openflowController;
		this.dpid = dpid;
	}

	/**
	 * @return
	 */
	public OpenflowController getOpenflowController() {
		return openflowController;
	}

	/**
	 * @param openflowController
	 */
	public void setOpenflowController(OpenflowController openflowController) {
		this.openflowController = openflowController;
	}

	/**
	 * @return the dpid
	 */
	public String getDpid() {
		return dpid;
	}

	/**
	 * @param dpid
	 *            the dpid to set
	 */
	public void setDpid(String dpid) {
		this.dpid = dpid;
	}

}
