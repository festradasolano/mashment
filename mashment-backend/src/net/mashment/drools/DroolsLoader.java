/**
 * 
 */
package net.mashment.drools;


import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import org.kie.api.runtime.KieSession;
import org.springframework.context.ApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * @author festradasolano
 *
 */
@WebListener
public class DroolsLoader implements ServletContextListener {
	
	/**
	 * Stateful session to insert data and fire rules.
	 */
	private KieSession kieSession;
	
	/**
	 * 
	 */
	private ScheduledExecutorService scheduler;
	
	/* (non-Javadoc)
	 * @see javax.servlet.ServletContextListener#contextDestroyed(javax.servlet.ServletContextEvent)
	 */
	@Override
	public void contextDestroyed(ServletContextEvent sce) {
		// Check if a stateful session exists
		if (kieSession != null) {
			// Dispose the stateful session
			kieSession.dispose();
		}
		// Check if an scheduler exists
		if (scheduler != null) {
			// Shutdown the scheduler
			scheduler.shutdown();
		}
	}

	/* (non-Javadoc)
	 * @see javax.servlet.ServletContextListener#contextInitialized(javax.servlet.ServletContextEvent)
	 */
	@Override
	public void contextInitialized(ServletContextEvent sce) {
		// Obtain application context
		ApplicationContext applicationContext = WebApplicationContextUtils.getWebApplicationContext(sce.getServletContext());
		// Check if application context is not null
		if (applicationContext != null) {
			// Obtain created stateful session bean from application context
			kieSession = (KieSession) applicationContext.getBean("kiesession");
			// CREATE AN SCHEDULER
			scheduler = Executors.newSingleThreadScheduledExecutor();
			scheduler.scheduleAtFixedRate(new Sensor(kieSession), 10, 10, TimeUnit.SECONDS);
		}
	}
	
}
