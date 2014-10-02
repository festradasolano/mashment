/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import javax.ws.rs.core.MediaType;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;

/**
 * @author festradasolano
 * 
 */
public class NosFloodlightClient extends NosClient {

	/**
	 * Client to access web resources
	 */
	private Client client;

	/**
	 * Web resources base URI
	 */
	private static final String BASE_URI = "http://";

	/**
	 * Constructor of NosFloodlightClient
	 */
	public NosFloodlightClient() {
		// Create client to access Floodlight web resources
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
		try {
			// Build web resource URI for devices connected to NOS switches
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/device/";
			WebResource webResource = client.resource(uri);
			// Get devices connected to NOS switches (non-system format)
			JSONArray jsonArrayDeviceTemp = new JSONArray(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class));
			// Parse devices to system format
			JSONArray jsonArrayDevice = new JSONArray();
			for (int i = 0; i < jsonArrayDeviceTemp.length(); i++) {
				JSONObject jsonDeviceTemp = jsonArrayDeviceTemp
						.getJSONObject(i);
				// Has the device an attachment point? yes
				JSONArray arrayAttachmentPoint = (JSONArray) jsonDeviceTemp
						.get("attachmentPoint");
				if (arrayAttachmentPoint.length() != 0) {
					JSONObject jsonDevice = new JSONObject();
					JSONArray macArray = jsonDeviceTemp.getJSONArray("mac");
					StringBuffer macs = new StringBuffer();
					for (int k = 0; k < macArray.length(); k++) {
						if (macs.length() > 0) {
							macs.append(" ");
						}
						macs.append(macArray.getString(k));
					}
					jsonDevice.put("dataLayerAddress", macs.toString());
					JSONArray ipArray = jsonDeviceTemp.getJSONArray("ipv4");
					StringBuffer ips = new StringBuffer();
					for (int k = 0; k < ipArray.length(); k++) {
						if (ips.length() > 0) {
							ips.append(" ");
						}
						ips.append(ipArray.getString(k));
					}
					jsonDevice.put("networkAddresses", ips.toString());
					jsonDevice.put("lastSeen", jsonDeviceTemp.get("lastSeen"));

					JSONObject attachmentPoint = ((JSONArray) jsonDeviceTemp
							.get("attachmentPoint")).getJSONObject(0);
					jsonDevice.put("switchDpid",
							attachmentPoint.get("switchDPID"));
					jsonDevice.put("port", attachmentPoint.get("port"));
					jsonArrayDevice.put(jsonDevice);
				}
			}
			// Return devices connected to NOS switches
			return jsonArrayDevice.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosDiscoveredLinks(java.lang.String,
	 * java.lang.String)
	 */
	public String getNosDiscoveredLinks(String nosIp, String nosPort)
			throws UniformInterfaceException {
		try {
			// Build web resource URI for links between NOS switches
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/topology/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("links").path("json");
			// Get links between NOS switches (non-system format)
			JSONArray jsonArrayLinkTemp = new JSONArray(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class));
			// Parse links to system format
			JSONArray jsonArrayLink = new JSONArray();
			for (int j = 0; j < jsonArrayLinkTemp.length(); j++) {
				JSONObject jsonLinkTemp = jsonArrayLinkTemp.getJSONObject(j);
				JSONObject jsonLink = new JSONObject();
				jsonLink.put("dataLayerSource", jsonLinkTemp.get("src-switch"));
				jsonLink.put("portSource", jsonLinkTemp.get("src-port"));
				jsonLink.put("dataLayerDestination",
						jsonLinkTemp.get("dst-switch"));
				jsonLink.put("portDestination", jsonLinkTemp.get("dst-port"));
				jsonArrayLink.put(jsonLink);
			}
			// Return links connected to NOS switches
			return jsonArrayLink.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see util.NosClient#getNosInformation(java.lang.String, java.lang.String)
	 */
	public String getNosInformation(String nosIp, String nosPort)
			throws UniformInterfaceException {
		// Build web resource URI for NOS information
		String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
		WebResource webResource = client.resource(uri);
		webResource = webResource.path("controller").path("info").path("json");
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
		try {
			// Build web resource URI for switches connected to NOS
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("controller").path("switches")
					.path("json");
			// Get switches connected to NOS (non-system format)
			JSONArray jsonArraySwitchTemp = new JSONArray(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class));
			// Parse switches to system format
			JSONArray jsonArraySwitch = new JSONArray();
			for (int i = 0; i < jsonArraySwitchTemp.length(); i++) {
				JSONObject jsonSwitchTemp = jsonArraySwitchTemp
						.getJSONObject(i);
				JSONObject jsonSwitch = new JSONObject();
				jsonSwitch.put("dpid", jsonSwitchTemp.get("dpid"));
				String inetAddress = String.valueOf(jsonSwitchTemp
						.get("inetAddress"));
				jsonSwitch.put("remoteIp",
						inetAddress.substring(1, inetAddress.indexOf(":")));
				jsonSwitch.put("remotePort", Integer.parseInt(inetAddress
						.substring(inetAddress.indexOf(":") + 1)));
				jsonSwitch.put("connectedSince",
						jsonSwitchTemp.get("connectedSince"));
				jsonArraySwitch.put(jsonSwitch);
			}
			// Return switches connected to NOS
			return jsonArraySwitch.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
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
		try {
			// Build web resource URI for flows from switch
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("switch").path(swId).path("flow")
					.path("json");
			// Get flows from switch (non-system format)
			JSONArray jsonArrayFlowTemp = new JSONObject(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class))
					.getJSONArray(swId);
			// Parse flows to system format
			JSONArray jsonArrayFlow = new JSONArray();
			for (int i = 0; i < jsonArrayFlowTemp.length(); i++) {
				JSONObject jsonFlowTemp = jsonArrayFlowTemp.getJSONObject(i);
				JSONObject jsonFlow = new JSONObject();
				JSONObject match = jsonFlowTemp.getJSONObject("match");

				// Long format
				jsonFlow.put("inPort", match.get("inputPort"));
				jsonFlow.put("dataLayerSource", match.get("dataLayerSource"));
				jsonFlow.put("dataLayerDestination",
						match.get("dataLayerDestination"));
				String dataLayerType = match.getString("dataLayerType");
				jsonFlow.put("dataLayerType",
						Integer.parseInt(dataLayerType.substring(2), 16));
				jsonFlow.put("networkSource", match.get("networkSource"));
				jsonFlow.put("networkDestination",
						match.get("networkDestination"));
				jsonFlow.put("networkProtocol", match.get("networkProtocol"));
				jsonFlow.put("transportSource", match.get("transportSource"));
				jsonFlow.put("transportDestination",
						match.get("transportDestination"));
				jsonFlow.put("wildcards", match.get("wildcards"));
				jsonFlow.put("bytes", jsonFlowTemp.get("byteCount"));
				jsonFlow.put("packets", jsonFlowTemp.get("packetCount"));
				jsonFlow.put(
						"time",
						jsonFlowTemp.getDouble("durationSeconds")
								+ (jsonFlowTemp
										.getDouble("durationNanoseconds") / 1000000000d));
				jsonFlow.put("idleTimeout", jsonFlowTemp.get("idleTimeout"));
				jsonFlow.put("hardTimeout", jsonFlowTemp.get("hardTimeout"));
				jsonFlow.put("cookie", jsonFlowTemp.get("cookie"));
				JSONArray actions = jsonFlowTemp.getJSONArray("actions");
				StringBuffer outPorts = new StringBuffer();
				for (int k = 0; k < actions.length(); k++) {
					JSONObject action = actions.getJSONObject(k);
					if (action.getString("type").equalsIgnoreCase("output")) {
						if (outPorts.length() > 0) {
							outPorts.append(" ");
						}
						outPorts.append(action.getString("port"));
					}
				}
				jsonFlow.put("outports", outPorts.toString());

				// Short format
				// jsonFlow.put("i", match.get("inputPort"));
				// jsonFlow.put("lS", match.get("dataLayerSource"));
				// jsonFlow.put("lD",
				// match.get("dataLayerDestination"));
				// String dataLayerType = match.getString("dataLayerType");
				// jsonFlow.put("lT",
				// Integer.parseInt(dataLayerType.substring(2), 16));
				// jsonFlow.put("nS", match.get("networkSource"));
				// jsonFlow.put("nD",
				// match.get("networkDestination"));
				// jsonFlow.put("nP", match.get("networkProtocol"));
				// jsonFlow.put("tS", match.get("transportSource"));
				// jsonFlow.put("tD",
				// match.get("transportDestination"));
				// jsonFlow.put("w", match.get("wildcards"));
				// jsonFlow.put("b", jsonFlowTemp.get("byteCount"));
				// jsonFlow.put("p", jsonFlowTemp.get("packetCount"));
				// jsonFlow.put(
				// "t",
				// jsonFlowTemp.getDouble("durationSeconds")
				// + (jsonFlowTemp
				// .getDouble("durationNanoseconds") / 1000000000d));
				// jsonFlow.put("iT", jsonFlowTemp.get("idleTimeout"));
				// jsonFlow.put("hT", jsonFlowTemp.get("hardTimeout"));
				// jsonFlow.put("c", jsonFlowTemp.get("cookie"));
				// JSONArray actions = jsonFlowTemp.getJSONArray("actions");
				// StringBuffer outPorts = new StringBuffer();
				// for (int k = 0; k < actions.length(); k++) {
				// JSONObject action = actions.getJSONObject(k);
				// if (action.getString("type").equalsIgnoreCase("output")) {
				// if (outPorts.length() > 0) {
				// outPorts.append(" ");
				// }
				// outPorts.append(action.getString("port"));
				// }
				// }
				// jsonFlow.put("oP", outPorts.toString());

				jsonArrayFlow.put(jsonFlow);
			}
			// Return flows from switch
			return jsonArrayFlow.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
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
		try {
			// Build web resource URI for ports from switch
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("switch").path(swId).path("port")
					.path("json");
			// Get ports from switch (non-system format)
			JSONArray jsonArrayPortTemp = new JSONObject(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class))
					.getJSONArray(swId);
			// Parse ports to system format
			JSONArray jsonArrayPort = new JSONArray();
			for (int i = 0; i < jsonArrayPortTemp.length(); i++) {
				JSONObject jsonPortTemp = jsonArrayPortTemp.getJSONObject(i);
				JSONObject jsonPort = new JSONObject();
				jsonPort.put("number", jsonPortTemp.get("portNumber"));
				jsonPort.put("rxPackets", jsonPortTemp.get("receivePackets"));
				jsonPort.put("txPackets", jsonPortTemp.get("transmitPackets"));
				jsonPort.put("rxBytes", jsonPortTemp.get("receiveBytes"));
				jsonPort.put("txBytes", jsonPortTemp.get("transmitBytes"));
				jsonPort.put("rxDrops", jsonPortTemp.get("receiveDropped"));
				jsonPort.put("txDrops", jsonPortTemp.get("transmitDropped"));
				jsonPort.put("rxError", jsonPortTemp.get("receiveErrors"));
				jsonPort.put("txError", jsonPortTemp.get("transmitErrors"));
				jsonPort.put("rxFrameError",
						jsonPortTemp.get("receiveFrameErrors"));
				jsonPort.put("rxOverrunError",
						jsonPortTemp.get("receiveOverrunErrors"));
				jsonPort.put("rxCrcError", jsonPortTemp.get("receiveCRCErrors"));
				jsonPort.put("collisions", jsonPortTemp.get("collisions"));
				jsonArrayPort.put(jsonPort);
			}
			// Return ports from switch
			return jsonArrayPort.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
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
		try {
			// Build web resource URI for port statistics from switch
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("switch").path(swId)
					.path("ffrecord").path("aggports").path(lastLogs)
					.path("json");
			// Return port statistics from switch
			return new JSONObject(webResource
					.accept(MediaType.APPLICATION_JSON).get(String.class))
					.getJSONArray(swId).toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
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
		try {
			// Build web resource URI for tables from switch
			String uri = BASE_URI + nosIp + ":" + nosPort + "/wm/core/";
			WebResource webResource = client.resource(uri);
			webResource = webResource.path("switch").path(swId).path("table")
					.path("json");
			// Get ports from switch (non-system format)
			JSONArray jsonArrayTableTemp = new JSONObject(webResource.accept(
					MediaType.APPLICATION_JSON).get(String.class))
					.getJSONArray(swId);
			// Parse ports to system format
			JSONArray jsonArrayTable = new JSONArray();
			for (int i = 0; i < jsonArrayTableTemp.length(); i++) {
				JSONObject jsonTableTemp = jsonArrayTableTemp.getJSONObject(i);
				JSONObject jsonTable = new JSONObject();
				jsonTable.put("id", jsonTableTemp.get("tableId"));
				jsonTable.put("name", jsonTableTemp.get("name"));
				jsonTable
						.put("wildcards", jsonTableTemp.getString("wildcards"));
				jsonTable
						.put("maxEntries", jsonTableTemp.get("maximumEntries"));
				jsonTable.put("activeCount", jsonTableTemp.get("activeCount"));
				jsonTable.put("lookupCount", jsonTableTemp.get("lookupCount"));
				jsonTable
						.put("matchedCount", jsonTableTemp.get("matchedCount"));
				jsonArrayTable.put(jsonTable);
			}
			// Return tables from switch
			return jsonArrayTable.toString();
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}

	public void close() {
		client.destroy();
	}

}
