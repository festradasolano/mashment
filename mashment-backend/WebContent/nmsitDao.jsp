<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@ page import="net.mashment.drools.NmsitDao"%>

<%
	// Get parameters
	JSONObject params = new JSONObject(request.getParameter("params"));
	JSONObject daoResponse = new JSONObject();
	String method = params.getString("method");
	JSONObject nmsit = params.getJSONObject("nmsit");
	if (method.equalsIgnoreCase("addNmsit")) {
		// if nmsit exists by situation, return error
		JSONObject checkNmsit = NmsitDao.loadNmsit(nmsit
				.getString("situation"));
		if (checkNmsit != null) {
			daoResponse.put("result", false);
			daoResponse.put("error",
					"Field 'Situation' is duplicated. Type other!");
		} else {
			// build rule
			String rule = "rule";
			//
			boolean insertResponse = NmsitDao.addNmsit(
					nmsit.getString("SITUATION"),
					nmsit.toString(), rule);
			daoResponse.put("result", insertResponse);
			if (insertResponse != false) {
				daoResponse.put("error", "NULL");
			} else {
				daoResponse.put("error",
						"Something went wrong when accessing database");
			}
		}
	}
	out.println(daoResponse);
	out.flush();
%>