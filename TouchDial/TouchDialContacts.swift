//
//  TouchDialContacts.swift
//  TouchDial
//
//  Created by Jieyi Hu on 9/19/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit

enum AddContactError: ErrorType {
    case numberExisted(number : String)
    case listIsFull
}

class TouchDialContacts: NSObject {

    //  singleton instance
    private static var _sharedContacts = TouchDialContacts()
    static func sharedContacts() -> TouchDialContacts {
        return _sharedContacts
    }
    //  contacts list
    private var _contacts = [Contact]()
    var contacts : [Contact] {
        get{
            return _contacts
        }
    }
    
    //  contacts file path
    private let contactsFilePath = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("contacts")
    
    //  touch dial contact limit
    private let limit = 5
    
    var count : Int {
        get{
            return _contacts.count
        }
    }
    
    override init() {
        super.init()
        load()
    }
    
    func addContact(contact : Contact) throws {
        if contacts.numberExisted(contact) {
            //  has number existed, throws
            throw AddContactError.numberExisted(number: contact.number)
        } else {
            if count == limit {
                //  list is full already, throws
                throw AddContactError.listIsFull
            } else {
                //  add contact
                _contacts.append(contact)
            }
        }
    }
    
    func removeContact(index : Int) {
        _contacts.removeAtIndex(index)
    }
    
    func swapContact(fromIndex : Int, toIndex : Int) {
        let contact = contacts[fromIndex]
        _contacts.removeAtIndex(fromIndex)
        _contacts.insert(contact, atIndex: toIndex)
    }
    
    private func load() {
        do{
            let jsonStr = try String(contentsOfFile: contactsFilePath, encoding: NSUTF8StringEncoding)
            let jsonData = jsonStr.dataUsingEncoding(NSUTF8StringEncoding)
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments) as! [[String : String]]
            _contacts = jsonObject.map({jsonRecord in Contact(jsonRecord: jsonRecord)})
        } catch let error as NSError {
            print(error)
        }
    }
    
    func store() {
        do{
            let jsonObject = _contacts.map({contact in contact.toJSONRecord()})
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions.PrettyPrinted)
            let jsonStr = NSString(data: jsonData, encoding: NSUTF8StringEncoding)
            try jsonStr?.writeToFile(contactsFilePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch let error as NSError {
            print(error)
        }
    }
    
    func reset() {
        _contacts = [Contact]()
    }
}
