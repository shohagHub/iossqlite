//
//  DatabaseManger.swift
//  SqliteDatabaseSwift
//
//  Created by Nazia Afroz on 1/10/18.
//  Copyright © 2018 Nazia Afroz. All rights reserved.
//

import UIKit
import SQLite3

class DatabaseManger {
    
    let dbName = "first.db"
    static let shared = DatabaseManger()
    var db: OpaquePointer?
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    private init(){
        print("singletone initialized")
        let dbPath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbName)
        if sqlite3_open(dbPath.path, &db) == SQLITE_OK {
            print("Successfully opened database connection at \(dbPath.path)")
        }
        else {
            print("unable to open database connection")
        }
    }
    
    
    
    let createTableQueryString = """
CREATE TABLE Dictionary(
Id INTEGER PRIMARY KEY AUTOINCREMENT,  image BLOB);
"""
    
    /*
     * call this method to create table
     */
    func createDictionaryTable() {
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableQueryString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("Dictionary table created.")
            } else {
                print("Dictionary table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    
    let insertStatementString = "INSERT INTO Dictionary (image) VALUES (?);"
    func insert() {
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let image = UIImage.init(named: "twiter.png")
            let data = UIImagePNGRepresentation(image!)! as NSData
            sqlite3_bind_blob(insertStatement, 1, data.bytes, Int32(data.length), SQLITE_TRANSIENT)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    
    let readQueryString = "select * from Dictionary;"
    func query() -> UIImage{
        var queryStatement: OpaquePointer? = nil
        var result: UIImage = UIImage.init()
        if sqlite3_prepare_v2(db, readQueryString, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let len = sqlite3_column_bytes(queryStatement, 1)
                let imageData = sqlite3_column_blob(queryStatement, 1)
                if imageData != nil {
                    let data = NSData.init(bytes: imageData, length: Int(len))
                    let image = UIImage.init(data: data as Data)
                    if image == nil{
                        print("image is nill check")
                        continue
                    }
                    result = image!
                    print("hi")
                }
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return result
    }

}
