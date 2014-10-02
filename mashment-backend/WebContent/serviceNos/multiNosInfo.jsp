<%@page import="util.NosClient"%>
<%@page import="core.WebServiceClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	// Get NOSs parameters
	String nosList = request.getParameter("nosList");
	JSONArray jsonArrayNos = new JSONArray(nosList);
	// Get information from each NOS
	JSONArray jsonArrayNosInfo = new JSONArray();
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
		// Get information from NOS
		JSONObject jsonNosInfo = new JSONObject(
				client.getNosInformation(jsonNos.getString("ip"),
						jsonNos.getString("port")));
		jsonNosInfo.put("ip", jsonNos.get("ip"));
		jsonNosInfo.put("port", jsonNos.get("port"));
		jsonNosInfo.put("type", jsonNos.get("type"));
		// Add to NOSs information array
		jsonArrayNosInfo.put(jsonNosInfo);
	}
	// Return NOSs information array
	out.println(jsonArrayNosInfo);
	out.flush();
%>