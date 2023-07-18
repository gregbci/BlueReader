//
//  ViewController.swift
//  BlueReader
//
//  Created by Greg Wilding on 2022-11-01.
//

import Cocoa
import IOBluetooth


class ViewController: NSViewController, IOBluetoothRFCOMMChannelDelegate
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // put the device mac address here, program will write to stdout
        self.device = IOBluetoothDevice(addressString: "E8:31:CD:A5:6A:96")
        self.channel = IOBluetoothRFCOMMChannel()
        
        if self.device.openRFCOMMChannelSync(&self.channel, withChannelID: 1, delegate: self) != kIOReturnSuccess
        {
            fatalError("failed to connect, is device on?")
        }
    }

    override var representedObject: Any?
    {
        didSet
        {
            // Update the view, if already loaded.
        }
    }

    
    // delegates
    func rfcommChannelOpenComplete(_ rfcommChannel: IOBluetoothRFCOMMChannel!, status error: IOReturn)
    {
        print("channel open")
    }
    
    func rfcommChannelClosed(_ rfcommChannel: IOBluetoothRFCOMMChannel!)
    {
        print("channel closed")
    }
    
    func rfcommChannelQueueSpaceAvailable(_ rfcommChannel: IOBluetoothRFCOMMChannel!)
    {
        print("queue space available")
    }

    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel!, data dataPointer: UnsafeMutableRawPointer!, length dataLength: Int)
    {
        // if device is writing to channel, we'll get data here
        let data = Data(bytes: dataPointer, count: dataLength)
        if let text = String(data: data, encoding: .utf8)
        {
            print(text, terminator: "")  // print adds a newline by default, T2S data has \r\n
        }
    }
    
    func rfcommChannelWriteComplete(_ rfcommChannel: IOBluetoothRFCOMMChannel!, refcon: UnsafeMutableRawPointer!, status error: IOReturn, bytesWritten length: Int)
    {
        print("wrote something")
    }

    
    var device: IOBluetoothDevice!
    var channel: IOBluetoothRFCOMMChannel!
}

