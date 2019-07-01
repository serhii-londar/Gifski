import Cocoa
import AVFoundation
import Crashlytics

final class MainWindowController: NSWindowController {
	var isConverting: Bool {
		return window?.contentViewController is ConversionViewController
	}

	convenience init() {
		let window = NSWindow.centeredWindow(size: .zero)
		window.contentViewController = VideoDropViewController()
		window.centerNatural()
		self.init(window: window)

		with(window) {
			$0.delegate = self
			$0.titleVisibility = .hidden
			$0.styleMask = [
				.titled,
				.closable,
				.miniaturizable,
				.fullSizeContentView
			]
			$0.tabbingMode = .disallowed
			$0.collectionBehavior = .fullScreenNone
			$0.titlebarAppearsTransparent = true
			$0.isMovableByWindowBackground = true
			$0.isRestorable = false
			$0.makeVibrant()
		}

		window.makeKeyAndOrderFront(nil)
		NSApp.activate(ignoringOtherApps: false)

		DockProgress.style = .circle(radius: 55, color: .themeColor)
	}

	@objc
	func open(_ sender: AnyObject) {
		let panel = NSOpenPanel()
		panel.canChooseDirectories = false
		panel.canCreateDirectories = false
		panel.allowedFileTypes = System.supportedVideoTypes

		panel.beginSheetModal(for: window!) {
			if $0 == .OK {
				self.convert(panel.url!)
			}
		}
	}

	func convert(_ inputUrl: URL) {
		guard !isConverting else {
			return
		}

		if let videoDropController = window?.contentViewController as? VideoDropViewController {
			videoDropController.convert(inputUrl)
		} else {
			let videoDropController = VideoDropViewController()
			window?.contentViewController?.push(viewController: videoDropController) {
				videoDropController.convert(inputUrl)
			}
		}
	}
}

extension MainWindowController: NSMenuItemValidation {
	func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
		switch menuItem.action {
		case #selector(open)?:
			return !isConverting
		default:
			return true
		}
	}
}
