//
//  ViewController.swift
//  MIMOTI
//
//  Created by Adrian Wyss on 25/02/16.
//  Copyright © 2016 MIMOTI Team. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON

class ChartsViewController: UIViewController, ChartViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var weightLineChart: LineChartView!
    @IBOutlet weak var subjectiveConditionLineChart: LineChartView!
    @IBOutlet weak var stepsLineChart: LineChartView!
    @IBOutlet weak var totalStepsLabel: UILabel!
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        
        weightLineChart.clear()
        subjectiveConditionLineChart.clear()
        stepsLineChart.clear()
        totalStepsLabel.text = ""
        
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // load weightData from Midata in weightChart
        
        loadWeightData({ (weightArray) -> Void in
            
            var datesWeight : [Double] = []
            var valuesWeight : [Double] = []
            var displayableWeightArray : [WeightRecord] = weightArray
            
            
            // sort the json array
            displayableWeightArray.sort(by: {$0.effectiveDateTime < $1.effectiveDateTime})
            
            // fill local arrays
            for weightRecord in displayableWeightArray{
                
                if(weightRecord.weightValue != 0){
                
                    datesWeight.append(self.convertString(weightRecord.effectiveDateTime))
                    valuesWeight.append(weightRecord.weightValue)
                }
                
            }
    
            // prepare the weightLineChart
            
            self.weightLineChart.delegate = self
            self.weightLineChart.drawGridBackgroundEnabled = true
            self.weightLineChart.gridBackgroundColor = UIColor(red: 176/255, green: 203/255, blue: 77/255, alpha: 1.0)
            self.weightLineChart.leftAxis.drawAxisLineEnabled = false
            self.weightLineChart.leftAxis.drawGridLinesEnabled = false
            self.weightLineChart.descriptionText = ""
            self.weightLineChart.leftAxis.maxWidth = 50
            self.weightLineChart.rightAxis.maxWidth = 50
            self.weightLineChart.leftAxis.minWidth = 50
            self.weightLineChart.rightAxis.minWidth = 50
            
            
            
            
            self.weightLineChart.leftAxis.axisMinimum = 0
            self.weightLineChart.rightAxis.axisMinimum = 0
            
            
    
            // display weightLineChart
            self.setChart(self.weightLineChart, label: "",dataPoints: datesWeight, values: valuesWeight, graphType: "WEIGHT")
            
        })
        
        
        
      // load subjectiveCondition data from Midata in subjective condition chart
        
        loadSubjectiveConditionData({ (subjectiveConditionArray) -> Void in
            
            var datesSubjectiveCondition : [Double] = []
            var valuesSubjectiveCondition : [Double] = []
            var displayableSCArray : [SubjectiveCondition] = subjectiveConditionArray
            
            
            // sort the json array
            displayableSCArray.sort(by: {$0.effectiveDateTime < $1.effectiveDateTime})
            
            // fill local arrays
            for subjectiveCondition in displayableSCArray{
                
                if(subjectiveCondition.value != 0){
                    
                    datesSubjectiveCondition.append(self.convertString(subjectiveCondition.effectiveDateTime))
                    valuesSubjectiveCondition.append(subjectiveCondition.value)
                }
            }
            
             // prepare the subjectiveCondition lineChart
            
            self.subjectiveConditionLineChart.delegate = self
            self.subjectiveConditionLineChart.drawGridBackgroundEnabled = true
            self.subjectiveConditionLineChart.gridBackgroundColor = UIColor(red: 243/255, green: 184/255, blue: 129/255, alpha: 1.0)
            self.subjectiveConditionLineChart.leftAxis.drawAxisLineEnabled = false
            self.subjectiveConditionLineChart.leftAxis.drawGridLinesEnabled = false
            self.subjectiveConditionLineChart.descriptionText = ""
            self.subjectiveConditionLineChart.leftAxis.minWidth = 50
            self.subjectiveConditionLineChart.rightAxis.minWidth = 50
            self.subjectiveConditionLineChart.leftAxis.maxWidth = 50
            self.subjectiveConditionLineChart.rightAxis.maxWidth = 50
            
            
            self.subjectiveConditionLineChart.leftAxis.axisMaximum = 3.5
            self.subjectiveConditionLineChart.leftAxis.axisMinimum = 0.5
            self.subjectiveConditionLineChart.rightAxis.axisMaximum = 3.5
            self.subjectiveConditionLineChart.rightAxis.axisMinimum = 0.5
            
            
            self.subjectiveConditionLineChart.leftAxis.labelTextColor = UIColor.white
            
            
            
            
            // display subjectiveCondition lineChart
            self.setChart(self.subjectiveConditionLineChart, label: "",dataPoints: datesSubjectiveCondition, values: valuesSubjectiveCondition, graphType: "SUBJECTIVECONDITION")
            
        })

      
        
        
        
        // load steps Data from Midata in steps lineChart
        
        loadStepsData({ (stepsArray) -> Void in
            
            var datesSteps : [Double] = []
            var valuesSteps : [Double] = []
            var displayableStepsArray : [StepsRecord] = stepsArray
            var stepAmount : Double
            
            // sort the json array
            displayableStepsArray.sort(by: {$0.effectiveDateTime < $1.effectiveDateTime})
            
            
            // total steps
            var totalStepsTaken = 0
            
            // fill local arrays
            for stepRecord in displayableStepsArray{
                
                stepAmount = Double(stepRecord.stepsValue)!
                    
                    datesSteps.append(self.convertFitBitDateString(stepRecord.effectiveDateTime))
                    valuesSteps.append(stepAmount)
                    
                    // aggregate total steps taken
                    totalStepsTaken += Int(stepAmount)
                    
                
                
            }
            
            
            // get the main thread since the background  might trigger UI updates
            DispatchQueue.main.async(execute: {
                
                
            // format for int value in totalStepsAmount
                
                let intFormatter = NumberFormatter()
                intFormatter.numberStyle = .decimal
                intFormatter.locale = Locale(identifier: "gsw_CH")
                
                self.totalStepsLabel.text = intFormatter.string(from: NSNumber(value: totalStepsTaken))! + ")"
            })
            
            // prepare stepsLineChart
            
            self.stepsLineChart.delegate = self
            self.stepsLineChart.drawGridBackgroundEnabled = true
            self.stepsLineChart.gridBackgroundColor = UIColor(red: 79/255, green: 147/255, blue: 193/255, alpha: 1.0)
            self.stepsLineChart.leftAxis.drawAxisLineEnabled = true
            self.stepsLineChart.leftAxis.drawGridLinesEnabled = true
            self.stepsLineChart.descriptionText = ""
            self.stepsLineChart.leftAxis.maxWidth = 50
            self.stepsLineChart.rightAxis.maxWidth = 50
            self.stepsLineChart.leftAxis.minWidth = 50
            self.stepsLineChart.rightAxis.minWidth = 50
            
            
            self.stepsLineChart.leftAxis.axisMinimum = 0
            self.stepsLineChart.rightAxis.axisMinimum = 0
            
            // display stepsLineChart
             self.setChart(self.stepsLineChart, label: "",dataPoints: datesSteps, values: valuesSteps, graphType: "STEPS")
            
        })
    }
    
    
    
    func loadWeightData(_ onCompletion: @escaping (_ weightArray: [WeightRecord]) -> Void) {
        
            var weightRecords: [WeightRecord] = []
        
            // get & update records in tableview everytime the user loads the view
            RestManager.sharedInstance.getRecords("preliminary") { (json, flag) -> Void in
                
                
                // check for error flag
                
                if (flag){
                    
                    // get the main thread since the background  might trigger UI updates
                    DispatchQueue.main.async(execute: {
                        
                        
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        
                        let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                        
                        UIApplication.shared.keyWindow!.rootViewController = loginViewController
                        
                        UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                        
                    })
                }
                else {
                    
                    // serialize json from api call
                    
                    for (key, subJson) in json {
                        
                        // only consider records with status 'preliminary'
                        if(subJson["data"]["status"] == "preliminary"){
                            
                            // create and append weight object if record type weight
                            if(subJson["data"]["code"]["coding"][0]["code"] == "3141-9"){
                                
                                
                                weightRecords.append(WeightRecord(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, weightValue: subJson["data"]["valueQuantity"]["value"].double!))
                                
                                }
                        }
                    }
                }
                
               
                
                // onCompletion return weightRecords array
                
                onCompletion(weightRecords)
                
            } // block finished
    }
    
    
    
    
    func loadStepsData(_ onCompletion: @escaping (_ stepsArray: [StepsRecord]) -> Void) {
        
        var stepsRecords: [StepsRecord] = []
        
        // get & update records in tableview everytime the user loads the view
        RestManager.sharedInstance.getRecordsWithFilter("preliminary", filter: "2016-04-01") { (json, flag) -> Void in
            
            // check for error flag
            
            if (flag){
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {
                    
                    
                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    UIApplication.shared.keyWindow!.rootViewController = loginViewController
                    
                    UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                    
                })
            }
            else {
                
                // serialize json from api call
                
                for (key, subJson) in json {
                    
                    // only consider records with status 'preliminary'
                    if(subJson["data"]["status"] == "preliminary"){
                        
                        // create and append weight object if record type weight
                        if(subJson["data"]["code"]["coding"][0]["code"] == "activities/steps"){
                            
                            stepsRecords.append(StepsRecord(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, stepsValue: subJson["data"]["valueQuantity"]["value"].string!))
                        }
                    }
                }
            }
            
            // onCompletion return stepsRecords array
            
            onCompletion(stepsRecords)
            
        } // block finished
    }
    
    
    
    
    // Helper function. Sets a LineChartView
    
    func setChart(_ chart : LineChartView, label : String, dataPoints: [Double], values: [Double], graphType : String) {
        
        
        if dataPoints.count > 0 {
        
        
        var dataEntries: [ChartDataEntry] = []
        
        // set dataPoints for chartView
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: dataPoints[i], y: values[i])
            dataEntries.append(dataEntry)
        }
        
        // define lineChartDataSet
        
        let chartDataSet = LineChartDataSet(values: dataEntries, label: "\(label)")
        
        // define chart style
        
        chartDataSet.setCircleColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha : 1.0)) //
        chartDataSet.fillColor = (UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha : 1.0)) //
        chartDataSet.setColor(UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha : 1.0)) //
        
        chartDataSet.lineWidth = 2.0
        chartDataSet.circleRadius = 3.0 // the radius of the node circle

        // define chart data
        
        
        var lineChartDataSets = [IChartDataSet]()
        lineChartDataSets.append(chartDataSet)
        let chartData = LineChartData(dataSets: lineChartDataSets)
        
            
        
        // define chart style
        
        chartData.setValueTextColor(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)) // black text
        
        
            
            
            // left Axis format
            chart.leftAxis.valueFormatter = DefaultAxisValueFormatter()
            
            
            // date formatter for x values
            
            let dayNumberAndShortNameFormatter = DateFormatter()
            dayNumberAndShortNameFormatter.dateFormat = "dd.MM.yy"
            
            
            let xValuesNumberFormatter = ChartXAxisFormatter()
            xValuesNumberFormatter.dateFormatter = dayNumberAndShortNameFormatter
            
            
            chart.xAxis.valueFormatter = xValuesNumberFormatter
            chart.xAxis.drawLabelsEnabled = true
            chart.xAxis.labelPosition = .bottom
            chart.xAxis.labelTextColor = UIColor.black
            
            chart.data = chartData
            chart.xAxis.avoidFirstLastClippingEnabled = false
            chart.xAxis.setLabelCount(5, force: true)
            
        
        if(graphType == "WEIGHT"){
            
            chart.leftAxis.axisMaximum = (chart.data?.yMax)! + 50
            chart.rightAxis.axisMaximum = (chart.data?.yMax)! + 50
            
        } else if (graphType == "SUBJECTIVECONDITION"){
            
            chartDataSet.drawValuesEnabled = false
            
        } else if(graphType == "STEPS"){
            
            chart.leftAxis.axisMaximum = (chart.data?.yMax)! + 5000
            chart.rightAxis.axisMaximum = (chart.data?.yMax)! + 5000
            
            
        }
        
            
        // define chart style
        
        chart.doubleTapToZoomEnabled = false
        chart.pinchZoomEnabled = true
        chart.scaleXEnabled = true
        chart.scaleYEnabled = false
        chart.leftAxis.drawAxisLineEnabled = false
        chart.leftAxis.drawGridLinesEnabled = false
        chart.rightAxis.labelTextColor = UIColor.white
        
        
        // update charts appearance on the main thread
        DispatchQueue.main.async(execute: {
            
            // update views in order to display data correctly

            
            chart.setNeedsDisplay()
            self.view.setNeedsDisplay()
            
        })
        
        }
        
    }
    
    // Helper function. Convert timestamps to user friendly dates for display
    
    fileprivate func convertString(_ stringToSplit : String) -> Double {
        
        
        let strSplit = stringToSplit.characters.split(separator: "T")
        
        
        
        let sub1 = String(strSplit[0])
        let sub2 = String(strSplit[1])
        
        let myDate = "\(sub1) \(sub2)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = dateFormatter.date(from: myDate)
        
        return date!.timeIntervalSince1970
        
    }
    
    
    // Helper function. Convert timestamps to user friendly dates for display
    
    fileprivate func convertFitBitDateString(_ stringToSplit : String) -> Double {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        
        let date = dateFormatter.date(from: stringToSplit)
        
        return date!.timeIntervalSince1970
        
    }


    func loadSubjectiveConditionData(_ onCompletion: @escaping (_ subjectiveConditionArray: [SubjectiveCondition]) -> Void) {
        
        var subjectiveConditionRecords: [SubjectiveCondition] = []
        
        // get & update records in tableview everytime the user loads the view
        RestManager.sharedInstance.getRecords("preliminary") { (json, flag) -> Void in
            
            // check for error flag
            
            if (flag){
                
                // get the main thread since the background  might trigger UI updates
                DispatchQueue.main.async(execute: {

                    let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let loginViewController: LoginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                    UIApplication.shared.keyWindow!.rootViewController = loginViewController
                    
                    UIApplication.shared.keyWindow!.window?.makeKeyAndVisible()
                    
                })
            }
            else {
                
            // serialize json from api call
            
            for (_, subJson) in json {
                
                // only consider records with status 'preliminary'
                if(subJson["data"]["status"] == "preliminary"){
                    
                    // create and append weight object if record type weight
                    if(subJson["data"]["code"]["coding"][0]["code"] == "subjective-condition"){
                        
                        subjectiveConditionRecords.append(SubjectiveCondition(oid: subJson["_id"].string!, version: subJson["version"].string!, effectiveDateTime: subJson["data"]["effectiveDateTime"].string!, value: subJson["data"]["valueQuantity"]["value"].double!))
                    
                        
                    }
                }
            }
            
             // onCompletion return subjectiveConditionRecords array
            
            onCompletion(subjectiveConditionRecords)
            
            } // block finished
        }

    }
}
  
