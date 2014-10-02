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
<title>Monitor SDN</title>
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

	// NOSs selected
	var jsonNosList = null;

	// Switches selected
	var jsonNosSwitchList = null;

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
			// Draw NOSs information table
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
			var jsonArrayNosSwitch = eval("(" + AJAXrequest.responseText + ")");
			// Draw switches table
			drawSwitchTable(jsonArrayNosSwitch);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on devices button
	function handlerDevices() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayNosDevice = eval("(" + AJAXrequest.responseText + ")");
			// Draw devices table
			drawDeviceTable(jsonArrayNosDevice);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on links button
	function handlerLinks() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayNosLink = eval("(" + AJAXrequest.responseText + ")");
			// Draw links table
			drawLinkTable(jsonArrayNosLink);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on flows button
	function handlerSwitchFlows() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			// Obtain AJAX request response text
			var jsonArrayNosSwitchFlow = eval("(" + AJAXrequest.responseText
					+ ")");
			// Draw flows table
			drawSwitchFlowTable(jsonArrayNosSwitchFlow);
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
			var jsonArrayNosSwitchTable = eval("(" + AJAXrequest.responseText
					+ ")");
			// Draw tables table
			drawSwitchTableTable(jsonArrayNosSwitchTable);
		} else if (AJAXrequest.readyState == 4 && AJAXrequest.status != 200) {
			// Error
			alert('Something went wrong...');
		}
	}

	// Handles AJAX request sent on ports button
	function handlerSwitchPorts() {
		// AJAX request status? finished and OK : finished and non-OK
		if (AJAXrequest.readyState == 4 && AJAXrequest.status == 200) {
			var jsonArrayNosSwitchPort = eval("(" + AJAXrequest.responseText
					+ ")");
			// Draw ports table
			drawSwitchPortTable(jsonArrayNosSwitchPort);
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
		// Obtain NOSs parameters
		var input =
<%String r = request.getParameter("params");
			out.print(r);%>
	;
		params = input;
		// Send AJAX request to obtain NOSs information
		AJAXrequest.open("GET",
				"serviceNos/multiNosInfo.jsp?nosList=" + params, true);
		AJAXrequest.onreadystatechange = handlerInit;
		AJAXrequest.send();
	}

	// Draw NOSs information table
	function drawNosInfoTable(jsonArrayNosInfo) {
		// Create NOS information data columns
		var data = new google.visualization.DataTable();
		data.addColumn("string", "Service IP");
		data.addColumn("string", "Service Port");
		data.addColumn("string", "Type");
		data.addColumn("string", "Listen Address");
		data.addColumn("number", "Listen Port");
		// Populate NOS information data
		data.addRows(jsonArrayNosInfo.length);
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
		// Show NOS information division
		show("nosInfo_div");
		// Add event listener for event SELECT
		google.visualization.events.addListener(tableNosInfo, "select",
				selectTableHandler);
		// Function for event SELECT
		function selectTableHandler() {
			selectNosInfoHandler(tableNosInfo.getSelection(), data);
		}
	}

	// Function for event SELECT on NOSs information table
	function selectNosInfoHandler(selection, data) {
		// Hide divisions
		hide("nosOpts_div");
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNosList = null;
		jsonNosSwitchList = null;
		// Number of NOSs selected? non-zero
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
				};
				jsonNosList[i] = jsonNos;
			}
			// Show NOS options
			show("nosOpts_div");
		}
	}

	// Draw switches table
	function drawSwitchTable(jsonArrayNosSwitch) {
		var data = new google.visualization.DataTable();
		// Number of selected NOSs? single : multiple
		if (jsonArrayNosSwitch.length == 1) {
			// Create switches data columns for single NOS selected
			createSwitchesDataColumns(data);
			// Populate switches data for single NOS selected
			var jsonArraySwitch = jsonArrayNosSwitch[0].jsonArraySwitch;
			data.addRows(jsonArraySwitch.length);
			for ( var i = 0; i < jsonArraySwitch.length; i++) {
				populateSwitchDataRow(data, i, jsonArraySwitch[i]);
			}
		} else {
			// Create switches data columns for multiple NOSs selected
			createSwitchesDataColumns(data);
			data.addColumn("string", "NOS IP");
			data.addColumn("string", "NOS Port");
			data.addColumn("string", "NOS Type");
			// Populate switches data for multiple switches selected
			var index = 0;
			for ( var i = 0; i < jsonArrayNosSwitch.length; i++) {
				var nosIp = jsonArrayNosSwitch[i].nosIp;
				var nosPort = jsonArrayNosSwitch[i].nosPort;
				var nosType = jsonArrayNosSwitch[i].nosType;
				var jsonArraySwitch = jsonArrayNosSwitch[i].jsonArraySwitch;
				data.addRows(jsonArraySwitch.length);
				for ( var j = 0; j < jsonArraySwitch.length; j++) {
					populateSwitchDataRow(data, index + j, jsonArraySwitch[j]);
					data.setCell(index + j, 4, nosIp, undefined, centerTextOpt);
					data.setCell(index + j, 5, nosPort, undefined,
							centerTextOpt);
					data.setCell(index + j, 6, nosType, undefined,
							centerTextOpt);
				}
				index = index + jsonArraySwitch.length;
			}
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
		
		// TODO DELETE
		console.log(data.getNumberOfRows());
	}

	// Create switches data columns
	function createSwitchesDataColumns(data) {
		data.addColumn("string", "Id");
		data.addColumn("string", "IP Address");
		data.addColumn("number", "Port");
		data.addColumn("date", "Connected");
		// 		data.addColumn("string", "Serial Number");
		// 		data.addColumn("string", "Manufacturer");
		// 		data.addColumn("string", "Hardware");
		// 		data.addColumn("string", "Software");
		// 		data.addColumn("string", "Datapath");
	}

	// Populate switch data row
	function populateSwitchDataRow(data, index, jsonSwitch) {
		data.setCell(index, 0, jsonSwitch.dpid, undefined, centerTextOpt);
		data.setCell(index, 1, jsonSwitch.remoteIp, undefined, centerTextOpt);
		data.setCell(index, 2, jsonSwitch.remotePort, undefined, centerTextOpt);
		data.setCell(index, 3, new Date(jsonSwitch.connectedSince), undefined,
				centerTextOpt);
		// 			data.setCell(index, 4, jsonSwitch.serialNumber, undefined, centerTextOpt);
		// 			data.setCell(index, 5, jsonSwitch.manufacturer, undefined, centerTextOpt);
		// 			data.setCell(index, 6, jsonSwitch.hardware, undefined, centerTextOpt);
		// 			data.setCell(index, 7, jsonSwitch.software, undefined, centerTextOpt);
		// 			data.setCell(index, 8, jsonSwitch.datapath, undefined, centerTextOpt);

	}

	// Function for event SELECT on switches table
	function selectSwitchHandler(selection, data) {
		// Hide divisions
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNosSwitchList = null;
		// Number of switches selected? non-zero
		if (selection.length != 0) {
			jsonNosSwitchList = [];
			// Number of NOSs selected? single : multiple
			if (jsonNosList.length == 1) {
				var ip = jsonNosList[0].ip;
				var port = jsonNosList[0].port;
				var type = jsonNosList[0].type;
				for ( var i = 0; i < selection.length; i++) {
					var item = selection[i];
					var swId = data.getFormattedValue(item.row, 0);
					var jsonSwitch = {
						"swId" : swId,
						"nosIp" : ip,
						"nosPort" : port,
						"nosType" : type
					};
					jsonNosSwitchList[i] = jsonSwitch;
				}
			} else {
				for ( var i = 0; i < selection.length; i++) {
					var item = selection[i];
					var swId = data.getFormattedValue(item.row, 0);
					var ip = data.getFormattedValue(item.row, 4);
					var port = data.getFormattedValue(item.row, 5);
					var type = data.getFormattedValue(item.row, 6);
					var jsonSwitch = {
						"swId" : swId,
						"nosIp" : ip,
						"nosPort" : port,
						"nosType" : type
					};
					jsonNosSwitchList[i] = jsonSwitch;
				}
			}
			// Show switch options
			show("switchOpts_div");
		}
	}

	// Draw devices table
	function drawDeviceTable(jsonArrayNosDevice) {
		var data = new google.visualization.DataTable();
		// Number of selected NOSs? single : multiple
		if (jsonArrayNosDevice.length == 1) {
			// Create devices data columns for single NOS selected
			createDevicesDataColumns(data);
			// Populate devices data for single NOS selected
			var jsonArrayDevice = jsonArrayNosDevice[0].jsonArrayDevice;
			data.addRows(jsonArrayDevice.length);
			for ( var i = 0; i < jsonArrayDevice.length; i++) {
				populateDeviceDataRow(data, i, jsonArrayDevice[i]);
			}
		} else {
			// Create devices data columns for multiple NOSs selected
			createDevicesDataColumns(data);
			data.addColumn("string", "NOS IP");
			data.addColumn("string", "NOS Port");
			data.addColumn("string", "NOS Type");
			// Populate devices data for multiple NOSs selected
			var index = 0;
			for ( var i = 0; i < jsonArrayNosDevice.length; i++) {
				var nosIp = jsonArrayNosDevice[i].nosIp;
				var nosPort = jsonArrayNosDevice[i].nosPort;
				var nosType = jsonArrayNosDevice[i].nosType;
				var jsonArrayDevice = jsonArrayNosDevice[i].jsonArrayDevice;
				data.addRows(jsonArrayDevice.length);
				for ( var j = 0; j < jsonArrayDevice.length; j++) {
					populateDeviceDataRow(data, index + j, jsonArrayDevice[j]);
					data.setCell(index + j, 5, nosIp, undefined, centerTextOpt);
					data.setCell(index + j, 6, nosPort, undefined,
							centerTextOpt);
					data.setCell(index + j, 7, nosType, undefined,
							centerTextOpt);
				}
				index = index + jsonArrayDevice.length;
			}
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

	// Create devices data columns
	function createDevicesDataColumns(data) {
		data.addColumn("string", "MAC");
		data.addColumn("string", "IP");
		data.addColumn("date", "Last Seen");
		data.addColumn("string", "Switch");
		data.addColumn("number", "Port");
	}

	// Populate device data row
	function populateDeviceDataRow(data, index, jsonDevice) {
		data.setCell(index, 0, jsonDevice.dataLayerAddress, undefined,
				centerTextOpt);
		data.setCell(index, 1, jsonDevice.networkAddresses, undefined,
				centerTextOpt);
		data.setCell(index, 2, new Date(jsonDevice.lastSeen), undefined,
				centerTextOpt);
		data.setCell(index, 3, jsonDevice.switchDpid, undefined, centerTextOpt);
		data.setCell(index, 4, jsonDevice.port, undefined, centerTextOpt);
	}

	// Draw links table
	function drawLinkTable(jsonArrayNosLink) {
		var data = new google.visualization.DataTable();
		// Number of selected NOSs? single : multiple
		if (jsonArrayNosLink.length == 1) {
			// Create links data columns for single NOS selected
			createLinksDataColumns(data);
			// Populate links data for single NOS selected
			var jsonArrayLink = jsonArrayNosLink[0].jsonArrayLink;
			data.addRows(jsonArrayLink.length);
			for ( var i = 0; i < jsonArrayLink.length; i++) {
				populateLinkDataRow(data, i, jsonArrayLink[i]);
			}
		} else {
			// Create links data columns for multiple NOSs selected
			createLinksDataColumns(data);
			data.addColumn("string", "NOS IP");
			data.addColumn("string", "NOS Port");
			data.addColumn("string", "NOS Type");
			// Populate links data for multiple NOSs selected
			var index = 0;
			for ( var i = 0; i < jsonArrayNosLink.length; i++) {
				var nosIp = jsonArrayNosLink[i].nosIp;
				var nosPort = jsonArrayNosLink[i].nosPort;
				var nosType = jsonArrayNosLink[i].nosType;
				var jsonArrayLink = jsonArrayNosLink[i].jsonArrayLink;
				data.addRows(jsonArrayLink.length);
				for ( var j = 0; j < jsonArrayLink.length; j++) {
					populateLinkDataRow(data, index + j, jsonArrayLink[j]);
					data.setCell(index + j, 4, nosIp, undefined, centerTextOpt);
					data.setCell(index + j, 5, nosPort, undefined,
							centerTextOpt);
					data.setCell(index + j, 6, nosType, undefined,
							centerTextOpt);
				}
				index = index + jsonArrayLink.length;
			}
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
		
		// TODO DELETE
		console.log(data.getNumberOfRows());
	}

	// Create links data columns
	function createLinksDataColumns(data) {
		data.addColumn("string", "Source Id");
		data.addColumn("number", "Source Port");
		data.addColumn("string", "Destination Id");
		data.addColumn("number", "Destination Port");
	}

	// Populate link data row
	function populateLinkDataRow(data, index, jsonLink) {
		data.setCell(index, 0, jsonLink.dataLayerSource, undefined,
				centerTextOpt);
		data.setCell(index, 1, jsonLink.portSource, undefined, centerTextOpt);
		data.setCell(index, 2, jsonLink.dataLayerDestination, undefined,
				centerTextOpt);
		data.setCell(index, 3, jsonLink.portDestination, undefined,
				centerTextOpt);
	}

	// Draw flows table
	function drawSwitchFlowTable(jsonArrayNosSwitchFlow) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArrayNosSwitchFlow.length == 1) {
			// Create flows data columns for single switch selected
			createFlowsDataColumns(data);
			// Populate flows data for single switch selected
			var jsonArrayFlow = jsonArrayNosSwitchFlow[0].jsonArrayFlow;
			data.addRows(jsonArrayFlow.length);
			for ( var i = 0; i < jsonArrayFlow.length; i++) {
				populateFlowDataRow(data, i, jsonArrayFlow[i]);
			}
		} else {
			// Number of selected NOSs? single : multiple
			if (jsonNosList.length == 1) {
				// Create flows data columns for multiple switches selected from single NOS
				createFlowsDataColumnsMultiSwitchSingleNos(data);
				// Populate flows data for multiple switches selected from single NOS
				var index = 0;
				for ( var i = 0; i < jsonArrayNosSwitchFlow.length; i++) {
					var swId = jsonArrayNosSwitchFlow[i].swId;
					var jsonArrayFlow = jsonArrayNosSwitchFlow[i].jsonArrayFlow;
					data.addRows(jsonArrayFlow.length);
					for ( var j = 0; j < jsonArrayFlow.length; j++) {
						populateFlowDataRowMultiSwitchSingleNos(data,
								index + j, jsonArrayFlow[j], swId);
					}
					index = index + jsonArrayFlow.length;
				}
			} else {
				// Create flows data columns for multiple switches selected from multiple NOSs
				createFlowsDataColumnsMultiSwitchSingleNos(data);
				data.addColumn("string", "NOS Service IP");
				data.addColumn("string", "NOS Service Port");
				data.addColumn("string", "NOS Type");
				// Populate flows data for multiple switches selected from multiple NOSs
				var index = 0;
				for ( var i = 0; i < jsonArrayNosSwitchFlow.length; i++) {
					var swId = jsonArrayNosSwitchFlow[i].swId;
					var nosIp = jsonArrayNosSwitchFlow[i].nosIp;
					var nosPort = jsonArrayNosSwitchFlow[i].nosPort;
					var nosType = jsonArrayNosSwitchFlow[i].nosType;
					var jsonArrayFlow = jsonArrayNosSwitchFlow[i].jsonArrayFlow;
					data.addRows(jsonArrayFlow.length);
					for ( var j = 0; j < jsonArrayFlow.length; j++) {
						populateFlowDataRowMultiSwitchSingleNos(data,
								index + j, jsonArrayFlow[j], swId);
						data.setCell(index + j, 18, nosIp, undefined,
								centerTextOpt);
						data.setCell(index + j, 19, nosPort, undefined,
								centerTextOpt);
						data.setCell(index + j, 20, nosType, undefined,
								centerTextOpt);
					}
					index = index + jsonArrayFlow.length;
				}
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
		
		// TODO DELETE
		console.log(data.getNumberOfRows());
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

	// Create flows data columns for multiple switches selected from single NOS
	function createFlowsDataColumnsMultiSwitchSingleNos(data) {
		createFlowsDataColumns(data);
		data.addColumn("string", "Switch Id");
	}

	// Populate flow data row
	function populateFlowDataRow(data, index, jsonFlow) {
		// Long format
// 		data.setCell(index, 0, jsonFlow.inPort, undefined, centerTextOpt);
// 		data.setCell(index, 1, jsonFlow.dataLayerSource, undefined,
// 				centerTextOpt);
// 		data.setCell(index, 2, jsonFlow.dataLayerDestination, undefined,
// 				centerTextOpt);
// 		data
// 				.setCell(index, 3, jsonFlow.dataLayerType, undefined,
// 						centerTextOpt);
// 		data
// 				.setCell(index, 4, jsonFlow.networkSource, undefined,
// 						centerTextOpt);
// 		data.setCell(index, 5, jsonFlow.networkDestination, undefined,
// 				centerTextOpt);
// 		data.setCell(index, 6, jsonFlow.networkProtocol, undefined,
// 				centerTextOpt);
// 		data.setCell(index, 7, jsonFlow.transportSource, undefined,
// 				centerTextOpt);
// 		data.setCell(index, 8, jsonFlow.transportDestination, undefined,
// 				centerTextOpt);
// 		data.setCell(index, 9, jsonFlow.wildcards, undefined, centerTextOpt);
// 		data.setCell(index, 10, jsonFlow.bytes, undefined, centerTextOpt);
// 		data.setCell(index, 11, jsonFlow.packets, undefined, centerTextOpt);
// 		data.setCell(index, 12, jsonFlow.time, undefined, centerTextOpt);
// 		data.setCell(index, 13, jsonFlow.idleTimeout, undefined, centerTextOpt);
// 		data.setCell(index, 14, jsonFlow.hardTimeout, undefined, centerTextOpt);
// 		data.setCell(index, 15, jsonFlow.cookie, undefined, centerTextOpt);
// 		data.setCell(index, 16, jsonFlow.outports, undefined, centerTextOpt);
		
		// Short format
		data.setCell(index, 0, jsonFlow.i, undefined, centerTextOpt);
		data.setCell(index, 1, jsonFlow.lS, undefined, centerTextOpt);
		data.setCell(index, 2, jsonFlow.lD, undefined, centerTextOpt);
		data.setCell(index, 3, jsonFlow.lT, undefined, centerTextOpt);
		data.setCell(index, 4, jsonFlow.nS, undefined, centerTextOpt);
		data.setCell(index, 5, jsonFlow.nD, undefined, centerTextOpt);
		data.setCell(index, 6, jsonFlow.nP, undefined, centerTextOpt);
		data.setCell(index, 7, jsonFlow.tS, undefined, centerTextOpt);
		data.setCell(index, 8, jsonFlow.tD, undefined, centerTextOpt);
		data.setCell(index, 9, jsonFlow.w, undefined, centerTextOpt);
		data.setCell(index, 10, jsonFlow.b, undefined, centerTextOpt);
		data.setCell(index, 11, jsonFlow.p, undefined, centerTextOpt);
		data.setCell(index, 12, jsonFlow.t, undefined, centerTextOpt);
		data.setCell(index, 13, jsonFlow.iT, undefined, centerTextOpt);
		data.setCell(index, 14, jsonFlow.hT, undefined, centerTextOpt);
		data.setCell(index, 15, jsonFlow.c, undefined, centerTextOpt);
		data.setCell(index, 16, jsonFlow.oP, undefined, centerTextOpt);
	}

	// Populate flow data row for multiple switches selected from single NOS
	function populateFlowDataRowMultiSwitchSingleNos(data, index, jsonFlow,
			swId) {
		populateFlowDataRow(data, index, jsonFlow);
		data.setCell(index, 17, swId, undefined, centerTextOpt);
	}

	// Draw tables table
	function drawSwitchTableTable(jsonArrayNosSwitchTable) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArrayNosSwitchTable.length == 1) {
			// Create tables data columns for single switch selected
			createTablesDataColumns(data);
			// Populate tables data for single switch selected
			var jsonArrayTable = jsonArrayNosSwitchTable[0].jsonArrayTable;
			data.addRows(jsonArrayTable.length);
			for (var i = 0; i < jsonArrayTable.length; i++) {
				populateTableDataRow(data, i, jsonArrayTable[i]);
			}
		} else {
			// Number of selected NOSs? single : multiple
			if (jsonNosList.length == 1) {
				// Create tables data columns for multiple switches selected from single NOS
				createTablesDataColumnsMultiSwitchSingleNos(data);
				// Populate tables data for multiple switches selected from single NOS
				var index = 0;
				for (var i = 0; i < jsonArrayNosSwitchTable.length; i++) {
					var swId = jsonArrayNosSwitchTable[i].swId;
					var jsonArrayTable = jsonArrayNosSwitchTable[i].jsonArrayTable;
					data.addRows(jsonArrayTable.length);
					for (var j = 0; j < jsonArrayTable.length; j++) {
						populateTableDataRowMultiSwitchSingleNos(data, index
								+ j, jsonArrayTable[j], swId);
					}
					index = index + jsonArrayTable.length;
				}
			} else {
				// Create tables data columns for multiple switches selected from multiple NOSs
				createTablesDataColumnsMultiSwitchSingleNos(data);
				data.addColumn("string", "NOS Service IP");
				data.addColumn("string", "NOS Service Port");
				data.addColumn("string", "NOS Type");
				// Populate tables data for multiple switches selected from multiple NOSs
				var index = 0;
				for (var i = 0; i < jsonArrayNosSwitchTable.length; i++) {
					var swId = jsonArrayNosSwitchTable[i].swId;
					var nosIp = jsonArrayNosSwitchTable[i].nosIp;
					var nosPort = jsonArrayNosSwitchTable[i].nosPort;
					var nosType = jsonArrayNosSwitchTable[i].nosType;
					var jsonArrayTable = jsonArrayNosSwitchTable[i].jsonArrayTable;
					data.addRows(jsonArrayTable.length);
					for (var j = 0; j < jsonArrayTable.length; j++) {
						populateTableDataRowMultiSwitchSingleNos(data, index
								+ j, jsonArrayTable[j], swId);
						data.setCell(index + j, 8, nosIp, undefined,
								centerTextOpt);
						data.setCell(index + j, 9, nosPort, undefined,
								centerTextOpt);
						data.setCell(index + j, 10, nosType, undefined,
								centerTextOpt);
					}
					index = index + jsonArrayTable.length;
				}
			}
		}
		// Create and draw tables table
		var tableSwitchTable = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchTable.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			width : "100%",
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

	// Create tables data columns for multiple switches selected from single NOS
	function createTablesDataColumnsMultiSwitchSingleNos(data) {
		createTablesDataColumns(data);
		data.addColumn("string", "Switch Id");
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

	// Populate table data row for multiple switches selected from single NOS
	function populateTableDataRowMultiSwitchSingleNos(data, index, jsonPort,
			swId) {
		populateTableDataRow(data, index, jsonPort);
		data.setCell(index, 7, swId, undefined, centerTextOpt);
	}

	// Draw ports table
	function drawSwitchPortTable(jsonArrayNosSwitchPort) {
		var data = new google.visualization.DataTable();
		// Number of selected switches? single : multiple
		if (jsonArrayNosSwitchPort.length == 1) {
			// Create ports data columns for single switch selected
			createPortsDataColumns(data);
			// Populate ports data for single switch selected
			var jsonArrayPort = jsonArrayNosSwitchPort[0].jsonArrayPort;
			data.addRows(jsonArrayPort.length);
			for (var i = 0; i < jsonArrayPort.length; i++) {
				populatePortDataRow(data, i, jsonArrayPort[i]);
			}
		} else {
			// Number of selected NOSs? single : multiple
			if (jsonNosList.length == 1) {
				// Create ports data columns for multiple switches selected from single NOS
				createPortsDataColumnsMultiSwitchSingleNos(data);
				// Populate ports data for multiple switches selected from single NOS
				var index = 0;
				for (var i = 0; i < jsonArrayNosSwitchPort.length; i++) {
					var swId = jsonArrayNosSwitchPort[i].swId;
					var jsonArrayPort = jsonArrayNosSwitchPort[i].jsonArrayPort;
					data.addRows(jsonArrayPort.length);
					for (var j = 0; j < jsonArrayPort.length; j++) {
						populatePortDataRowMultiSwitchSingleNos(data,
								index + j, jsonArrayPort[j], swId);
					}
					index = index + jsonArrayPort.length;
				}
			} else {
				// Create ports data columns for multiple switches selected from multiple NOSs
				createPortsDataColumnsMultiSwitchSingleNos(data);
				data.addColumn("string", "NOS Service IP");
				data.addColumn("string", "NOS Service Port");
				data.addColumn("string", "NOS Type");
				// Populate ports data for multiple switches selected from multiple NOSs
				var index = 0;
				for (var i = 0; i < jsonArrayNosSwitchPort.length; i++) {
					var swId = jsonArrayNosSwitchPort[i].swId;
					var nosIp = jsonArrayNosSwitchPort[i].nosIp;
					var nosPort = jsonArrayNosSwitchPort[i].nosPort;
					var nosType = jsonArrayNosSwitchPort[i].nosType;
					var jsonArrayPort = jsonArrayNosSwitchPort[i].jsonArrayPort;
					data.addRows(jsonArrayPort.length);
					for (var j = 0; j < jsonArrayPort.length; j++) {
						populatePortDataRowMultiSwitchSingleNos(data,
								index + j, jsonArrayPort[j], swId);
						data.setCell(index + j, 14, nosIp, undefined,
								centerTextOpt);
						data.setCell(index + j, 15, nosPort, undefined,
								centerTextOpt);
						data.setCell(index + j, 16, nosType, undefined,
								centerTextOpt);
					}
					index = index + jsonArrayPort.length;
				}
			}
		}
		// Create and draw ports table
		var tableSwitchPort = new google.visualization.Table(document
				.getElementById("switchDetailTable_div"));
		tableSwitchPort.draw(data, {
			allowHtml : true,
			showRowNumber : true,
			width : "100%",
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

	// Create ports data columns for multiple switches selected from single NOS
	function createPortsDataColumnsMultiSwitchSingleNos(data) {
		createPortsDataColumns(data);
		data.addColumn("string", "Switch Id");
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

	// Populate port data row for multiple switches selected from single NOS
	function populatePortDataRowMultiSwitchSingleNos(data, index, jsonPort,
			swId) {
		populatePortDataRow(data, index, jsonPort);
		data.setCell(index, 13, swId, undefined, centerTextOpt);
	}

	// Obtain switches connected to selected NOSs
	function onSwitchesButton() {
		// Number of selected NOSs? between 5 and 1
		if (jsonNosList.length > 5 && jsonNosList.length < 1) {
			alert('You must select at least 1 switch and maximum 5 NOSs');
			return;
		}
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNosSwitchList = null;
		// Send AJAX request to obtain switches connected to selected NOSs
		AJAXrequest.open("GET", "serviceNos/multiNosSwitch.jsp?nosList="
				+ JSON.stringify(jsonNosList), true);
		AJAXrequest.onreadystatechange = handlerSwitches;
		AJAXrequest.send();
		// Set switches title of NOS detail table
		var title;
		if (jsonNosList.length == 1) {
			title = "Switches on NOS (IP = " + jsonNosList[0].ip + ", Port = "
					+ jsonNosList[0].port + ", Type = " + jsonNosList[0].type
					+ ")";
		} else {
			title = "Switches on NOSs";
		}
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain devices connected to switches from selected NOSs 
	function onDevicesButton() {
		// Number of selected NOSs? between 5 and 1
		if (jsonNosList.length > 5 && jsonNosList.length < 1) {
			alert('You must select at least 1 switch and maximum 5 NOSs');
			return;
		}
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNosSwitchList = null;
		// Send AJAX request to obtain devices connected to switches from selected NOSs
		AJAXrequest.open("GET", "serviceNos/multiNosDevice.jsp?nosList="
				+ JSON.stringify(jsonNosList), true);
		AJAXrequest.onreadystatechange = handlerDevices;
		AJAXrequest.send();
		// Set devices title of NOS detail table
		var title;
		if (jsonNosList.length == 1) {
			title = "Devices on NOS (IP = " + jsonNosList[0].ip + ", Port = "
					+ jsonNosList[0].port + ", Type = " + jsonNosList[0].type
					+ ")";
		} else {
			title = "Devices on NOSs";
		}
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain links between switches from selected NOSs
	function onLinksButton() {
		// Number of selected NOSs? between 5 and 1
		if (jsonNosList.length > 5 && jsonNosList.length < 1) {
			alert('You must select at least 1 switch and maximum 5 NOSs');
			return;
		}
		// Hide divisions
		hide("nosDetail_div");
		hide("switchOpts_div");
		hide("switchDetail_div");
		// Initialize parameters
		jsonNosSwitchList = null;
		// Send AJAX request to obtain links between switches from selected NOSs
		AJAXrequest.open("GET", "serviceNos/multiNosLink.jsp?nosList="
				+ JSON.stringify(jsonNosList), true);
		AJAXrequest.onreadystatechange = handlerLinks;
		AJAXrequest.send();
		// Set links title of NOS detail table
		var title;
		if (jsonNosList.length == 1) {
			title = "Links on NOS (IP = " + jsonNosList[0].ip + ", Port = "
					+ jsonNosList[0].port + ", Type = " + jsonNosList[0].type
					+ ")";
		} else {
			title = "Links on NOSs";
		}
		document.getElementById("nosDetail_title").innerHTML = title;
	}

	// Obtain flows from selected switches
	function onFlowsButton() {
		// Number of selected switches? between 10 and 1
		if (jsonNosSwitchList.length > 10 && jsonNosSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain flows from selected switches
		AJAXrequest.open("GET",
				"serviceNos/multiNosSwitchFlow.jsp?nosSwitchList="
						+ JSON.stringify(jsonNosSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchFlows;
		AJAXrequest.send();
		// Set flows title of switch detail table
		var title;
		if (jsonNosSwitchList.length == 1) {
			title = "Flows on Switch (ID = " + jsonNosSwitchList[0].swId + ")";
		} else {
			title = "Flows on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
	}

	// Obtain tables from selected switches
	function onTablesButton() {
		// Number of selected switches? between 10 and 1
		if (jsonNosSwitchList.length > 10 && jsonNosSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain ports from selected switches
		AJAXrequest.open("GET",
				"serviceNos/multiNosSwitchTable.jsp?nosSwitchList="
						+ JSON.stringify(jsonNosSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchTables;
		AJAXrequest.send();
		// Set tables title of switch detail table
		var title;
		if (jsonNosSwitchList.length == 1) {
			title = "Tables on Switch (ID = " + jsonNosSwitchList[0].swId + ")";
		} else {
			title = "Tables on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
	}

	// Obtain ports from selected switches
	function onPortsButton() {
		// Number of selected switches? between 10 and 1
		if (jsonNosSwitchList.length > 10 && jsonNosSwitchList.length < 1) {
			alert('You must select at least 1 switch and maximum 10 switches');
			return;
		}
		// Hide divisions
		hide("switchDetail_div");
		// Send AJAX request to obtain ports from selected switches
		AJAXrequest.open("GET",
				"serviceNos/multiNosSwitchPort.jsp?nosSwitchList="
						+ JSON.stringify(jsonNosSwitchList), true);
		AJAXrequest.onreadystatechange = handlerSwitchPorts;
		AJAXrequest.send();
		// Set ports title of switch detail table
		var title;
		if (jsonNosSwitchList.length == 1) {
			title = "Ports on Switch (ID = " + jsonNosSwitchList[0].swId + ")";
		} else {
			title = "Ports on Switches";
		}
		document.getElementById("switchDetail_title").innerHTML = title;
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
							on NOS(s)</button>
						<button type="button" onclick="onDevicesButton()">Devices
							on NOS(s)</button>
						<button type="button" onclick="onLinksButton()">Links on
							NOS(s)</button>
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