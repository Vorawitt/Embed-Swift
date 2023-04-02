//
//  MQTTController.swift
//  Emmed-App
//
//  Created by vorawit chenthulee on 2/4/2566 BE.
//

import Foundation
import UIKit
import MqttCocoaAsyncSocket
import CocoaMQTT

//class MQTTControllrt: CocoaMQTTDelegate {
//    func initMqtt() {
//        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
//        let mqtt = CocoaMQTT(clientID: clientID, host: "localhost", port: 1883)
//        mqtt.username = "test"
//        mqtt.password = "public"
//        mqtt.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
//        mqtt.keepAlive = 60
//        mqtt.delegate = self
//        mqtt.connect()
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didConnectAck ack: CocoaMQTT.CocoaMQTTConnAck) {
//        <#code#>
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didPublishMessage message: CocoaMQTT.CocoaMQTTMessage, id: UInt16) {
//        <#code#>
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didPublishAck id: UInt16) {
//        <#code#>
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didReceiveMessage message: CocoaMQTT.CocoaMQTTMessage, id: UInt16) {
//        <#code#>
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
//        <#code#>
//    }
//
//    func mqtt(_ mqtt: CocoaMQTT.CocoaMQTT, didUnsubscribeTopics topics: [String]) {
//        <#code#>
//    }
//
//    func mqttDidPing(_ mqtt: CocoaMQTT.CocoaMQTT) {
//        <#code#>
//    }
//
//    func mqttDidReceivePong(_ mqtt: CocoaMQTT.CocoaMQTT) {
//        <#code#>
//    }
//
//    func mqttDidDisconnect(_ mqtt: CocoaMQTT.CocoaMQTT, withError err: Error?) {
//        <#code#>
//    }
//}

