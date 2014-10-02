/**
 * 
 */
package util;

import com.sun.jersey.api.client.UniformInterfaceException;

/**
 * @author festradasolano
 * 
 */
public abstract class NosClient {

	/**
	 * @param nosIp
	 * @param nosPort
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosDevices(String nosIp, String nosPort)
			throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosDiscoveredLinks(String nosIp, String nosPort)
			throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosInformation(String nosIp, String nosPort)
			throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosSwitches(String nosIp, String nosPort)
			throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @param swId
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosSwitchFlows(String nosIp, String nosPort,
			String swId) throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @param swId
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosSwitchPorts(String nosIp, String nosPort,
			String swId) throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @param swId
	 * @param lastLogs
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosSwitchPortStatsLogs(String nosIp,
			String nosPort, String swId, String lastLogs)
			throws UniformInterfaceException;

	/**
	 * @param nosIp
	 * @param nosPort
	 * @param swId
	 * @return
	 * @throws UniformInterfaceException
	 */
	public abstract String getNosSwitchTables(String nosIp, String nosPort,
			String swId) throws UniformInterfaceException;

}
