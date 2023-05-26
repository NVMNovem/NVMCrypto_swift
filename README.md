![NVMColor_header](https://github.com/NVMNovem/NVMCrypto_swift/assets/44820440/3eef5d95-9cb0-4424-a537-f7dc4faacba1)


<h3 align="center">iOS · macOS · watchOS · tvOS</h3>

---

A pure Swift library that allows you to easily encrypt and decrypt data.

This project is created and maintained by Novem.

---

- [Installation](#installation)
  - [Swift Package Manager](#swift-package-manager)
- [Usage Guide](#usage-guide)
  - [Encrypting](#encrypting)
  - [Decrypting](#decrypting)

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

You can use The Swift Package Manager (SPM) to install NVMRegion by adding the following description to your `Package.swift` file:

```swift
import PackageDescription

let package = Package(
    name: "YOUR_PROJECT_NAME",
    dependencies: [
        .package(url: "https://github.com/NVMNovem/NVMCrypto_swift", from: "1.0.0"),
    ]
)
```
Then run `swift build`. 

You can also install using SPM in your Xcode project by going to 
"Project->NameOfYourProject->Swift Packages" and placing "https://github.com/NVMNovem/NVMCrypto" in the 
search field. Then select the option that is most suited for your needs.


## Usage Guide

### Encrypting
```swift
let nvmCryptResult = try NVMCrypto.encryptString("Your string to encrypt")
```

### Decrypting
```swift
let decryptedString = try NVMCrypto.decryptString(nvmCryptResult)
```
