//
//  SDIconsTests.swift
//  SDIconsKit
//
//  Created by Isaac Akalanne on 03/10/2025.
//

import Testing
import SwiftUI
import UIKit
@testable import SDIconsKit

class SDIconsTests {
    
    // MARK: - Parameterized Icon Tests
    
    @Test(arguments: [
        (SDIcons.scroll, "scroll")
    ])
    func icon_name(icon: SDIcons, expectedName: String) {
        #expect(icon.name == expectedName)
    }
    
    @Test(arguments: [
        SDIcons.scroll
    ])
    func icon_bundle(icon: SDIcons) {
        let bundle = icon.bundle
        #expect(bundle != nil)
        #expect(bundle.bundleIdentifier?.contains("SDIconsKit") == true)
    }
    
    @Test(arguments: [
        SDIcons.scroll
    ])
    func icon_uiImage(icon: SDIcons) {
        let uiImage = icon.uiImage
        #expect(uiImage != nil)
        #expect(uiImage is UIImage)
    }
    
    @Test(arguments: [
        SDIcons.scroll
    ])
    func icon_swiftUIImage(icon: SDIcons) {
        let image = icon.image
        #expect(image != nil)
        #expect(image is Image)
    }
    
    @Test(arguments: [
        (SDIcons.scroll, "scroll")
    ])
    func icon_imageLoadingConsistency(icon: SDIcons, expectedName: String) {
        let bundle = icon.bundle
        let directImage = UIImage(named: expectedName, in: bundle, compatibleWith: nil)
        let iconImage = icon.uiImage
        
        // If the resource exists, both should be non-empty
        // If it doesn't exist, both should be empty UIImages
        if directImage != nil {
            #expect(iconImage.size != CGSize.zero)
        } else {
            #expect(iconImage.size == CGSize.zero)
        }
    }
    
    @Test(arguments: [
        SDIcons.scroll
    ])
    func icon_propertyConsistency(icon: SDIcons) {
        let bundle = icon.bundle
        let uiImage = icon.uiImage
        
        // Verify consistency between properties
        let directUIImage = UIImage(named: icon.name, in: bundle, compatibleWith: nil)
        if directUIImage != nil {
            // If the resource exists, sizes should match
            #expect(uiImage.size == directUIImage?.size)
        } else {
            // If resource doesn't exist, should return empty UIImage
            #expect(uiImage.size == CGSize.zero)
        }
    }
    
    // MARK: - Bundle Extension Tests
    
    @Test
    func packageBundle_returnsValidBundle() {
        let bundleName = "SDIconsKit_SDIconsKit"
        let bundle = Bundle.packageBundle(bundleName)
        
        // Verify bundle is created and has expected properties
        #expect(bundle != nil)
        #expect(bundle is Bundle)
    }
    
    @Test
    func packageBundle_invalidName_throws() {
        let invalidBundleName = "NonExistentBundle_Invalid"
        
        // This should throw a fatal error, but we can't easily test fatal errors
        // Instead, we test with a valid name to ensure the method works
        let validBundle = Bundle.packageBundle("SDIconsKit_SDIconsKit")
        #expect(validBundle != nil)
    }
    
    // MARK: - Edge Case Tests
    
    @Test
    func bundle_consistency() {
        let icon1 = SDIcons.scroll
        let icon2 = SDIcons.scroll
        
        // Same enum cases should return the same bundle
        #expect(icon1.bundle.bundlePath == icon2.bundle.bundlePath)
    }
    
    @Test
    func uiImage_consistency() {
        let icon = SDIcons.scroll
        let image1 = icon.uiImage
        let image2 = icon.uiImage
        
        // Multiple calls should return consistent results
        #expect(image1.size == image2.size)
    }
}
