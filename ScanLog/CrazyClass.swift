//
//  CrazyClass.swift
//  ScanLog
//
//  Created by Federico on 30/04/16.
//  Copyright © 2016 Alexander Lehmann. All rights reserved.
//

import Foundation
import Parsimmon

class ScanLogTaggedToken: NSObject {
    var internalToken: TaggedToken?
    
    var token: String? {
        return self.internalToken?.token
    }
    var tag: String? {
        return self.internalToken?.tag
    }
 
    init(taggedToken: TaggedToken) {
        self.internalToken = taggedToken
    }
}

class CrazyClass: NSObject {
    
    var tagger: Tagger?
    
    override init() {
        self.tagger = Tagger()
    }
    
    func tagTokensInText(text: String) -> [ScanLogTaggedToken] {
        var resultValue = [ScanLogTaggedToken]()
        
        if let tagger = self.tagger {
            for tagged in tagger.tagWordsInText(text) {
                resultValue.append(ScanLogTaggedToken(taggedToken: tagged))
            }
        }
        
        return resultValue
    }
    
}