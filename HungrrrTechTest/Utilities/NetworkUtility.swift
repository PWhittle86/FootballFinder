//
//  NetworkUtility.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

public enum searchParameter : String {
    case players
    case teams
}

class NetworkUtility {

    //Move this to a constant?
    let apiString = "http://trials.mtcmobile.co.uk/api/football/1.0/search"

    func executeSearch(searchString: String,
                       isFirstSearch: Bool,
                       searchType: searchParameter?,
                       offset: Int?,
                       completionHandler: @escaping (PlayerTeamRootObject) -> Void) {

        //Generate URL Request
        let request = generateURLRequest()

        //Generate parameters based on whether this is the first search by the user, or they are searching for additional players/teams.
        //See the generateSearchParameters function for additional info.
        let searchParameters = generateSearchParameters(searchString: searchString,
                                                  searchType: searchType,
                                                  offset: offset)

        //Attempt to serialise the parameters into JSON format.
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: searchParameters, options: [])
        } catch {
            print("Error: Unable to serialise JSON data for upload: \(error)")
            return
        }

        //Attempt Upload
        let session = URLSession.init(configuration: .default)
        let task = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
            
            //Check that we can parse the response from the API.
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Unable to parse API response as HTTPURLResponse")
                return
            }

            //Check for any http status code errors using the network response checker.
            if let responseError = self.handleNetworkResponse(response: httpResponse) {
                print("Unexpected API HTTP response: \(responseError.rawValue)")
                return
            }

            //Check we have received valid data and unwrap it.
            guard let data = data else {
                print("Unable to safely unwrap data received from API.")
                return
            }

            //Decode the JSON object into a struct and use the completion handler to pass the data back to the tableview once complete.
            do {
                let decoder = JSONDecoder()
                let playerTeams = try decoder.decode(PlayerTeamRootObject.self, from: data)
                completionHandler(playerTeams)
            } catch {
                print("Unable to decode data received from API. Error: \(error)")
                }
        }
        task.resume()
    }
    
    func generateURLRequest() -> URLRequest {
        guard let footballAPI = URL(string: apiString) else { print("Failure to generate URL for playerTeamSearch.")
            //TODO: Force unwrap here, fix it.
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: footballAPI)
        request.httpMethod = "POST"
        return request
    }
    
    func generateSearchParameters(searchString: String, searchType: searchParameter?, offset: Int?) -> [String : Any] {
        //Always add the searchString parameter to the request.
        var searchParameters: [String : Any] = ["searchString": "\(searchString)"]
        
        //If searchType and offset have also been requested, add the parameters to the dictionary.
        if let type = searchType,
            let searchOffset = offset {
            searchParameters["offset"] = searchOffset
            switch type {
            case .players:
                searchParameters["searchType"] = "players"
            case .teams:
                searchParameters["searchType"] = "teams"
            }
        }
        return searchParameters
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
