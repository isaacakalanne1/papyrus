//
//  Bundle+Package.swift
//  SDIconsKit
//
//  Created by Isaac Akalanne on 04/10/2025.
//

import SwiftUI

private class CurrentBundleFinder { /* Not needed */ }

extension Bundle {
    static func packageBundle(_ name: String) -> Bundle {
        /* Create a list of URLs to test where the Bundle resides*/
        let candidates = [
            /* Bundle should be present here when the package is linked into an App. */
            Bundle.main.resourceURL,

            /* Bundle should be present here when the package is linked into a framework. */
            Bundle(for: CurrentBundleFinder.self).resourceURL,

            /* For command-line tools. */
            Bundle.main.bundleURL,

            /* Bundle should be present here when running previews
                from a different package (this is the path to "…/Debug-iphonesimulator/"). */
            Bundle(for: CurrentBundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent()
                .deletingLastPathComponent(),

            Bundle(for: CurrentBundleFinder.self)
                .resourceURL?
                .deletingLastPathComponent()
                .deletingLastPathComponent(),
        ]

        /* Test each candidate to see where the bundle resides */
        for candidate in candidates {
            let bundlePath = candidate?.appendingPathComponent(name + ".bundle")
            if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                return bundle
            }
        }

        fatalError("unable to find bundle named \(name)")
    }
}
