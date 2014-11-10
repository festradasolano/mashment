<%@page import="org.codehaus.jettison.json.JSONObject"%>
<%@ page import="net.mashment.drools.rules.RuleLoader"%>

<%
	// Get parameters
	JSONObject params = new JSONObject(request.getParameter("params"));
	JSONObject daoResponse = new JSONObject();
	String method = params.getString("method");
	if (method.equalsIgnoreCase("loadRules")) {
		RuleLoader ruleLoader = new RuleLoader();
		ruleLoader.loadAllRules();
	}
	daoResponse.put("error", "NULL");
	out.println(daoResponse);
	out.flush();
%>