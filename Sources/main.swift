import AppKit
import Darwin

// MARK: - Memory reading

func memoryUsagePercent() -> Int {
    var stats = vm_statistics64()
    var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.stride / MemoryLayout<integer_t>.stride)
    let host = mach_host_self()

    let result = withUnsafeMutablePointer(to: &stats) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
            host_statistics64(host, HOST_VM_INFO64, $0, &count)
        }
    }

    guard result == KERN_SUCCESS else { return 0 }

    let pageSize = UInt64(vm_kernel_page_size)
    let active   = UInt64(stats.active_count) * pageSize
    let wired    = UInt64(stats.wire_count) * pageSize
    let compressed = UInt64(stats.compressor_page_count) * pageSize

    let used = active + wired + compressed

    let totalMemory = ProcessInfo.processInfo.physicalMemory

    return Int((Double(used) / Double(totalMemory)) * 100)
}

// MARK: - App

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem!
    var timer: Timer?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        updateTitle()

        // Update every 3 seconds
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateTitle()
        }

        // Build menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit MemBar", action: #selector(quit), keyEquivalent: "q"))
        statusItem.menu = menu
    }

    func updateTitle() {
        let pct = memoryUsagePercent()
        statusItem.button?.title = "\(pct)%"
    }

    @objc func quit() {
        NSApp.terminate(nil)
    }
}

// Run as menu-bar-only app (no dock icon)
let app = NSApplication.shared
app.setActivationPolicy(.accessory)

let delegate = AppDelegate()
app.delegate = delegate
app.run()
