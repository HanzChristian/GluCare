//
//  NetworkManager.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 13/07/22.
//

import Foundation

enum NetworkerError: Error {
  case badResponse
  case badStatusCode(Int)
  case badData
}

class NetworkManager {
  
  static let shared = NetworkManager()
  
  private let session: URLSession
  
  init() {
    let config = URLSessionConfiguration.default
    session = URLSession(configuration: config)
  }
  
  func getMedicationListName(completion: @escaping ([MedicineApi]?, Error?) -> (Void)) {
    let url = URL(string: "https://62c5339c134fa108c24abf12.mockapi.io/glucare/Medicine")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
      
      if let error = error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
        return
      }
      
      guard let httpResponse = response as? HTTPURLResponse else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badResponse)
        }
        return
      }
      
      guard (200...299).contains(httpResponse.statusCode) else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badStatusCode(httpResponse.statusCode))
        }
        return
      }
      
      guard let data = data else {
        DispatchQueue.main.async {
          completion(nil, NetworkerError.badData)
        }
        return
      }
      
      do {
        let medicineApi = try JSONDecoder().decode([MedicineApi].self, from: data)
        DispatchQueue.main.async {
          completion(medicineApi, nil)
        }
      } catch let error {
        DispatchQueue.main.async {
          completion(nil, error)
        }
      }
    }
    task.resume()
  }
    
}
