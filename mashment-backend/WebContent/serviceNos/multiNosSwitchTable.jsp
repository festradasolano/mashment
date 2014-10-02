<%@page import="util.NosClient"%>
<%@page import="core.WebServiceClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get switches parameters
	String nosSwitchList = request.getParameter("nosSwitchList");
	JSONArray jsonArrayNosSwitch = new JSONArray(nosSwitchList);
	// Get tables from each switch
	JSONArray jsonArrayNosSwitchTable = new JSONArray();
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
		// Get tables from switch
		JSONArray jsonArrayTable = new JSONArray(
				client.getNosSwitchTables(
						jsonNosSwitch.getString("nosIp"),
						jsonNosSwitch.getString("nosPort"),
						jsonNosSwitch.getString("swId")));
		// Match switch ID and NOS with corresponding tables
		JSONObject jsonNosSwitchTable = new JSONObject();
		jsonNosSwitchTable.put("swId", jsonNosSwitch.get("swId"));
		jsonNosSwitchTable.put("nosIp", jsonNosSwitch.get("nosIp"));
		jsonNosSwitchTable.put("nosPort", jsonNosSwitch.get("nosPort"));
		jsonNosSwitchTable.put("nosType", jsonNosSwitch.get("nosType"));
		jsonNosSwitchTable.put("jsonArrayTable", jsonArrayTable);
		// Add to tables array
		jsonArrayNosSwitchTable.put(jsonNosSwitchTable);
	}
	// Return tables array
	out.println(jsonArrayNosSwitchTable);
	out.flush();
%>