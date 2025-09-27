//
//  WelcomeView.swift
//  Reader
//
//  Created by Isaac Akalanne on 27/09/2025.
//

import SwiftUI

struct WelcomeView: View {

    init() {
        
    }

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "scroll.fill")
                .font(.system(size: 64))
                .foregroundColor(Color(red: 0.6, green: 0.5, blue: 0.4))
                .opacity(0.5)
            
            VStack(spacing: 16) {
                Text("Welcome to Papyrus")
                    .font(.custom("Georgia", size: 28))
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                
                Text("Begin your tale...")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color(red: 0.4, green: 0.35, blue: 0.3))
                    .italic()
            }

            Spacer()
        }
    }
}
