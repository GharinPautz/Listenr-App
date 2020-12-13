//
//  SpotifyAPI.swift
//  Listenr
//
//  Created by Gharin Pautz on 12/11/20.
//

import Foundation
import SwiftyJSON

class SpotifyAPI {
    static let recommendationsBaseURL = "https://api.spotify.com/v1/recommendations"
    static let searchBaseURL = "https://api.spotify.com/v1/search"
    static let APIKey = "4454950da1fc4bcc9df0125438fecd14"
    
    static func searchURL(query: String, type: String) -> URL {
        let params = [
            "q": query,
            "type": type,
            "access_token": SpotifyAPI.APIKey
        ]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        var components = URLComponents(string: SpotifyAPI.searchBaseURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    // Here I started stubbing out how we can get the string optional artistID  using SwiftyJSON
    // It needs a completion handler that updates artist id in the PrevSongViewController class

    static func fetchArtistID(artist: String) -> String? {

        let url = searchURL(query: artist, type: "artist")
        print(url)
        
        let task = URLSession.shared.dataTask(with: url) { (dataOptional, urlResponseOptional, errorOptional) in
            if let data = dataOptional {
                do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    //let artistID = json["artists"]["items"]["id"].string
                   
                } catch {
                    
                    print("in first else, error converting data to json")
                }
            } else {
                print("in else")
            }
        }
        return ""
    }
    
    static func fetchTrackID(track: String) -> String {
        return ""
    }
 
    
}
