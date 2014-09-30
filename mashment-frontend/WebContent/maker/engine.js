/*
 * Copyright (c) 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright (c) 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * Copyright (c) 2007-2009 Eric Abouaf <eric.abouaf at gmail>
 * 
 * Distributed under the MIT License (MIT) (see LICENSE for details)
 */

/**
 * Engine of the Mashment Maker that executes built mashments. Mashments are
 * wiring configurations that contains a set module instances and a set of wires
 * linking them. Each mashment has its own execution environment.
 * 
 * Copyright (c) 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright (c) 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * Copyright (c) 2007-2009 Eric Abouaf <eric.abouaf at gmail>
 * 
 * Distributed under the MIT License (MIT) (see LICENSE for details)
 */

/* omcaicedo added this code: */
// back-end URL to execute mashments
var home = location.protocol + '//' + location.host + '/mashment-backend/';

/**
 * Configures the Cross-Origin XML HTTP Request.
 * 
 * @returns The Cross-Origin XML HTTP Request configuration
 */
function CrossXHR() {
	var crossxhr = false;
	if (window.XMLHttpRequest) {
		crossxhr = new XMLHttpRequest();
		if (crossxhr.overrideMimeType) {
			crossxhr.overrideMimeType('text/xml');
		}
	} else if (window.ActiveXObject) {
		try {
			crossxhr = new ActiveXObject('Msxml2.XMLHTTP');
		} catch (e) {
			try {
				crossxhr = new ActiveXObject('Microsoft.XMLHTTP');
			} catch (e) {
				crossxhr = false;
			}
		}
	}
	return crossxhr;
}
/* end of omcaicedo's code: */

/* festradasolano added this code: */
/**
 * Prints the text in the console of the Mashment Maker.
 * 
 * @param text
 *            Text to print in console.
 */
function toConsole(text) {
	document.getElementById("consoleText").value += text + "\n";
	document.getElementById("consoleText").scrollTop = document
			.getElementById("consoleText").scrollHeight;
}

/**
 * Clear the console of the Mashment Maker.
 */
function clearConsole() {
	document.getElementById("consoleText").value = "";
	document.getElementById("consoleText").scrollTop = document
			.getElementById("consoleText").scrollHeight;
}
/* end of festradasolano code: */

/* festradasolano and omcaicedo modified this code: */
/**
 * Creates an execution environment for the mashment.
 * 
 * @class engine
 * @constructor
 * @param wiringConfig
 *            The mashment to execute
 * @param frameLevel
 * @param parentFrame
 * @param parentIndex
 */
var engine = function(wiringConfig, frameLevel, parentFrame, parentIndex) {
	// save the initial config
	this.wiringConfig = wiringConfig;
	// save the parent frame
	this.frameLevel = frameLevel || 0;
	this.parentFrame = parentFrame;
	this.parentIndex = parentIndex;
	// Contain executions (this.execValues[module][outputName] = the value)
	this.execValues = {};
};

engine.prototype = {

	/**
	 * Check runnable modules and execute them.
	 * 
	 * @method run
	 * @param params
	 *            The input parameters
	 */
	run : function(params) {
		var modules = this.wiringConfig.working.modules, i;
		try {
			// check runnable modules
			var moduleIdsToExecute = [];
			for (i = 0; i < modules.length; i++) {
				if (this.mayEval(i)) {
					moduleIdsToExecute.push(i);
				}
			}
			// execute runnable modules
			for (i = 0; i < moduleIdsToExecute.length; i++) {
				this.execute(moduleIdsToExecute[i], params);
			}
		} catch (ex) {
			console.log("Error while running: ", ex);
		}
	},

	/**
	 * Evaluates if the module is runnable: all wires that target this module
	 * have a source output evaluated.
	 * 
	 * @param moduleId
	 *            Module id to evaluate
	 * @returns {Boolean} Is the module runnable
	 */
	mayEval : function(moduleId) {
		var t = this.wiringConfig.working.modules[moduleId].name;
		// check type of module
		if (t == "input" || t == "callback") {
			// input and callback modules are runnable
			return true;
		} else if (t == "comment") {
			// comment module is not runnable
			return false;
		} else {
			// other modules are runnable if all wires that target this module
			// have a source output evaluated
			var wires = this.wiringConfig.working.wires;
			for (var i = 0; i < wires.length; i++) {
				var wire = wires[i];
				if (wire.tgt.moduleId == moduleId) {
					if (!this.execValues[wire.src.moduleId]
							|| typeof this.execValues[wire.src.moduleId][wire.src.terminal] == "undefined") {
						return false;
					}
				}
			}
			return true;
		}
	},

	/**
	 * Executes the module.
	 * 
	 * @param moduleId
	 *            Module id to execute
	 * @param srcTerminal
	 */
	executeModules : function(moduleId, srcTerminal) {
		var params = this.execValues[moduleId][srcTerminal];
		// Execute the modules linked to the callbackFunction
		var i, wires = this.wiringConfig.working.wires;
		for (i = 0; i < wires.length; i++) {
			var wire = wires[i];
			if (wire.src.moduleId == moduleId
					&& wire.src.terminal == srcTerminal) {
				if (this.mayEval(wire.tgt.moduleId)) {
					this.execute(wire.tgt.moduleId, params);
				}
			}
		}

	},

	/**
	 * Executes the module.
	 * 
	 * @param moduleId
	 *            Module id to execute
	 * @param params
	 *            Parameters to execute the module
	 */
	execute : function(moduleId, params) {
		var module = null;
		try {
			module = this.wiringConfig.working.modules[moduleId];
			var t = module.name;
			var d = new Date();
			toConsole("[" + d.toString() + "]: Running module '" + t + "'");
			/* omcaicedo added this code: */
			if (t == "Xen") {
				// build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				this.execValues[moduleId] = {
					out : params
				};
				this.executeModules(moduleId, "out");
			} else if (t == "VBox1") {
				// build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				this.execValues[moduleId] = {
					out : params
				};
				this.executeModules(moduleId, "out");
			} else if (t == "VBox") {
				// build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				this.execValues[moduleId] = {
					out : params
				};
				this.executeModules(moduleId, "out");
			} else if (t == "Dashboard") {
				// build the params list
				var params = {};
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}
				var nodes = params["server1"];
				var nodes1 = params["server2"];
				var nodes2 = params["server3"];
				toConsole(nodes);
				toConsole(YAHOO.lang.JSON.stringify(nodes));

				this.execValues[moduleId] = {
					out : output
				};
				var dashParams = "[" + YAHOO.lang.JSON.stringify(nodes) + ","
						+ YAHOO.lang.JSON.stringify(nodes1) + ","
						+ YAHOO.lang.JSON.stringify(nodes2) + "]";
				this.executeModules(moduleId, "out");
				window.open(home + "vnmg.jsp?params="
						+ YAHOO.lang.JSON.stringify(dashParams));
			}
			/* end of omcaicedo's code */

			/* festradasolano added this code: */
			else if (t == "Beacon") {
				// Build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				params["type"] = "beacon";
				// Push on execValues
				this.execValues[moduleId] = {
					out : params
				};
				// Execute module
				this.executeModules(moduleId, "out");
			} else if (t == "Floodlight") {
				// Build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				params["type"] = "floodlight";
				// Push on execValues
				this.execValues[moduleId] = {
					out : params
				};
				// Execute module
				this.executeModules(moduleId, "out");
			} else if (t == "POX") {
				// Build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				params["type"] = "pox";
				// Push on execValues
				this.execValues[moduleId] = {
					out : params
				};
				// Execute module
				this.executeModules(moduleId, "out");
			} else if (t == "YUI Chart") {
				// Build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				params["type"] = "yuichart";
				// Push on execValues
				this.execValues[moduleId] = {
					out : params
				};
				// Execute module
				this.executeModules(moduleId, "out");
			} else if (t == "RRDTool") {
				// Build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				params["type"] = "rrdTool";
				// Push on execValues
				this.execValues[moduleId] = {
					out : params
				};
				// Execute module
				this.executeModules(moduleId, "out");
			} else if (t == "Controller Monitor") {
				// Build the params list
				var params = {};
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}
				// Obtain NOS input params
				var nos = params["nos"];
				this.execValues[moduleId] = {
					out : output
				};
				var nosParams = YAHOO.lang.JSON.stringify(nos);
				// Execute module
				this.executeModules(moduleId, "out");
				window.open(home + "monitorController.jsp?params="
						+ YAHOO.lang.JSON.stringify(nosParams));
			} else if (t == "Monitor SDN") {
				// Build the params list
				var params = {};
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}
				// Obtain NOSs input params
				var nos1 = params["nos1"];
				var nos2 = params["nos2"];
				var nos3 = params["nos3"];
				this.execValues[moduleId] = {
					out : output
				};
				var nosParams = "[" + YAHOO.lang.JSON.stringify(nos1) + ","
						+ YAHOO.lang.JSON.stringify(nos2) + ","
						+ YAHOO.lang.JSON.stringify(nos3) + "]";
				// Execute module
				this.executeModules(moduleId, "out");
				window.open(home + "monitorSdn.jsp?params="
						+ YAHOO.lang.JSON.stringify(nosParams));
			} else if (t == "Monitoring Panel") {
				// Build the params list
				var params = {};
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}
				// Obtain NOSs and graph input params
				var nos1 = params["nos1"];
				var nos2 = params["nos2"];
				var nos3 = params["nos3"];
				var graphTool = params["graphTool"];
				this.execValues[moduleId] = {
					out : output
				};
				var nosParams = "[" + YAHOO.lang.JSON.stringify(nos1) + ","
						+ YAHOO.lang.JSON.stringify(nos2) + ","
						+ YAHOO.lang.JSON.stringify(nos3) + "]";
				var graphParams = YAHOO.lang.JSON.stringify(graphTool);
				// Execute module
				this.executeModules(moduleId, "out");
				window.open(home + "monitorPanel.jsp?params="
						+ YAHOO.lang.JSON.stringify(nosParams) + "&gtparams="
						+ YAHOO.lang.JSON.stringify(graphParams));
			} else if (t == "OF Monitor") {
				// Build the params list
				var params = {};
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}
				// Obtain NOSs and graph input params
				var nos1 = params["nos1"];
				var nos2 = params["nos2"];
				var nos3 = params["nos3"];
				var graphTool = params["graphTool"];
				this.execValues[moduleId] = {
					out : output
				};
				var nosParams = "[" + YAHOO.lang.JSON.stringify(nos1) + ","
						+ YAHOO.lang.JSON.stringify(nos2) + ","
						+ YAHOO.lang.JSON.stringify(nos3) + "]";
				var graphParams = YAHOO.lang.JSON.stringify(graphTool);
				// Execute module
				this.executeModules(moduleId, "out");
				window.open(home + "monitorOF.jsp?params="
						+ YAHOO.lang.JSON.stringify(nosParams) + "&gtparams="
						+ YAHOO.lang.JSON.stringify(graphParams));
			}
			/* end of festradasolano's code */

			else {
				// HERE, WE HAVE A COMPOSED MODULE
				var wiringText = jsBox.editor.pipesByName[t].working;
				var wiringConfig = {
					name : t,
					working : YAHOO.lang.JSON.parse(wiringText)
				};
				var f = new engine(wiringConfig, this.frameLevel + 1, this,
						moduleId);

				// build the params list
				var params = {};
				// Copy the default parameters value
				for ( var key in module.value) {
					if (module.value.hasOwnProperty(key)) {
						params[key] = module.value[key];
					}
				}
				// Overwrite with the wires values
				var wires = this.wiringConfig.working.wires;
				for (var i = 0; i < wires.length; i++) {
					var wire = wires[i];
					if (wire.tgt.moduleId == moduleId) {
						var paramName = wire.tgt.terminal;
						var paramValue = this.execValues[wire.src.moduleId][wire.src.terminal];
						params[paramName] = paramValue;
					}
				}

				for ( var x in params) {
					toConsole("#" + x + " - " + params[x]);
				}

				f.run(params);
			}
		} catch (ex) {
			console.log("Error while executing module", module, ex);
		}

	}

};
