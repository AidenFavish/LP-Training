//
//  vidSetup.swift
//  LP Training
//
//  Created by Aiden Favish on 12/10/23.
//

import SwiftUI
import UniformTypeIdentifiers
import AVFoundation

struct vidSetup: View {
    @Binding var address: String
    
    @State private var outputFolder: URL?
    @State private var selectedFolder: URL?
    @State private var processingProgress: Double = 0.0
    @State private var isWritePermissionGranted: Int = 0
    @State private var isProcessing: Bool = false
    @State private var frameRate: Int = 1
    var body: some View {
        VStack {
            Text("Setup")
                .font(.title)
            
            
            HStack {
                Text("Select video:")
                
                Button(selectedFolder != nil ? selectedFolder!.lastPathComponent: "Choose File") {
                    chooseVideoFile()
                }
                .frame(width: 90)
                .disabled(isProcessing)
            }
            .padding()
            HStack {
                Text("Select output:")
                
                Button(action: {
                    chooseOutputFolder()
                }, label: {
                    Label(outputFolder != nil ? outputFolder!.lastPathComponent : "Choose Folder", systemImage: isWritePermissionGranted == 0 ? "folder" : (isWritePermissionGranted == 1 ? "checkmark" : "xmark"))
                        .foregroundStyle(isWritePermissionGranted == 0 ? .white : (isWritePermissionGranted == 1 ? .green : .red))
                })
                .frame(width: 135)
                .disabled(isProcessing)
            }
            .padding(.horizontal)
            HStack {
                Stepper(value: $frameRate, in: 1...30, step: 1) {
                    Text("Frame every \(frameRate) seconds")
                }
                .disabled(isProcessing)
            }.padding()
            

            
            Button(action: {
                processVideo()
            }, label: {
                Label("Process", systemImage: "cpu")
                    .font(.title3)
                    .padding(.horizontal)
                    .padding(.vertical, 7)
            })
            .buttonStyle(.plain)
            .background(isWritePermissionGranted != 1 ? .black:.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top)
            .disabled(isWritePermissionGranted != 1 || isProcessing)
            
            if isProcessing {
                ProgressView("Processing...", value: max(0.0, min(processingProgress, 1.0)), total: 1.0)
            }
            
        }.padding()
    }
    
    func chooseVideoFile() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.mpeg4Movie] // Set the allowed file types as needed

        openPanel.begin { response in
            if response == .OK, let selectedURL = openPanel.url {
                // Assign the selected folder to the appropriate state variable
                selectedFolder = selectedURL
            }
        }
    }
    
    func chooseOutputFolder() {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.canChooseDirectories = true

        openPanel.begin { response in
            if response == .OK, let folderURL = openPanel.url {
                outputFolder = openPanel.url
                requestWriteAccess(to: folderURL)
            }
        }
    }
        
    func requestWriteAccess(to folderURL: URL) {
        let securityScope = folderURL.startAccessingSecurityScopedResource()

        if securityScope {
            isWritePermissionGranted = 1
        } else {
            isWritePermissionGranted = 2
            print("Write access not granted.")
        }
    }
    
    func processVideo() {
            guard let outputFolder = outputFolder else {
                print("Output folder not selected.")
                return
            }
            
            isProcessing = true
            
            Task {
                do {
                    let asset = AVURLAsset(url: selectedFolder!)
                    
                    let imageGenerator = AVAssetImageGenerator(asset: asset)
                    imageGenerator.requestedTimeToleranceBefore = .zero
                    imageGenerator.requestedTimeToleranceAfter = .zero
                    
                    let durationInSeconds = try await asset.load(.duration).seconds
                    let timeInterval: Double = Double(frameRate)
                    
                    for i in stride(from: 0, to: durationInSeconds, by: timeInterval) {
                        let startTime = CMTime(seconds: i, preferredTimescale: 600)
                        _ = CMTime(seconds: min(i + timeInterval, durationInSeconds), preferredTimescale: 600)
                        let cgImage = try imageGenerator.copyCGImage(at: startTime, actualTime: nil)
                        
                        //Temp
                        let nsImageT = NSImage(cgImage: cgImage, size: .zero)
                        
                        let nsImage = cropImageToSquare(image: nsImageT, size: NSSize(width: min(nsImageT.size.width, nsImageT.size.height), height: min(nsImageT.size.width, nsImageT.size.height)))
                        let progress = (i + timeInterval) / durationInSeconds
                        
                        DispatchQueue.main.async {
                            processingProgress = progress
                        }
                        
                        // Save the image locally (you may want to customize the path)
                        if let data = nsImage!.tiffRepresentation {
                            let imageName = "frame\(i / timeInterval).jpg"
                            let imageUrl = outputFolder.appendingPathComponent(imageName)
                            try data.write(to: imageUrl)
                        }
                        
                        print("Processed image at \(startTime.seconds) seconds")
                    }
                    
                    // Reset the progress after processing is complete
                    DispatchQueue.main.async {
                        //processingProgress = 0.0
                        //isProcessing = false
                        print("Video processing complete.")
                        print(outputFolder.path())
                        address = outputFolder.path()
                        //returner = false
                    }
                } catch {
                    print("Error processing video: \(error)")
                    // Handle error gracefully, show alert, etc.
                }
            }
        }
    
    func cropImageToSquare(image: NSImage, size: NSSize) -> NSImage? {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return nil
        }
        
        let width = min(cgImage.width, cgImage.height)
        let height = width
        
        let x = (cgImage.width - width) / 2
        let y = (cgImage.height - height) / 2
        
        let cropRect = CGRect(x: x, y: y, width: width, height: height)
        
        if let croppedCGImage = cgImage.cropping(to: cropRect) {
            let croppedImage = NSImage(cgImage: croppedCGImage, size: size)
            return croppedImage
        }
        
        return nil
    }

}
/*
#Preview {
    vidSetup(bruh: true)
}*/
