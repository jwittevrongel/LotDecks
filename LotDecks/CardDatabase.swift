//
//  CardDatabase.swift
//  LotDecks
//
//  Created by Jeremiah Wittevrongel on 3/12/16.
//  Copyright © 2016 Jeremiah Wittevrongel. All rights reserved.
//

import UIKit
import Foundation
import SQLite

enum CardDatabaseError : ErrorType {
    case OpenFailed
}

class CardDatabase {
    static var db: Connection?
    
    // Tables
    let table_heroCards = Table("hero_cards");
    let table_spheres = Table("spheres");
    let table_sets = Table("sets");
    let table_cardTypes = Table("card_types");

    // columns
    let col_id = Expression<Int64>("id");
    let col_name = Expression<String>("name");
    let col_image = Expression<NSData>("image_jpeg");
    
    init() throws {
        do {
            if (CardDatabase.db == nil) {
                CardDatabase.db = try Connection(NSBundle(forClass: MasterViewController.self).pathForResource("cards", ofType: "db")!, readonly: true)
            }
        }
        catch {
            throw CardDatabaseError.OpenFailed
        }
    }
    
    func getAllHeroesByName() throws -> AnySequence<Row> {
        return try CardDatabase.db!.prepare(heroesByName())
    }
    
    func getImageForHero(cardId: Int64) -> UIImage? {
        do {
            let rows = try CardDatabase.db!.prepare(heroImage(cardId))
            for row in rows {
                return UIImage(data: row.get(col_image));
            }
        }
        catch {
            
        }
        return UIImage()
    }
    
    private func heroesByName() -> Table {
        return table_heroCards.select(col_id, col_name).order(col_name)
    }
    
    private func heroImage(cardId: Int64) -> QueryType {
        return table_heroCards.select(col_image).filter(col_id == cardId)
    }
    
}

// assumes NSData conformance, above
extension UIImage: Value {
    public class var declaredDatatype: String {
        return Blob.declaredDatatype
    }
    public class func fromDatatypeValue(blobValue: Blob) -> UIImage {
        return UIImage(data: NSData.fromDatatypeValue(blobValue))!
    }
    public var datatypeValue: Blob {
        return UIImagePNGRepresentation(self)!.datatypeValue
    }
}
