package com.amrit;

import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.mongodb.client.MongoDatabase;

public class MongoUtil {

    private static MongoClient mongoClient;

    static {
        mongoClient = MongoClients.create("mongodb://localhost:27017");
    }

    public static MongoDatabase getDatabase() {
        return mongoClient.getDatabase("traveldb");
    }
}