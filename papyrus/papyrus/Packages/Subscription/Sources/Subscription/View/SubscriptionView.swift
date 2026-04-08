//
//  SubscriptionView.swift
//  Subscription
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import PapyrusStyleKit
import ReduxKit
import StoreKit
import SwiftUI

public struct SubscriptionView: View {
    @EnvironmentObject var store: SubscriptionStore
    @Environment(\.papyrusColorScheme) private var colorScheme
    let fontName: String

    private var state: SubscriptionState {
        store.state
    }

    public init(fontName: String = "Georgia") {
        self.fontName = fontName
    }

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
        .background(PapyrusColor.background.color(in: colorScheme))
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Premium")
                .font(.custom(fontName, size: 24))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

            Divider()
                .background(PapyrusColor.iconPrimary.color(in: colorScheme).opacity(0.5))
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 8)
    }

    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: PapyrusColor.accent.color(in: colorScheme)))
                .scaleEffect(1.2)

            Text("Loading subscription details...")
                .font(.custom(fontName, size: 16))
                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
                    .font(.custom(fontName, size: 20))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

                Text("Enjoy unlimited chapter creation")
                    .font(.custom(fontName, size: 16))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(PapyrusColor.borderPrimary.color(in: colorScheme), lineWidth: 1)
                    )
            )

            VStack(spacing: 8) {
                Text("Subscription Status")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))

                Text(state.isSubscribed ? "Active" : "Inactive")
                    .font(.custom(fontName, size: 16))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
            }

            Button(action: {
                store.dispatch(SubscriptionAction.restorePurchases)
            }) {
                Text("Restore Purchases")
                    .font(.custom(fontName, size: 14))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
                    .font(.custom(fontName, size: 24))
                    .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)

                Text("Create unlimited chapters and bring your stories to life")
                    .font(.custom(fontName, size: 16))
                    .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
                    .fill(PapyrusColor.backgroundSecondary.color(in: colorScheme).opacity(0.4))
            )

            if let product = state.product {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        Text(product.displayPrice)
                            .font(.custom(fontName, size: 28))
                            .foregroundColor(PapyrusColor.accent.color(in: colorScheme))

                        Text("per month")
                            .font(.custom(fontName, size: 14))
                            .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                    }

                    Button(action: {
                        store.dispatch(.purchaseSubscription)
                    }) {
                        Text("Subscribe Now")
                            .font(.custom(fontName, size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 52)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(PapyrusColor.accent.color(in: colorScheme))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(state.isLoading)

                    HStack(spacing: 12) {
                        Button(action: {
                            store.dispatch(.restorePurchases)
                        }) {
                            Text("Restore Purchases")
                                .font(.custom(fontName, size: 14))
                                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                                .underline()
                        }
                        .buttonStyle(PlainButtonStyle())
                        .disabled(state.isLoading)
                    }

                    HStack(spacing: 16) {
                        Link(destination: URL(string: "https://www.smileydude.co.uk/post/papyrus-privacy-policy")!) {
                            Text("Privacy Policy")
                                .font(.custom(fontName, size: 12))
                                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
                                .underline()
                        }

                        Link(destination: URL(string: "https://www.smileydude.co.uk/post/papyrus-terms-of-use-eula")!) {
                            Text("Terms of Use (EULA)")
                                .font(.custom(fontName, size: 12))
                                .foregroundColor(PapyrusColor.textSecondary.color(in: colorScheme))
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
                .foregroundColor(PapyrusColor.accent.color(in: colorScheme))
                .frame(width: 28)

            Text(text)
                .font(.custom(fontName, size: 16))
                .foregroundColor(PapyrusColor.textPrimary.color(in: colorScheme))

            Spacer()
        }
    }

    private func errorView(_ error: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(red: 0.8, green: 0.4, blue: 0.3))

            Text(error)
                .font(.custom(fontName, size: 14))
                .foregroundColor(PapyrusColor.error.color(in: colorScheme))

            Spacer()

            Button(action: {
                store.dispatch(SubscriptionAction.clearError)
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(PapyrusColor.error.color(in: colorScheme))
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
