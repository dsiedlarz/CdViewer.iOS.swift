//
//  ViewController.swift
//  CdViewer
//
//  Created by Użytkownik Gość on 12.10.2017.
//  Copyright © 2017 Użytkownik Gość. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var cdCollection: [CD] = []
    var currentCdIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getJsonFromUrl2()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var ArtistName: UITextField!
    
    func getJsonFromUrl2(){
        let cdUrl = "https://isebi.net/albums.php";

    var request = URLRequest(url: URL(string: cdUrl)!)
    
    
    request.httpMethod = "GET"
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {                                                 // check for fundamental networking error
            print("error=\(String(describing: error))")
            return
        }
        
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
            print("statusCode should be 200, but is \(httpStatus.statusCode)")
            print("response = \(String(describing: response))")
        }
        
        let responseString = String(data: data, encoding: .utf8)
        print("responseString = \(String(describing: responseString!))")
    }
    task.resume()
    }
    
    func getJsonFromUrl3(){
        let cdUrl = "https://isebi.net/albums.php";
        
        guard let url = URL(string: cdUrl) else {
            print("Error: cannot create URL")
            let error = BackendError.urlError(reason: "Could not construct URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // Make request
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: {
            (data, response, error) in
            // handle response to request
            // check for error
            guard error == nil else {
                print("Error: did not receive data")
                return
            }
            // make sure we got data in the response
            guard let responseData = data else {
                print("Error: did not receive data")
    
                return
            }
            
            // parse the result as JSON
            // then create a Todo from the JSON
            do {
                if let todoJSON = try JSONSerialization.jsonObject(with: responseData, options: []) as [String: Any] {
                    var todo = CD(json: todoJSON)
                    // created a TODO object
                //https://grokswift.com/json-swift-4/
                    print("success")
                
            } catch {
                // error trying to convert the data to JSON using JSONSerialization.jsonObject
                return
            }
        })
        task.resume()
    }
    
}

