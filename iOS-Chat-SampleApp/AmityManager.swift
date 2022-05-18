//
//  AmityManager.swift
//  iOS-Chat-SampleApp
//
//  Created by Mark on 18/5/2565 BE.
//

import Foundation
import AmitySDK

final class AmityManager {
    
    private(set) var client: AmityClient?
    
    /// An array storing json stirng of push payload, sorted in ascending order.
    private(set) var pushPayloads: [String] = []
    
    var postRepository: AmityPostRepository?
    
    static let shared: AmityManager = AmityManager()
    
    // Production Environment
    // Note:
    // If you want to use default region, you can also use `AmityClient(apiKey: _)` method.
    func setup(apiKey: String, region: AmityRegion) {
        guard !apiKey.isEmpty else {
            assertionFailure("Api key is required!")
            return
        }
        
      
        self.client = try? AmityClient(apiKey:apiKey,region: region)
        

    }
}
    
   
