// swift-tools-version:4.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription


let useBrew = true
let libpqUrl: String
#if os(macOS)
    if useBrew {
        libpqUrl = "https://github.com/Molbie/swift-libpq-macos-brew.git"
    }
    else {
        libpqUrl = "https://github.com/Molbie/swift-libpq-macos-installer.git"
    }
#else
    libpqUrl = "https://github.com/Molbie/swift-libpq-linux.git"
#endif


let package = Package(
    name: "swift-PostgreSQL",
    products: [
        .library(name: "SwiftPostgreSQL", targets: ["SwiftPostgreSQL"]),
    ],
    dependencies: [
        .package(url: libpqUrl, from: "1.0.0"),
    ],
    targets: [
        .target(name: "SwiftPostgreSQL", dependencies: [])
    ]
)
