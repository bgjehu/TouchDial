//
//  Contact.swift
//  TouchDial
//
//  Created by Jieyi Hu on 9/19/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

class Contact {
    var name : String = ""
    var number : String = ""
    var numberType : String = ""
    var oneliner : String {
        get{
            let numberTypeString = numberType != "" ? "(\(numberType))" : ""
            if name == "" {
                //  "123-456-7890"
                //  "123-456-7890(main)"
                return "\(number)\(numberTypeString)"
            } else {
                //  "JE: 123-456-7890"
                //  "JE: 123-456-7890(iPhone)"
                return "\(name): \(number)\(numberTypeString)"
            }
        }
    }
    
    init(firstName : String, lastName : String, number : String, numberType : String) {
        if firstName == "" && lastName == "" {
            // name = "" + "" = ""
            name = ""
        } else {
            if firstName == "" {
                //  name = "" + "last" = "last"
                name = lastName
            } else {
                if lastName == "" {
                    //  name = "first" + "" = "first"
                    name = firstName
                } else {
                    //  name = "first" + "last" = "first last"
                    name = "\(firstName) \(lastName)"
                }
            }
        }
        self.number = number
        self.numberType = numberType
    }
    init(jsonRecord : [String : String]){
        name = jsonRecord["name"]!
        number = jsonRecord["number"]!
        numberType = jsonRecord["numberType"]!
    }
    func toJSONRecord() -> [String : String] {
        return ["name" : name, "number" : number, "numberType" : numberType]
    }
    func hasSameNumber(with contact : Contact) -> Bool{
        return self.number == contact.number
    }
}

extension CollectionType where Generator.Element == Contact {
    func numberExisted(contact : Contact) -> Bool {
        if self.count > 0 {
            for index in startIndex..<endIndex {
                if self[index].hasSameNumber(with: contact) {
                    return true
                } else {
                    /* Do nothing */
                }
            }
            return false
        } else {
            return false
        }
    }
}
