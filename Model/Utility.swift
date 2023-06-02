//
//  Utility.swift
//  WeatherAppAPI
//
//  Created by Tripathy, Samiksha (Contractor) on 31/05/23.
//

import Foundation

struct mainWeatherInfo: Codable{
    var temp:Double
    var feels_like:Double
    var temp_min: Double
    var temp_max: Double
    var pressure:Int
    var humidity: Int
}

struct windDetails: Codable{
    var speed: Double
    var deg: Int
}

struct weatherList: Codable{
    var weather: [weatherS]
    var main: mainWeatherInfo
    var visibility: Int
    var wind:windDetails
    var name: String
    var sys : weatherSys
}
    
struct weatherS: Codable{
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct weatherSys: Codable{
    var country: String
}


struct Utility{
    
    //Write a sinle instance
    static let shared = Utility()
    
    //write a private initializer so that no other instance created
    private init(){
        
    }
    
    //higher order function
    func getWeather(lat: Double, long: Double,nameTextField: String, handler: @escaping ([weatherList]) -> Void){
        
        //do http communication
        let weatherDataURL = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&appid=a0aa58cd119946323df6ec2a0793d19b&units=metric"
        print("DataURL is \(weatherDataURL)")
        
        //1.get reference of URL session
        let session = URLSession.shared
        
        //2. create request
        if let url = URL(string: weatherDataURL){
            
            //3.create task
            let task = session.dataTask(with: url){respData, httpResp, err in
                
                if err == nil{
                    print("Request success:\(weatherDataURL)")
                    
                    let statusCode = (httpResp as! HTTPURLResponse).statusCode
                    switch statusCode{
                    case 20...299:
                        print("Success")
                        let wthrList = parseWeatherData(jsonResponse: respData)
                        print("wtheList count \(wthrList.count)")
                        print("Latitude: \(lat), Longitude: \(long)")
                        //calling handler with wthrList
                        handler(wthrList)
                    case 300...399:
                        print("Redirection")
                    case 400...499:
                        print("Client error")
                    case 500...599:
                        print("Server error")
                    default:
                        print("Unknown error")
                        
                    }
                                      
                }
                else {
                    print("Request could not be completed")
                }
            }
            
            //start task, request fired on bg thread asynchronously
            task.resume()
            
        }
        else{
            print("Invalid URL")
        }
    }
    func parseWeatherData(jsonResponse: Data?) -> [weatherList]{
        //parsing data
        guard let jResponse = jsonResponse else
        {
            return []
        }
        do{
            let wthrList = try JSONDecoder().decode(weatherList.self, from: jResponse)
            print("Decoding done")
            return [wthrList]
        }
        catch{
            print("Parsing failed \(error.localizedDescription)")
        }
        return []
    }
    
    func imageDownload(iconName: String, callback: @escaping (URL)-> Void){
        let imageURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imgPath = docURL.appendingPathComponent(iconName)
        if FileManager.default.fileExists(atPath: imgPath.relativePath){
            callback(imgPath)
            return
        }
        
        let session = URLSession.shared
        if let imageURL = URL(string: imageURL){
            let task = session.downloadTask(with: imageURL){tempURL, resp, error in
                if error == nil{
                    let status = (resp as! HTTPURLResponse).statusCode
                    
                    if status == 200{
                        try! FileManager.default.moveItem(at: tempURL!, to: imgPath)
                        callback(imgPath)
                    }
                    else{
                        print("Something went wrong: \(status) ")
                    }
                }
                else{
                    print("network issue")
                }
            }
            task.resume()
        }
        else{
            print("invalid url")
        }
    }
}
