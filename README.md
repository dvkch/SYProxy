SYProxy
=======

NSURLProtocol subclass to implement in-app proxying.

For a quick introduction to this pod take a look at the example project in this repo. 


```swift
import SYProxy

@main
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        self.proxies = ... (decode using NSCoder)

        ProxyURLProtocol.dataSource = self
        ProxyURLProtocol.isLoggingEnabled = true
        ProxyURLProtocol.register()

        return true
    }
    
    func proxyURLProtocolRequiresFirstProxyMatching(url: URL) -> Proxy? {
        return proxies.first(matching: url)
    }
}
```

License
===

Use it as you like in every project you want, redistribute with mentions of my name and don't blame me if it breaks :)

-- dvkch
 
