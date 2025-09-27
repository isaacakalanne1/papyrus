//
//  ReaderView.swift
//  papyrus
//
//  Created by Isaac Akalanne on 26/09/2025.
//

import SwiftUI

struct ReaderView: View {
    @EnvironmentObject var store: ReaderStore
    
    init() {
        
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                Text(store.state.chapter)
                    .font(.custom("Georgia", size: 18))
                    .lineSpacing(8)
                    .foregroundColor(Color(red: 0.2, green: 0.15, blue: 0.1))
                    .padding(.horizontal, 32)
                    .padding(.vertical, 40)
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
