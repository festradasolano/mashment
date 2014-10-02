/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;

/**
 * @author festradasolano
 * 
 */
public class NosPoxClient extends NosClient {

	/**
	 * Client to access web resources
	 */
	private Client client;

	/**
	 * Web resources base URI
	 */
	private static final String BASE_URI = "http://";

	private static final String BASE_REST_URI = "/web/jsonrest/";

	/**
	 * Constructor of NosPoxClient
	 */
	public NosPoxClient() {
		// Create client to access POX web resources
		ClientConfig clientConfig = new DefaultClientConfig();
		client = Client.create(clientConfig);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosDevices(java.lang.String, java.lang.String)
	 */
	public String getNosDevices(String nosIp, String nosPort)
			throws UniformInterfaceException {
		// Build web resource URI for devices connected to NOS switches
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("host_tracker").path("devices");
		// Return devices connected to NOS switches
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosDiscoveredLinks(java.lang.String,
	 * java.lang.String)
	 */
	public String getNosDiscoveredLinks(String nosIp, String nosPort)
			throws UniformInterfaceException {
		// Build web resource URI for links between NOS switches
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("discovery").path("links");
		// Return links between NOS switches
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosInformation(java.lang.String, java.lang.String)
	 */
	public String getNosInformation(String nosIp, String nosPort)
			throws UniformInterfaceException {
		// Build web resource URI for NOS information
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("controller").path("info");
		// Return NOS information
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosSwitches(java.lang.String)
	 */
	public String getNosSwitches(String nosIp, String nosPort)
			throws UniformInterfaceException {
		// Build web resource URI for switches connected to NOS
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("switches");
		// Return switches connected to NOS
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosSwitchFlows(java.lang.String, java.lang.String,
	 * java.lang.String)
	 */
	@Override
	public String getNosSwitchFlows(String nosIp, String nosPort, String swId)
			throws UniformInterfaceException {
		// Build web resource URI for flows from switch
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("switch").path(swId)
				.path("flows");
		// Return flows from switch
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosSwitchPorts(java.lang.String, java.lang.String,
	 * java.lang.String)
	 */
	@Override
	public String getNosSwitchPorts(String nosIp, String nosPort, String swId)
			throws UniformInterfaceException {
		// Build web resource URI for ports from switch
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("switch").path(swId)
				.path("ports");
		// Return ports from switch
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosSwitchPortStatsLogs(java.lang.String,
	 * java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public String getNosSwitchPortStatsLogs(String nosIp, String nosPort,
			String swId, String lastLogs) throws UniformInterfaceException {
		// Build web resource URI for port statistics from switch
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("switch").path(swId)
				.path("ffrecord").path("aggports").path(lastLogs);
		// Return port statistics from switch
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosSwitchTables(java.lang.String,
	 * java.lang.String, java.lang.String)
	 */
	@Override
	public String getNosSwitchTables(String nosIp, String nosPort, String swId)
			throws UniformInterfaceException {
		// Build web resource URI for tables from switch
		String uri = BASE_URI + nosIp + ":" + nosPort + BASE_REST_URI;
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("of").path("switch").path(swId)
				.path("tables");
		// Return tables from switch
		return webResource.accept(MediaType.APPLICATION_JSON).get(String.class);
	}

	public void close() {
		client.destroy();
	}

}
