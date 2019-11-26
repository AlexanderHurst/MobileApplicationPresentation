package com.ontechu.eyespy.api;

import java.net.ServerSocket;
import java.io.IOException;
import io.vertx.core.Vertx;
import io.vertx.core.DeploymentOptions;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.unit.Async;
import io.vertx.ext.unit.TestContext;
import io.vertx.ext.unit.junit.VertxUnitRunner;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

/**
 * JUnit Test for com.ontechu.eyespy.api.Server
 */
@RunWith(VertxUnitRunner.class)
public class ServerTest {

    private Vertx vertx;
    private int port;

    /**
     * Test configuration tasks - create vertex instance and deploy
     * our Server class. We create a random port here and create a
     * DeploymentOptions object to simulate getting input from a
     * JSON-based configuration file.
     */
    @Before
    public void configure(TestContext context) throws IOException {
	vertx = Vertx.vertx();

	ServerSocket socket = new ServerSocket(0);
	port = socket.getLocalPort();
	socket.close();
	
	DeploymentOptions options = new DeploymentOptions();
	options.setConfig(new JsonObject().put("http.port", port));
	
	vertx.deployVerticle(Server.class.getName(),
			     options,
			     context.asyncAssertSuccess());
    }

    /**
     * Test clean-up tasks - destroy the vertx instance.
     */
    @After
    public void clean(TestContext context) {
	vertx.close(context.asyncAssertSuccess());
    }

    /**
     * JUnit test.Sends a request to the HTTP server on localhost and
     * verifies the root route can be accessed.
     */
    @Test
    public void testRoot(TestContext context) {
	
	final Async async = context.async();
	
	vertx.createHttpClient()
	    .getNow(port, "localhost", "/", response -> {
		response.handler(body -> {
			context.assertTrue(body
					   .toString()
					   .contains("root"));
			async.complete();
		    });
	    });
    }

    /**
     * JUnit test.Sends a request to the HTTP server on localhost and
     * verifies that the database route can not be accessed without
     * authentication.
     */
    @Test
    public void testDatabaseBadAuth(TestContext context) {
	
	final Async async = context.async();
	
	vertx.createHttpClient()
	    .getNow(port, "localhost", "/database", response -> {
		response.handler(body -> {
			context.assertFalse(body
					    .toString()
					    .contains("database"));
			async.complete();
		    });
	    });
    }

    /**
     * JUnit test.Sends a request to the HTTP server on localhost and
     * verifies that the login route can be accessed.
     */
    /*@Test
    public void testLogin(TestContext context) {
	
	final Async async = context.async();
	
	vertx.createHttpClient()
	    .getNow(port, "localhost", "/login", response -> {
		response.handler(body -> {
			context.assertTrue(body
					   .toString()
					   .contains("login"));
			async.complete();
		    });
	    });
    }*/   
}
