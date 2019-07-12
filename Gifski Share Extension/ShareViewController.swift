//
//  ShareViewController.swift
//  Gifski Share Extension
//
//  Created by Serhii Londar on 7/1/19.
//  Copyright © 2019 Sindre Sorhus. All rights reserved.
//

import Cocoa

class ShareViewController: NSViewController {
	var shareURL: URL?
	var mainWindowController = MainWindowController()
    override var nibName: NSNib.Name? {
        return NSNib.Name("ShareViewController")
    }
    override func loadView() {
        let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
		if let itemProvider = item.attachments?.first {
			if itemProvider.hasItemConformingToTypeIdentifier("public.url") {
				itemProvider.loadItem(forTypeIdentifier: "public.url", options: nil) { (url, error) in
					if let shareURL = url as? URL {
						DispatchQueue.main.async {
							self.mainWindowController.showWindow(self)
							self.mainWindowController.convert(shareURL)
						}
					}
				}
			}
		} else {
            NSLog("No Attachments")
        }
    }
    @IBAction func send(_ sender: AnyObject?) {
        // Complete implementation by setting the appropriate value on the output item
		let item = self.extensionContext!.inputItems[0] as! NSExtensionItem
		let outputItems = [item]
        self.extensionContext!.completeRequest(returningItems: outputItems, completionHandler: nil)
}

    @IBAction func cancel(_ sender: AnyObject?) {
        let cancelError = NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError, userInfo: nil)
        self.extensionContext!.cancelRequest(withError: cancelError)
    }
}
