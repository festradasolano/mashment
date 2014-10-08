<%@page import="util.NosClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get NOSs parameters
	String nosList = request.getParameter("nosList");
	JSONArray jsonArrayNos = new JSONArray(nosList);
	// Get devices connected to switches from each NOS
	JSONArray jsonArrayNosDevice = new JSONArray();
	for (int i = 0; i < jsonArrayNos.length(); i++) {
		// NOS type? beacon : pox : floodlight : other
		JSONObject jsonNos = jsonArrayNos.getJSONObject(i);
		NosClient client;
		if (jsonNos.getString("type").equalsIgnoreCase("beacon")) {
			client = new NosBeaconClient();
		} else if (jsonNos.getString("type").equalsIgnoreCase("pox")) {
			client = new NosPoxClient();
		} else if (jsonNos.getString("type").equalsIgnoreCase(
				"floodlight")) {
			client = new NosFloodlightClient();
		} else {
			return;
		}
		// Get devices connected to switches from NOS
		JSONArray jsonArrayDevice = new JSONArray(
				client.getNosDevices(jsonNos.getString("ip"),
						jsonNos.getString("port")));
		// Match NOS with corresponding devices
		JSONObject jsonNosDevice = new JSONObject();
		jsonNosDevice.put("nosIp", jsonNos.get("ip"));
		jsonNosDevice.put("nosPort", jsonNos.get("port"));
		jsonNosDevice.put("nosType", jsonNos.get("type"));
		jsonNosDevice.put("jsonArrayDevice", jsonArrayDevice);
		// Add to devices array
		jsonArrayNosDevice.put(jsonNosDevice);
	}
	// Return devices array
	out.println(jsonArrayNosDevice);
	out.flush();
%>