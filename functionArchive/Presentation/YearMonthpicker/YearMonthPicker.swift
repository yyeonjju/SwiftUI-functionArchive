//
//  YearMonthPicker.swift
//  functionArchive
//
//  Created by 하연주 on 2022/05/14.
//

import Foundation
import SwiftUI

struct PickerTextField: UIViewRepresentable {
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()
    
    public var placeholder: String
    @Binding public var dateString: String
    public var dateStringFormat : String
    public var suffix : String
    
    private var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateStringFormat
        return formatter
    }
    
    var date : Date? {
        get {
            let dateType = dateFormatter.date(from: dateString)
            return dateType
        }
    }
    
    func makeUIView(context: Context) -> UITextField {
        datePicker.date = date ?? Date()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)
        
        textField.placeholder = placeholder
        textField.inputView = datePicker
        //textField.borderStyle = .roundedRect
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        helper.onDateValueChanged = {
            self.dateString = dateFormatter.string(from: datePicker.date)
        }
        
        helper.onDoneButtonTapped = {
            if date == nil {
                self.dateString = dateFormatter.string(from: datePicker.date)
            }
            textField.resignFirstResponder()
        }
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = date {
            let formatter = DateFormatter()
            formatter.dateFormat = dateStringFormat
            uiView.text = "\(formatter.string(from: selectedDate)) \(suffix)"
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Helper {
        public var onDateValueChanged: (() -> Void)?
        public var onDoneButtonTapped: (() -> Void)?
        
        @objc func dateValueChanged() {
            onDateValueChanged?()
        }
        
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }
    
    class Coordinator {}
}

//🍑🍑🍑🍑🍑🍑🍑🍑🍑
struct CustomPicker: UIViewRepresentable {
    @Binding var dataArrays : [[String]]
    
    //makeCoordinator()
    func makeCoordinator() -> CustomPicker.Coordinator {
        return CustomPicker.Coordinator(self)
    }
    
    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPicker>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    //updateUIView(_:context:)
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<CustomPicker>) {
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPicker
        init(_ pickerView: CustomPicker) {
            self.parent = pickerView
        }
        
        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            //            return parent.dataArrays.count
            return 1
        }
        
        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays[component].count
        }
        
        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width/3
        }
        
        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 60
        }
        
        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: 60))
            
            let pickerLabel = UILabel(frame: view.bounds)
            
            pickerLabel.text = parent.dataArrays[component][row]
            
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0
            
            view.addSubview(pickerLabel)
            
            view.clipsToBounds = true
            view.layer.cornerRadius = view.bounds.height * 0.1
            view.layer.borderWidth = 0.5
            view.layer.borderColor = UIColor.black.cgColor
            
            return view
        }
    }
}

struct CustomYearMonthPicker: UIViewRepresentable {
    private let textField = UITextField()
    private let picker = UIPickerView(frame: .zero)
    private let helper = Helper()
    @State var dataArrays = [
        ["2000","2001","2002","2003","2004","2005","2006","2007","2008","2009"],
        ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    ]
    
    public var placeholder: String
    @Binding public var dateString: String
    public var suffix : String
    
    class Helper {
        //        public var onDateValueChanged: (() -> Void)?
        public var onDoneButtonTapped: (() -> Void)?
        
        //        @objc func dateValueChanged() {
        //            onDateValueChanged?()
        //        }
        
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }
    
    //makeCoordinator()
    func makeCoordinator() -> CustomYearMonthPicker.Coordinator {
        CustomYearMonthPicker.Coordinator(self)
    }
    
    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomYearMonthPicker>) -> UITextField {
        let defaultYearIndex = dataArrays[0].firstIndex(of: dateString.components(separatedBy: ".")[0])
        let defaultMonthIndex = dataArrays[1].firstIndex(of: dateString.components(separatedBy: ".")[1])
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.selectRow(defaultYearIndex ?? 0, inComponent: 0, animated: true)
        picker.selectRow(defaultMonthIndex ?? 0, inComponent: 1, animated: true)
        
        textField.text = dateString + " " + suffix
        textField.placeholder = placeholder
        textField.inputView = picker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        //        helper.onDateValueChanged = {
        //            print("")
        ////            self.dateString = dateFormatter.string(from: datePicker.date)
        //        }
        
        helper.onDoneButtonTapped = {
            //            if date == nil {
            //                self.dateString = dateFormatter.string(from: datePicker.date)
            //            }
            textField.resignFirstResponder()
        }
        
        return textField
        
    }
    
    //updateUIView(_:context:)
    func updateUIView(_ view: UITextField, context: UIViewRepresentableContext<CustomYearMonthPicker>) {
        //                if let selectedDate = dateString {
        //                    let formatter = DateFormatter()
        //                    formatter.dateFormat = dateStringFormat
        //                    uiView.text = "\(formatter.string(from: selectedDate)) \(suffix)"
        //                }
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomYearMonthPicker
        init(_ pickerView: CustomYearMonthPicker) {
            self.parent = pickerView
        }
        
        //Number Of Components:
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.dataArrays.count
        }
        
        //Number Of Rows In Component:
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays[component].count
        }
        
        //Width for component:
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width/3
        }
        
        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }
        
        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: 60))
            
            let pickerLabel = UILabel(frame: view.bounds)
            if(component == 0) {
                pickerLabel.text = parent.dataArrays[component][row] + "년"
            } else if (component == 1) {
                pickerLabel.text = parent.dataArrays[component][row] + "월"
                
            }
            //            pickerLabel.text = parent.dataArrays[component][row]
            
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0
            
            view.addSubview(pickerLabel)
            
            view.clipsToBounds = true
            //            view.layer.cornerRadius = view.bounds.height * 0.1
            //            view.layer.borderWidth = 0.5
            //            view.layer.borderColor = UIColor.black.cgColor
            
            return view
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            let year =  parent.dataArrays[0][pickerView.selectedRow(inComponent: 0)]
            let month = parent.dataArrays[1][pickerView.selectedRow(inComponent: 1)]
            parent.textField.text = year + "." + month + " " + parent.suffix
            parent.dateString = year + "." + month
        }
    }
}
//✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅✅

struct YearMonthPicker: View {
    @State private var zoomed = false
    
    @State private var dateFrom = "2003.02"
    @State private var dateTo = "2001.01"
    
    @State private var startDate = Date()
    @State private var showSheet = false
    
    private let data: [[String]] = [
        Array(0...10).map { "\($0)" },
        Array(20...40).map { "\($0)" },
        Array(100...200).map { "\($0)" }
    ]
    
    @State private var selections: [Int] = [5, 10, 50]
    
    @State private var selectedArray = [
        ["1", "2", "3", "4", "5"],
        ["Consider long text her: word1, word2, word3, word4, word5", "7", "8", "9", "10"],
        ["11", "12", "13", "14", "15"]
    ]
    @State private var yearMonthArray = [
        ["2000","2001","2002","2003","2004","2005","2006","2007","2008","2009"],
        ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    ];
    
    
    var body: some View {
        VStack{
            //✅✅✅
            HStack {
                
                PickerTextField(
                    placeholder:"입학년도",
                    dateString : Binding(
                        get: {dateFrom },
                        set: {dateFrom = $0}),
                    dateStringFormat : "yyyy.MM",
                    suffix: "입학"
                )
                    .padding()
                //                .onSubmit {
                //                    vm.validate()
                //                }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
                
                Text("~")
                
                PickerTextField(
                    placeholder:"졸업년도",
                    dateString : Binding(
                        get: {dateTo },
                        set: {dateTo = $0}),
                    dateStringFormat : "yyyy.MM",
                    suffix: "졸업"
                )
                    .padding()
                //                .onSubmit {
                //                    vm.validate()
                //                }
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .foregroundColor(.black)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(12)
            }
            .frame(height: 100)
            
            //🍑🍑🍑🍑🍑🍑🍑🍑🍑
            //                    CustomPicker(dataArrays: $selectedArray)
            //🍑🍑🍑🍑🍑🍑🍑🍑🍑
            CustomYearMonthPicker(
                placeholder:"입학년도",
                dateString : Binding(
                    get: {dateFrom },
                    set: {dateFrom = $0}),
                suffix: "입학"
            )
            
            Text("dateFrom 확인 \(dateFrom)")
            
        }
        
    }
}


struct YearMonthPicker_Previews: PreviewProvider {
    static var previews: some View {
        YearMonthPicker()
    }
}
