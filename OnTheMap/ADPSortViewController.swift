//
//  ADPSortViewController.swift
//  OnTheMap
//
//  Created by Pritam Hinger on 16/08/16.
//  Copyright © 2016 AppDevelapp. All rights reserved.
//

import UIKit

class ADPSortViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - IBOutlets
    @IBOutlet weak var recordCountStepper: UIStepper!
    @IBOutlet weak var recordCountLabel: UILabel!
    @IBOutlet weak var sortDirectionSegment: UISegmentedControl!
    @IBOutlet weak var sortableColumnPickerView: UIPickerView!
    
    // MARK: - Private Properties
    private let sortableColumns = [
        ParseClient.ColumnDisplayName.CreatedTime,
                                   ParseClient.ColumnDisplayName.FirstName,
                                   ParseClient.ColumnDisplayName.LastName,
                                   ParseClient.ColumnDisplayName.Latitude,
                                   ParseClient.ColumnDisplayName.Longitude,
                                   ParseClient.ColumnDisplayName.UniqueKey,
                                   ParseClient.ColumnDisplayName.UpdatedTime]
    
    private let columnDisplayNameToNameMapping  = [ ParseClient.ColumnDisplayName.CreatedTime:"createdAt",
                                                    ParseClient.ColumnDisplayName.FirstName:"firstName",
                                                    ParseClient.ColumnDisplayName.LastName:"lastName",
                                                    ParseClient.ColumnDisplayName.Latitude:"latitude",
                                                    ParseClient.ColumnDisplayName.Longitude:"longitude",
                                                    ParseClient.ColumnDisplayName.UniqueKey:"uniqueKey",
                                                    ParseClient.ColumnDisplayName.UpdatedTime:"updatedAt"]
    
    //private
    var sortParameter:SortParameter?
    
    // MARK: - Controller Life Cycle Events
    override func viewDidLoad() {
        super.viewDidLoad()
        sortableColumnPickerView.dataSource = self
        sortableColumnPickerView.delegate = self
        recordCountLabel.text = "\(recordCountStepper.value)"
        sortParameter = (UIApplication.sharedApplication().delegate as! AppDelegate).sortParameter
        
        configureUI(sortParameter!);
        
    }
    
    // MARK: - IBActions
    @IBAction func recordCountValueChanged(sender: AnyObject) {
        recordCountLabel.text = "\(Int((sender as! UIStepper).value))"
        UpdateSortParameter()
    }

    
    @IBAction func initiateGetRequest(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName(ParseClient.NotificationName.SortParameterChangeNotification, object: nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func sortDirectionChanged(sender: UISegmentedControl) {
        let sortDirection = sender.titleForSegmentAtIndex(sender.selectedSegmentIndex)
        
        print("Sorting Direction is : \(sortDirection)")
        UpdateSortParameter()
    }

    // MARK: - UIPickerView Datasource and Delegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortableColumns.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortableColumns[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UpdateSortParameter()
    }
    
    func UpdateSortParameter() -> Void {
        sortParameter?.pageSize = Int(recordCountStepper.value)
        switch sortDirectionSegment.selectedSegmentIndex {
        case 0:
            sortParameter?.sortDirection = SortDirection.Ascending
        default:
            sortParameter?.sortDirection = SortDirection.Descending
        }
        
        sortParameter?.sortByColumn = columnDisplayNameToNameMapping[sortableColumns[sortableColumnPickerView.selectedRowInComponent(0)]]!
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).sortParameter = sortParameter!
    }
    
    func configureUI(sortParameter:SortParameter) -> Void {
        recordCountStepper.value = Double(sortParameter.pageSize)
        recordCountLabel.text = "\(sortParameter.pageSize)"
        switch sortParameter.sortDirection {
        case .Ascending:
            sortDirectionSegment.selectedSegmentIndex = 0
        default:
            sortDirectionSegment.selectedSegmentIndex = 1
        }
        
        let keys = (columnDisplayNameToNameMapping as NSDictionary).allKeysForObject(sortParameter.sortByColumn) as! [String]
        let index = sortableColumns.indexOf(keys.first!)
        sortableColumnPickerView.selectRow(index!, inComponent: 0, animated: true)
    }
}
