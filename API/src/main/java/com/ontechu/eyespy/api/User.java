package com.ontechu.eyespy.api;

import java.util.concurrent.atomic.AtomicInteger;

public class User {
    
    // Allow us to create a unique, incrementable, integer id
    private static final AtomicInteger COUNTER = new AtomicInteger();

    private int orgId;
    private int accountId;
    private final int userId;

    private String username;
    private String password;

    public User(int orgId, int accountId, String username, String password) {
	this.orgId = orgId;
	this.accountId = accountId;
	this.userId = COUNTER.getAndIncrement();
	this.username = username;
	this.password = password;
    }

    public User() {
	// By default -1: an unassigned camera
	this.orgId = -1;
	this.accountId = -1;
	this.userId = COUNTER.getAndIncrement();
    }

    public String getName() {
	return this.username;
    }

    public String getPassword() {
	return this.password;
    }

    public int getOrg() {
	return this.orgId;
    }

    public int getAccount() {
	return this.accountId;
    }

    public int getId() {
	return this.userId;
    }

    public void setUsername(String name) {
	this.username = name;
    }

    public void setPassword(String password) {
	this.password = password;
    }

    public void setOrg(int orgId) {
	this.orgId = orgId;
    }

    public void setAccount(int accountId) {
	this.accountId = accountId;
    }
    
}
