////
////  GitHubLoginViewController.swift
////  DevReels
////
////  Created by 강현준 on 2023/05/18.
////  Copyright © 2023 DevReels. All rights reserved.
////
//
import UIKit
import WebKit

final class GitHubLoginViewController: UIViewController {
    
    // GitHub 로그인 관련 상수
        let clientID = "088431dfc535a571f124"
        let redirectURI = "https://devreels.firebaseapp.com/__/auth/handler"
        let scope = "user:email" // 요청할 권한 범위
    
    let webView = WKWebView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            view = webView
            startOAuth()
        }
        
        func startOAuth() {
            // GitHub 로그인 창을 열기 위해 인증 URL 생성
            let authURLString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&scope=\(scope)"
            guard let authURL = URL(string: authURLString)else {
                print("Invalid auth URL")
                return
            }
            let reqeuest = URLRequest(url: authURL)
            
            webView.load(reqeuest)
        }
}

extension GitHubLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let queryItems = components.queryItems
            print(queryItems)
        }
    }
}
