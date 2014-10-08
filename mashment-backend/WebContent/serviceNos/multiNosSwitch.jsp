<%@page import="util.NosClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get NOSs parameters
	String nosList = request.getParameter("nosList");
	JSONArray jsonArrayNos = new JSONArray(nosList);
	// Get switches connected to each NOS
	JSONArray jsonArrayNosSwitch = new JSONArray();
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
		// Get switches connected to NOS
		JSONArray jsonArraySwitch = new JSONArray(
				client.getNosSwitches(jsonNos.getString("ip"),
						jsonNos.getString("port")));
		// Match NOS with corresponding switches
		JSONObject jsonNosSwitch = new JSONObject();
		jsonNosSwitch.put("nosIp", jsonNos.get("ip"));
		jsonNosSwitch.put("nosPort", jsonNos.get("port"));
		jsonNosSwitch.put("nosType", jsonNos.get("type"));
		jsonNosSwitch.put("jsonArraySwitch", jsonArraySwitch);
		// Add to switches array
		jsonArrayNosSwitch.put(jsonNosSwitch);
	}
	// Return switches array
	out.println(jsonArrayNosSwitch);
	out.flush();
%>