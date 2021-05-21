//
//  ViewController.swift
//  BitcoinProject
//
//  Created by user193356 on 5/18/21.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // MARK: - Outlets:
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    
    @IBOutlet weak var bitcoinPicker: UIPickerView!
    
    // MARK: - Variables and Constants
    
    let apiKey = "ZDE1NDUxMmVhNjg3NGMxZGI4ODZkZjdhZWY5N2I3ZjE"
    
    let currencies = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    let baseUrl = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData(url: baseUrl)
        
        bitcoinPicker.delegate = self
        bitcoinPicker.dataSource = self
        
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var url = "\(baseUrl)\(currencies[row])"
        
        fetchData(url: url)

            }
    
        
    func fetchData(url:String) {
        let url = URL(string: url)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-ba-key")
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                self.parseJson(json: data)
            } else {
                print("Error")
            }
        }
        task.resume()
    }
    
    func parseJson(json: Data) {
        do {
            if let json = try JSONSerialization.jsonObject(with: json, options: .mutableContainers) as? [String: Any] {
                print(json)
                if let askValue = json["ask"] as? NSNumber {
                    print(askValue)
                    
                    let formatter = NumberFormatter()
                    
                    formatter.numberStyle = .currency
                    
                    formatter.locale = Locale(identifier: "pt_BR")

                    let askvalueString = formatter.string(from: askValue)

                    //let askvalueString = "\(askValue)"
                    DispatchQueue.main.async {
                        
                        self.bitcoinLabel.text = askvalueString
                    }
                    print("success")
                } else {
                    print("error")
                }
            }
        } catch {
            
            print("error parsing json: \(error)")
        }
    }

}

