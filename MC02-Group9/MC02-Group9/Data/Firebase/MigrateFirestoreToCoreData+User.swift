//
//  MigrateFirestoreToCoreData+User.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 09/12/22.
//

import Foundation
import UIKit
import CoreData
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

extension MigrateFirestoreToCoreData {
    
    func removeConnection() {
        if let user = Auth.auth().currentUser?.email {
            db.collection("link").whereField("caregiver", isEqualTo: user)
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                            CoreDataManager.coreDataManager.resetAllCoreData()
                        }
                    }
                }
            
            db.collection("link").whereField("patient", isEqualTo: user)
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                    }
                }
            
            db.collection("link").whereField("owner", isEqualTo: user)
                .getDocuments { [weak self] (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            document.reference.delete()
                        }
                    }
                }
        }
    }
    
}

