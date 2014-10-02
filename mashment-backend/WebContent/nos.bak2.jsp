<%@page
	import="org.codehaus.jettison.json.JSONArray,org.codehaus.jettison.json.JSONObject"%>
<!--
You are free to copy and use this sample in accordance with the terms of the
Apache license (http:// www.apache.org/licenses/LICENSE-2.0.html)
-->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>NOS Dashboard Management Mashup</title>
<link href="css/layout.css" type="text/css" rel="stylesheet"></link>
<style type="text/css">
.center-text {
	text-align: center;
}

.border-cell {
	border: 1px solid #eeeeee;
}

.style-title {
	text-align: center;
	font-weight: bold;
	background: white url(images/title-bg.gif) repeat-x left bottom;
	font-size: 11pt;
	border: 1px solid #eeeeee;
}
</style>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
	google.load('visualization', '1', {
		packages : [ 'corechart, orgchart,table' ]
	});
</script>
<script type="text/javascript">
	var AJAXrequest = createXMLHttpRequest();
	var params = null;
	var jsonNosList = null;
	var servicePathNos = null;
	var jsonSwitchList = null;
	var switchId = null;

	function createXMLHttpRequest() {
		// See http://en.wikipedia.org/wiki/XMLHttpRequest
		// Provide the XMLHttpRequest class for IE 5.x-6.x:
		if (typeof XMLHttpRequest == "undefined")
			XMLHttpRequest = function() {
				try {
					return new ActiveXObject("Msxml2.XMLHTTP.6.0")
				} catch (e) {
				}
				try {
					return new ActiveXObject("Msxml2.XMLHTTP.3.0")
				} catch (e) {
				}
				try {
					return new ActiveXObject("Msxml2.XMLHTTP")
				} catch (e) {
				}
				try {
					return new ActiveXObject("Microsoft.XMLHTTP")
				} catch (e) {
				}
				throw new Error("This browser does not support XMLHttpRequest.")
			};
		return new XMLHttpRequest();
	}

	function handlerInit() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayNosInfo = eval("(" + AJAXrequest.responseText + ")");
			// Draw NOSs information table
			drawNosInfoTable(jsonArrayNosInfo);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert("Something went wrong...");
		}
	}

	function handlerSwitches() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitch = eval("(" + AJAXrequest.responseText + ")");
			drawSwitchTable(jsonArraySwitch);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerSwitchesForManyNos() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitch = eval("(" + AJAXrequest.responseText + ")");
			drawSwitchTableForManyNos(jsonArraySwitch);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerDevices() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArrayDevice = eval("(" + AJAXrequest.responseText + ")");
			drawDeviceTable(jsonArrayDevice);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerDevicesForManyNos() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArrayDevice = eval("(" + AJAXrequest.responseText + ")");
			drawDeviceTableForManyNos(jsonArrayDevice);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerLinks() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArrayLink = eval("(" + AJAXrequest.responseText + ")");
			drawLinkTable(jsonArrayLink);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerLinksForManyNos() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArrayLink = eval("(" + AJAXrequest.responseText + ")");
			drawLinkTableForManyNos(jsonArrayLink);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerSwitchFlows() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitchFlow = eval("(" + AJAXrequest.responseText + ")");
			drawSwitchFlowTable(jsonArraySwitchFlow);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerSwitchFlowsForManySwitches() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitchFlow = eval("(" + AJAXrequest.responseText + ")");
			drawSwitchFlowTableForManySwitches(jsonArraySwitchFlow);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerSwitchTables() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitchTable = eval("(" + AJAXrequest.responseText
					+ ")");
			drawSwitchTableTable(jsonArraySwitchTable);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	function handlerSwitchPorts() {
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArraySwitchPort = eval("(" + AJAXrequest.responseText + ")");
			drawSwitchPortTable(jsonArraySwitchPort);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}
</script>
<script type="text/javascript">
	function hide(element) {
		var visElement = document.getElementById(element);
		visElement.style.visibility = "hidden";
	}

	function show(element) {
		var visElement = document.getElementById(element);
		visElement.style.visibility = "visible";
	}

	function init() {
		hide("nosInfo_div");
		hide("nosOpts_div");
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Obtain NOSs parameters
		var input =
<%String r = request.getParameter("params");
			out.print(r);%>
	var auxParams = input;
		params = auxParams;
		// Send AJAX request to obtain NOSs info
		AJAXrequest.open("GET",
				"http://127.0.0.1:8080/systembackend/serviceNos/info.jsp?nosList="
						+ params, true);
		AJAXrequest.onreadystatechange = handlerInit;
		AJAXrequest.send();
	}

	function drawNosInfoTable(jsonArrayNosInfo) {
		// Create and populate the data NOSs information table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Service IP");
		data.addColumn("string", "Service Port");
		data.addColumn("string", "Type");
		data.addColumn("string", "Listen Address");
		data.addColumn("number", "Listen Port");
		data.addRows(jsonArrayNosInfo.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArrayNosInfo.length; i++) {
			data
					.setCell(i, 0, jsonArrayNosInfo[i].ip, undefined,
							centerTextOpt);
			data.setCell(i, 1, jsonArrayNosInfo[i].port, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArrayNosInfo[i].type, undefined,
					centerTextOpt);
			if (jsonArrayNosInfo[i].listenAddress == "*"
					|| jsonArrayNosInfo[i].listenAddress == "0.0.0.0") {
				data.setCell(i, 3, "any", undefined, centerTextOpt);
			} else {
				data.setCell(i, 3, jsonArrayNosInfo[i].listenAddress,
						undefined, centerTextOpt);
			}
			data.setCell(i, 4, jsonArrayNosInfo[i].listenPort, undefined,
					centerTextOpt);
		}
		// Create and draw NOSs information table
		var tableNosInfo = new google.visualization.Table(document
				.getElementById("nosInfoTable_div"));
		tableNosInfo.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 5
		});
		show("nosInfo_div");
		// Add event listener for event SELECT
		google.visualization.events.addListener(tableNosInfo, "select",
				selectTableHandler);
		// Function for event SELECT
		function selectTableHandler() {
			// Hide divisions
			hide("nosOpts_div");
			hide("nosDetail_div");
			hide("switchOpts_div");
			hide("switchDetail_div");
			// Initialize parameters
			jsonNosList = null;
			servicePathNos = null;
			jsonSwitchList = null;
			switchId = null;
			// Obtain selection and check it
			var selection = tableNosInfo.getSelection();
			if (selection.length != 0) {
				jsonNosList = [];
				for ( var i = 0; i < selection.length; i++) {
					var item = selection[i];
					var ip = data.getFormattedValue(item.row, 0);
					var port = data.getFormattedValue(item.row, 1);
					var type = data.getFormattedValue(item.row, 2);
					var jsonNos = {
						"ip" : ip,
						"port" : port,
						"type" : type
					}
					jsonNosList[i] = jsonNos;
				}
				if (jsonNosList.length == 1) {
					var jsonNos = jsonNosList[0];
					if (jsonNos.type == "beacon") {
						servicePathNos = jsonNos.ip + ":" + jsonNos.port
								+ "/resources/beaconmediator";
					} else if (jsonNos.type == "pox") {
						servicePathNos = jsonNos.ip + ":" + jsonNos.port
								+ "/resources/poxmediator";
					} else {
						servicePathNos = "unknown";
					}
				}
				show("nosOpts_div");
			}
		}
	}

	function selectSwitchHandler(selection, data) {
		// Hide divisions
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonSwitchList = null;
		switchId = null;
		// Check selection
		if (selection.length != 0) {
			jsonSwitchList = [];
			if (jsonNosList.length == 1) {
				jsonNos = jsonNosList[0];
				var ip = jsonNos.ip;
				var port = jsonNos.port;
				var type = jsonNos.type;
				for ( var i = 0; i < selection.length; i++) {
					var item = selection[i];
					var swId = data.getFormattedValue(item.row, 0);
					var jsonSwitch = {
						"swId" : swId,
						"ip" : ip,
						"port" : port,
						"type" : type
					}
					jsonSwitchList[i] = jsonSwitch;
				}
				if (jsonSwitchList.length == 1) {
					var jsonSwitch = jsonSwitchList[0];
					switchId = jsonSwitch.swId;
				}
			} else if (jsonNosList.length > 1) {
				for ( var i = 0; i < selection.length; i++) {
					var item = selection[i];
					var swId = data.getFormattedValue(item.row, 0);
					var ip = data.getFormattedValue(item.row, 4);
					var port = data.getFormattedValue(item.row, 5);
					var type = data.getFormattedValue(item.row, 6);
					var jsonSwitch = {
						"swId" : swId,
						"ip" : ip,
						"port" : port,
						"type" : type
					}
					jsonSwitchList[i] = jsonSwitch;
				}
				if (jsonSwitchList.length == 1) {
					var jsonSwitch = jsonSwitchList[0];
					switchId = jsonSwitch.swId;
					if (jsonSwitch.type == "beacon") {
						servicePathNos = jsonSwitch.ip + ":" + jsonSwitch.port
								+ "/resources/beaconmediator";
					} else if (jsonSwitch.type == "pox") {
						servicePathNos = jsonSwitch.ip + ":" + jsonSwitch.port
								+ "/resources/poxmediator";
					} else {
						servicePathNos = "unknown";
					}
				}
			}
			show("switchOpts_div");
		}
	}

	function drawSwitchTable(jsonArraySwitch) {
		// Create and populate the switches table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Id");
		data.addColumn("string", "IP Address");
		data.addColumn("number", "Port");
		data.addColumn("date", "Connected");
		// 		data.addColumn("string", "Serial Number");
		// 		data.addColumn("string", "Manufacturer");
		// 		data.addColumn("string", "Hardware");
		// 		data.addColumn("string", "Software");
		// 		data.addColumn("string", "Datapath");
		data.addRows(jsonArraySwitch.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitch.length; i++) {
			data.setCell(i, 0, jsonArraySwitch[i].dpid, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitch[i].remoteIp, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitch[i].remotePort, undefined,
					centerTextOpt);
			data.setCell(i, 3, new Date(jsonArraySwitch[i].connectedSince),
					undefined, centerTextOpt);
			// 			data.setCell(i, 4, jsonArraySwitch[i].serialNumber, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 5, jsonArraySwitch[i].manufacturer, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 6, jsonArraySwitch[i].hardware, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 7, jsonArraySwitch[i].software, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 8, jsonArraySwitch[i].datapath, undefined,
			// 					centerTextOpt);
		}
		// Create and apply date formatter pattern
		var formatterDateTime = new google.visualization.DateFormat({
			pattern : "yyyy-MM-dd HH:mm:ss"
		});
		formatterDateTime.format(data, 3);
		// Create and draw switches table
		var tableSwitch = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableSwitch.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
		// Add event listener for event SELECT
		google.visualization.events.addListener(tableSwitch, "select",
				selectTableHandler);
		// Function for event SELECT
		function selectTableHandler() {
			selectSwitchHandler(tableSwitch.getSelection(), data);
		}
	}

	function drawSwitchTableForManyNos(jsonArraySwitch) {
		// Create and populate the switches table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Id");
		data.addColumn("string", "IP Address");
		data.addColumn("number", "Port");
		data.addColumn("date", "Connected");
		data.addColumn("string", "NOS Service IP");
		data.addColumn("string", "NOS Service Port");
		data.addColumn("string", "NOS Type");
		data.addRows(jsonArraySwitch.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitch.length; i++) {
			data.setCell(i, 0, jsonArraySwitch[i].dpid, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitch[i].remoteIp, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitch[i].remotePort, undefined,
					centerTextOpt);
			data.setCell(i, 3, new Date(jsonArraySwitch[i].connectedSince),
					undefined, centerTextOpt);
			data.setCell(i, 4, jsonArraySwitch[i].nosIp, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArraySwitch[i].nosPort, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArraySwitch[i].nosType, undefined,
					centerTextOpt);
		}
		// Create and apply date formatter pattern
		var formatterDateTime = new google.visualization.DateFormat({
			pattern : "yyyy-MM-dd HH:mm:ss"
		});
		formatterDateTime.format(data, 3);
		// Create and draw switches table
		var tableSwitch = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableSwitch.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
		// Add event listener for event SELECT
		google.visualization.events.addListener(tableSwitch, "select",
				selectTableHandler);
		// Function for event SELECT
		function selectTableHandler() {
			selectSwitchHandler(tableSwitch.getSelection(), data);
		}
	}

	function drawDeviceTable(jsonArrayDevice) {
		// Create and populate the devices table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "MAC");
		data.addColumn("string", "IP");
		data.addColumn("date", "Last Seen");
		data.addColumn("string", "Switch");
		data.addColumn("number", "Port");
		data.addRows(jsonArrayDevice.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArrayDevice.length; i++) {
			data.setCell(i, 0, jsonArrayDevice[i].dataLayerAddress, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArrayDevice[i].networkAddresses, undefined,
					centerTextOpt);
			data.setCell(i, 2, new Date(jsonArrayDevice[i].lastSeen),
					undefined, centerTextOpt);
			data.setCell(i, 3, jsonArrayDevice[i].switchDpid, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArrayDevice[i].port, undefined,
					centerTextOpt);
		}
		// Create and apply date formatter pattern
		var formatterDateTime = new google.visualization.DateFormat({
			pattern : "yyyy-MM-dd HH:mm:ss"
		});
		formatterDateTime.format(data, 2);
		// Create and draw devices table
		var tableDevice = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableDevice.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
	}

	function drawDeviceTableForManyNos(jsonArrayDevice) {
		// Create and populate the devices table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "MAC");
		data.addColumn("string", "IP");
		data.addColumn("date", "Last Seen");
		data.addColumn("string", "Switch");
		data.addColumn("number", "Port");
		data.addColumn("string", "NOS Service IP");
		data.addColumn("string", "NOS Service Port");
		data.addColumn("string", "NOS Type");
		data.addRows(jsonArrayDevice.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArrayDevice.length; i++) {
			data.setCell(i, 0, jsonArrayDevice[i].dataLayerAddress, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArrayDevice[i].networkAddresses, undefined,
					centerTextOpt);
			data.setCell(i, 2, new Date(jsonArrayDevice[i].lastSeen),
					undefined, centerTextOpt);
			data.setCell(i, 3, jsonArrayDevice[i].switchDpid, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArrayDevice[i].port, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArrayDevice[i].nosIp, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArrayDevice[i].nosPort, undefined,
					centerTextOpt);
			data.setCell(i, 7, jsonArrayDevice[i].nosType, undefined,
					centerTextOpt);
		}
		// Create and apply date formatter pattern
		var formatterDateTime = new google.visualization.DateFormat({
			pattern : "yyyy-MM-dd HH:mm:ss"
		});
		formatterDateTime.format(data, 2);
		// Create and draw devices table
		var tableDevice = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableDevice.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
	}

	function drawLinkTable(jsonArrayLink) {
		// Create and populate the links table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Source Id");
		data.addColumn("number", "Source Port");
		data.addColumn("string", "Destination Id");
		data.addColumn("number", "Destination Port");
		data.addRows(jsonArrayLink.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArrayLink.length; i++) {
			data.setCell(i, 0, jsonArrayLink[i].dataLayerSource, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArrayLink[i].portSource, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArrayLink[i].dataLayerDestination,
					undefined, centerTextOpt);
			data.setCell(i, 3, jsonArrayLink[i].portDestination, undefined,
					centerTextOpt);
		}
		// Create and draw devices table
		var tableLink = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableLink.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
	}

	function drawLinkTableForManyNos(jsonArrayLink) {
		// Create and populate the links table
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Source Id");
		data.addColumn("number", "Source Port");
		data.addColumn("string", "Destination Id");
		data.addColumn("number", "Destination Port");
		data.addColumn("string", "NOS Service IP");
		data.addColumn("string", "NOS Service Port");
		data.addColumn("string", "NOS Type");
		data.addRows(jsonArrayLink.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArrayLink.length; i++) {
			data.setCell(i, 0, jsonArrayLink[i].dataLayerSource, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArrayLink[i].portSource, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArrayLink[i].dataLayerDestination,
					undefined, centerTextOpt);
			data.setCell(i, 3, jsonArrayLink[i].portDestination, undefined,
					centerTextOpt);
			data
					.setCell(i, 4, jsonArrayLink[i].nosIp, undefined,
							centerTextOpt);
			data.setCell(i, 5, jsonArrayLink[i].nosPort, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArrayLink[i].nosType, undefined,
					centerTextOpt);
		}
		// Create and draw devices table
		var tableLink = new google.visualization.Table(document
				.getElementById("nosDetailTable_div"));
		tableLink.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("nosDetail_div");
	}

	function drawSwitchFlowTable(jsonArraySwitchFlow) {
		// Create and populate the switch flows table
		var data = new google.visualization.DataTable();
		data.addColumn("number", "In Port");
		data.addColumn("string", "DataLayer Source");
		data.addColumn("string", "DataLayer Destination");
		data.addColumn("number", "DataLayer Type");
		data.addColumn("string", "Network Source");
		data.addColumn("string", "Network Destination");
		data.addColumn("number", "Network Protocol");
		data.addColumn("number", "Transport Source");
		data.addColumn("number", "Transport Destination");
		data.addColumn("number", "Wildcards");
		data.addColumn("number", "Bytes");
		data.addColumn("number", "Packets");
		data.addColumn("number", "Time (s)");
		data.addColumn("number", "Idle TimeOut");
		data.addColumn("number", "Hard TimeOut");
		data.addColumn("number", "Cookie");
		data.addColumn("string", "Out Ports");
		data.addRows(jsonArraySwitchFlow.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitchFlow.length; i++) {
			// 			data.setCell(i, 0, jsonArraySwitchFlow[i].inPort, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 1, jsonArraySwitchFlow[i].dataLayerSource,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 2, jsonArraySwitchFlow[i].dataLayerDestination,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 3, jsonArraySwitchFlow[i].dataLayerType, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 4, jsonArraySwitchFlow[i].networkSource, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 5, jsonArraySwitchFlow[i].networkDestination,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 6, jsonArraySwitchFlow[i].networkProtocol,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 7, jsonArraySwitchFlow[i].transportSource,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 8, jsonArraySwitchFlow[i].transportDestination,
			// 					undefined, centerTextOpt);
			// 			data.setCell(i, 9, jsonArraySwitchFlow[i].wildcards, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 10, jsonArraySwitchFlow[i].bytes, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 11, jsonArraySwitchFlow[i].packets, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 12, jsonArraySwitchFlow[i].time, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 13, jsonArraySwitchFlow[i].idleTimeout, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 14, jsonArraySwitchFlow[i].hardTimeout, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 15, jsonArraySwitchFlow[i].cookie, undefined,
			// 					centerTextOpt);
			// 			data.setCell(i, 16, jsonArraySwitchFlow[i].outports, undefined,
			// 					centerTextOpt);

			data.setCell(i, 0, jsonArraySwitchFlow[i].i, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitchFlow[i].lS, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitchFlow[i].lD, undefined,
					centerTextOpt);
			data.setCell(i, 3, jsonArraySwitchFlow[i].lT, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArraySwitchFlow[i].nS, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArraySwitchFlow[i].nD, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArraySwitchFlow[i].nP, undefined,
					centerTextOpt);
			data.setCell(i, 7, jsonArraySwitchFlow[i].tS, undefined,
					centerTextOpt);
			data.setCell(i, 8, jsonArraySwitchFlow[i].tD, undefined,
					centerTextOpt);
			data.setCell(i, 9, jsonArraySwitchFlow[i].w, undefined,
					centerTextOpt);
			data.setCell(i, 10, jsonArraySwitchFlow[i].b, undefined,
					centerTextOpt);
			data.setCell(i, 11, jsonArraySwitchFlow[i].p, undefined,
					centerTextOpt);
			data.setCell(i, 12, jsonArraySwitchFlow[i].t, undefined,
					centerTextOpt);
			data.setCell(i, 13, jsonArraySwitchFlow[i].iT, undefined,
					centerTextOpt);
			data.setCell(i, 14, jsonArraySwitchFlow[i].hT, undefined,
					centerTextOpt);
			data.setCell(i, 15, jsonArraySwitchFlow[i].c, undefined,
					centerTextOpt);
			data.setCell(i, 16, jsonArraySwitchFlow[i].oP, undefined,
					centerTextOpt);

		}
		// Create and draw switches table
		var tableSwitchFlow = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchFlow.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			width : "100%",
			page : "enable",
			pageSize : 10
		});
		show("switchDetail_div");
	}

	function drawSwitchFlowTableForManySwitches(jsonArraySwitchFlow) {
		// Create and populate the switch flows table
		var data = new google.visualization.DataTable();
		data.addColumn("number", "In Port");
		data.addColumn("string", "DataLayer Source");
		data.addColumn("string", "DataLayer Destination");
		data.addColumn("number", "DataLayer Type");
		data.addColumn("string", "Network Source");
		data.addColumn("string", "Network Destination");
		data.addColumn("number", "Network Protocol");
		data.addColumn("number", "Transport Source");
		data.addColumn("number", "Transport Destination");
		data.addColumn("number", "Wildcards");
		data.addColumn("number", "Bytes");
		data.addColumn("number", "Packets");
		data.addColumn("number", "Time (s)");
		data.addColumn("number", "Idle TimeOut");
		data.addColumn("number", "Hard TimeOut");
		data.addColumn("number", "Cookie");
		data.addColumn("string", "Out Ports");
		data.addColumn("string", "Switch Id");
		data.addColumn("string", "NOS Service IP");
		data.addColumn("string", "NOS Service Port");
		data.addColumn("string", "NOS Type");
		data.addRows(jsonArraySwitchFlow.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitchFlow.length; i++) {
			data.setCell(i, 0, jsonArraySwitchFlow[i].i, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitchFlow[i].lS, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitchFlow[i].lD, undefined,
					centerTextOpt);
			data.setCell(i, 3, jsonArraySwitchFlow[i].lT, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArraySwitchFlow[i].nS, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArraySwitchFlow[i].nD, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArraySwitchFlow[i].nP, undefined,
					centerTextOpt);
			data.setCell(i, 7, jsonArraySwitchFlow[i].tS, undefined,
					centerTextOpt);
			data.setCell(i, 8, jsonArraySwitchFlow[i].tD, undefined,
					centerTextOpt);
			data.setCell(i, 9, jsonArraySwitchFlow[i].w, undefined,
					centerTextOpt);
			data.setCell(i, 10, jsonArraySwitchFlow[i].b, undefined,
					centerTextOpt);
			data.setCell(i, 11, jsonArraySwitchFlow[i].p, undefined,
					centerTextOpt);
			data.setCell(i, 12, jsonArraySwitchFlow[i].t, undefined,
					centerTextOpt);
			data.setCell(i, 13, jsonArraySwitchFlow[i].iT, undefined,
					centerTextOpt);
			data.setCell(i, 14, jsonArraySwitchFlow[i].hT, undefined,
					centerTextOpt);
			data.setCell(i, 15, jsonArraySwitchFlow[i].c, undefined,
					centerTextOpt);
			data.setCell(i, 16, jsonArraySwitchFlow[i].oP, undefined,
					centerTextOpt);
			data.setCell(i, 17, jsonArraySwitchFlow[i].sI, undefined,
					centerTextOpt);
			data.setCell(i, 18, jsonArraySwitchFlow[i].cI, undefined,
					centerTextOpt);
			data.setCell(i, 19, jsonArraySwitchFlow[i].cP, undefined,
					centerTextOpt);
			data.setCell(i, 20, jsonArraySwitchFlow[i].cT, undefined,
					centerTextOpt);
		}
		// Create and draw switches table
		var tableSwitchFlow = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchFlow.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			width : "100%",
			page : "enable",
			pageSize : 10
		});
		show("switchDetail_div");
	}

	function drawSwitchTableTable(jsonArraySwitchTable) {
		// Create and populate the switch flows table
		var data = new google.visualization.DataTable();
		data.addColumn("number", "Id");
		data.addColumn("string", "Name");
		data.addColumn("string", "Wildcards");
		data.addColumn("number", "Max Entries");
		data.addColumn("number", "Active Count");
		data.addColumn("number", "Lookup Count");
		data.addColumn("number", "Matched Count");
		data.addRows(jsonArraySwitchTable.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitchTable.length; i++) {
			data.setCell(i, 0, jsonArraySwitchTable[i].id, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitchTable[i].name, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitchTable[i].wildcards, undefined,
					centerTextOpt);
			data.setCell(i, 3, jsonArraySwitchTable[i].maxEntries, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArraySwitchTable[i].activeCount, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArraySwitchTable[i].lookupCount, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArraySwitchTable[i].matchedCount, undefined,
					centerTextOpt);
		}
		// Create and draw switches table
		var tableSwitchTable = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchTable.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("switchDetail_div");
	}

	function drawSwitchPortTable(jsonArraySwitchPort) {
		// Create and populate the switch flows table
		var data = new google.visualization.DataTable();
		data.addColumn("number", "Port Number");
		data.addColumn("number", "RX Packets");
		data.addColumn("number", "TX Packets");
		data.addColumn("number", "RX Bytes");
		data.addColumn("number", "TX Bytes");
		data.addColumn("number", "RX Drop");
		data.addColumn("number", "TX Drop");
		data.addColumn("number", "RX Error");
		data.addColumn("number", "TX Error");
		data.addColumn("number", "RX Frame Error");
		data.addColumn("number", "RX Overrun Error");
		data.addColumn("number", "RX CRC Error");
		data.addColumn("number", "Collisions");
		data.addRows(jsonArraySwitchPort.length);
		var centerTextOpt = {
			className : "center-text border-cell"
		};
		for ( var i = 0; i < jsonArraySwitchPort.length; i++) {
			data.setCell(i, 0, jsonArraySwitchPort[i].number, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitchPort[i].rxPackets, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitchPort[i].txPackets, undefined,
					centerTextOpt);
			data.setCell(i, 3, jsonArraySwitchPort[i].rxBytes, undefined,
					centerTextOpt);
			data.setCell(i, 4, jsonArraySwitchPort[i].txBytes, undefined,
					centerTextOpt);
			data.setCell(i, 5, jsonArraySwitchPort[i].rxDrops, undefined,
					centerTextOpt);
			data.setCell(i, 6, jsonArraySwitchPort[i].txDrops, undefined,
					centerTextOpt);
			data.setCell(i, 7, jsonArraySwitchPort[i].rxError, undefined,
					centerTextOpt);
			data.setCell(i, 8, jsonArraySwitchPort[i].txError, undefined,
					centerTextOpt);
			data.setCell(i, 9, jsonArraySwitchPort[i].rxFrameError, undefined,
					centerTextOpt);
			data.setCell(i, 10, jsonArraySwitchPort[i].rxOverrunError,
					undefined, centerTextOpt);
			data.setCell(i, 11, jsonArraySwitchPort[i].rxCrcError, undefined,
					centerTextOpt);
			data.setCell(i, 12, jsonArraySwitchPort[i].collisions, undefined,
					centerTextOpt);
		}
		// Create and draw switches table
		var tableSwitchPort = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchPort.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		show("switchDetail_div");
	}

	function onSwitchesButton() {
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		jsonSwitchList = null;
		switchId = null;
		if (jsonNosList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET", "http://" + servicePathNos
						+ "/switches", true);
				AJAXrequest.onreadystatechange = handlerSwitches;
				AJAXrequest.send();
			} else {
				AJAXrequest.open("GET",
						"http://127.0.0.1:8080/systembackend/serviceNos/switch.jsp?nosList="
								+ JSON.stringify(jsonNosList), true);
				AJAXrequest.onreadystatechange = handlerSwitches;
				AJAXrequest.send();
			}
			var jsonNos = jsonNosList[0];
			var title = "Switches on Slice (IP = " + jsonNos.ip + ", Port = "
					+ jsonNos.port + ", Type = " + jsonNos.type + ")";
			document.getElementById("nosDetail_title").innerHTML = title;
		} else if (jsonNosList.length > 1 && jsonNosList.length <= 5) {
			AJAXrequest.open("GET",
					"http://127.0.0.1:8080/systembackend/serviceNos/switch.jsp?nosList="
							+ JSON.stringify(jsonNosList), true);
			AJAXrequest.onreadystatechange = handlerSwitchesForManyNos;
			AJAXrequest.send();
			document.getElementById("nosDetail_title").innerHTML = "Switches on Slice";
		} else {
			alert('You must select at least 1 NOS and maximum 5 NOSs');
		}
	}

	function onDevicesButton() {
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		jsonSwitchList = null;
		switchId = null;
		if (jsonNosList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET",
						"http://" + servicePathNos + "/devices", true);
				AJAXrequest.onreadystatechange = handlerDevices;
				AJAXrequest.send();
			} else {
				AJAXrequest.open("GET",
						"http://127.0.0.1:8080/systembackend/serviceNos/device.jsp?nosList="
								+ JSON.stringify(jsonNosList), true);
				AJAXrequest.onreadystatechange = handlerDevices;
				AJAXrequest.send();
			}
			var jsonNos = jsonNosList[0];
			var title = "Devices on Slice (IP = " + jsonNos.ip + ", Port = "
					+ jsonNos.port + ", Type = " + jsonNos.type + ")";
			document.getElementById("nosDetail_title").innerHTML = title;
		} else if (jsonNosList.length > 1 && jsonNosList.length <= 5) {
			AJAXrequest.open("GET",
					"http://127.0.0.1:8080/systembackend/serviceNos/device.jsp?nosList="
							+ JSON.stringify(jsonNosList), true);
			AJAXrequest.onreadystatechange = handlerDevicesForManyNos;
			AJAXrequest.send();
			document.getElementById("nosDetail_title").innerHTML = "Devices on Slice";
		} else {
			alert('You must select at least 1 NOS and maximum 5 NOSs');
		}
	}

	function onLinksButton() {
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		jsonSwitchList = null;
		switchId = null;
		if (jsonNosList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET", "http://" + servicePathNos + "/links",
						true);
				AJAXrequest.onreadystatechange = handlerLinks;
				AJAXrequest.send();
			} else {
				AJAXrequest.open("GET",
						"http://127.0.0.1:8080/systembackend/serviceNos/link.jsp?nosList="
								+ JSON.stringify(jsonNosList), true);
				AJAXrequest.onreadystatechange = handlerLinks;
				AJAXrequest.send();
			}
			var jsonNos = jsonNosList[0];
			var title = "Links on Slice (IP = " + jsonNos.ip + ", Port = "
					+ jsonNos.port + ", Type = " + jsonNos.type + ")";
			document.getElementById("nosDetail_title").innerHTML = title;
		} else if (jsonNosList.length > 1 && jsonNosList.length <= 5) {
			AJAXrequest.open("GET",
					"http://127.0.0.1:8080/systembackend/serviceNos/link.jsp?nosList="
							+ JSON.stringify(jsonNosList), true);
			AJAXrequest.onreadystatechange = handlerLinksForManyNos;
			AJAXrequest.send();
			document.getElementById("nosDetail_title").innerHTML = "Links on Slice";
		} else {
			alert('You must select at least 1 NOS and maximum 5 NOSs');
		}
	}

	function onFlowsButton() {
		hide("switchDetail_div");
		if (jsonSwitchList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET", "http://" + servicePathNos + "/switch/"
						+ switchId + "/flows", true);
				AJAXrequest.onreadystatechange = handlerSwitchFlows;
				AJAXrequest.send();
			} else {
				AJAXrequest.open("GET",
						"http://127.0.0.1:8080/systembackend/serviceNos/switchflow.jsp?switchList="
								+ JSON.stringify(jsonSwitchList), true);
				AJAXrequest.onreadystatechange = handlerSwitchFlows;
				AJAXrequest.send();
			}
			var jsonSwitch = jsonSwitchList[0];
			var title = "Flows on Switch (ID = " + jsonSwitch.swId + ")";
			document.getElementById("switchDetail_title").innerHTML = title;
		} else if (jsonSwitchList.length > 1) {
			// 		else if (jsonSwitchList.length > 1 && jsonSwitchList.length <= 10) {
			AJAXrequest.open("GET",
					"http://127.0.0.1:8080/systembackend/serviceNos/switchflow.jsp?switchList="
							+ JSON.stringify(jsonSwitchList), true);
			AJAXrequest.onreadystatechange = handlerSwitchFlowsForManySwitches;
			AJAXrequest.send();
			document.getElementById("switchDetail_title").innerHTML = "Flows on Switches";
		} else {
			alert('You must select at least 1 switch and maximum 10 switches');
		}
	}

	function onTablesButton() {
		hide("switchDetail_div");
		if (jsonSwitchList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET", "http://" + servicePathNos + "/switch/"
						+ switchId + "/tables", true);
				AJAXrequest.onreadystatechange = handlerSwitchTables;
				AJAXrequest.send();
			} else {
				alert('Function only implemented for NOSs Beacon and POX');
			}
			var jsonSwitch = jsonSwitchList[0];
			var title = "Tables on Switch (ID = " + jsonSwitch.swId + ")";
			document.getElementById("switchDetail_title").innerHTML = title;
		} else {
			alert('You must select 1 switch');
		}
	}

	function onPortsButton() {
		hide("switchDetail_div");
		if (jsonSwitchList.length == 1) {
			if (servicePathNos != "unknown") {
				AJAXrequest.open("GET", "http://" + servicePathNos + "/switch/"
						+ switchId + "/ports", true);
				AJAXrequest.onreadystatechange = handlerSwitchPorts;
				AJAXrequest.send();
			} else {
				alert('Function only implemented for NOSs Beacon and POX');
			}
			var jsonSwitch = jsonSwitchList[0];
			var title = "Ports on Switch (ID = " + jsonSwitch.swId + ")";
			document.getElementById("switchDetail_title").innerHTML = title;
		} else {
			alert('You must select 1 switch');
		}
	}
</script>
</head>
<body style="font-family: Arial; border: 0 none;" onload="init();">
	<div id="container_div">
		<div id="header_div">
			<center>
			<h1>Slice Monitoring Mashup</h1>
			</center>
		</div>
		<div id="left_div"></div>
		<div id="content_div">
			<table align="center" cellspacing="2" cellpadding="2">
				<tr>
					<td align="center" id="nosInfo_div">
						<div class="style-title">Slice General Information</div>
						<div id="nosInfoTable_div" />
					</td>
				</tr>
				<tr>
					<td></td>
				</tr>
				<tr>
					<td align="center" id="nosOpts_div">
						<button type="button" onclick="onSwitchesButton()">Switches
							on Slice</button>
						<button type="button" onclick="onDevicesButton()">Devices
							on Slice</button>
						<button type="button" onclick="onLinksButton()">Links on
							Slice</button>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table align="center" cellspacing="2" cellpadding="2">
				<tr>
					<td align="center" id="nosDetail_div">
						<div id="nosDetail_title" class="style-title">Slice Detailed
							Information</div>
						<div id="nosDetailTable_div" />
					</td>
				</tr>
				<tr>
					<td></td>
				</tr>
				<tr>
					<td align="center" id="switchOpts_div">
						<button type="button" onclick="onFlowsButton()">Flows on
							Switches</button>
						<button type="button" onclick="onTablesButton()">Tables
							on Switches</button>
						<button type="button" onclick="onPortsButton()">Ports on
							Switches</button>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
			</table>
			<table align="center" cellspacing="2" cellpadding="2" width="90%">
				<tr>
					<td align="center" id="switchDetail_div">
						<div id="switchDetail_title" class="style-title">Switch
							Detailed Information</div>
						<div id="switchDetailTable_div" />
					</td>
				</tr>
			</table>
		</div>
		<div id="footer_div"></div>
	</div>
</body>
</html>