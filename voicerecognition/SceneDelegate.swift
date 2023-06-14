//
//  SceneDelegate.swift
//  voicerecognition
//
//  Created by 坂本　龍征 on 2023/06/14.
//
import SwiftUI

func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    guard let url = URLContexts.first?.url else {
        return
    }
    print("Launch app from \(url.host ?? "unknown")")
}

func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    if let url = connectionOptions.urlContexts.first?.url{
        print("Launch app from \(url.host ?? "unknown")")
    }
}
