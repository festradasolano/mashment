/**
 * 
 */
package net.mashment.drools;

import net.mashment.drools.entities.OpenflowController;
import net.mashment.drools.entities.OpenflowPort;
import net.mashment.drools.entities.OpenflowSwitch;
import net.mashment.drools.rules.RuleLoader;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.kie.api.definition.KiePackage;
import org.kie.api.definition.rule.Rule;

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
	// KieSession kieSession;

	// FIXME
	JSONArray jsonArrayNos;

	/**
	 * 
	 */
	public Sensor() {
		jsonArrayNos = new JSONArray();
		JSONObject jsonNos1 = new JSONObject();
		JSONObject jsonNos2 = new JSONObject();
		JSONObject jsonNos3 = new JSONObject();
		try {
			jsonNos1.put("ip", "192.168.210.89");
			jsonNos1.put("port", "8082");
			jsonNos1.put("type", "pox");
			
			jsonNos2.put("ip", "192.168.210.89");
			jsonNos2.put("port", "8081");
			jsonNos2.put("type", "beacon");
			
			jsonNos3.put("ip", "192.168.210.74");
			jsonNos3.put("port", "8083");
			jsonNos3.put("type", "floodlight");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		jsonArrayNos.put(jsonNos1);
		jsonArrayNos.put(jsonNos2);
		jsonArrayNos.put(jsonNos3);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	@Override
	public void run() {

//		for (KiePackage kp : RuleLoader.kieSession.getKieBase()
//				.getKiePackages()) {
//			System.out.println(kp.getName());
//			for (Rule r : kp.getRules()) {
//				System.out.println("    " + r.getName());
//			}
//		}
//		System.out.println("----");

		// // Insert facts into the stateful session
		// final Message message = new Message();
		// message.setMessage("hello");
		// message.setStatus(Message.HELLO);
		// RuleLoader.kieSession.insert(message);
		//
		// // Insert facts into the stateful session
		// final Message message2 = new Message();
		// message2.setMessage("world");
		// message2.setStatus(2);
		// RuleLoader.kieSession.insert(message2);
		//
		// // Fire the rules
		// RuleLoader.kieSession.fireAllRules();

		try {
			// Get switches connected to each NOS
			for (int i = 0; i < jsonArrayNos.length(); i++) {
				JSONObject jsonNos = jsonArrayNos.getJSONObject(i);
				OpenflowController nos = new OpenflowController(
						jsonNos.getString("ip"), jsonNos.getString("port"),
						jsonNos.getString("type"));
				// NOS type? beacon : pox : floodlight : other
				NosClient client;
				if (nos.getType().equalsIgnoreCase("beacon")) {
					client = new NosBeaconClient();
				} else if (nos.getType().equalsIgnoreCase("pox")) {
					client = new NosPoxClient();
				} else if (nos.getType().equalsIgnoreCase("floodlight")) {
					client = new NosFloodlightClient();
				} else {
					return;
				}
				// Get switches connected to NOS
				JSONArray jsonArraySwitch = new JSONArray(
						client.getNosSwitches(nos.getIp(), nos.getPort()));
				// Get ports from each switch
				for (int j = 0; j < jsonArraySwitch.length(); j++) {
					JSONObject jsonSwitch = jsonArraySwitch.getJSONObject(j);
					OpenflowSwitch sw = new OpenflowSwitch(nos,
							jsonSwitch.getString("dpid"));
					// Get ports from switch
					JSONArray jsonArrayPort = new JSONArray(
							client.getNosSwitchPorts(nos.getIp(),
									nos.getPort(), sw.getDpid()));
					for (int k = 0; k < jsonArrayPort.length(); k++) {
						JSONObject jsonPort = jsonArrayPort.getJSONObject(k);

						long rxPackets = jsonPort.getLong("rxPackets");
						long txPackets = jsonPort.getLong("txPackets");
						long rxDrops = jsonPort.getLong("rxDrops");
						long txDrops = jsonPort.getLong("txDrops");
						long rxError = jsonPort.getLong("rxError");
						long txError = jsonPort.getLong("txError");
						float percentRxDrops = ((float) rxDrops / rxPackets * 100);
						float percentTxDrops = ((float) txDrops / txPackets * 100);
						float percentRxError = ((float) rxError / rxPackets * 100);
						float percentTxError = ((float) txError / txPackets * 100);

						OpenflowPort port = new OpenflowPort(sw,
								String.valueOf(jsonPort.getInt("number")),
								percentRxDrops, percentTxDrops, percentRxError,
								percentTxError);
						
						port.setReceivedPackets(rxPackets);

						// Insert facts into the stateful session
						RuleLoader.kieSession.insert(nos);
						RuleLoader.kieSession.insert(sw);
						RuleLoader.kieSession.insert(port);
					}
				}
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		// Fire the rules
		RuleLoader.kieSession.fireAllRules();

	}

}
