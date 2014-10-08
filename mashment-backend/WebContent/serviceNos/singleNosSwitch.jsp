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
	// Get switches connected to NOS
	JSONArray jsonArraySwitch = new JSONArray(client.getNosSwitches(
			jsonNos.getString("ip"), jsonNos.getString("port")));
	// Return switches connected to NOS
	out.println(jsonArraySwitch);
	out.flush();
%>