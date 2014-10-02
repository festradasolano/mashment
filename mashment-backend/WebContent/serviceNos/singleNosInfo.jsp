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
	// Get NOS information
	JSONObject jsonNosInfo = new JSONObject(client.getNosInformation(
			jsonNos.getString("ip"), jsonNos.getString("port")));
	// Add NOS listen address, listen port and type
	jsonNosInfo.put("ip", jsonNos.get("ip"));
	jsonNosInfo.put("port", jsonNos.get("port"));
	jsonNosInfo.put("type", jsonNos.get("type"));
	// Return NOS information
	out.println(jsonNosInfo);
	out.flush();
%>