<%@page import="util.NosClient"%>
<%@page import="core.WebServiceClient"%>
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
	// Get tables from each switch
	JSONArray jsonArraySwitchTable = new JSONArray();
	for (int i = 0; i < jsonSwitchList.length(); i++) {
		// Get tables from switch
		String swId = jsonSwitchList.getJSONObject(i).getString("swId");
		JSONArray jsonArrayTable = new JSONArray(
				client.getNosSwitchTables(jsonNos.getString("ip"),
						jsonNos.getString("port"), swId));
		// Match switch ID with corresponding tables
		JSONObject jsonSwitchTable = new JSONObject();
		jsonSwitchTable.put("swId", swId);
		jsonSwitchTable.put("jsonArrayTable", jsonArrayTable);
		// Add to tables array
		jsonArraySwitchTable.put(jsonSwitchTable);
	}
	// Return tables array
	out.println(jsonArraySwitchTable);
	out.flush();
%>