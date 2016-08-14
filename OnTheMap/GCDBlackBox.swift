//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 14/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(updates: () -> Void) {
    dispatch_async(dispatch_get_main_queue()) {
        updates()
    }
}