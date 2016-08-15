//
//  ADPStudentTableViewCell.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 15/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ADPStudentTableViewCell: UITableViewCell {

    @IBOutlet weak var studentName: UILabel!
    @IBOutlet weak var mediaURL: UILabel!
    @IBOutlet weak var createdDate: UILabel!
    @IBOutlet weak var updatedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
