//
//  ViewController.swift
//  TestForWebView
//
//  Created by 윤여환 on 2020/01/01.
//  Copyright © 2020 윤여환. All rights reserved.
//

import UIKit
import WebKit
import CoreLocation

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var webView: WKWebView!
    private let locationManager = CLLocationManager()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://mobile.aboutcafe.co.kr/#/auth/login")
        let request = URLRequest(url: url!)
        webView.load(request)
        
        locationCheck()
    }
    
    override func loadView() {
        super.loadView()
        
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    @available(iOS 8.0, *)
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        
        alert.addAction(otherAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: {(action) in completionHandler(false)})
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {(action) in completionHandler(true)})
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.frame = CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100)
        activityIndicator.color = UIColor.red
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        //activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    @objc func locationCheck(){
        let status = CLLocationManager.authorizationStatus()
        
        if status == CLAuthorizationStatus.denied || status == CLAuthorizationStatus.restricted || status == CLAuthorizationStatus.notDetermined {
            let alter = UIAlertController(title: "위치권한 설정이 '안함'으로 되어있습니다.", message: "앱 설정 화면으로 가시겠습니까? \n '아니오'를 선택하시면 앱이 종료됩니다.", preferredStyle: UIAlertController.Style.alert)
            
            let logOkAction = UIAlertAction(title: "네", style: UIAlertAction.Style.default){
                (action: UIAlertAction) in
                self.locationManager.requestWhenInUseAuthorization()
            }
            let logNoAction = UIAlertAction(title: "아니오", style: UIAlertAction.Style.destructive){
                (action: UIAlertAction) in
                exit(0)
            }
            alter.addAction(logNoAction)
            alter.addAction(logOkAction)
            
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.present(alter, animated: true, completion: nil)
                }
            }
        }
    }
}

