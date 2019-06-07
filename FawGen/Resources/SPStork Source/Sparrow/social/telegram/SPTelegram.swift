// The MIT License (MIT)
// Copyright © 2017 Ivan Vorobei (hello@ivanvorobei.by)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class SPTelegram {
    
    static var isSetApp: Bool {
        if UIApplication.shared.canOpenURL(URL(string: "tg://msg?text=test")!) {
            return true
        } else {
            return false
        }
    }
    
    static func share(text: String, complection: @escaping (_ isOpened: Bool)->() = {_ in }) {
        let urlStringEncoded = text.addingPercentEncoding( withAllowedCharacters: .urlHostAllowed)
        let urlOptional = URL(string: "tg://msg?text=\(urlStringEncoded ?? "")")
        if let url = urlOptional {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: complection)
            } else {
                complection(false)
            }
        } else {
            complection(false)
        }
    }
    
    static func joinChannel(id: String) {
        let url = "https://t.me/joinchat/\(id)"
        SPOpener.Link.redirectToBrowserAndOpen(link: url)
    }
    
    static func openBot(username: String) {
        var username = username
        if username.first == "@" {
            username.removeFirst()
        }
        let url = "https://telegram.me/\(username)"
        SPOpener.Link.redirectToBrowserAndOpen(link: url)
    }
    
    private init() {}
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
