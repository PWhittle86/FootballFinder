//
//  NetworkUtility.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

class NetworkUtility {
    
    func basicPlayerTeamSearch(searchString: String) {
        
        let session = URLSession.init(configuration: .default)
        guard let footballAPI = URL(string: "http://trials.mtcmobile.co.uk/api/football/1.0/search") else {
            print("Unable to generate URL for playerTeamSearch.")
            return
        }
        var request = URLRequest(url: footballAPI)
        request.httpMethod = "POST"
        let searchParameters: [String : Any] = [
            "searchString": "\(searchString)"
        ]
        let jsonData = try! JSONSerialization.data(withJSONObject: searchParameters, options: [])
                
        let task = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
            
            //Check that we have received a successful response from the API.
            guard let httpResponse = response as? HTTPURLResponse,
            //TODO: Error handling if we get anything other than a 200.
                httpResponse.statusCode == 200,
                let data = data else {
                    return
            }
            
            do {
                let decoder = JSONDecoder()
                let json = try decoder.decode(PlayerTeamJson.self, from: data)
                print(json)
            } catch {
                print("Unable to decode data received from API. Error: \(error)")
            }
        }
        task.resume()
    }
    
    
    func getPlayers() {
        
    }
    
    func getTeams() {
        
    }
    
}
