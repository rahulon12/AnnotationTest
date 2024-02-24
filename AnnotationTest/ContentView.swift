//
//  ContentView.swift
//  AnnotationTest
//
//  Created by Rahul on 2/13/24.
//

import SwiftUI

struct ContentView: View {
    @State private var modelPath: URL?
    @State private var showingFiles = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CubeView(modelPath: modelPath)
            Button {
                showingFiles = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(.thinMaterial)
                    Label("Import", systemImage: "folder")
                }
            }
            .padding()
            .frame(width: 150, height: 75)
            .foregroundStyle(.thickMaterial)
        }
        .fileImporter(
            isPresented: $showingFiles,
            allowedContentTypes: [.threeDContent]
        ) { result in
            do {
                let selectedFile: URL = try result.get()
                // file importing code
                guard selectedFile.startAccessingSecurityScopedResource() else {
                    // Handle the failure here.
                    return
                }
                
                let documentsUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
                let destinationUrl = documentsUrl.appendingPathComponent(selectedFile.lastPathComponent)
                // copies file to cache
                if let dataFromURL = NSData(contentsOf: selectedFile) {
                    if dataFromURL.write(to: destinationUrl, atomically: true) {
                        modelPath = destinationUrl
                    } else {
                        fatalError("Error Saving and recording file")
                    }
                }
                // needed to avoid Apple security Failures
                selectedFile.stopAccessingSecurityScopedResource()
            } catch {
                print("error in file importer ", error)
            }
        }
    }
}

#Preview {
    ContentView()
}
