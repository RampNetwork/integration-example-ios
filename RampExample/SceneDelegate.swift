//
//  SceneDelegate.swift
//  RampExample
//
//  Created by Mateusz Jabłoński on 15/01/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let urlContext = URLContexts.first {
            Ramp.sendNotificationIfUrlValid(urlContext.url)
        }
    }

}
