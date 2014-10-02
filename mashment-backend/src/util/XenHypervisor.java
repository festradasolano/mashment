/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.UniformInterfaceException;
import com.sun.jersey.api.client.WebResource;

/** Jersey REST client generated for REST resource:XenResource [xen]<br>
 *  USAGE:<pre>
 *        XenHypervisor client = new XenHypervisor();
 *        Object response = client.XXX(...);
 *        // do whatever with response
 *        client.close();
 *  </pre>
 * @author omcaicedo
 */
public class XenHypervisor {
    private WebResource webResource;
    private Client client;
    private static final String BASE_URI = "http://localhost:8080/vnwrapper/resources";

    public XenHypervisor() {
        com.sun.jersey.api.client.config.ClientConfig config = new com.sun.jersey.api.client.config.DefaultClientConfig();
        client = Client.create(config);
        webResource = client.resource(BASE_URI).path("xen");
    }

    public String getHostInfo(String servers) throws UniformInterfaceException {
        WebResource resource = webResource;
        if (servers != null) {
            resource = resource.queryParam("servers", servers);
        }
        resource = resource.path("hostinfo");
        return resource.accept(javax.ws.rs.core.MediaType.APPLICATION_JSON).get(String.class);
    }

    public void close() {
        client.destroy();
    }
    
}
