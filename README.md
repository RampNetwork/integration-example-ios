# Ramp iOS integration tutorial

If you have an iOS app built with Swift, here's a tutorial on how to add Ramp to it in just a few steps.

Remember to check out our full documentation at [https://docs.ramp.network/](https://docs.ramp.network/).

## What do we need to do?
- compose a URL for the Ramp widget with parameters of your choice
- create a Safari view controller and load the composed URL
- handle a callback URL to complete the purchase

## In detail

### Composing the widget URL

The Ramp widget allows you to provide some parameters before displaying it, so the user doesn't have to type or copy-paste information. You can set options such as wallet address, cryptocurrency and crypto amount, etc. In order to do so, we need to create a URL with proper query items as showcased in the snippet below. You can find the description of all available parameters in our [documentation](https://docs.ramp.network/configuration/).

```swift
struct Configuration {
    var swapAsset: String? = nil
    var swapAmount: String? = nil
    var fiatCurrency: String? = nil
    var fiatValue: String? = nil
    var userAddress: String? = nil
    var hostLogoUrl: String? = nil
    var hostAppName: String? = nil
    var userEmailAddress: String? = nil
    var url: String
    var finalUrl: String? = nil
    var hostApiKey: String? = nil

    func composeUrl() -> URL {
        var urlComponents = URLComponents(string: url)!

        urlComponents.appendQueryItem(name: "swapAsset", value: swapAsset)
        urlComponents.appendQueryItem(name: "swapAmount", value: swapAmount)
        urlComponents.appendQueryItem(name: "fiatCurrency", value: fiatCurrency)
        urlComponents.appendQueryItem(name: "fiatValue", value: fiatValue)
        urlComponents.appendQueryItem(name: "userAddress", value: userAddress)
        urlComponents.appendQueryItem(name: "hostLogoUrl", value: hostLogoUrl)
        urlComponents.appendQueryItem(name: "hostAppName", value: hostAppName)
        urlComponents.appendQueryItem(name: "userEmailAddress", value: userEmailAddress)
        urlComponents.appendQueryItem(name: "finalUrl", value: finalUrl)
        urlComponents.appendQueryItem(name: "hostApiKey", value: hostApiKey)

        return urlComponents.url!
    }
}

extension URLComponents {
    /// Appends query item to components. If no query items present,
    /// creates new list. If value is nil, does nothing.
    mutating func appendQueryItem(name: String, value: String?) {
        guard let value = value else { return }
        if queryItems == nil { queryItems = [.init(name: name, value: value)] }
        else { queryItems!.append(.init(name: name, value: value)) }
    }
}
```

### Presenting Safari web view with widget

We've composed the Ramp widget URL with all the parameters we need. The next step is to instantiate a `SFSafariViewController`, present it with the `present()` call and load the URL we just composed.

```swift
import UIKit
import SafariServices

class ViewController: UIViewController {

    func showRampInstantWidget() {
        var configuration = Configuration(url: "https://buy.ramp.network")
        configuration.fiatCurrency = "EUR"
        configuration.fiatValue = "2"
        configuration.swapAsset = "BTC"
        configuration.finalUrl = "rampexample://ramp.purchase.complete"

        let url = configuration.composeUrl()
        let rampVC = SFSafariViewController(url: rampWidgetUrl)
        present(rampVC, animated: true)
    }

}
```

### Handling a callback URL

One of the query items you can pass to the Ramp widget URL is `finalUrl`. If you do this, Ramp will redirect your users to this URL after the purchase is completed. You can use this mechanism to redirect the user back to your app, to detect purchase completion and perform some actions like dismissing the Safari view controller and notifying your user.

#### Step 1 - Define a redirection URL

Now, we need to register a URL scheme that's unique for our app. Usually, the best way is to simply use the app's name for this. If your app's name is **RampExample**, the scheme may be `rampexample`. Next, append a path that is unique for completing purchase via Ramp, for example `ramp.purchase.complete`.

Having these two, you can now define a value for the `finalUrl` parameter - it will be `rampexample://ramp.purchase.complete`.

#### Step 2 - Register URL scheme

Now, add a URL scheme to your app. You can do it using the `Info` tab for a specific target in Xcode or by manually editing the `Info.plist` file. If iOS ever tries to open an URL with your scheme, it will pass the URL to your app to handle it. You can find more details on how to add a custom URL scheme in [Apple documentation](https://developer.apple.com/documentation/xcode/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app).

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>rampexample</string> <!--Put your app scheme here-->
        </array>
    </dict>
</array>
```

#### Step 3 - Handling the callback

Now it's time to handle the URL callback inside your app. There are two methods to implement, depending on iOS version:
- `UIWindowSceneDelegate` - `func scene(_:, openURLContexts:)`
- `UIApplicationDelegate` - `func application(_:, open:, options:) -> Bool`

These methods will be called when the system detects that a user tried to open an URL that fits our scheme.

That's where our Safari view controller and setting the `finalUrl` parameter comes into play. After the purchase is completed and user taps the confirmation button, Safari VC will try to open the URL. Since it fits our registered scheme, the methods described above will be triggered. Now you can dismiss your Safari view controller, notify the user and perform any task you want.

That's it - your app can now use Ramp to allow your users to buy crypto easily.
