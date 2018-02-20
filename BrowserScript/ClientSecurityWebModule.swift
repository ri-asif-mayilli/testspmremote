import Foundation
import WebKit

class ClientSecurityWebModule: NSObject, WKNavigationDelegate {
    
    private var wkWebView = WKWebView()
    private var _token : String
    private var _snippetId : String
    
    init(snippetId: String, uuidToken: String) {
        self._snippetId = snippetId
        self._token = uuidToken
        super.init()

        self.wkWebView.navigationDelegate = self
    }
    
    public func loadRequest(request: URLRequest) {
        wkWebView.load(request)
    }
    
    // MARK: WKNavigationDelegate
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
         //do nothing
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: .executeWebSnippet(self._snippetId, self._token, error.localizedDescription))) {
            (_,_) in
        }
    }
}
