<%@page import="util.NosClient"%>
<%@page import="core.WebServiceClient"%>
<%@page
	import="util.NosBeaconClient,util.NosPoxClient,util.NosFloodlightClient,util.RrdToolManager,org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<%
	//Get switches parameters
	String nosSwitchList = request.getParameter("nosSwitchList");
	JSONArray jsonArrayNosSwitch = new JSONArray(nosSwitchList);
	// Get graph tool parameters
	String graphToolParams = request.getParameter("graphToolParams");
	JSONObject gtParams = new JSONObject(graphToolParams);
	String graphToolType = gtParams.getString("type");
	String lastLogs = gtParams.getString("lastLogs");
	String traffic = gtParams.getString("traffic");
	// Get traffic graph result from each switch
	JSONArray jsonArrayResult = new JSONArray();
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
		// Get port statistics from switch
		JSONArray jsonArrayPortStatsLog = new JSONArray(
				client.getNosSwitchPortStatsLogs(
						jsonNosSwitch.getString("nosIp"),
						jsonNosSwitch.getString("nosPort"),
						jsonNosSwitch.getString("swId"), lastLogs));
		// Graph tool type? rrdtool : yuichart
		if (graphToolType.equalsIgnoreCase("rrdtool")) {
			// Get details from RRDTool generated graph
			RrdToolManager rrdTool = new RrdToolManager();
			JSONObject jsonGraphDetail = null;
			if (traffic.equalsIgnoreCase("allpackets")) {
				jsonGraphDetail = new JSONObject(
						rrdTool.createSwitchPortStatsLogsGraph(
								jsonNosSwitch.toString(),
								jsonArrayPortStatsLog.toString()));
			} else if (traffic.equalsIgnoreCase("bytes")) {
				jsonGraphDetail = new JSONObject(
						rrdTool.createSwitchPortStatsLastMinuteHourGraph(
								jsonNosSwitch.toString(),
								jsonArrayPortStatsLog.toString()));
			}
			// Add to result array
			jsonArrayResult.put(jsonGraphDetail);
		} else if (graphToolType.equalsIgnoreCase("yuichart")) {
			// Create graph ID and title
			String id = jsonNosSwitch.get("nosType")
					+ "_"
					+ jsonNosSwitch.get("nosIp").toString()
							.replace('.', '-')
					+ "_"
					+ jsonNosSwitch.get("nosPort")
					+ "_"
					+ jsonNosSwitch.get("swId").toString()
							.replace(':', '-');
			String title = "Traffic Switch "
					+ jsonNosSwitch.get("swId") + " "
					+ jsonNosSwitch.get("nosType") + " "
					+ jsonNosSwitch.get("nosIp") + ":"
					+ jsonNosSwitch.get("nosPort");
			// Match graph ID and title with corresponding port statistics
			JSONObject jsonNosSwitchPortStatsLog = new JSONObject();
			jsonNosSwitchPortStatsLog.put("id", id);
			jsonNosSwitchPortStatsLog.put("title", title);
			jsonNosSwitchPortStatsLog.put("jsonArrayPortStatsLog",
					jsonArrayPortStatsLog);
			// Add to result array
			jsonArrayResult.put(jsonNosSwitchPortStatsLog);
		}
	}
	out.println(jsonArrayResult);
	out.flush();
%>