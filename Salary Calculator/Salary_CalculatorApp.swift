//
//  Salary_CalculatorApp.swift
//  Salary Calculator
//
//  Created by Wenqi Zheng on 7/5/24.
//

import SwiftUI

@main
struct Salary_CalculatorApp: App {
    @StateObject private var jobData = JobData()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(jobData)
        }
    }
}
