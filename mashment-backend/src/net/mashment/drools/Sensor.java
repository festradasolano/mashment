/**
 * 
 */
package net.mashment.drools;

import net.mashment.drools.entities.Message;
import net.mashment.drools.entities.NetworkOperatingSystem;
import net.mashment.drools.entities.Port;
import net.mashment.drools.entities.Switch;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.kie.api.runtime.KieSession;

import util.NosBeaconClient;
import util.NosClient;
import util.NosFloodlightClient;
import util.NosPoxClient;

/**
 * @author felipe
 * 
 */
public class Sensor implements Runnable {

	// Define a stateful session
	KieSession kieSession;

	// FIXME
	JSONArray jsonArrayNos;

	/**
	 * 
	 */
	public Sensor() {
		// jsonArrayNos = new JSONArray();
		// JSONObject jsonNos = new JSONObject();
		// try {
		// jsonNos.put("ip", "127.0.0.1");
		// jsonNos.put("port", "8082");
		// jsonNos.put("type", "pox");
		// } catch (JSONException e) {
		// e.printStackTrace();
		// }
		// jsonArrayNos.put(jsonNos);
	}

	public Sensor(KieSession kieSession) {
		this();
		this.kieSession = kieSession;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	@Override
	public void run() {
		// Insert facts into the stateful session
		final Message message = new Message();
		message.setMessage("hello");
		message.setStatus(1);
		kieSession.insert(message);

		// Insert facts into the stateful session
		final Message message2 = new Message();
		message2.setMessage("world");
		message2.setStatus(2);
		kieSession.insert(message2);
		
		// Fire the rules
		kieSession.fireAllRules();

		// try {
		// // Get switches connected to each NOS
		// for (int i = 0; i < jsonArrayNos.length(); i++) {
		// JSONObject jsonNos = jsonArrayNos.getJSONObject(i);
		// NetworkOperatingSystem nos = new NetworkOperatingSystem(
		// jsonNos.getString("ip"), jsonNos.getString("port"),
		// jsonNos.getString("type"));
		// // NOS type? beacon : pox : floodlight : other
		// NosClient client;
		// if (nos.getType().equalsIgnoreCase("beacon")) {
		// client = new NosBeaconClient();
		// } else if (nos.getType().equalsIgnoreCase("pox")) {
		// client = new NosPoxClient();
		// } else if (nos.getType().equalsIgnoreCase("floodlight")) {
		// client = new NosFloodlightClient();
		// } else {
		// return;
		// }
		// // Get switches connected to NOS
		// JSONArray jsonArraySwitch = new JSONArray(
		// client.getNosSwitches(nos.getIp(), nos.getPort()));
		// // Get ports from each switch
		// for (int j = 0; j < jsonArraySwitch.length(); j++) {
		// JSONObject jsonSwitch = jsonArraySwitch.getJSONObject(j);
		// Switch sw = new Switch(nos, jsonSwitch.getString("dpid"));
		// // Get ports from switch
		// JSONArray jsonArrayPort = new JSONArray(
		// client.getNosSwitchPorts(nos.getIp(),
		// nos.getPort(), sw.getDpid()));
		// for (int k = 0; k < jsonArrayPort.length(); k++) {
		// JSONObject jsonPort = jsonArrayPort.getJSONObject(k);
		// Port port = new Port(sw, jsonPort.getInt("number"),
		// jsonPort.getLong("rxPackets"),
		// jsonPort.getLong("txPackets"));
		// // Insert facts into the stateful session
		// kieSession.insert(port);
		// }
		// }
		// }
		// } catch (JSONException e) {
		// e.printStackTrace();
		// }
		// // Fire the rules
		// kieSession.fireAllRules();

	}

}
