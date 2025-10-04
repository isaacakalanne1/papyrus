//
//  SubscriptionView.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI
import ReduxKit
import StoreKit

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
        .background(Color(red: 0.98, green: 0.95, blue: 0.89))
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Premium")
                .font(.custom("Georgia", size: 24))
                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
            
            Divider()
                .background(Color(red: 0.6, green: 0.5, blue: 0.4).opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(red: 0.8, green: 0.65, blue: 0.4)))
                .scaleEffect(1.2)
            
            Text("Loading subscription details...")
                .font(.custom("Georgia", size: 16))
                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
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
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                
                Text("Enjoy unlimited chapter creation")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.8, green: 0.75, blue: 0.7), lineWidth: 1)
                    )
            )
            
            VStack(spacing: 8) {
                Text("Subscription Status")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                
                Text(state.isSubscribed ? "Active" : "Inactive")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
            }
            
            Button(action: {
                store.dispatch(SubscriptionAction.restorePurchases)
            }) {
                Text("Restore Purchases")
                    .font(.custom("Georgia", size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
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
                    .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                Text("Create unlimited chapters and bring your stories to life")
                    .font(.custom("Georgia", size: 16))
                    .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
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
                    .fill(Color(red: 0.96, green: 0.92, blue: 0.84).opacity(0.4))
            )
            
            if let product = state.product {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(product.displayPrice)
                            .font(.custom("Georgia", size: 28))
                            .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                        
                        Text("per month")
                            .font(.custom("Georgia", size: 14))
                            .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
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
                                    .fill(Color(red: 0.8, green: 0.65, blue: 0.4))
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
                                .foregroundColor(Color(red: 0.5, green: 0.45, blue: 0.4))
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(state.isLoading)
                    }
                }
            }
        }
    }
    
    private func featureItem(icon: String, text: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color(red: 0.8, green: 0.65, blue: 0.4))
                .frame(width: 28)
            
            Text(text)
                .font(.custom("Georgia", size: 16))
                .foregroundColor(Color(red: 0.3, green: 0.25, blue: 0.2))
            
            Spacer()
        }
    }
    
    private func errorView(_ error: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.3))
            
            Text(error)
                .font(.custom("Georgia", size: 14))
                .foregroundColor(Color(red: 0.6, green: 0.3, blue: 0.2))
            
            Spacer()
            
            Button(action: {
                store.dispatch(SubscriptionAction.clearError)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.6, green: 0.3, blue: 0.2))
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
