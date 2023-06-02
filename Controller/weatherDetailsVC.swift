//
//  weatherDetailsVC.swift
//  WeatherAppAPI
//
//  Created by Tripathy, Samiksha (Contractor) on 01/06/23.
//

import UIKit

class weatherDetailsVC: UIViewController {
    
    var acquiredData : [weatherList]? = nil

    @IBOutlet weak var dateTimeL: UILabel!
    @IBOutlet weak var placeCountryL: UILabel!
    @IBOutlet weak var countryL: UILabel!
    @IBOutlet weak var currentTempL: UILabel!
    
    @IBOutlet weak var imageUI: UIImageView!
    
    @IBOutlet weak var feelsLikeMainL: UILabel!
    @IBOutlet weak var speedL: UILabel!
    @IBOutlet weak var pressureL: UILabel!
    @IBOutlet weak var humidityL: UILabel!
    @IBOutlet weak var visibilityL: UILabel!
    @IBOutlet weak var minTempL: UILabel!
    @IBOutlet weak var maxTempL: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let date = Date().formatted(date: .long, time: .omitted)
        let time = Date().formatted(date: .omitted, time: .shortened)
        print("Today \(date), \(time)")
        dateTimeL.text = "\(date), \(time)"
        
        
        if let placeCountryText = acquiredData?[0].name{
            
            placeCountryL.text = placeCountryText
        }
       // placeCountryL.text = acquiredData?[0].name
//
        if let countryText = acquiredData?[0].sys.country {
            //let country = String(countryText)
            countryL.text = (",\(countryText)")
            print(countryText)
        }
        
        if let currentTempText = acquiredData?[0].main.temp{
            currentTempL.text = ("\(currentTempText)°C")
            print(currentTempText)
        }
        
        if let feelsLike = acquiredData?[0].main.feels_like{
            feelsLikeMainL.text = "Feels like \(feelsLike)°C. "
            print(feelsLike)
        }
        
        if let speedText = acquiredData?[0].wind.speed{
            speedL.text = String(speedText)
            print(speedText)
        }
        
        if let pressureText = acquiredData?[0].main.pressure{
            pressureL.text = ("\(pressureText)hPa")
            print(pressureText)
        }
        
        if let humidityText = acquiredData?[0].main.humidity{
            humidityL.text = String(humidityText)
            print(humidityText)
        }
        
        if let visibilityText = acquiredData?[0].visibility{
            visibilityL.text = ("\(visibilityText)Km")
            print(visibilityText)
        }
        
        if let minText = acquiredData?[0].main.temp_min{
            minTempL.text = ("\(minText)°C")
            print(minText)
        }
        
        if let maxText = acquiredData?[0].main.temp_max{
            maxTempL.text = ("\(maxText)°C")
            print(maxText)
        }
        
        if let iconImage = acquiredData?[0].weather[0].icon{
            print("iconImage\(iconImage)")
            
            Utility.shared.imageDownload(iconName: iconImage) { url in
                let iconData = try! Data(contentsOf: url)
                print("jjjjjjj\(url)")
                DispatchQueue.main.async {
                    self.imageUI.image = UIImage(data: iconData)
                    print("-------")
                    print(iconData)
                }
            }
        }

    }

}
