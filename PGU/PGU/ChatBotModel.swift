//
//  ChatBotModel.swift
//  PGU
//
//  Created by Bryan Arambula on 2/15/24.
//

import SwiftUI

struct FAQ {
    let question: String
    let answer: String
    let keywords: [String] // Add keywords related to the question
}

class ChatBotModel: ObservableObject {
    @Published var faqs = [
        
        FAQ(question: "What is the refund policy?",
            answer: "Full refunds are available up to seven (7) days after initial registration. No refunds will be available after May 26, 2024, regardless of when you registered. This is due to facilities, coaches, materials and travel arrangements being paid for by this time. If there is an injury or illness, there are potential options for rolling over your registration to another camp or giving your registration to another would-be camper. Refunds will be given due to injury or illness with a doctor's note.",
            keywords: ["refund", "return policy", "money back"]),
        
        FAQ(question: "Are your camps only for Point Guards?",
            answer: "No! We work with all positions at every camp and every training session.",
            keywords: ["position", "point guards", "other positions"]),
        
        FAQ(question: "How will we know where to go when we arrive?",
            answer: "There will be plenty of signage in the parking lot and within the facility directing you where to check in. You will also receive an email ahead of camp with all of the information you'll need.",
            keywords: ["where to go", "arrive", "location", "do i go", "do we go"]),
        
        FAQ(question: "Are there options to stay overnight?",
            answer: "While we are not an overnight camp and do not offer lodging, we do sometimes partner with hotels that will have special rates. If this is the case for your camp, we will let you know via email and on social media..",
            keywords: ["overnight", "stay the night", "hotels"]),
        
        FAQ(question: "Do the camps consist of drills or scrimmage?",
            answer: "For the most part, drills and stations. We want to work on an individual basis with your athlete and this allows us to do so. However, there will be time on the final day of camp for live scrimmage and fun.",
            keywords: ["scrimmage", "drills", "consist"]),
        
        FAQ(question: "How can I watch my athlete during your camps?",
            answer: "We always have seating in the gyms, you are welcome to hang out and watch. We also broadcast every minute of camp live on Facebook. We also post daily recaps on our Instagram.",
            keywords: ["watch", "observe", "look", "cheerlead", "spectate", "parents stay", "stay"]),
        
        FAQ(question: "Can my athlete move up or down a group?",
            answer: "Yep! Just shoot us an email at info@pointguarduniversity.com to let us know.",
            keywords: ["move up", "graduate", "ranks"]),
    ]
    
    func answer(for userInput: String) -> String? {
        let lowercasedInput = userInput.lowercased()
        for faq in faqs {
            for keyword in faq.keywords {
                if lowercasedInput.contains(keyword) {
                    return faq.answer
                }
            }
        }
        return "I'm not sure about that. Can you try asking in a different way, email us at info@pointguarduniversity.com or check our FAQ section?"
    }
}

