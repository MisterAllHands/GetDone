//
//  AppDelegate.swift
//  Somethingnew
//
//  Created by TTGMOTSF on 04/11/2022.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do{
            let realm = try Realm()
        }catch{
            print("Couldn't cast realm \(error)")
        }
        return true
    }
}

