<%@page import="util.NosClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get switches parameters
	String nosSwitchList = request.getParameter("nosSwitchList");
	JSONArray jsonArrayNosSwitch = new JSONArray(nosSwitchList);
	// Get ports from each switch
	JSONArray jsonArrayNosSwitchPort = new JSONArray();
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
		// Get ports from switch
		JSONArray jsonArrayPort = new JSONArray(
				client.getNosSwitchPorts(
						jsonNosSwitch.getString("nosIp"),
						jsonNosSwitch.getString("nosPort"),
						jsonNosSwitch.getString("swId")));
		// Match switch ID and NOS with corresponding ports
		JSONObject jsonNosSwitchPort = new JSONObject();
		jsonNosSwitchPort.put("swId", jsonNosSwitch.get("swId"));
		jsonNosSwitchPort.put("nosIp", jsonNosSwitch.get("nosIp"));
		jsonNosSwitchPort.put("nosPort", jsonNosSwitch.get("nosPort"));
		jsonNosSwitchPort.put("nosType", jsonNosSwitch.get("nosType"));
		jsonNosSwitchPort.put("jsonArrayPort", jsonArrayPort);
		// Add to ports array
		jsonArrayNosSwitchPort.put(jsonNosSwitchPort);
	}
	// Return ports array
	out.println(jsonArrayNosSwitchPort);
	out.flush();
%>