<%@page import="util.NosClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get NOS parameters
	String nos = request.getParameter("nos");
	JSONObject jsonNos = new JSONObject(nos);
	// NOS type? beacon : pox : floodlight : other
	NosClient client;
	if (jsonNos.getString("type").equalsIgnoreCase("beacon")) {
		client = new NosBeaconClient();
	} else if (jsonNos.getString("type").equalsIgnoreCase("pox")) {
		client = new NosPoxClient();
	} else if (jsonNos.getString("type").equalsIgnoreCase("floodlight")) {
		client = new NosFloodlightClient();
	} else {
		return;
	}
	// Get switches parameters
	String switchList = request.getParameter("switchList");
	JSONArray jsonSwitchList = new JSONArray(switchList);
	// Get flows from each switch
	JSONArray jsonArraySwitchFlow = new JSONArray();
	for (int i = 0; i < jsonSwitchList.length(); i++) {
		// Get flows from switch
		String swId = jsonSwitchList.getJSONObject(i).getString("swId");
		JSONArray jsonArrayFlow = new JSONArray(
				client.getNosSwitchFlows(jsonNos.getString("ip"),
						jsonNos.getString("port"), swId));
		// Match switch ID with corresponding flows
		JSONObject jsonSwitchFlow = new JSONObject();
		jsonSwitchFlow.put("swId", swId);
		jsonSwitchFlow.put("jsonArrayFlow", jsonArrayFlow);
		// Add to flows array
		jsonArraySwitchFlow.put(jsonSwitchFlow);
	}
	// Return flows array
	out.println(jsonArraySwitchFlow);
	out.flush();
%>