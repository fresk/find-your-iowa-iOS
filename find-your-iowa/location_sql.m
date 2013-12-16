//
//  location_db_sql.c
//  find-your-iowa
//
//  Created by Thomas Hansen on 12/9/13.
//  Copyright (c) 2013 Thomas Hansen. All rights reserved.
//
#include <stdio.h>
#import <sqlite3.h>
#include "locations_sql.h"
#include "Location.h"
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

/*
 id varchar PRIMARY KEY NOT NULL,
 lat float,
 lng float,
 name varchar,
 city varchar,
 images varchar,
 categories varchar,
 popularity float,
 last_update integer
 */

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv)
{
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    assert(argc == 4);
    // check that all four arguments are non-null
    if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        sqlite3_result_null(context);
        return;
    }
    // get the four argument values
    double lat1 = sqlite3_value_double(argv[0]);
    double lon1 = sqlite3_value_double(argv[1]);
    double lat2 = sqlite3_value_double(argv[2]);
    double lon2 = sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}


sqlite3* open_locations_db(){
    sqlite3* _db;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"locations" ofType:@"db"];
    if (sqlite3_open([filePath UTF8String], &_db) == SQLITE_OK){
        NSLog(@"open sqlite:  OK.");
    }
    else
        NSLog(@"Failed to open sqlite3 DB.");
    
    if (sqlite3_create_function(_db, "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL) == SQLITE_OK){
        
    }else{
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(_db), sqlite3_errmsg(_db));
    }
    return _db;
};


UIImageView* imageViewForLocation(NSDictionary* location);


NSDictionary* dictionaryFromSqlRow(sqlite3_stmt* stmt){
    int num_columns = sqlite3_data_count(stmt);
    NSDictionary* dict = [[NSMutableDictionary alloc] init];
    for(int i=0; i< num_columns; i++){
        NSString* key = [NSString stringWithUTF8String:(char *)sqlite3_column_name(stmt, i)];
        int column_type = sqlite3_column_type(stmt, i);
        if (column_type == SQLITE_INTEGER){
            NSNumber* val = [NSNumber numberWithInt:sqlite3_column_int(stmt, i)];
            [dict setValue:val forKey:key];
        }
        else if(column_type == SQLITE_FLOAT){
            NSNumber* val = [NSNumber numberWithFloat:sqlite3_column_double(stmt, i)];
            [dict setValue:val forKey:key];
        }
        else {
            NSString* val = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, i)];
            [dict setValue:val forKey:key];
        }
    }
    return dict;
}


NSArray* queryLocations(NSString* sql_query) {
    
    sqlite3* db = open_locations_db();
    sqlite3_stmt* sql_stmt;
    NSMutableArray* results = [[NSMutableArray alloc] init];
    
    if (sqlite3_prepare_v2(db, [sql_query UTF8String], -1, &sql_stmt, NULL) != SQLITE_OK){
        NSLog(@"Database returned error %d: %s", sqlite3_errcode(db), sqlite3_errmsg(db));
        sqlite3_close(db);
        return results;
    }
    
    while(sqlite3_step(sql_stmt) == SQLITE_ROW){
        NSDictionary* location_dict = dictionaryFromSqlRow(sql_stmt);
        Location* location = [[Location alloc] initWithData: location_dict];
        [results addObject:location];
    }
    
    sqlite3_finalize(sql_stmt);
    sqlite3_close(db);
    return results;
}


