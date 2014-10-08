<%@page import="util.NosClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get NOSs parameters
	String nosList = request.getParameter("nosList");
	JSONArray jsonArrayNos = new JSONArray(nosList);
	// Get links between switches from each NOS
	JSONArray jsonArrayNosLink = new JSONArray();
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
		// Get links between switches from NOS
		JSONArray jsonArrayLink = new JSONArray(
				client.getNosDiscoveredLinks(jsonNos.getString("ip"),
						jsonNos.getString("port")));
		// Match NOS with corresponding devices
		JSONObject jsonNosLink = new JSONObject();
		jsonNosLink.put("nosIp", jsonNos.get("ip"));
		jsonNosLink.put("nosPort", jsonNos.get("port"));
		jsonNosLink.put("nosType", jsonNos.get("type"));
		jsonNosLink.put("jsonArrayLink", jsonArrayLink);
		// Add to devices array
		jsonArrayNosLink.put(jsonNosLink);
	}
	// Return devices array
	out.println(jsonArrayNosLink);
	out.flush();
%>