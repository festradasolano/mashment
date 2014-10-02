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
<title>Monitor Controller</title>
<link href="css/layout.css" type="text/css" rel="stylesheet"></link>
<link rel="stylesheet"
	href="http://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>
<script type="text/javascript" src="http://www.google.com/jsapi"></script>
<script type="text/javascript">
	google.load('visualization', '1', {
		packages : [ 'corechart, orgchart,table' ]
	});
</script>
<script type="text/javascript">
	// XML HTTP request
	var AJAXrequest = createXMLHttpRequest();

	// Params received
	var params = null;

	// Monitored NOS
	var jsonNos = null;

	// Switches selected
	var jsonSwitchList = null;

	// Format for Google JSAPI table data
	var centerTextOpt = {
		className : "center-text border-cell"
	};

	// Creates a XML HTTP request
	function createXMLHttpRequest() {
		// See http://en.wikipedia.org/wiki/XMLHttpRequest
		// Provide the XMLHttpRequest class for IE 5.x-6.x:
		if (typeof XMLHttpRequest == "undefined")
			XMLHttpRequest = function() {
				try {
					return new ActiveXObject("Msxml2.XMLHTTP.6.0");
				} catch (e) {
				}
				try {
					return new ActiveXObject("Msxml2.XMLHTTP.3.0");
				} catch (e) {
				}
				try {
					return new ActiveXObject("Msxml2.XMLHTTP");
				} catch (e) {
				}
				try {
					return new ActiveXObject("Microsoft.XMLHTTP");
				} catch (e) {
				}
				throw new Error("This browser does not support XMLHttpRequest.");
			};
		return new XMLHttpRequest();
	}

	// Handles AJAX request sent on init
	function handlerInit() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonNosInfo = eval("(" + AJAXrequest.responseText + ")");
			// Draw NOS information table
			drawNosInfoTable(jsonNosInfo);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert("Something went wrong...");
		}
	}

	// Handles AJAX request sent on switches button
	function handlerSwitches() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArraySwitch = eval("(" + AJAXrequest.responseText + ")");
			// Draw switches table
			drawSwitchTable(jsonArraySwitch);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on devices button
	function handlerDevices() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayDevice = eval("(" + AJAXrequest.responseText + ")");
			// Draw devices table
			drawDeviceTable(jsonArrayDevice);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on links button
	function handlerLinks() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayLink = eval("(" + AJAXrequest.responseText + ")");
			// Draw links table
			drawLinkTable(jsonArrayLink);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on flows button
	function handlerSwitchFlows() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArraySwitchFlow = eval("(" + AJAXrequest.responseText + ")");
			// Draw flows table
			drawSwitchFlowTable(jsonArraySwitchFlow);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on tables button
	function handlerSwitchTables() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArraySwitchTable = eval("(" + AJAXrequest.responseText
					+ ")");
			// Draw tables table
			drawSwitchTableTable(jsonArraySwitchTable);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on ports button
	function handlerSwitchPorts() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArraySwitchPort = eval("(" + AJAXrequest.responseText + ")");
			// Draw ports table
			drawSwitchPortTable(jsonArraySwitchPort);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}
</script>
<script type="text/javascript">
	// Hides the element
	function hide(element) {
		// Get element by ID
		var visElement = document.getElementById(element);
		// Set element visibility to hidden
		visElement.style.visibility = "hidden";
	}

	// Shows the element
	function show(element) {
		// Get element by ID
		var visElement = document.getElementById(element);
		// Set element visibility to visible
		visElement.style.visibility = "visible";
	}

	// Init function
	function init() {
		// Hide divisions
		hide("nosInfo_div");
		hide("nosOpts_div");
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Obtain NOS parameters
		var input =
<%String r = request.getParameter("params");
			out.print(r);%>
	;
		params = input;
		// Send AJAX request to obtain NOS information
		AJAXrequest.open("GET", "serviceNos/singleNosInfo.jsp?nos=" + params,
				true);
		AJAXrequest.onreadystatechange = handlerInit;
		AJAXrequest.send();
	}

	// Draw NOS information table
	function drawNosInfoTable(jsonNosInfo) {
		// Create NOS information data columns
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Service IP");
		data.addColumn("string", "Service Port");
		data.addColumn("string", "Type");
		data.addColumn("string", "Listen Address");
		data.addColumn("number", "Listen Port");
		// Populate NOS information data
		data.addRows(1);
		data.setCell(0, 0, jsonNosInfo.ip, undefined, centerTextOpt);
		data.setCell(0, 1, jsonNosInfo.port, undefined, centerTextOpt);
		data.setCell(0, 2, jsonNosInfo.type, undefined, centerTextOpt);
		if (jsonNosInfo.listenAddress == "*"
				|| jsonNosInfo.listenAddress == "0.0.0.0") {
			data.setCell(0, 3, "any", undefined, centerTextOpt);
		} else {
			data.setCell(0, 3, jsonNosInfo.listenAddress, undefined,
					centerTextOpt);
		}
		data.setCell(0, 4, jsonNosInfo.listenPort, undefined, centerTextOpt);
		// Create and draw NOS information table
		var tableNosInfo = new google.visualization.Table(document
				.getElementById("nosInfoTable_div"));
		tableNosInfo.draw(data, {
			allowHtml : true,
			showRowNumber : false
		});
		// Show and hide divisions
		show("nosInfo_div");
		show("nosOpts_div");
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNos = jsonNosInfo;
		jsonSwitchList = null;
	}

	// Draw switches table
	function drawSwitchTable(jsonArraySwitch) {
		// Create switches data columns
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
		// Populate switches data
		data.addRows(jsonArraySwitch.length);
		for ( var i = 0; i < jsonArraySwitch.length; i++) {
			data.setCell(i, 0, jsonArraySwitch[i].dpid, undefined,
					centerTextOpt);
			data.setCell(i, 1, jsonArraySwitch[i].remoteIp, undefined,
					centerTextOpt);
			data.setCell(i, 2, jsonArraySwitch[i].remotePort, undefined,
					centerTextOpt);
			data.setCell(i, 3, new Date(jsonArraySwitch[i].connectedSince),
					undefined, centerTextOpt);
			// 			data.setCell(i, 4, jsonArraySwitch[i].serialNumber, undefined, centerTextOpt);
			// 			data.setCell(i, 5, jsonArraySwitch[i].manufacturer, undefined, centerTextOpt);
			// 			data.setCell(i, 6, jsonArraySwitch[i].hardware, undefined, centerTextOpt);
			// 			data.setCell(i, 7, jsonArraySwitch[i].software, undefined, centerTextOpt);
			// 			data.setCell(i, 8, jsonArraySwitch[i].datapath, undefined, centerTextOpt);
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
		// Show NOS detail division
		show("nosDetail_div");
		// Add event listener for event SELECT
		google.visualization.events.addListener(tableSwitch, "select",
				selectTableHandler);
		// Function for event SELECT
		function selectTableHandler() {
			selectSwitchHandler(tableSwitch.getSelection(), data);
		}
	}

	// Function for event SELECT on switches table
	function selectSwitchHandler(selection, data) {
		// Hide divisions
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonSwitchList = null;
		// Number of switches selected? non-zero
		if (selection.length != 0) {
			jsonSwitchList = [];
			for ( var i = 0; i < selection.length; i++) {
				var item = selection[i];
				var swId = data.getFormattedValue(item.row, 0);
				var jsonSwitch = {
					"swId" : swId,
				};
				jsonSwitchList[i] = jsonSwitch;
			}
			// Show switch options
			show("switchOpts_div");
		}
	}

	// Draw devices table
	function drawDeviceTable(jsonArrayDevice) {
		// Create devices data columns
		var data = new google.visualization.DataTable();
		data.addColumn("string", "MAC");
		data.addColumn("string", "IP");
		data.addColumn("date", "Last Seen");
		data.addColumn("string", "Switch");
		data.addColumn("number", "Port");
		// Populate devices data
		data.addRows(jsonArrayDevice.length);
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
		// Show NOS detail division
		show("nosDetail_div");
	}

	// Draw links table
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
		// Show NOS detail division
		show("nosDetail_div");
	}

	// Draw flows table
	function drawSwitchFlowTable(jsonArraySwitchFlow) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArraySwitchFlow.length == 1) {
			// Create flows data columns for single switch selected
			createFlowsDataColumns(data);
			// Populate flows data for single switch selected
			var jsonArrayFlow = jsonArraySwitchFlow[0].jsonArrayFlow;
			data.addRows(jsonArrayFlow.length);
			for ( var i = 0; i < jsonArrayFlow.length; i++) {
				populateFlowDataRow(data, i, jsonArrayFlow[i]);
			}
		} else {
			// Create flows data columns for multiple switches selected
			createFlowsDataColumns(data);
			data.addColumn("string", "Switch Id");
			// Populate flows data for multiple switches selected
			var index = 0;
			for ( var i = 0; i < jsonArraySwitchFlow.length; i++) {
				var swId = jsonArraySwitchFlow[i].swId;
				var jsonArrayFlow = jsonArraySwitchFlow[i].jsonArrayFlow;
				data.addRows(jsonArrayFlow.length);
				for ( var j = 0; j < jsonArrayFlow.length; j++) {
					populateFlowDataRow(data, index + j, jsonArrayFlow[j]);
					data.setCell(index + j, 17, swId, undefined, centerTextOpt);
				}
				index = index + jsonArrayFlow.length;
			}
		}
		// Create and draw flows table
		var tableSwitchFlow = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchFlow.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			width : "100%",
			page : "enable",
			pageSize : 10
		});
		// Show switch detail division
		show("switchDetail_div");
	}

	// Create flows data columns
	function createFlowsDataColumns(data) {
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
	}

	// Populate flow data row
	function populateFlowDataRow(data, index, jsonFlow) {
		// Long format
		data.setCell(index, 0, jsonFlow.inPort, undefined, centerTextOpt);
		data.setCell(index, 1, jsonFlow.dataLayerSource, undefined,
				centerTextOpt);
		data.setCell(index, 2, jsonFlow.dataLayerDestination, undefined,
				centerTextOpt);
		data
				.setCell(index, 3, jsonFlow.dataLayerType, undefined,
						centerTextOpt);
		data
				.setCell(index, 4, jsonFlow.networkSource, undefined,
						centerTextOpt);
		data.setCell(index, 5, jsonFlow.networkDestination, undefined,
				centerTextOpt);
		data.setCell(index, 6, jsonFlow.networkProtocol, undefined,
				centerTextOpt);
		data.setCell(index, 7, jsonFlow.transportSource, undefined,
				centerTextOpt);
		data.setCell(index, 8, jsonFlow.transportDestination, undefined,
				centerTextOpt);
		data.setCell(index, 9, jsonFlow.wildcards, undefined, centerTextOpt);
		data.setCell(index, 10, jsonFlow.bytes, undefined, centerTextOpt);
		data.setCell(index, 11, jsonFlow.packets, undefined, centerTextOpt);
		data.setCell(index, 12, jsonFlow.time, undefined, centerTextOpt);
		data.setCell(index, 13, jsonFlow.idleTimeout, undefined, centerTextOpt);
		data.setCell(index, 14, jsonFlow.hardTimeout, undefined, centerTextOpt);
		data.setCell(index, 15, jsonFlow.cookie, undefined, centerTextOpt);
		data.setCell(index, 16, jsonFlow.outports, undefined, centerTextOpt);
		// Short format
		// 		data.setCell(index, 0, jsonFlow.i, undefined, centerTextOpt);
		// 		data.setCell(index, 1, jsonFlow.lS, undefined, centerTextOpt);
		// 		data.setCell(index, 2, jsonFlow.lD, undefined, centerTextOpt);
		// 		data.setCell(index, 3, jsonFlow.lT, undefined, centerTextOpt);
		// 		data.setCell(index, 4, jsonFlow.nS, undefined, centerTextOpt);
		// 		data.setCell(index, 5, jsonFlow.nD, undefined, centerTextOpt);
		// 		data.setCell(index, 6, jsonFlow.nP, undefined, centerTextOpt);
		// 		data.setCell(index, 7, jsonFlow.tS, undefined, centerTextOpt);
		// 		data.setCell(index, 8, jsonFlow.tD, undefined, centerTextOpt);
		// 		data.setCell(index, 9, jsonFlow.w, undefined, centerTextOpt);
		// 		data.setCell(index, 10, jsonFlow.b, undefined, centerTextOpt);
		// 		data.setCell(index, 11, jsonFlow.p, undefined, centerTextOpt);
		// 		data.setCell(index, 12, jsonFlow.t, undefined, centerTextOpt);
		// 		data.setCell(index, 13, jsonFlow.iT, undefined, centerTextOpt);
		// 		data.setCell(index, 14, jsonFlow.hT, undefined, centerTextOpt);
		// 		data.setCell(index, 15, jsonFlow.c, undefined, centerTextOpt);
		// 		data.setCell(index, 16, jsonFlow.oP, undefined, centerTextOpt);
	}

	// Draw tables table
	function drawSwitchTableTable(jsonArraySwitchTable) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArraySwitchTable.length == 1) {
			// Create tables data columns for single switch selected
			createTablesDataColumns(data);
			// Populate tables data
			var jsonArrayTable = jsonArraySwitchTable[0].jsonArrayTable;
			data.addRows(jsonArrayTable.length);
			for ( var i = 0; i < jsonArrayTable.length; i++) {
				populateTableDataRow(data, i, jsonArrayTable[i]);
			}
		} else {
			// Create tables data columns for multiple switches selected
			createTablesDataColumns(data);
			data.addColumn("string", "Switch Id");
			// Populate tables data
			var index = 0;
			for ( var i = 0; i < jsonArraySwitchTable.length; i++) {
				var swId = jsonArraySwitchTable[i].swId;
				var jsonArrayTable = jsonArraySwitchTable[i].jsonArrayTable;
				data.addRows(jsonArrayTable.length);
				for ( var j = 0; j < jsonArrayTable.length; j++) {
					populateTableDataRow(data, index + j, jsonArrayTable[j]);
					data.setCell(index + j, 7, swId, undefined, centerTextOpt);
				}
				index = index + jsonArrayTable.length;
			}
		}
		// Create and draw tables table
		var tableSwitchTable = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchTable.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		// Show switch detail division
		show("switchDetail_div");
	}

	// Create tables data columns
	function createTablesDataColumns(data) {
		data.addColumn("number", "Id");
		data.addColumn("string", "Name");
		data.addColumn("string", "Wildcards");
		data.addColumn("number", "Max Entries");
		data.addColumn("number", "Active Count");
		data.addColumn("number", "Lookup Count");
		data.addColumn("number", "Matched Count");
	}

	// Populate table data row
	function populateTableDataRow(data, index, jsonTable) {
		data.setCell(index, 0, jsonTable.id, undefined, centerTextOpt);
		data.setCell(index, 1, jsonTable.name, undefined, centerTextOpt);
		data.setCell(index, 2, jsonTable.wildcards, undefined, centerTextOpt);
		data.setCell(index, 3, jsonTable.maxEntries, undefined, centerTextOpt);
		data.setCell(index, 4, jsonTable.activeCount, undefined, centerTextOpt);
		data.setCell(index, 5, jsonTable.lookupCount, undefined, centerTextOpt);
		data
				.setCell(index, 6, jsonTable.matchedCount, undefined,
						centerTextOpt);
	}

	// Draw ports table
	function drawSwitchPortTable(jsonArraySwitchPort) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArraySwitchPort.length == 1) {
			// Create ports data columns for single switch selected
			createPortsDataColumns(data);
			// Populate ports data
			var jsonArrayPort = jsonArraySwitchPort[0].jsonArrayPort;
			data.addRows(jsonArrayPort.length);
			for ( var i = 0; i < jsonArrayPort.length; i++) {
				populatePortDataRow(data, i, jsonArrayPort[i]);
			}
		} else {
			// Create ports data columns for multiple switches selected
			createPortsDataColumns(data);
			data.addColumn("string", "Switch Id");
			// Populate ports data
			var index = 0;
			for ( var i = 0; i < jsonArraySwitchPort.length; i++) {
				var swId = jsonArraySwitchPort[i].swId;
				var jsonArrayPort = jsonArraySwitchPort[i].jsonArrayPort;
				data.addRows(jsonArrayPort.length);
				for ( var j = 0; j < jsonArrayPort.length; j++) {
					populatePortDataRow(data, index + j, jsonArrayPort[j]);
					data.setCell(index + j, 13, swId, undefined, centerTextOpt);
				}
				index = index + jsonArrayPort.length;
			}
		}
		// Create and draw ports table
		var tableSwitchPort = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchPort.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			page : "enable",
			pageSize : 10
		});
		// Show switch detail division
		show("switchDetail_div");
	}

	// Create ports data columns
	function createPortsDataColumns(data) {
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
	}

	// Populate port data row
	function populatePortDataRow(data, index, jsonPort) {
		data.setCell(index, 0, jsonPort.number, undefined, centerTextOpt);
		data.setCell(index, 1, jsonPort.rxPackets, undefined, centerTextOpt);
		data.setCell(index, 2, jsonPort.txPackets, undefined, centerTextOpt);
		data.setCell(index, 3, jsonPort.rxBytes, undefined, centerTextOpt);
		data.setCell(index, 4, jsonPort.txBytes, undefined, centerTextOpt);
		data.setCell(index, 5, jsonPort.rxDrops, undefined, centerTextOpt);
		data.setCell(index, 6, jsonPort.txDrops, undefined, centerTextOpt);
		data.setCell(index, 7, jsonPort.rxError, undefined, centerTextOpt);
		data.setCell(index, 8, jsonPort.txError, undefined, centerTextOpt);
		data.setCell(index, 9, jsonPort.rxFrameError, undefined, centerTextOpt);
		data.setCell(index, 10, jsonPort.rxOverrunError, undefined,
				centerTextOpt);
		data.setCell(index, 11, jsonPort.rxCrcError, undefined, centerTextOpt);
		data.setCell(index, 12, jsonPort.collisions, undefined, centerTextOpt);
	}

	// Obtain switches connected to NOS
	function onSwitchesButton() {
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonSwitchList = null;
		// Send AJAX request to obtain switches connected to NOS
		AJAXrequest.open("GET", "serviceNos/singleNosSwitch.jsp?nos="
				+ JSON.stringify(jsonNos), true);
		AJAXrequest.onreadystatechange = handlerSwitches;
		AJAXrequest.send();
		// Set switches title of NOS detail table
		var title = "Switches on " + jsonNos.type;
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain devices connected to NOS switches
	function onDevicesButton() {
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonSwitchList = null;
		// Send AJAX request to obtain devices connected to NOS switches
		AJAXrequest.open("GET", "serviceNos/singleNosDevice.jsp?nos="
				+ JSON.stringify(jsonNos), true);
		AJAXrequest.onreadystatechange = handlerDevices;
		AJAXrequest.send();
		// Set devices title of NOS detail table
		var title = "Devices on " + jsonNos.type;
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain links between NOS switches
	function onLinksButton() {
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonSwitchList = null;
		// Send AJAX request to obtain links between NOS switches
		AJAXrequest.open("GET", "serviceNos/singleNosLink.jsp?nos="
				+ JSON.stringify(jsonNos), true);
		AJAXrequest.onreadystatechange = handlerLinks;
		AJAXrequest.send();
		// Set links title of NOS detail table
		var title = "Links on " + jsonNos.type;
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain flows from selected switches
	function onFlowsButton() {
		// Number of selected switches? between 10 and 1
		if (jsonSwitchList.length > 10 && jsonSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain flows from selected switches
		AJAXrequest.open("GET", "serviceNos/singleNosSwitchFlow.jsp?nos="
				+ JSON.stringify(jsonNos) + "&switchList="
				+ JSON.stringify(jsonSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchFlows;
		AJAXrequest.send();
		// Set flows title of switch detail table
		var title;
		if (jsonSwitchList.length == 1) {
			title = "Flows on Switch (ID = " + jsonSwitchList[0].swId + ")";
		} else {
			title = "Flows on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
	}

	// Obtain ports from selected switches
	function onPortsButton() {
		// Number of selected switches? between 10 and 1
		if (jsonSwitchList.length > 10 && jsonSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain ports from selected switches
		AJAXrequest.open("GET", "serviceNos/singleNosSwitchPort.jsp?nos="
				+ JSON.stringify(jsonNos) + "&switchList="
				+ JSON.stringify(jsonSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchPorts;
		AJAXrequest.send();
		// Set ports title of switch detail table
		var title;
		if (jsonSwitchList.length == 1) {
			title = "Ports on Switch (ID = " + jsonSwitchList[0].swId + ")";
		} else {
			title = "Ports on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
	}

	// Obtain tables from selected switches
	function onTablesButton() {
		// Number of selected switches? between 10 and 1
		if (jsonSwitchList.length > 10 && jsonSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain tables from selected switches
		AJAXrequest.open("GET", "serviceNos/singleNosSwitchTable.jsp?nos="
				+ JSON.stringify(jsonNos) + "&switchList="
				+ JSON.stringify(jsonSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchTables;
		AJAXrequest.send();
		// Set tables title of switch detail table
		var title;
		if (jsonSwitchList.length == 1) {
			title = "Tables on Switch (ID = " + jsonSwitchList[0].swId + ")";
		} else {
			title = "Tables on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
	}
</script>
</head>
<body style="font-family: Arial; border: 0 none;" onload="init();">
	<div id="container_div">
		<div id="header_div">
			<center>
			<h1 style="font-size: 16pt">
				Floodlight Monitoring Mashup<br />-Runtime-
			</h1>
			</center>
		</div>
		<div id="left_div"></div>
		<div id="content_div">
			<table align="center" cellspacing="2" cellpadding="2">
				<tr>
					<td align="center" id="nosInfo_div">
						<div class="style-title">Floodlight General Information</div>
						<div id="nosInfoTable_div" />
					</td>
				</tr>
				<tr>
					<td></td>
				</tr>
				<tr>
					<td align="center" id="nosOpts_div">
						<button type="button" onclick="onSwitchesButton()"
							class="font-size-temp">Switches on NOS</button>
						<button type="button" onclick="onDevicesButton()"
							class="font-size-temp">Devices on NOS</button>
						<button type="button" onclick="onLinksButton()"
							class="font-size-temp">Links on NOS</button>
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
						<button type="button" onclick="onFlowsButton()"
							class="font-size-temp">Flows on Switch(es)</button>
						<button type="button" onclick="onTablesButton()"
							class="font-size-temp">Tables on Switch(es)</button>
						<button type="button" onclick="onPortsButton()"
							class="font-size-temp">Ports on Switch(es)</button>
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