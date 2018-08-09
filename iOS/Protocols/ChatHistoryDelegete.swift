//
//  ChatHistoryDelegete.swift
//  AskMe
//
//  Created by Maryam Jafari on 4/27/18.
//  Copyright © 2018 Maryam Jafari. All rights reserved.
//

import Foundation
protocol ChatHistoryDelegate {
    func chatHistoryUpdateRecieved(data: Message?)
}
