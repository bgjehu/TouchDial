//
//  LocalContacts.swift
//  TouchDial
//
//  Created by Jieyi Hu on 9/19/15.
//  Copyright © 2015 fullstackpug. All rights reserved.
//

import UIKit
import Contacts

class LocalContacts: NSObject {
    static var contacts : [Contact] {
        get{
            var contacts = [Contact]()
            do{
                let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let containerId = CNContactStore().defaultContainerIdentifier()
                let predicate: NSPredicate = CNContact.predicateForContactsInContainerWithIdentifier(containerId)
                let localContacts = try CNContactStore().unifiedContactsMatchingPredicate(predicate, keysToFetch: keysToFetch)
                localContacts.map({contact in
                    contact.phoneNumbers.map({number in
                        let numberStr = (number.value as! CNPhoneNumber).stringValue
                        let numberType = (number.label).stringByReplacingOccurrencesOfString("_$!<", withString: "").stringByReplacingOccurrencesOfString(">!$_", withString: "")
                        contacts.append(Contact(firstName: contact.givenName, lastName: contact.familyName, number: numberStr, numberType: numberType))
                    })
                })
            } catch let error as NSError {print(error)}
            let sortedContacts = contacts.sort({$0.name.localizedStandardCompare($1.name) == .OrderedAscending})
            return sortedContacts
        }
    }
}
