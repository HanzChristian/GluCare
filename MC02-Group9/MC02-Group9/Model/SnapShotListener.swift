//
//  ViewModel.swift
//  MC02-Group9
//
//  Created by Hanz Christian on 16/01/23.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct snapShotListener{
    var listenerBG:ListenerRegistration?
    var listenerMed:ListenerRegistration?
    var listenerLog:ListenerRegistration?
    
}

var snapShotListenerList = snapShotListener()

