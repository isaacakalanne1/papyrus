//
//  SubscriptionView.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import ReduxKit
import StoreKit
import PapyrusStyleKit

public struct SubscriptionView: View {
    @EnvironmentObject var store: SubscriptionStore
    
    private var state: SubscriptionState {
        store.state
    }
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            headerSection
            
            ScrollView {
                VStack(spacing: 24) {
                    if state.isLoading && state.product == nil {
                        loadingView
                    } else if state.isSubscribed {
                        activeSubscriptionView
                    } else {
                        subscriptionOfferView
                    }
                    
                    if let error = state.error {
                        errorView(error)
                    }
                }
                .padding(20)
            }
        }
        .background(PapyrusColor.background.color)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Premium")
                .font(.custom("Georgia", size: 24))
                .foregroundColor(PapyrusColor.textPrimary.color)
            
            Divider()
                .background(PapyrusColor.iconPrimary.color.opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PapyrusColor.accent.color))
                .scaleEffect(1.2)
            
            Text("Loading subscription details...")
                .font(.custom("Georgia", size: 16))
                .foregroundColor(PapyrusColor.textSecondary.color)
        }
        .frame(maxWidth: .infinity, minHeight: 200)
    }
    
    private var activeSubscriptionView: some View {
        VStack(spacing: 20) {
            VStack(spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 48))
                    .foregroundColor(Color(red: 0.4, green: 0.6, blue: 0.4))
                
                Text("You're subscribed!")
                    .font(.custom("Georgia", size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color)
                
                Text("Enjoy unlimited chapter creation")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(PapyrusColor.textSecondary.color)
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(PapyrusColor.backgroundSecondary.color.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(PapyrusColor.borderPrimary.color, lineWidth: 1)
                    )
            )
            
            VStack(spacing: 8) {
                Text("Subscription Status")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color)
                
                Text(state.isSubscribed ? "Active" : "Inactive")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(PapyrusColor.textPrimary.color)
            }
            
            Button(action: {
                store.dispatch(SubscriptionAction.restorePurchases)
            }) {
                Text("Restore Purchases")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color)
                    .underline()
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(state.isLoading)
        }
    }
    
    private var subscriptionOfferView: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Text("Unlock Your\nCreative Potential")
                    .font(.custom("Georgia", size: 24))
                    .foregroundColor(PapyrusColor.textPrimary.color)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Create unlimited chapters and bring your stories to life")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(PapyrusColor.textSecondary.color)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 20) {
                featureItem(icon: "book.fill", text: "Unlimited chapter creation")
                featureItem(icon: "sparkles", text: "AI-powered story generation")
                featureItem(icon: "arrow.clockwise", text: "Automatic story sequels")
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(PapyrusColor.backgroundSecondary.color.opacity(0.4))
            )
            
            if let product = state.product {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(product.displayPrice)
                            .font(.custom("Georgia", size: 28))
                            .foregroundColor(PapyrusColor.accent.color)
                        
                        Text("per month")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(PapyrusColor.textSecondary.color)
                    }
                    
                    Button(action: {
                        store.dispatch(.purchaseSubscription)
                    }) {
                        Text("Subscribe Now")
                            .font(.custom("Georgia", size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(PapyrusColor.accent.color)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(state.isLoading)
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            store.dispatch(.restorePurchases)
                        }) {
                            Text("Restore Purchases")
                                .font(.custom("Georgia", size: 14))
                                .foregroundColor(PapyrusColor.textSecondary.color)
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(state.isLoading)
                    }
                    
                    HStack(spacing: 16) {
                        Link(destination: URL(string: "https://www.smileydude.co.uk/post/papyrus-privacy-policy")!) {
                            Text("Privacy Policy")
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(PapyrusColor.textSecondary.color)
                                .underline()
                        }
                        
                        Link(destination: URL(string: "https://www.smileydude.co.uk/post/papyrus-terms-of-use-eula")!) {
                            Text("Terms of Use (EULA)")
                                .font(.custom("Georgia", size: 12))
                                .foregroundColor(PapyrusColor.textSecondary.color)
                                .underline()
                        }
                    }
                }
            }
        }
    }
    
    private func featureItem(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(PapyrusColor.accent.color)
                .frame(width: 28)
            
            Text(text)
                .font(.custom("Georgia", size: 16))
                .foregroundColor(PapyrusColor.textPrimary.color)
            
            Spacer()
        }
    }
    
    private func errorView(_ error: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.3))
            
            Text(error)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(PapyrusColor.error.color)
            
            Spacer()
            
            Button(action: {
                store.dispatch(SubscriptionAction.clearError)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(PapyrusColor.error.color)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 1, green: 0.9, blue: 0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 0.8, green: 0.4, blue: 0.3).opacity(0.3), lineWidth: 1)
                )
        )
    }
}
