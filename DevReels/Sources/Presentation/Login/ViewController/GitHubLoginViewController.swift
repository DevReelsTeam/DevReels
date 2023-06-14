////
////  GitHubLoginViewController.swift
////  DevReels
////
////  Created by 강현준 on 2023/05/18.
////  Copyright © 2023 DevReels. All rights reserved.
////
//
//import UIKit
//import SafariServices
//
//final class GitHubLoginViewController: UIViewController, SFSafariViewControllerDelegate{
//    
//    // GitHub 로그인 관련 상수
//        let clientID = "YOUR_GITHUB_CLIENT_ID"
//        let redirectURI = "YOUR_REDIRECT_URI"
//        let scope = "user:email" // 요청할 권한 범위
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            
//            // GitHub 로그인 버튼을 생성하고 클릭 시 로그인 창을 열도록 설정
//            let loginButton = UIButton(type: .system)
//            loginButton.setTitle("GitHub 로그인", for: .normal)
//            loginButton.addTarget(self, action: #selector(openGitHubLogin), for: .touchUpInside)
//            // 로그인 버튼을 적절한 위치에 추가하거나 레이아웃 설정
//            
//            view.addSubview(loginButton)
//        }
//        
//        @objc func openGitHubLogin() {
//            // GitHub 로그인 창을 열기 위해 인증 URL 생성
//            let authURLString = "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)&scope=\(scope)"
//            guard let authURL = URL(string: authURLString) else {
//                print("Invalid auth URL")
//                return
//            }
//            
//            // SFSafariViewController를 사용하여 로그인 창을 열기
//            let safariVC = SFSafariViewController(url: authURL)
//            safariVC.delegate = self
//            present(safariVC, animated: true, completion: nil)
//        }
//        
//        // 콜백 URL 처리를 위한 delegate 메서드
//        func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
//            // 로그인 창이 열릴 때 호출됨
//            // 로그인이 성공하거나 실패한 경우 콜백 URL을 확인하여 처리
//            if let url = controller.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: true) {
//                if let code = components.queryItems?.first(where: { $0.name == "code" })?.value {
//                    // GitHub에서 반환한 인증 코드(code)를 사용하여 액세스 토큰을 요청하고 처리
//                    
//                    // 액세스 토큰을 받아서 Firebase 인증 등에 활용할 수 있음
//                    
//                    // 로그인 성공 후 필요한 작업 수행
//                } else if let error = components.queryItems?.first(where: { $0.name == "error" })?.value {
//                    // 로그인 실패 처리
//                    print("GitHub 로그인 실패: \(error)")
//                }
//            }
//            
//            // 로그인 창 닫기
//            controller.dismiss(animated: true, completion: nil)
//        }
//}
