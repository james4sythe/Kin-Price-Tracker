//
//  ViewController.swift
//  Kin Price Tracker
//
//  Created by James Forsythe on 8/14/18.
//  Copyright © 2018 James Forsythe. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import WebKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    let baseURL = "https://min-api.cryptocompare.com/data/price?fsym=KIN&tsyms="
    let currencyArray = ["","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    let currencySymbolArray = ["","$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "R"]
    var finalURL = ""
    var selectedCurrency = ""
    var symbolForCurrency = ""
    
    @IBOutlet weak var kinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var webView: WKWebView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = currencyArray[row]
        symbolForCurrency = currencySymbolArray[row]
        finalURL = baseURL + currencyArray[row]
        getKINData(url: finalURL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateWebChart()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }
    
    //TODO: Place your 3 UIPickerView delegate methods here
    
    
    //MARK: - Networking
    /***************************************************************/
    
    func getKINData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {
                    
                    print("Success! Got the KIN data")
                    let kinJSON : JSON = JSON(response.result.value!)
                    self.updateKINData(json: kinJSON)
                    
                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.kinPriceLabel.text = "Connection Issues"
                }
        }
        
    }
    
    func updateWebChart() {
        
        let htmlCode = Bundle.main.path(forResource: "HtmlCode", ofType: "html")
        let url = URL(fileURLWithPath: htmlCode!)
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    @IBAction func refreshButtonPressed(_ sender: Any) {

        updateWebChart()
        
    }
    //MARK: - JSON Parsing
    /***************************************************************/

    func updateKINData(json : JSON) {
//        let numberFormatter = NumberFormatter()
//        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let kinResult = json["\(selectedCurrency)"].float {
            print(kinResult)
//            let finalNumber = numberFormatter.number(from: "\(kinResult)")
            kinPriceLabel.text = ("\(symbolForCurrency)\(kinResult)")
            
        } else {
            kinPriceLabel.text = "Price Unavailable"
        }
    }

    
}

