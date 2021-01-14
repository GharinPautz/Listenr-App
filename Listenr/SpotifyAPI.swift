//
//  SpotifyAPI.swift
//  Listenr
//  This is Ghar Pautz and Kellie Colson's final proejct for iOS App Development Fall, 2020. This program calls Spotify's Authentication, Search, and Recommendations APIs to produce songs for users based on their favorite tracks, artists, and genres of music. Additionally, the music data generated is stored using Firebase Firestore in the current user's account so they are able to access it again when they reopen the app after logging out.
//  CPSC 315-02, Fall 2020
//  Final Project
//
//  Created by Gharin Pautz on 12/11/20.
//

import Foundation
import SwiftyJSON

class SpotifyAPI {
    static let recommendationsBaseURL = "https://api.spotify.com/v1/recommendations?"
    static let searchBaseURL = "https://api.spotify.com/v1/search?"
    static let APIKey = "" // No key provided for security purposes
    static let authKeyStr = "" // No key provided for security purposes
    static let authKey = "Basic " + authKeyStr.data(using: .utf8)!.base64EncodedString()
    static var accessToken = ""

    /*
      Calls Spotify Authentication API to get access token needed for calls to Spotify's other APIs

      Parameter completion: closure executed when the Spotify access token has been received
    */
    static func getSpotifyToken(completion: @escaping (String?, Error?) -> Void) {
        // assmble url/ request to call the Spotify Authentication API
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let bodyParams = "grant_type=client_credentials"
        request.httpBody = bodyParams.data(using: String.Encoding.ascii, allowLossyConversion: true)
        request.addValue(authKey, forHTTPHeaderField: "Authorization")

        // make call to Spotify Authentication API
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            print("printing from getSpotifyToken")
            print(String(data: data, encoding: String.Encoding.utf8)!)
            do {
                // parse JSON response from Spotify Authentication API for the access token
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


    /*
      Get the Spotify artist ID for a given artist by calling the Spotify Search APIs

      -Parameter artist: the user's favorite artist to be used for the Spotify search APIs
      -Parameter completion: closure executed when the Spotify artist ID has been fetched and parsed
    */
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

    /*
      Parses JSON data returned from Spotify Search API for artist ID

      -Parameter data: data object returned by Spotify API
    */
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

    /*
      Get the Spotify track ID for a given track by calling the Spotify Search APIs

      -Parameter tracl: the user's favorite tracl to be used for the Spotify search APIs
      -Parameter completion: closure executed when the Spotify track ID has been fetched and parsed
    */
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

    /*
      Parses JSON data returned from Spotify Search API for track ID

      -Parameter data: data object returned by Spotify API
    */
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

    /*
      Calls Spotify's Recommendations API to get a reccommended song for the users

      -Parameter artistID: Spotify ID for the user's favorite artist
      -Parameter trackID: Spotify ID for the user's favorite song
      -Parameter genres: array of user's favorite genres
      -Parameter completion: closure that executes when recommended song from API is available
    */
    static func getSongRecommendation(artistID: String, trackID: String, genres: [String], completion: @escaping (Track?) -> Void) {
        // convert array of genres to comma separated list
        var genresStr = ""
        for genre in genres {
            genresStr.append(genre)
            if genre != genres[genres.count - 1] {
                genresStr.append("%2C")
            }
        }

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

                // set parameters of request
                var queryItems = [URLQueryItem]()
                for (key, value) in params {
                    queryItems.append(URLQueryItem(name: key, value: value))
                }


                var components = URLComponents(string: SpotifyAPI.recommendationsBaseURL)!
                components.queryItems = queryItems
                let url = components.url!

                var request = URLRequest(url: url)
                request.httpMethod = "GET"

                // set header of request
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

    /*
      Parses JSON results from call to Spotify Recommendations API

      -Parameter data: data object returned by Spotify API
      -Returns: Track optional object representing the parsed recommended track
    */
    static func parseRecommendations(fromData data: Data) -> Track? {
        do {
          // convert data to JSON
        let json = try JSONSerialization.jsonObject(with: data, options: [])
            guard let jsonDictionary = json as? [String: Any], let tracks = jsonDictionary["tracks"] as? [[String: Any]], let trackInfo = tracks[0] as? [String: Any], let artistArray = trackInfo["artists"] as? [[String: Any]], let artistName = artistArray[0]["name"] as? String, let trackName = trackInfo["name"] as? String else {
                print("did not properly parse json from recommendations api")
                return nil
            }
            // song link is not always available in the returned Spotify API data, check song link is available
            if let songLink = trackInfo["preview_url"] as? String {
                // song link available in JSON
                print("link: \(songLink)")
                return Track(title: trackName, artist: artistName, songLink: songLink)
            }

            print("track name: \(trackName)")
            print("artist name: \(artistName)")

            // song link is not available in JSON, set songLink to nil
            return Track(title: trackName, artist: artistName, songLink: nil)

        } catch {
            print("error converting data to json")
        }
        return nil
    }


}
