//
//  MyMemoryResponse.swift
//  TranslateMe
//
//  Created by Admin on 4/5/24.
//

import SwiftUI

enum MyMemoryLanguageOption: String {
  case english = "en", spanish = "es", portuguese = "pt", french = "fr"
}



struct MyMemoryBaseRequest {
  let query: String
  let sourceLanguage: MyMemoryLanguageOption
  let outputLanguage: MyMemoryLanguageOption
}


func makeMemoryUrlFor(_ request: MyMemoryBaseRequest) -> URL {
  URL(string: "https://api.mymemory.translated.net/get?q=\(request.query)&langpair=\(request.sourceLanguage.rawValue)|\(request.outputLanguage.rawValue)")!
}


let memoryUrl = makeMemoryUrlFor(
  MyMemoryBaseRequest(
    query: "Hello how have you been?",
    sourceLanguage: .english,
    outputLanguage: .portuguese
  )
)

// MARK: - Response

/**
 ```
 {
   "responseData": {
     "translatedText": "Ciao Mondo!",
     "match": 1
   },
   "quotaFinished": false,
   "mtLangSupported": null,
   "responseDetails": "",
   "responseStatus": 200,
   "responderId": null,
   "exception_code": null,
   "matches": [
     {
       "id": "747064246",
       "segment": "Hello World!",
 -- >  "translation": "Ciao Mondo!",
       "source": "en-GB",
       "target": "it-IT",
       "quality": 74,
       "reference": null,
       "usage-count": 2,
       "subject": "",
       "created-by": "MateCat",
       "last-updated-by": "MateCat",
       "create-date": "2024-03-25 15:49:22",
       "last-update-date": "2024-03-25 15:49:22",
       "match": 1
     }
   ]
 }
 ```
 */

// Codable = Encodable & Decodable
struct MyMemoryMatchesResponse: Decodable {
  let translation: String
}

struct MyMemoryTranslateResponse: Decodable {
  let matches: [MyMemoryMatchesResponse]
}


