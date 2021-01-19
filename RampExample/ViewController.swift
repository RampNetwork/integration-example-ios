//
//  ViewController.swift
//  RampExample
//
//  Created by Mateusz Jabłoński on 17/01/2021.
//

import UIKit
import SafariServices

class ViewController: UIViewController {
    
    @IBOutlet weak var purchaseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotificationObserving()
    }
    
    func setupNotificationObserving() {
        NotificationCenter.default.addObserver(
            forName: Ramp.notification, object: nil, queue: .main) { [weak self] (notification) in
            self?.dismiss(animated: true) {
                self?.showAlert()
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        purchaseButton.layer.cornerRadius = purchaseButton.bounds.height / 4
    }
    
    @IBAction func showRamp(_ sender: UIButton) {
        
        var configuration = Ramp.Configuration(url: "https://ri-widget-dev.firebaseapp.com/")
        configuration.fiatCurrency = "EUR"
        configuration.fiatValue = "2"
        configuration.swapAsset = "BTC"
        configuration.finalUrl = "rampexample://ramp.purchase.complete"
        let rampWidgetUrl = configuration.composeUrl()
        
        let rampVC = SFSafariViewController(url: rampWidgetUrl)
        rampVC.modalPresentationStyle = .overFullScreen
        present(rampVC, animated: true)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Ramp purchase finished", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
