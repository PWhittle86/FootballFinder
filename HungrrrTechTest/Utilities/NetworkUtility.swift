//
//  NetworkUtility.swift
//  HungrrrTechTest
//
//  Created by Peter Whittle on 11/09/2020.
//  Copyright © 2020 Whittle Productions. All rights reserved.
//

import Foundation

protocol FailedToCompleteNetworkRequest: class {
    func didFailToProcessNetworkRequest()
}

class NetworkUtility {

    let alertUtility = AlertUtility()
    weak var delegate: FailedToCompleteNetworkRequest?
    
    //The prime function of the class. Sends POST requests to the specified API, decodes the data and returns it to the requesting class in a completion handler.
    func executeSearch(searchString: String,
                       searchType: SearchParameter?,
                       offset: Int?,
                       completionHandler: @escaping (FootballAPIRootDataObject, String) -> Void) {

        //Generate URL Request
        let request = generatePOSTURLRequest()

        //Generate parameters based on whether this is the first search by the user, or they are searching for additional players/teams.
        let searchParameters = generateSearchParameters(searchString: searchString,
                                                  searchType: searchType,
                                                  offset: offset)

        //Attempt to serialise the parameters into JSON format.
        let jsonData: Data
        do {
            jsonData = try JSONSerialization.data(withJSONObject: searchParameters, options: [])
        } catch {
            print("Error: Unable to serialise JSON data for upload: \(error)")
            self.delegate?.didFailToProcessNetworkRequest()
            return
        }

        //Attempt Upload
        let session = URLSession.init(configuration: .default)
        let task = session.uploadTask(with: request, from: jsonData) { (data, response, error) in
            
            //Check that we can parse the response from the API.
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Error: Unable to parse API response as HTTPURLResponse")
                self.delegate?.didFailToProcessNetworkRequest()
                return
            }

            //Check for any http status code errors using the network response checker. Display alert based on response received.
            if let responseError = self.handleNetworkResponse(response: httpResponse) {
                self.alertUtility.presentOKAlert(title: "Error!", message: "Unable to connect to the data server: \(responseError.rawValue)")
                self.delegate?.didFailToProcessNetworkRequest()
                print("Unexpected HTTP response: \(responseError.rawValue)")
                return
            }

            //Check we have received valid data and unwrap it.
            guard let data = data else {
                print("Unable to safely unwrap data received from API.")
                self.delegate?.didFailToProcessNetworkRequest()
                return
            }

            //Decode the JSON object into a struct and use the completion handler to pass the data back to the tableview once complete.
            do {
                let decoder = JSONDecoder()
                let playerTeams = try decoder.decode(FootballAPIRootDataObject.self, from: data)
                completionHandler(playerTeams, searchString)
            } catch {
                print("Unable to decode data received from API. Error: \(error)")
                self.delegate?.didFailToProcessNetworkRequest()
                }
        }
        task.resume()
    }
    
    //Generate a POST URLRequest
    private func generatePOSTURLRequest() -> URLRequest {
        guard let footballAPI = URL(string: NetworkUtilityConstant.apiString) else {
            print("Failure to generate URL for playerTeamSearch.")
            self.delegate?.didFailToProcessNetworkRequest()
            return URLRequest(url: URL(string: "")!)
        }
        var request = URLRequest(url: footballAPI)
        request.httpMethod = "POST"
        return request
    }
    
    //Generates search parameters based on whether user is searching for the first time, or asking for more players/teams.
    private func generateSearchParameters(searchString: String, searchType: SearchParameter?, offset: Int?) -> [String : Any] {
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
    
    //Convenience function to return specific error codes for http codes that don't represent success.
    private func handleNetworkResponse(response: HTTPURLResponse) -> DownloadError? {
        switch response.statusCode {
        case 200...299: return (.none)
        case 300...399: return (.redirectionError)
        case 400...499: return (.clientError)
        case 500...599: return (.serverError)
        case 600: return (.invalidRequest)
        default: return (.unknownError)
        }
    }
    
}
