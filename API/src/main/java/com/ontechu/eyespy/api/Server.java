package com.ontechu.eyespy.api;

import io.vertx.core.AbstractVerticle;
import io.vertx.core.Future;
import io.vertx.core.http.HttpServerResponse;
import io.vertx.core.json.Json;
import io.vertx.core.json.JsonObject;
import io.vertx.ext.web.Router;
import io.vertx.ext.web.RoutingContext;
import io.vertx.ext.web.handler.BodyHandler;
import io.vertx.ext.web.handler.StaticHandler;
import io.vertx.core.file.AsyncFile;
import io.vertx.core.file.OpenOptions;
import io.vertx.core.streams.Pump;

import java.util.*;
import java.io.*;

/**
 * Main server entry-point.
 */
public class Server extends AbstractVerticle {

    private String keyA = "SecretCode";
    private String keyB = "SuperSecure";
    private String rootDir = System.getProperty("user.dir");
    private Map<Integer, Camera> cameraListA = new HashMap<Integer, Camera>();
    private Map<Integer, Camera> cameraListB = new HashMap<Integer, Camera>();
    private Map<String, User> users = new HashMap<String, User>();
    
    /**
     * Creates an HTTP server and listens for incoming connections on
     * port 8080.
     *
     * param fut A Future object that tells us when the start sequence
     * is completed
     */
    @Override
    public void start(Future<Void> fut) {

	this.mockDataA();
	this.mockDataB();
	this.mockUsers();

	Router router = Router.router(vertx);

	router.route("/").handler(routingContext -> {
		HttpServerResponse response = routingContext.response();
		response
		    .putHeader("Content-Type", "text/html")
		    .end("<p>This is the root route</p>");
	    });

	router.post("/database").handler(routingContext -> {
		String xApiKey =
		    routingContext.request().getHeader("x-api-key");
		if (!xApiKey.equals("secretcode")) {
		    // The authentication failed
		    // TODO: Refactor into a common authentication system
		    HttpServerResponse response = routingContext.response();
		    response
			.putHeader("Content-Type", "text/html")
			.setStatusCode(401)
			.end("<b>You are not authorized to access this" +
			     "resource<b>");
		    return;
		} else {
		    // The authentication was a success
		    HttpServerResponse response = routingContext.response();
		    response
			.putHeader("Content-Type", "text/html")
			.end("<p>This is the database route</p>");
		}
	    });

	router.route("/login").handler(BodyHandler.create());
	router.route("/login").handler(routingContext -> {
		JsonObject body = routingContext.getBodyAsJson();

		if (!(body.containsKey("username") && body.containsKey("password"))) {
		    String msg = "Malformed request body";
		    this.errorMessage(routingContext, msg, 400);
		    return;
		}
				
		String username = body.getString("username");
		String password = body.getString("password");

		boolean validUser = users.containsKey(username);
		if (!validUser) {
		    // The user is not in the database
		    String msg = "Invalid username - contact your administrator to sign up";
		    this.errorMessage(routingContext, msg, 500);
		    return;
		}

		User currentUser = users.get(username);

		if (!currentUser.getPassword().equals(password)) {
		    // The sent password doesn't match
		    String msg = "Invalid password";
		    this.errorMessage(routingContext, msg, 403);
		    return;
		}

		if (currentUser.getAccount() == 1) {
		    JsonObject response = new JsonObject();
		    response.put("key", this.keyA);
		    routingContext.response()
			.putHeader("Content-Type", "application/json")
			.end(Json.encodePrettily(response));
		    return;
		} else {
		    JsonObject response = new JsonObject();
		    response.put("key", this.keyB);
		    routingContext.response()
			.putHeader("Content-Type", "application/json")
			.end(Json.encodePrettily(response));
		    return;
		}
		

	    });

	router.route("/sources").handler(routingContext -> {
		this.authenticate(routingContext);

	        String xApiKey = routingContext.request().getHeader("x-api-key");

		if (xApiKey.equals(this.keyA)) {
		    routingContext.response()
			.putHeader("content-type", "application/json")
			.end(Json.encodePrettily(cameraListA.values()));
		    return;
		}

		if (xApiKey.equals(this.keyB)) {
		    routingContext.response()
			.putHeader("content-type", "application/json")
			.end(Json.encodePrettily(cameraListB.values()));
		    return;
		}

		// Somehow an unknown x-api-key got through
		String msg = "Unknown x-api-key authenticated";
		this.errorMessage(routingContext, msg, 500);
	    });
	
	router.route("/source").handler(BodyHandler.create());
	router.route("/source").handler(routingContext -> {
		this.authenticate(routingContext);

		JsonObject body = routingContext.getBodyAsJson();
		
		if (body.containsKey("camera_id")) {
		    int sourceId = body.getInteger("camera_id");
		    String path = this.rootDir + File.separator + "assets" + File.separator + sourceId + ".mp4";

		    File video = new File(path);
		    if (!video.exists()) {
			// The camera video doesn't exist
			String msg = "Failed to connect to camera";
			this.errorMessage(routingContext, msg, 404);
			return;
		    }
		    
		    vertx.fileSystem().open(path, new OpenOptions(), readEvent -> {
			    if (readEvent.failed()) {
				routingContext.response()
				    .setStatusCode(500)
				    .end("EVENT FAILED");
				return;
			    }

			    AsyncFile file = readEvent.result();
			    routingContext.response().setChunked(true);
			    
			    Pump pump = Pump.pump(file, routingContext.response());
			    pump.start();

			    file.endHandler(aVoid -> {
				    file.close();
				    routingContext.response().end();
				});
			});
		} else {
		    String msg = "You must specify a camera_id";
		    this.errorMessage(routingContext, msg, 400);
		    return;
		}		
	    });
	
	vertx
	    .createHttpServer()
	    .requestHandler(router::accept)
	    .listen(config().getInteger("http.port", 8080), result -> {
		    if (result.succeeded()) {
			fut.complete();
		    } else {
			fut.fail(result.cause());
		    }
		});
    }

    protected void authenticate(RoutingContext routingContext) {
	
	String xApiKey = routingContext.request().getHeader("x-api-key");

	// Check if we have the right headers
	if (xApiKey == null) {
	    String msg = "You must present authorization to access this resource";
	    this.errorMessage(routingContext, msg, 403);
	    return;
	}

	String[] keys = {this.keyA, this.keyB};
	boolean activeKey = Arrays.stream(keys).anyMatch(xApiKey::equals);
	// Check if we have the right authorization
	if (!activeKey) {
	    String msg = "Authorization failed - You are not authorized to access this resource";
	    this.errorMessage(routingContext, msg, 401);
	    return;
	}
    }

    protected void errorMessage(RoutingContext routingContext, String message, int code) {
	JsonObject error = new JsonObject();
	error.put("error", message);
	routingContext.response()
	    .putHeader("content-type", "application/json")
	    .setStatusCode(code)
	    .end(Json.encodePrettily(error));
    }

    private void mockDataA() {
	Camera a = new Camera(1, 1, "Carpark", "10.10.10.40");
	Camera b = new Camera(1, 1, "Hallway-A", "10.10.10.41");
	Camera c = new Camera(1, 1, "Enterance", "10.10.10.42");

	this.cameraListA.put(a.getId(), a);
	this.cameraListA.put(b.getId(), b);
	this.cameraListA.put(c.getId(), c);
    }

    private void mockDataB() {
	Camera a = new Camera(2, 2, "Main Floor", "88.87.86.10");
	Camera b = new Camera(2, 2, "Exterior", "88.87.86.11");
	Camera c = new Camera(2, 2, "Underground Parking", "88.87.86.12");

	this.cameraListB.put(a.getId(), a);
	this.cameraListB.put(b.getId(), b);
	this.cameraListB.put(c.getId(), c);
    }

    private void mockUsers() {
	User a = new User(1, 1, "johndoe", "johndoe");
	User b = new User(1, 1, "janedoe", "janedoe");
	User c = new User(2, 2, "jack", "jack");
	User d = new User(2, 2, "jill", "jill");

	this.users.put(a.getName(), a);
	this.users.put(b.getName(), b);
	this.users.put(c.getName(), c);
	this.users.put(d.getName(), d);
    }
}
