//
//  NetworkUtility.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

class NetworkUtility {
    
    //TODO: Perhaps split this into smaller functions? One for getting the data and one for decoding?
    func basicPlayerTeamSearch(searchString: String, completion: @escaping (PlayerTeamRootObject) -> Void) {
                
        let session = URLSession.init(configuration: .default)
        guard let footballAPI = URL(string: "http://trials.mtcmobile.co.uk/api/football/1.0/search") else {
            print("Failure to generate URL for playerTeamSearch.")
            return
        }
        
        var request = URLRequest(url: footballAPI)
        request.httpMethod = "POST"
        let searchParameters: [String : Any] = [
            "searchString": "\(searchString)"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: searchParameters, options: [])
                
        let task = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
            
            //Check that we can parse the response from the API.
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Unable to parse API response as HTTPURLResponse")
                return
            }
            
            //Check for any http status code errors using the network response checker.
            if let responseError = self.handleNetworkResponse(response: httpResponse) {
                print("Unexpected API response: \(responseError.rawValue)")
            }

            //Check we have received valid data and unwrap it safely.
            guard let data = data else {
                print("")
                return
            }
            
            let decoder = JSONDecoder()

            //TODO: This needs refactored so badly.
            do {
                let playerTeams = try decoder.decode(PlayerTeamRootObject.self, from: data)
                completion(playerTeams)
            } catch {
                print("Unable to decode data received from API. Error: \(error)")
                }
        }
        task.resume()
    }
    
    private func handleNetworkResponse(response: HTTPURLResponse) -> DownloadError? {
        switch response.statusCode {
        case 200...299: return (nil)
        case 300...399: return (.redirectionError)
        case 400...499: return (.clientError)
        case 500...599: return (.serverError)
        case 600: return (.invalidRequest)
        default: return (.unknownError)
        }
    }
    
    
    
}
