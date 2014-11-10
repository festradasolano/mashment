/**
 * 
 */
package net.mashment.drools.rules;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import net.mashment.drools.NmsitDao;
import net.mashment.drools.Sensor;

import org.apache.commons.lang3.text.WordUtils;
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

	public static KieSession kieSession;

	private ScheduledExecutorService scheduler;

	/*
	 * (non-Javadoc)
	 * 
	 * @see javax.servlet.ServletContextListener#contextDestroyed(javax.servlet.
	 * ServletContextEvent)
	 */
	@Override
	public void contextDestroyed(ServletContextEvent sce) {

		if (RuleLoader.kieSession != null) {
			RuleLoader.kieSession.dispose();
		}

		// Check if an scheduler exists
		if (scheduler != null) {
			// Shutdown the scheduler
			scheduler.shutdown();
		}
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

		// Thread loader = new Thread(this);
		// loader.start();
		this.loadAllRules();

		// CREATE AN SCHEDULER
		scheduler = Executors.newSingleThreadScheduledExecutor();
		scheduler.scheduleAtFixedRate(new Sensor(), 5, 5, TimeUnit.SECONDS);
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
			final String ENTITY_PREFIX = "e";
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
				String entity = eac.getString(KEY_ENTITY);
				rule.append("import ").append(ENTITY_PACKAGE).append(".")
						.append(WordUtils.capitalize(entity)).append(" \n");
			}
			rule.append("\n");
			// add rule's name: situation
			rule.append("rule \"").append(situation).append("\" \n");
			// add rule's when: entities, attributes and constraints
			rule.append("    when \n");
			for (int i = 0; i < eacArray.length(); i++) {
				boolean firstAttribute = true;
				// entities
				JSONObject eac = eacArray.getJSONObject(i);
				String entity = eac.getString(KEY_ENTITY);
				rule.append("        $").append(ENTITY_PREFIX).append(i)
						.append(" : ").append(WordUtils.capitalize(entity))
						.append("(");
				// check if entity is a constraint in other eac
				for (int j = 0; j < eacArray.length(); j++) {
					JSONObject eacCheck = eacArray.getJSONObject(j);
					String entityAsParam = eacCheck.getString(KEY_ENTITY);
					JSONArray propertyArrayCheck = eacCheck
							.getJSONArray(KEY_PROPERTY);
					for (int k = 0; k < propertyArrayCheck.length(); k++) {
						JSONObject propertyCheck = propertyArrayCheck
								.getJSONObject(k);
						String constraintCheck = propertyCheck
								.getString(KEY_CONSTRAINT);
						if (entity.equalsIgnoreCase(constraintCheck)) {
							// check if first attribute
							if (!firstAttribute) {
								rule.append(", ");
							}
							rule.append(entityAsParam).append(" == $")
									.append(ENTITY_PREFIX).append(j);
							firstAttribute = false;
						}
					}
				}
				// attributes and constraints
				JSONArray propertyArray = eac.getJSONArray(KEY_PROPERTY);
				for (int j = 0; j < propertyArray.length(); j++) {
					// get attribute and constraint
					JSONObject property = propertyArray.getJSONObject(j);
					String attribute = property.getString(KEY_ATTRIBUTE);
					String constraint = property.getString(KEY_CONSTRAINT);
					// check if constraint references an entity
					boolean isConstraintAnEntity = false;
					for (int k = 0; k < eacArray.length(); k++) {
						JSONObject eacCheck = eacArray.getJSONObject(k);
						String entityCheck = eacCheck.getString(KEY_ENTITY);
						if (constraint.equalsIgnoreCase(entityCheck)) {
							isConstraintAnEntity = true;
							break;
						}
					}
					// if constraint is an entity or all, do not add attribute
					if (!isConstraintAnEntity
							&& !constraint.equalsIgnoreCase("all")) {
						// check if first attribute
						if (!firstAttribute) {
							rule.append(", ");
						}
						// check if constraint includes operator
						rule.append(attribute).append(" ");
						if (!constraint.matches("[<>=!].*")) {
							// separate or
							String[] options = constraint.split("or");
							boolean firstConstraint = true;
							for (String opt : options) {
								if (!firstConstraint) {
									rule.append(" || ");
								}
								rule.append("== \"").append(opt.trim())
										.append("\"");
								firstConstraint = false;
							}
						} else {
							rule.append(constraint);
						}
						firstAttribute = false;
					}
				}
				rule.append(") \n");
			}
			// FIXME add rule's then: printing
			rule.append("    then \n");
			// rule.append("        System.out.println(\"Detected situation ")
			// .append(situation).append("\"); \n");

			rule.append("        System.out.println(\"Detected situation ")
					.append(situation)
					.append(" for \" + $e2.toString() ); \n");
			// + \" in  \"); \n");

			// add rule's end
			rule.append("end \n");
			System.out.println(rule.toString());

			// StringBuilder rule2 = new StringBuilder();
			// rule2.append("package net.mashment.drools.rules \n");
			// rule2.append("\n");
			// rule2.append("import net.mashment.drools.entities.Message; \n");
			// rule2.append("\n");
			// rule2.append("rule \"test\" \n");
			// rule2.append("		salience 50 \n");
			// rule2.append("    when \n");
			// rule2.append("        m : Message(status == Message.HELLO, message : message) \n");
			// rule2.append("    then \n");
			// rule2.append("        System.out.println(\"Rule added as a new file\"); \n");
			// rule2.append("end \n");
			// return rule2.toString();

			return rule.toString();
		} catch (JSONException e) {
			e.printStackTrace();
		}

		return null;
	}

	public void loadAllRules() {
		// TODO
		Thread ruleLoader = new Thread(this);
		ruleLoader.start();
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
		KieSession kieSessionToDispose = RuleLoader.kieSession;
		RuleLoader.kieSession = kieContainer.newKieSession();
		if (kieSessionToDispose != null) {
			kieSessionToDispose.dispose();
			kieSessionToDispose = null;
		}
	}

}
