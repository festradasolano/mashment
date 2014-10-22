/**
 * 
 */
package net.mashment.drools.rules;

import java.sql.SQLException;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import net.mashment.drools.NmsitDao;
import net.mashment.drools.Sensor;

import org.codehaus.jettison.json.JSONArray;
import org.codehaus.jettison.json.JSONException;
import org.codehaus.jettison.json.JSONObject;
import org.kie.api.KieServices;
import org.kie.api.builder.KieBuilder;
import org.kie.api.builder.KieFileSystem;
import org.kie.api.builder.Message.Level;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;

/**
 * @author festradasolano
 * 
 */
@WebListener
public class RuleLoader implements ServletContextListener, Runnable {

	private KieSession kieSession;

//	private ScheduledExecutorService scheduler;

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.ServletContextListener#contextDestroyed(javax.servlet.
	 * ServletContextEvent)
	 */
	@Override
	public void contextDestroyed(ServletContextEvent sce) {

		if (kieSession != null) {
			kieSession.dispose();
		}

		// Check if an scheduler exists
//		if (scheduler != null) {
//			// Shutdown the scheduler
//			scheduler.shutdown();
//		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * javax.servlet.ServletContextListener#contextInitialized(javax.servlet
	 * .ServletContextEvent)
	 */
	@Override
	public void contextInitialized(ServletContextEvent sce) {

//		Thread loader = new Thread(this);
//		loader.start();

		// CREATE AN SCHEDULER
//		scheduler = Executors.newSingleThreadScheduledExecutor();
//		scheduler.scheduleAtFixedRate(new Sensor(kieSession), 10, 10,
//				TimeUnit.SECONDS);
	}

	/**
	 * Returns file system separator string.
	 * 
	 * @return File system separator ("/" on Unix, "\" on Windows)
	 */
	private static String getFileSeparator() {
		return System.getProperty("file.separator");
	}

	/**
	 * @param contextPath
	 * @param filename
	 * @return
	 */
	private static String getRulePath(String filename) {
		final String[] DIRS_TO_RULE_DIR = { "src", "main", "resources", "net",
				"mashment", "drools", "rules" };
		// build path to rule directory
		StringBuilder ruleDirPath = new StringBuilder();
		for (String dir : DIRS_TO_RULE_DIR) {
			ruleDirPath.append(dir).append(RuleLoader.getFileSeparator());
		}
		return ruleDirPath.toString() + filename;
	}

	/**
	 * @param _nmsit
	 * @return
	 */
	public static String buildRule(JSONObject nmsit) {
		try {
			// declare constants
			final String RULE_PACKAGE = "net.mashment.drools.rules";
			final String ENTITY_PACKAGE = "net.mashment.drools.entities";
			final String KEY_SITUATION = "SITUATION";
			final String KEY_EAC = "EAC";
			final String KEY_ENTITY = "ENTITY";
			final String KEY_PROPERTY = "PROPERTY";
			final String KEY_ATTRIBUTE = "ATTRIBUTE";
			final String KEY_CONSTRAINT = "CONSTRAINT";
			// get rule parameters
			String situation = nmsit.getString(KEY_SITUATION);
			JSONArray eacArray = nmsit.getJSONArray(KEY_EAC);
			// build rule
			StringBuilder rule = new StringBuilder();
			// add rule's package: default
			rule.append("package ").append(RULE_PACKAGE).append(" \n");
			rule.append("\n");
			// add rule's imports: entities (default package)
			for (int i = 0; i < eacArray.length(); i++) {
				// entities
				JSONObject eac = eacArray.getJSONObject(i);
				rule.append("import ").append(ENTITY_PACKAGE).append(".")
						.append(eac.getString(KEY_ENTITY)).append(" \n");
			}
			rule.append("\n");
			// add rule's name: situation
			rule.append("rule \"").append(situation).append("\" \n");
			// add rule's when: entities, attributes and constraints
			rule.append("    when \n");
			for (int i = 0; i < eacArray.length(); i++) {
				// entities
				JSONObject eac = eacArray.getJSONObject(i);
				rule.append("        ").append(eac.getString(KEY_ENTITY))
						.append("(");
				// attributes and constraints
				JSONArray propertyArray = eac.getJSONArray(KEY_PROPERTY);
				for (int j = 0; j < propertyArray.length(); j++) {
					if (j > 0) {
						rule.append(", ");
					}
					JSONObject property = propertyArray.getJSONObject(j);
					rule.append(property.getString(KEY_ATTRIBUTE)).append(" ")
							.append(property.get(KEY_CONSTRAINT));
				}
				rule.append(") \n");
			}
			// FIXME add rule's then: printing
			rule.append("    then \n");
			rule.append("        System.out.println(\"Detected situation ")
					.append(situation).append("\"); \n");
			// add rule's end
			rule.append("end \n");
			System.out.println(rule.toString());
			return rule.toString();
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return null;
	}
	
	public void loadRule() {
		// TODO
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see java.lang.Runnable#run()
	 */
	@Override
	public void run() {
		// create kie file system to define a kie module programmatically
		KieServices kieServices = KieServices.Factory.get();
		KieFileSystem kieFileSystem = kieServices.newKieFileSystem();
		try {
			// get array of rules from database
			JSONArray jsonArrayNmsit = NmsitDao.listNmsits();
			for (int i = 0; i < jsonArrayNmsit.length(); i++) {
				// get nmsit situation and rule
				JSONObject jsonNmsit = jsonArrayNmsit.getJSONObject(i);
				String ruleName = jsonNmsit.getString("situation");
				String rule = jsonNmsit.getString("rule");
				// write each rule through the kie file system
				kieFileSystem.write(RuleLoader.getRulePath(ruleName + ".drl"),
						rule);
			}
		} catch (JSONException e) {
			e.printStackTrace();
			return;
		}
		// build the kie file system
		KieBuilder kieBuilder = kieServices.newKieBuilder(kieFileSystem);
		kieBuilder.buildAll();
		if (kieBuilder.getResults().hasMessages(Level.ERROR)) {
			throw new RuntimeException("Build Errors:\n"
					+ kieBuilder.getResults().toString());
		}
		// build kie session
		KieContainer kieContainer = kieServices.newKieContainer(kieServices
				.getRepository().getDefaultReleaseId());
		// dispose old kie session and save new kie session
		KieSession kieSessionToDispose = this.kieSession;
		this.kieSession = kieContainer.newKieSession();
		kieSessionToDispose.dispose();
		kieSessionToDispose = null;
	}

}
