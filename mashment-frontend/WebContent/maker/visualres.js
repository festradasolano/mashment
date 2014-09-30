/*
 * Copyright 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * Originally created by Eric Abouaf, distributed under the MIT License
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 * 
 * 		http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Specifies visual resources for the Mashment Maker in the defined visual
 * language: "mashment". This script also implements functions for new buttons
 * ("RUN" and "PUBLISH") and functions to reuse composed modules.
 * 
 * Copyright 2012-2014 Felipe Estrada-Solano <festradasolano at gmail>
 * Copyright 2012      Oscar Mauricio Caicedo <omcaicedo at gmail>
 * Originally created by Eric Abouaf, distributed under the MIT License
 * 
 * Distributed under the Apache License, Version 2.0
 */
var autorunExecuted = false;
var eng;
var visualres = {

	language : {

		// Set a unique name for the language
		languageName : "mashment",

		// List of visual resources
		modules : [

		/* omcaicedo added these modules: */
		{
			"name" : "Hybrid Dashboard",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "Virtual Router",
						"name" : "vd1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Virtual Server",
						"name" : "vs1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Switch",
						"name" : "server3",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		}, {
			"name" : "Switch",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "Switch",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "SNMP Params",
						"name" : "snmparams",
						"wirable" : true
					}
				}, {
					"type" : "select",
					"inputParams" : {
						"label" : "Type",
						"name" : "Type",
						"selectValues" : [ "Cisco" ]
					}
				} ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : 86,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]

			}
		}, {
			"name" : "Vyatta",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "Vyatta",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IP",
						"name" : "IP",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "Login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Passwd",
						"name" : "Passwd",
						"wirable" : false
					}
				}, {
					"type" : "select",
					"inputParams" : {
						"label" : "Type",
						"name" : "Type",
						"selectValues" : [ "Vyatta" ]
					}
				} ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : 86,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]

			}
		}, {
			"name" : "Dashboard",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "Server1",
						"name" : "server1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Server2",
						"name" : "server2",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Server3",
						"name" : "server3",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		}, {
			"name" : "Xen",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "Xen",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IP",
						"name" : "IP",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "Login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Passwd",
						"name" : "Passwd",
						"wirable" : false
					}
				}, {
					"type" : "select",
					"inputParams" : {
						"label" : "Type",
						"name" : "Type",
						"selectValues" : [ "Xen" ]
					}
				} ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : 86,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]

			}
		}, {
			"name" : "VBox",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "Vbox",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IP",
						"name" : "IP",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Port",
						"name" : "Port",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "Login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Passwd",
						"name" : "Passwd",
						"wirable" : false
					}
				}, {
					"type" : "select",
					"inputParams" : {
						"label" : "Type",
						"name" : "Type",
						"selectValues" : [ "VBox" ]
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : 86,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]

			}
		}, {
			"name" : "VBox1",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "Vbox1",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IP",
						"name" : "IP",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Port",
						"name" : "Port",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "Login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Passwd",
						"name" : "Passwd",
						"wirable" : false
					}
				}, {
					"type" : "select",
					"inputParams" : {
						"label" : "Type",
						"name" : "Type",
						"selectValues" : [ "VBox" ]
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : 86,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]

			}
		},
		/* end of omcaicedo's modules */

		/* festradasolano added these modules: */
		{
			"name" : "Beacon",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.beacon",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IPAddr",
						"name" : "ip",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Port",
						"name" : "port",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Key",
						"name" : "pwd",
						"wirable" : false
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 1, 0 ],
					"offsetPosition" : {
						"left" : 184,
						"bottom" : -1
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]
			}
		}, {
			"name" : "Floodlight",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.floodlight",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IPAddr",
						"name" : "ip",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Port",
						"name" : "port",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Key",
						"name" : "pwd",
						"wirable" : false
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 1, 0 ],
					"offsetPosition" : {
						"left" : 184,
						"bottom" : -1
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]
			}
		}, {
			"name" : "POX",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.pox",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "IPAddr",
						"name" : "ip",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Port",
						"name" : "port",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Login",
						"name" : "login",
						"wirable" : false
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Key",
						"name" : "pwd",
						"wirable" : false
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 1, 0 ],
					"offsetPosition" : {
						"left" : 184,
						"bottom" : -1
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]
			}
		}, {
			"name" : "Controller Monitor",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.controllerMonitor",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller",
						"name" : "nos",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		}, {
			"name" : "Monitor SDN",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.monitorSdn",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "NOS 1",
						"name" : "nos1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "NOS 2",
						"name" : "nos2",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "NOS 3",
						"name" : "nos3",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		},

		{
			"name" : "Monitoring Panel",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.monitoringPlatform",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 1",
						"name" : "nos1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 2",
						"name" : "nos2",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 3",
						"name" : "nos3",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Graph Tool",
						"name" : "graphTool",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		}, {
			"name" : "YUI Chart",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.yuichart",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "Refresh Time (s)",
						"name" : "refreshTime",
						"wirable" : false
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 1, 0 ],
					"offsetPosition" : {
						"left" : 184,
						"bottom" : -1
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]
			}
		}, {
			"name" : "RRDTool",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.rrdTool",
				"fields" : [ {
					"type" : "string",
					"inputParams" : {
						"label" : "Refresh Time (s)",
						"name" : "refreshTime",
						"wirable" : false
					}
				}, ],
				"terminals" : [ {
					"name" : "out",
					"direction" : [ 1, 0 ],
					"offsetPosition" : {
						"left" : 184,
						"bottom" : -1
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				} ]
			}
		}, {
			"name" : "OF Monitor",
			"container" : {
				"xtype" : "WireIt.FormContainer",
				"title" : "co.edu.unicauca.git.monitoringPlatform",
				"fields" : [ {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 1",
						"name" : "nos1",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 2",
						"name" : "nos2",
						"wirable" : true
					}
				}, {
					"type" : "list",
					"inputParams" : {
						"label" : "Controller 3",
						"name" : "nos3",
						"wirable" : true
					}
				}, {
					"type" : "string",
					"inputParams" : {
						"label" : "Traffic Graph Tool",
						"name" : "graphTool",
						"wirable" : true
					}
				} ],
				"outputs" : [ "out" ]
			}
		}
		/* end of festradasolano's modules */
		]
	},

	/* festradasolano modified or added this code: */
	/**
	 * Inits the designer of the Mashment Maker.
	 * 
	 * @method init
	 * @static
	 */
	init : function() {
		this.editor = new visualres.WiringEditor(this.language);
		// Open the minimap and help panel
		this.editor.accordionView.openPanel(1);
		this.editor.accordionView.openPanel(2);
	},

	/**
	 * Execute the mashment in the engine of the Mashment Maker.
	 * 
	 * @method run
	 * @static
	 */
	run : function() {
		eng = new engine(this.editor.getValue());
		eng.run();
	},

	/**
	 * Publish the mashment in the repository.
	 * 
	 * @method publish
	 * @static
	 */
	publish : function() {
		alert("Function PUBLISH is not implemented yet.");
	}
/* end of festradasolano's modules */

};

/**
 * The wiring editor is overriden to add a button "RUN" and "PUBLISH" to the
 * control bar.
 */
visualres.WiringEditor = function(options) {
	visualres.WiringEditor.superclass.constructor.call(this, options);
};
YAHOO.lang.extend(visualres.WiringEditor, WireIt.WiringEditor, {

	/**
	 * Add the "RUN" and "PUBLISH" buttons.
	 */
	renderButtons : function() {
		visualres.WiringEditor.superclass.renderButtons.call(this);

		/* festradasolano modified or added this code: */
		// Add the run button
		var toolbar = YAHOO.util.Dom.get('toolbar');
		var runButton = new YAHOO.widget.Button({
			label : "Run",
			id : "MashmentMaker-runButton",
			container : toolbar
		});
		runButton.on("click", visualres.run, visualres, true);

		// Add the publish button
		var publishButton = new YAHOO.widget.Button({
			label : "Publish",
			id : "MashmentMaker-publishButton",
			container : toolbar
		});
		publishButton.on("click", visualres.publish, visualres, true);
		/* end of festradasolano's code */
	},

	/**
	 * Customize the load success handler for the composed module list
	 */
	onLoadSuccess : function(wirings) {
		visualres.WiringEditor.superclass.onLoadSuccess.call(this, wirings);

		// Customize to display composed module in the left list
		this.updateComposedModuleList();

		var p = window.location.search.substr(1).split('&');
		var oP = {};
		for (var i = 0; i < p.length; i++) {
			var v = p[i].split('=');
			oP[v[0]] = window.decodeURIComponent(v[1]);
		}

		if ((oP.autoload) && (!autorunExecuted)) {
			toConsole("Called on AutoLoad mode. " + oP.autoload + " loaded.");

			if (oP.autorun) {
				toConsole("Autorun mode. Running " + oP.autoload);
				visualres.run();
				autorunExecuted = true;
			}

		}
	},

	/**
	 * All the saved wirings are reusable modules :
	 */
	updateComposedModuleList : function() {

		// TODO optimize
		// Remove all previous module with the ComposedModule class
		var l = YAHOO.util.Dom.getElementsByClassName("ComposedModule", "div",
				this.leftEl);
		for (var i = 0; i < l.length; i++) {
			this.leftEl.removeChild(l[i]);
		}

		if (YAHOO.lang.isArray(this.pipes)) {
			for (i = 0; i < this.pipes.length; i++) {
				var module = this.pipes[i];
				this.pipesByName[module.name] = module;
				// Add the module to the list
				var div = WireIt.cn('div', {
					className : "WiringEditor-module ComposedModule"
				});
				div.appendChild(WireIt.cn('span', null, null, module.name));
				var ddProxy = new WireIt.ModuleProxy(div, this);
				ddProxy._module = {
					name : module.name,
					container : {
						"xtype" : "visualres.ComposedContainer",
						"title" : module.name
					}
				};
				this.leftEl.appendChild(div);
			}
		}

	}
});

/**
 * Container class used by the "visualres" module (automatically sets terminals
 * depending on the number of arguments)
 * 
 * @class Container
 * @namespace visualres
 * @constructor
 */
visualres.Container = function(options, layer) {

	visualres.Container.superclass.constructor.call(this, options, layer);

	this.buildTextArea(options.codeText || "function(e) {\n\n  return 0;\n}");

	this.createTerminals();

	// Reposition the terminals when the visualres is being resized
	this.ddResize.eventResize.subscribe(function(e, args) {
		this.positionTerminals();
		YAHOO.util.Dom.setStyle(this.textarea, "height", (args[0][1] - 70)
				+ "px");
	}, this, true);
};

YAHOO
		.extend(
				visualres.Container,
				WireIt.Container,
				{

					/**
					 * Create the textarea for the javascript code
					 * 
					 * @method buildTextArea
					 * @param {String}
					 *            codeText
					 */
					buildTextArea : function(codeText) {

						this.textarea = WireIt.cn('textarea', null, {
							width : "90%",
							height : "70px",
							border : "0",
							padding : "5px"
						}, codeText);
						this.setBody(this.textarea);

						YAHOO.util.Event.addListener(this.textarea, 'change',
								this.createTerminals, this, true);

					},

					/**
					 * Create (and re-create) the terminals with this.nParams
					 * input terminals
					 * 
					 * @method createTerminals
					 */
					createTerminals : function() {

						// Output Terminal
						if (!this.outputTerminal) {
							this.outputTerminal = this.addTerminal({
								xtype : "WireIt.util.TerminalOutput",
								"name" : "out"
							});
							this.outputTerminal.visualres = this;
						}

						// Input terminals :
						var match = (this.textarea.value)
								.match((/^[ ]*function[ ]*\((.*)\)[ ]*\{/));
						var sParamList = match ? match[1] : "";
						var params = sParamList.split(',');
						var nParams = (sParamList == "") ? 0 : params.length;

						var curTerminalN = this.nParams || 0;
						if (curTerminalN < nParams) {
							// add terminals
							for (var i = curTerminalN; i < nParams; i++) {
								var term = this.addTerminal({
									xtype : "WireIt.util.TerminalInput",
									"name" : "param" + i
								});
								// term.visualres = this;
								WireIt.sn(term.el, null, {
									position : "absolute",
									top : "-15px"
								});
							}
						} else if (curTerminalN > nParams) {
							// remove terminals
							for (var i = this.terminals.length
									- (curTerminalN - nParams); i < this.terminals.length; i++) {
								this.terminals[i].remove();
								this.terminals[i] = null;
							}
							this.terminals = WireIt.compact(this.terminals);
						}
						this.nParams = nParams;

						this.positionTerminals();

						// Declare the new terminals to the drag'n drop handler
						// (so the wires are moved around with the container)
						this.dd.setTerminals(this.terminals);
					},

					/**
					 * Reposition the terminals
					 * 
					 * @method positionTerminals
					 */
					positionTerminals : function() {
						var width = WireIt.getIntStyle(this.el, "width");

						var inputsIntervall = Math.floor(width
								/ (this.nParams + 1));

						for (var i = 1; i < this.terminals.length; i++) {
							var term = this.terminals[i];
							YAHOO.util.Dom.setStyle(term.el, "left",
									(inputsIntervall * (i)) - 15 + "px");
							for (var j = 0; j < term.wires.length; j++) {
								term.wires[j].redraw();
							}
						}

						// Output terminal
						WireIt.sn(this.outputTerminal.el, null, {
							position : "absolute",
							bottom : "-15px",
							left : (Math.floor(width / 2) - 15) + "px"
						});
						for (var j = 0; j < this.outputTerminal.wires.length; j++) {
							this.outputTerminal.wires[j].redraw();
						}
					},

					/**
					 * Extend the getConfig to add the "codeText" property
					 * 
					 * @method getConfig
					 */
					getConfig : function() {
						var obj = visualres.Container.superclass.getConfig
								.call(this);
						obj.codeText = this.textarea.value;
						return obj;
					}

				});

/**
 * ComposedContainer is a class for Container representing Pipes. It
 * automatically generates the inputEx Form from the input Params.
 * 
 * @class ComposedContainer
 * @extends WireIt.FormContainer
 * @constructor
 */
visualres.ComposedContainer = function(options, layer) {

	if (!options.fields) {

		options.fields = [];
		options.terminals = [];

		var pipe = visualres.editor.getPipeByName(options.title);
		for (var i = 0; i < pipe.modules.length; i++) {
			var m = pipe.modules[i];
			if (m.name == "input") {
				m.value.input.inputParams.wirable = true;
				options.fields.push(m.value.input);
			} else if (m.name == "output") {
				options.terminals.push({
					name : m.value.name,
					"direction" : [ 0, 1 ],
					"offsetPosition" : {
						"left" : options.terminals.length * 40,
						"bottom" : -15
					},
					"ddConfig" : {
						"type" : "output",
						"allowedTypes" : [ "input" ]
					}
				});
			}
		}
	}

	visualres.ComposedContainer.superclass.constructor.call(this, options,
			layer);
};
YAHOO.extend(visualres.ComposedContainer, WireIt.FormContainer);
