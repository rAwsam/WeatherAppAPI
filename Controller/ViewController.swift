//
//  ViewController.swift
//  WeatherAppAPI
//
//  Created by Tripathy, Samiksha (Contractor) on 31/05/23.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locations: [weatherList] = []

    @IBOutlet weak var nameTxtFld: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view.
//        let gradientLayer = CAGradientLayer()
//        
//        gradientLayer.colors = [UIColor.systemBlue.cgColor,UIColor.white.cgColor]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradientLayer.frame = view.bounds
//        view.layer.addSublayer(gradientLayer)
    }

    @IBAction func searchAction(_ sender: UIButton) {
        let geoCoder = CLGeocoder()
        let location = nameTxtFld.text ?? ""
        print(location)
        
        geoCoder.geocodeAddressString(location) { locData, _ in
            let lat: Double
            let long: Double
            lat = locData?[0].location?.coordinate.latitude ?? 0
            long = locData?[0].location?.coordinate.longitude ?? 0
            Utility.shared.getWeather(lat: lat, long: long, nameTextField: location) { weatherArray in
                print("............")
                print(weatherArray)
                print("............")
                
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "weatherDetail") as! weatherDetailsVC
                    vc.acquiredData = weatherArray
                    self.present(vc, animated: true)
                    
                }
            }
        }
            
        }
        
    }
    


