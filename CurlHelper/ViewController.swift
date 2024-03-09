//
//  ViewController.swift
//  CurlHelper
//
//  Created by Marko2155 on 8.3.24.
//

import Cocoa
import Foundation

func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()
    
    task.standardOutput = pipe
    task.standardError = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/zsh"
    task.standardInput = nil
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return output
}

func showSavePanel() -> URL? {
    let savePanel = NSSavePanel()
    savePanel.canCreateDirectories = true
    savePanel.isExtensionHidden = false
    
    let response = savePanel.runModal()
    return response == .OK ? savePanel.url : nil
}
            


func showMessage(title: String, message: String, style: NSAlert.Style) {
    let alert = NSAlert()
    alert.messageText = title
    alert.informativeText = message
    alert.alertStyle = style
    alert.addButton(withTitle: "OK")
    alert.runModal()
}



class ViewController: NSViewController {

    @IBOutlet weak var urlTextField: NSTextField!
    @IBOutlet weak var jsonCheckBox: NSButton!
    @IBOutlet weak var jsonTextField: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var requestTypeTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var saveCheckBox: NSButton!
    @IBOutlet weak var consoleTextField: NSTextView!
    
    var saveNeeded = false
    var savePath = ""
    var jsonNeeded = false
    var command = "curl --header \"Content-Type: application/json\" --request "
    override func viewDidLoad() {
        super.viewDidLoad()
        requestTypeTextField.stringValue = "GET"
        urlTextField.stringValue = "https://www.example.com"
        consoleTextField.string = "[INFO] This is the CurlGUI console."
        jsonTextField.isEnabled = false
        saveButton.isEnabled = false
        jsonTextField.stringValue = "{ }"
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func clearConsoleButtonClicked(_ sender: Any) {
        consoleTextField.string = ""
    }
    
    @IBAction func saveCheckBoxCliked(_ sender: Any) {
        if (saveCheckBox.state == NSControl.StateValue.on) {
            saveNeeded = true
            saveButton.isEnabled = true
            savePath = "/Users/" + NSUserName() + "/Desktop/output.txt"
            consoleTextField.string = consoleTextField.string + "\n[INFO] Saving cURL output to file: " + savePath
        } else {
            saveNeeded = false
            saveButton.isEnabled = false
            consoleTextField.string = consoleTextField.string + "\n[INFO] Saving cURL output to file canceled"
        }
    }
    
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        let res = showSavePanel()
        let path = res?.path()
        savePath = path ?? "/Users/" + NSUserName() + "/Desktop/output.txt"
        consoleTextField.string = consoleTextField.string + "\n[INFO] Saving cURL output to file: " + savePath
    }
    
    @IBAction func jsonCheckBoxClicked(_ sender: Any) {
        if (jsonCheckBox.state == NSControl.StateValue.on) {
            jsonNeeded = true
            jsonTextField.isEnabled = true
        } else {
            jsonNeeded = false
            jsonTextField.isEnabled = false
        }
    }
    
    
    
    
    @IBAction func startClicked(_ sender: Any) {
        if (urlTextField.stringValue == "") {
            showMessage(title: "Error", message: "Please do not leave the URL empty", style: NSAlert.Style.critical)
        } else {
            switch (requestTypeTextField.stringValue) {
            
            case "POST":
                command = command + "POST"
                break
            case "GET":
                command = command + "GET"
                break
            case "HEAD":
                command = command + "HEAD"
                break
            case "PUT":
                command = command + "PUT"
                break
            case "DELETE":
                command = command + "DELETE"
                break
            case "CONNECT":
                command = command + "CONNECT"
                break
            case "OPTIONS":
                command = command + "OPTIONS"
                break
            case "TRACE":
                command = command + "TRACE"
                break
            case "PATCH":
                command = command + "PATCH"
                break
            default:
                command = command + "GET"
                break
            }
            if (jsonNeeded == true) {
                command = command + " --data \"" + jsonTextField.stringValue + "\" "
            }
            if (saveNeeded == true) {
                command = command + " -o " + savePath
            }
            _ = NSUserName()
            command = command + " " + urlTextField.stringValue
            let out1 = shell(command)
            consoleTextField.string = out1
            if (saveNeeded == true) {
                _ = shell("open -a /System/Applications/TextEdit.app " + savePath)
            }
            command = "curl --header \"Content-Type: application/json\" --request "
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

