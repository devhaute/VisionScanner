//
//  ContentView.swift
//  VisionScanner
//
//  Created by kai on 4/9/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Text(viewModel.scannerAccessStatus.description)
        }
        .task {
            await viewModel.requestScannerAccessStatus()
        }
    }
}

#Preview {
    ContentView()
}
