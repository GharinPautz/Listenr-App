//
//  SpotifyAPI.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/11/20.
//

import Foundation
import SwiftyJSON

class SpotifyAPI {
    static let recommendationsBaseURL = "https://api.spotify.com/v1/recommendations?"
    static let searchBaseURL = "https://api.spotify.com/v1/search?"
    static let APIKey = "4454950da1fc4bcc9df0125438fecd14"
    static let authKeyStr = "9ecbb13db1e7401f84131d3ca1276c5a:4454950da1fc4bcc9df0125438fecd14"
    static let authKey = "Basic " + authKeyStr.data(using: .utf8)!.base64EncodedString()
    static var accessToken = ""
    
    
    static func getSpotifyToken(completion: @escaping (String?, Error?) -> Void) {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyParams = "grant_type=client_credentials"
        request.httpBody = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        request.addValue(authKey, forHTTPHeaderField: "Authorization")
      
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            print("printing from getSpotifyToken")
            print(String(data: data, encoding: String.Encoding.utf8)!)
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDictionary = jsonObject as? [String: Any] {
                    let accessToken = jsonDictionary["access_token"] as! String
                    print("have reference to accessToken")
                    self.accessToken = accessToken
                    
                    
                    DispatchQueue.main.async {
                        completion(accessToken, nil)
                    }
                }
            } catch {
                print("error getting json from data")
            }
        }
        task.resume()
    }



    static func fetchArtistID(artist: String, completion: @escaping (String?) -> Void) {
        // get access token
        getSpotifyToken{ (tokenOptional, errorOptional) in
            if let accessToken = tokenOptional {
                // create url with access token
                let params = [
                    "q": artist,
                    "type": "artist",
                    "access_token": accessToken
                ]
                
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
                
                var components = URLComponents(string: SpotifyAPI.searchBaseURL)!
                components.queryItems = queryItems
                let url = components.url!
                
                // get artistID from search api
                let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
                    if let data = dataOptional {
                        if let artistID = self.parseArtistID(fromData: data){
                            print(artistID)
                            DispatchQueue.main.async {
                                completion(artistID)
                            }
                        }
                    }
                    if let error = errorOptional {
                        print("error running task: \(error)")
                    }
                }
                task.resume()
            }
        }
    }
    
    static func parseArtistID(fromData data: Data) -> String? {
        do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            guard let jsonDictionary = json as? [String: Any], let artistsArray = jsonDictionary["artists"] as? [String: Any], let itemsArray = artistsArray["items"] as? [[String: Any]], let artistID = itemsArray[0]["id"] as? String else {
                print("did not properly parse json")
                return nil
            }
            print("ArtistID: \(artistID)")
            return artistID
           
        } catch {
            print("error converting data to json")
        }
        return nil
    }
        
    static func fetchTrackID(track: String, completion: @escaping (String?) -> Void) {
        // get access token
        getSpotifyToken{ (tokenOptional, errorOptional) in
            if let accessToken = tokenOptional {
                // create url with access token
                let params = [
                    "q": track,
                    "type": "track",
                    "access_token": accessToken
                ]
                
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
                
                var components = URLComponents(string: SpotifyAPI.searchBaseURL)!
                components.queryItems = queryItems
                let url = components.url!
                
                // get trackID from search api
                let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
                    if let data = dataOptional {
                        if let trackID = self.parseTrackID(fromData: data){
                            print(trackID)
                            DispatchQueue.main.async {
                                completion(trackID)
                            }
                        }
                    }
                    if let error = errorOptional {
                        print("error running task: \(error)")
                    }
                }
                task.resume()
            }
        }
    }
    
    static func parseTrackID(fromData data: Data) -> String? {
        do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
            //print(json)
            guard let jsonDictionary = json as? [String: Any], let tracks = jsonDictionary["tracks"] as? [String: Any], let itemsArray = tracks["items"] as? [[String: Any]], let trackID = itemsArray[0]["id"] as? String else {
                print("did not properly parse json for track id")
                return nil
            }
            print("TrackID: \(trackID)")
            return trackID
           
        } catch {
            print("error converting data to json")
        }
        return nil
    }
    
    static func getSongRecommendation(artistID: String, trackID: String, genres: [String], completion: @escaping (Track?) -> Void) {
        // convert array of genres to comma separated list
        var genresStr = ""
        for genre in genres {
            genresStr.append(genre)
            if genre != genres[genres.count - 1] {
                genresStr.append("%2C")
            }
        }
        
        
        /*
         let url = URL(string: "https://accounts.spotify.com/api/token")!
         var request = URLRequest(url: url)
         request.httpMethod = "POST"
         let bodyParams = "grant_type=client_credentials"
         request.httpBody = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
         request.addValue(authKey, forHTTPHeaderField: "Authorization")
         */
        
        
        
        // get access token
        getSpotifyToken{ (tokenOptional, errorOptional) in
            if let accessToken = tokenOptional {
                
                // create url
                let params = [
                    "seed_artists": artistID,
                    "seed_tracks": trackID
                    //"seed_genres": genresStr,
                ]
                
                let headers = [
                    "Authorization": "Bearer \(accessToken)"
                ]
                
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }
                
                
                var components = URLComponents(string: SpotifyAPI.recommendationsBaseURL)!
                components.queryItems = queryItems
                let url = components.url!
                
                //let url = URL(string: SpotifyAPI.recommendationsBaseURL)!
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                
                for (key, value) in headers {
                    request.setValue(value, forHTTPHeaderField: key)
                }
                
                print(request)
                
                // call spotify recommendations api
                let task = URLSession.shared.dataTask(with: request) { (dataOptional, urlResponseOptional, errorOptional) in
                    if let data = dataOptional {
                        // call to parse results
                        if let recommendation = self.parseRecommendations(fromData: data){
                            print(recommendation)
                            DispatchQueue.main.async {
                                completion(recommendation)
                            }
                        }
                    }
                    if let error = errorOptional {
                        print("error running task: \(error)")
                    }
                }
                task.resume()
            }
        }
            
    }
    
    static func parseRecommendations(fromData data: Data) -> Track? {
        do {
        let json = try JSONSerialization.jsonObject(with: data, options: [])
            print(json)
            guard let jsonDictionary = json as? [String: Any], let tracks = jsonDictionary["tracks"] as? [[String: Any]], let trackInfo = tracks[0] as? [String: Any], let artistArray = trackInfo["artists"] as? [[String: Any]], let artistName = artistArray[0]["name"] as? String, let trackName = trackInfo["name"] as? String else {
                print("did not properly parse json from recommendations api")
                return nil
            }
            print("track name: \(trackName)")
            print("artist name: \(artistName)")
            return Track(title: trackName, artist: artistName)
           
        } catch {
            print("error converting data to json")
        }
        return nil
    }
 
    
}
