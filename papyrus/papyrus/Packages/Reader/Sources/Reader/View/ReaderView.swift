//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    @State private var loadingOpacity: Double = 0.3
    
    init() {
        
    }
    
    public var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let chapter = store.state.chapter {
                    Text(chapter)
                        .font(.custom("Georgia", size: 18))
                        .lineSpacing(8)
                        .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                        .padding(.horizontal, 32)
                        .padding(.vertical, 40)
                } else {
                    // Loading state
                    VStack(spacing: 20) {
                        // Ancient scroll icon
                        Image(systemName: "scroll.fill")
                            .font(.system(size: 48))
                            .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                            .opacity(loadingOpacity)
                            .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: loadingOpacity)
                        
                        Text("Unrolling the scroll...")
                            .font(.custom("Georgia", size: 16))
                            .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                            .italic()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical, 100)
                    .onAppear {
                        loadingOpacity = 1.0
                    }
                }
            }
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.95, blue: 0.89),
                    Color(red: 0.96, green: 0.92, blue: 0.84)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            store.dispatch(.createChapter)
        }
    }
}

#Preview {
    ReaderView()
}
