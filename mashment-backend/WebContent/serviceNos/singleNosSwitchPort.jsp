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
	// Get ports from each switch
	JSONArray jsonArraySwitchPort = new JSONArray();
	for (int i = 0; i < jsonSwitchList.length(); i++) {
		// Get ports from switch
		String swId = jsonSwitchList.getJSONObject(i).getString("swId");
		JSONArray jsonArrayPort = new JSONArray(
				client.getNosSwitchPorts(jsonNos.getString("ip"),
						jsonNos.getString("port"), swId));
		// Match switch ID with corresponding ports
		JSONObject jsonSwitchPort = new JSONObject();
		jsonSwitchPort.put("swId", swId);
		jsonSwitchPort.put("jsonArrayPort", jsonArrayPort);
		// Add to ports array
		jsonArraySwitchPort.put(jsonSwitchPort);
	}
	// Return ports array
	out.println(jsonArraySwitchPort);
	out.flush();
%>