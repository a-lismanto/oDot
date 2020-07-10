//
//  ServiceWorker.swift
//  oDot
//
//  Created by Andrew on 09/07/20.
//  Copyright © 2020 Andrew. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class ServiceWorker: NSObject {
    static let shared = ServiceWorker()
    
    func getData(completion: @escaping (_ success: Bool) -> Void) {
        let request = AF.request("https://api.opendota.com/api/heroStats", method: .get)
        
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let processResult = RealmWorker.shared.saveHeroesFromJson(heroes: json)
                
                if processResult {
                    completion(true)
                } else {
                    completion(false)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
            //
        }
    }
}
