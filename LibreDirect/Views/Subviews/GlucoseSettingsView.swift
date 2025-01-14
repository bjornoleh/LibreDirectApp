//
//  GlucoseSettingsView.swift
//  LibreDirect
//

import SwiftUI

// MARK: - GlucoseSettingsView

struct GlucoseSettingsView: View {
    @EnvironmentObject var store: AppStore

    var body: some View {
        Section(
            content: {
                ToggleView(key: LocalizedString("Glucose Unit", comment: ""), value: store.state.glucoseUnit.asBool, trueValue: true.asGlucoseUnit.description, falseValue: false.asGlucoseUnit.description) { value -> Void in
                    store.dispatch(.setGlucoseUnit(unit: value.asGlucoseUnit))
                }
                
                NumberSelectorView(key: LocalizedString("Lower Limit", comment: ""), value: store.state.alarmLow, step: 5, displayValue: store.state.alarmLow.asGlucose(unit: store.state.glucoseUnit, withUnit: true)) { value -> Void in
                    store.dispatch(.setAlarmLow(lowerLimit: value))
                }
                
                NumberSelectorView(key: LocalizedString("Upper Limit", comment: ""), value: store.state.alarmHigh, step: 5, displayValue: store.state.alarmHigh.asGlucose(unit: store.state.glucoseUnit, withUnit: true)) { value -> Void in
                    store.dispatch(.setAlarmHigh(upperLimit: value))
                }
            },
            header: {
                Label("Glucose Settings", systemImage: "cross.case")
            }
        )
    }
}

private extension Bool {
    var asGlucoseUnit: GlucoseUnit {
        if self == GlucoseUnit.mgdL.asBool {
            return GlucoseUnit.mgdL
        }

        return GlucoseUnit.mmolL
    }
}

private extension GlucoseUnit {
    var asBool: Bool {
        return self == .mmolL
    }
}
