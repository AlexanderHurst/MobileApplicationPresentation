package com.ontechu.eyespy.api;

import java.util.concurrent.atomic.AtomicInteger;

public class Camera {
    
    // Allow us to create a unique, incrementable, integer id
    private static final AtomicInteger COUNTER = new AtomicInteger();

    private int orgId;
    private int accountId;
    private final int cameraId;

    private String cameraNickname;
    private String cameraAddress;

    public Camera(int orgId, int accountId, String cameraNickname, String cameraAddress) {
	this.orgId = orgId;
	this.accountId = accountId;
	this.cameraId = COUNTER.getAndIncrement();
	this.cameraNickname = cameraNickname;
	this.cameraAddress = cameraAddress;
    }

    public Camera() {
	// By default -1: an unassigned camera
	this.orgId = -1;
	this.accountId = -1;
	this.cameraId = COUNTER.getAndIncrement();
    }

    public String getName() {
	return this.cameraNickname;
    }

    public String getAddress() {
	return this.cameraAddress;
    }

    public int getOrg() {
	return this.orgId;
    }

    public int getAccount() {
	return this.accountId;
    }

    public int getId() {
	return this.cameraId;
    }

    public void setName(String name) {
	this.cameraNickname = name;
    }

    public void setAddress(String address) {
	this.cameraAddress = address;
    }

    public void setOrg(int orgId) {
	this.orgId = orgId;
    }

    public void setAccount(int accountId) {
	this.accountId = accountId;
    }
    
}
