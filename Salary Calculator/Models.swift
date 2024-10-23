//
//  Models.swift
//  Salary Calculator
//
//  Created by Wenqi Zheng on 9/13/24.
//

import Foundation
import Combine

class JobData: ObservableObject {
    @Published var jobList: [String] = []
    @Published var jobHours: [String: (rate: Double, hourList: [[Date]], numHoursList: [Double],income: Double)] = [:]

}

