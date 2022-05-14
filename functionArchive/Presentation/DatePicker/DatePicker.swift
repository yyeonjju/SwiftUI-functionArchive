//
//  DatePicker.swift
//  functionArchive
//
//  Created by 하연주 on 2022/05/05.
//

import Foundation
import SwiftUI

struct DatePickerView: View {
    @State private var admissionDate : Date?
    @State private var graduationDate : Date?
//    @State private var showsDatePicker = false
    
    var formmated : String { //🍑🍑🍑 DatePicker에서 선택한 날짜 포매팅
        print("🍑🍑🍑")
        print(self.admissionDate)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd hh:mm"
        let convertStr = dateFormatter.string(from: self.admissionDate ?? Date() )
        return convertStr
        
    }
    
    private func makeFormmatedString (date : Date?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy--MM"
        let strDate = dateFormatter.string(from: date ?? Date() )
        return strDate
    }
    
    
    var body: some View {
        ZStack{
            
            Color.gray
            Form{   //Form을 쓰면 Control들을 그룹화하기 용이하다
                VStack{
//                    Text("DatePicker 나타나기")
//                        .onTapGesture {
//                            showsDatePicker.toggle()
//                        }
                    HStack{
                        Section("입학날짜") {
                            DatePickerTextField(placeholder: admissionDate != nil ? formmated : "Select Date", date: $admissionDate)
                               
                        }
                        Section("졸업날짜") {
                            DatePickerTextField(placeholder: graduationDate != nil ? formmated : "Select Date", date: $graduationDate)
                               
                        }
                        
                    }

                    
//                    DatePicker(
//                        "날짜를 선택하세요",  //텍스트를 "" = empty로 지정할 수 있다.
//                        selection: $pickedDate,
//                        displayedComponents: .date //🍑🍑🍑 DatePicker 에서 어떤 날짜를 선택하게 할것인지
//                    )
//                        .datePickerStyle(.wheel) //🍑🍑🍑 DatePicker의 다양한 스타일
//                        .labelsHidden()  //피커에 텍스트가 안보이게됨
//                    //                    .background(.blue)
                    
                    HStack {
                        Text(makeFormmatedString(date : admissionDate))
                        Text(makeFormmatedString(date : graduationDate))
                    }
                    .background(.blue)

                    
                }
            }
            
            
            
            
        }

    }
}


//            .sheet(isPresented: $showsDatePicker){
////                Form{
//                    DatePicker(
//                        "날짜를 선택하세요",  //텍스트를 "" = empty로 지정할 수 있다.
//                        selection: $wakeUp,
//                        displayedComponents: .date //🍑🍑🍑 DatePicker 에서 어떤 날짜를 선택하게 할것인지
//                    )
//                        .datePickerStyle(.wheel) //🍑🍑🍑 DatePicker의 다양한 스타일
//                        .labelsHidden()  //피커에 텍스트가 안보이게됨
//    //                    .background(.blue)
////                }
//
//            }

struct DatePickerView_Previews: PreviewProvider {

    static var previews: some View {
        DatePickerView()
    }
}
//
//

struct Globals {
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()
}

struct DatePickerTextField: UIViewRepresentable {
    private let textField = UITextField()
    private let datePicker = UIDatePicker()
    private let helper = Helper()

    public var placeholder: String
    @Binding public var date: Date?

    func makeUIView(context: Context) -> UITextField {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self.helper, action: #selector(self.helper.dateValueChanged), for: .valueChanged)

        textField.placeholder = placeholder
        textField.inputView = datePicker
//        print("🎀🎀🎀🎀🎀 textField.inputView")
        print(textField.inputView)
        //textField.borderStyle = .roundedRect

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))

        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar

        helper.onDateValueChanged = {
//            print("🎀🎀🎀🎀🎀 helper.onDateValueChanged  datePicker.date")
//            print(datePicker.date)
            date = datePicker.date
        }

        helper.onDoneButtonTapped = {
            if date == nil {
                date = datePicker.date
            }
            textField.resignFirstResponder()
        }

        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        if let selectedDate = date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM"
            uiView.text = "\(formatter.string(from: selectedDate)) 입학"
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
