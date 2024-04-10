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
            if viewModel.scannerAccessStatus == .scannerAvailable {
                mainView
            }
        }
        .task {
            await viewModel.requestScannerAccessStatus()
        }
    }
}

extension ContentView {
    private var mainView: some View {
        ScannerView(
            recognizedItems: $viewModel.recognizedItems,
            recognizedDataType: viewModel.recognizedDataType,
            recognizesMultipleItems: viewModel.recognizesMultipleItems
        )
    }
}

#Preview {
    ContentView()
}
