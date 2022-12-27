//
//  LineChartViewFormatter.swift
//  MC02-Group9
//
//  Created by Christophorus Davin on 14/12/22.
//

import Foundation
import Charts

class xAxisFormatter : AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {

        switch value {
        case 0:
            return "00"
        case 360:
            return "06"
        case 720:
            return "12"
        case 1080:
            return "18"
        case 1440:
            return "23"
        default:
            return "00"
        }
    }
}
