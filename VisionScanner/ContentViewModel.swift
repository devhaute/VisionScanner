//
//  ContentViewModel.swift
//  VisionScanner
//
//  Created by kai on 4/9/24.
//

import AVFoundation
import VisionKit

enum ScanType {
    case text, barcode
}

enum ScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerAvailable
    case scannerNotAvaliable
    
    var description: String {
        switch self {
        case .notDetermined:
            return "사용자로부터 카메라 접근 권한에 대한 결정이 아직 이루어지지 않았습니다."
        case .cameraAccessNotGranted:
            return "사용자가 카메라 접근 권한을 부여하지 않았습니다."
        case .cameraNotAvailable:
            return "카메라가 사용 불가능한 상태입니다."
        case .scannerAvailable:
            return "스캐너가 사용 가능한 상태입니다."
        case .scannerNotAvaliable:
            return "스캐너가 사용 불가능한 상태입니다."
        }
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var scannerAccessStatus: ScannerAccessStatusType = .notDetermined
    @Published var recognizedItems: [RecognizedItem] = []
    @Published var scanType: ScanType = .barcode
    @Published var textContentType: DataScannerViewController.TextContentType?
    @Published var recognizesMultipleItems = true
    
    var recognizedDataType: DataScannerViewController.RecognizedDataType {
        scanType == .barcode ? .barcode() : .text(textContentType: textContentType)
    }
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            scannerAccessStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            
            if granted {
                scannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvaliable
            } else {
                scannerAccessStatus = .cameraAccessNotGranted
            }
        case .authorized:
            scannerAccessStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvaliable
        case .denied, .restricted:
            scannerAccessStatus = .cameraAccessNotGranted
        @unknown default:
            fatalError()
        }
    }
}
