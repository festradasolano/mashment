<%@page import="util.NosClient"%>
<%@page import="core.WebServiceClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get switches parameters
	String nosSwitchList = request.getParameter("nosSwitchList");
	JSONArray jsonArrayNosSwitch = new JSONArray(nosSwitchList);
	// Get flows from each switch
	JSONArray jsonArrayNosSwitchFlow = new JSONArray();
	for (int i = 0; i < jsonArrayNosSwitch.length(); i++) {
		// NOS type? beacon : pox : floodlight : other
		JSONObject jsonNosSwitch = jsonArrayNosSwitch.getJSONObject(i);
		NosClient client;
		if (jsonNosSwitch.getString("nosType").equalsIgnoreCase(
				"beacon")) {
			client = new NosBeaconClient();
		} else if (jsonNosSwitch.getString("nosType").equalsIgnoreCase(
				"pox")) {
			client = new NosPoxClient();
		} else if (jsonNosSwitch.getString("nosType").equalsIgnoreCase(
				"floodlight")) {
			client = new NosFloodlightClient();
		} else {
			return;
		}
		// Get flows from switch
		JSONArray jsonArrayFlow = new JSONArray(
				client.getNosSwitchFlows(
						jsonNosSwitch.getString("nosIp"),
						jsonNosSwitch.getString("nosPort"),
						jsonNosSwitch.getString("swId")));
		// Match switch ID and NOS with corresponding flows
		JSONObject jsonNosSwitchFlow = new JSONObject();
		jsonNosSwitchFlow.put("swId", jsonNosSwitch.get("swId"));
		jsonNosSwitchFlow.put("nosIp", jsonNosSwitch.get("nosIp"));
		jsonNosSwitchFlow.put("nosPort", jsonNosSwitch.get("nosPort"));
		jsonNosSwitchFlow.put("nosType", jsonNosSwitch.get("nosType"));
		jsonNosSwitchFlow.put("jsonArrayFlow", jsonArrayFlow);
		// Add to flows array
		jsonArrayNosSwitchFlow.put(jsonNosSwitchFlow);
	}
	// Return flows array
	out.println(jsonArrayNosSwitchFlow);
	out.flush();
%>