import AppKit
import ServiceManagement

class MenuBarManager: NSObject {
    private var statusItem: NSStatusItem!
    private var timer: DispatchSourceTimer?
    private let timerQueue = DispatchQueue(label: "com.argos.timer", qos: .background)

    private var isActive: Bool = false {
        didSet {
            UserDefaults.standard.set(isActive, forKey: "isActive")
            updateIcon()
            updateMenu()
            if isActive { startTimer() } else { stopTimer() }
        }
    }

    private var interval: TimeInterval {
        get { UserDefaults.standard.double(forKey: "interval").nonZero ?? 10 }
        set { UserDefaults.standard.set(newValue, forKey: "interval") }
    }

    private var teamsCompatMode: Bool {
        get { UserDefaults.standard.bool(forKey: "teamsCompatMode") }
        set { UserDefaults.standard.set(newValue, forKey: "teamsCompatMode") }
    }

    override init() {
        super.init()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        isActive = UserDefaults.standard.bool(forKey: "isActive")
        updateIcon()
        updateMenu()
    }

    private func updateIcon() {
        guard let button = statusItem.button else { return }
        DispatchQueue.main.async {
            let symbolName = self.isActive ? "eye.fill" : "eye.slash"
            let config = NSImage.SymbolConfiguration(pointSize: 16, weight: .regular)
            button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)?
                .withSymbolConfiguration(config)
            button.image?.isTemplate = !self.isActive
            if self.isActive {
                button.contentTintColor = NSColor.systemGreen
            } else {
                button.contentTintColor = nil
            }
        }
    }

    private func updateMenu() {
        DispatchQueue.main.async {
            let menu = NSMenu()

            let statusTitle = self.isActive ? "Active — click to pause" : "Inactive — click to start"
            let statusItem = NSMenuItem(title: statusTitle, action: nil, keyEquivalent: "")
            statusItem.isEnabled = false
            menu.addItem(statusItem)

            menu.addItem(NSMenuItem.separator())

            let toggleTitle = self.isActive ? "Stop" : "Start"
            menu.addItem(NSMenuItem(title: toggleTitle, action: #selector(self.toggle), keyEquivalent: "t").then {
                $0.target = self
            })

            menu.addItem(NSMenuItem.separator())

            let intervalMenu = NSMenu()
            for seconds in [5.0, 10.0, 15.0, 30.0, 60.0] {
                let item = NSMenuItem(
                    title: seconds == 60 ? "60 seconds (1 min)" : "\(Int(seconds)) seconds",
                    action: #selector(self.setInterval(_:)),
                    keyEquivalent: ""
                )
                item.target = self
                item.tag = Int(seconds)
                item.state = self.interval == seconds ? .on : .off
                intervalMenu.addItem(item)
            }
            let intervalItem = NSMenuItem(title: "Interval", action: nil, keyEquivalent: "")
            intervalItem.submenu = intervalMenu
            menu.addItem(intervalItem)

            menu.addItem(NSMenuItem.separator())

            let teamsItem = NSMenuItem(
                title: "Teams Compatibility Mode",
                action: #selector(self.toggleTeamsCompat),
                keyEquivalent: ""
            )
            teamsItem.target = self
            teamsItem.state = self.teamsCompatMode ? .on : .off
            menu.addItem(teamsItem)

            menu.addItem(NSMenuItem.separator())

            let launchAtLoginItem = NSMenuItem(
                title: "Launch at Login",
                action: #selector(self.toggleLaunchAtLogin),
                keyEquivalent: ""
            )
            launchAtLoginItem.target = self
            launchAtLoginItem.state = self.isLaunchAtLoginEnabled ? .on : .off
            menu.addItem(launchAtLoginItem)

            menu.addItem(NSMenuItem.separator())

            menu.addItem(NSMenuItem(title: "Quit Argos", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))

            self.statusItem.menu = menu
        }
    }

    @objc private func toggle() {
        isActive.toggle()
    }

    @objc private func toggleTeamsCompat() {
        teamsCompatMode.toggle()
        updateMenu()
    }

    @objc private func setInterval(_ sender: NSMenuItem) {
        interval = TimeInterval(sender.tag)
        if isActive {
            stopTimer()
            startTimer()
        }
        updateMenu()
    }

    private var isLaunchAtLoginEnabled: Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }

    @objc private func toggleLaunchAtLogin() {
        if #available(macOS 13.0, *) {
            do {
                if isLaunchAtLoginEnabled {
                    try SMAppService.mainApp.unregister()
                } else {
                    try SMAppService.mainApp.register()
                }
                updateMenu()
            } catch {
                NSLog("Argos: Launch at login error: \(error)")
            }
        }
    }

    private func startTimer() {
        let t = DispatchSource.makeTimerSource(queue: timerQueue)
        t.schedule(deadline: .now() + interval, repeating: interval)
        t.setEventHandler { [weak self] in self?.nudgeCursor() }
        t.resume()
        timer = t
    }

    private func stopTimer() {
        timer?.cancel()
        timer = nil
    }

    private func nudgeCursor() {
        guard let currentEvent = CGEvent(source: nil) else { return }
        let origin = currentEvent.location

        let moved = CGPoint(x: origin.x + 1, y: origin.y + 1)
        let moveEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved,
                                mouseCursorPosition: moved, mouseButton: .left)
        moveEvent?.post(tap: .cghidEventTap)

        Thread.sleep(forTimeInterval: 0.1)

        let returnEvent = CGEvent(mouseEventSource: nil, mouseType: .mouseMoved,
                                  mouseCursorPosition: origin, mouseButton: .left)
        returnEvent?.post(tap: .cghidEventTap)

        if teamsCompatMode {
            postShiftKey()
        }
    }

    private func postShiftKey() {
        let src = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: true)
        let keyUp   = CGEvent(keyboardEventSource: src, virtualKey: 0x38, keyDown: false)
        keyDown?.post(tap: .cghidEventTap)
        Thread.sleep(forTimeInterval: 0.05)
        keyUp?.post(tap: .cghidEventTap)
    }
}

private extension NSMenuItem {
    func then(_ configure: (NSMenuItem) -> Void) -> NSMenuItem {
        configure(self)
        return self
    }
}

private extension Double {
    var nonZero: Double? { self == 0 ? nil : self }
}
