//
//  CustomPickerTextField.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/06.
//

import Foundation
import SwiftUI


//블로그 SwiftUI에서 UIKit 사용하기 UIViewRepresentable (2)
struct UIKitTextField : UIViewRepresentable {
    private let textField = UITextField()
    @Binding var binding : Bool
    @Binding var comment : String
    
    func makeUIView(context: UIViewRepresentableContext<UIKitTextField>) -> UITextField{
        //textField의 delegate
        textField.delegate = context.coordinator
        
        //textField의 style
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 3
        

        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<UIKitTextField>){
        print("updateUIView : ", binding)
    }
    
    
    //makeCoordinator()
    func makeCoordinator() -> UIKitTextField.Coordinator {
        print("makeCoordinator")
        return UIKitTextField.Coordinator(self)
        
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent : UIKitTextField
        init(_ textField: UIKitTextField) {
            self.parent = textField
        }
        
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            //            return (textField.text! + string).count <= 10
            if (textField.text! + string).count > 10 {
                parent.comment = "글자수가 초과되었습니다."
            } else {
                parent.comment = "글자수를 넘기지 않았습니다."
            }
            return true
        }
        
    }
}


/*
 //블로그 SwiftUI에서 UIKit 사용하기 UIViewRepresentable (1)
struct UIKitTextField : UIViewRepresentable {
    private let textField = UITextField()
//    @Binding var bindingString : String
//    var onClickCancelBtn : (() -> Void)
    
    let helper : Helper = Helper()
    
    
    //버튼의 addTarget에 넣을 동작을 만들기 위해서는
    //셀렉터를 만들어야하는데
    //그러려면 클래스 내부에 @objc 함수를 만들어주어야한다
    class Helper {
        public var onClickCancelButton: (() -> Void)?
        @objc func clickCancelButton() {
            onClickCancelButton?()
            print("🍑 onClickClearButton")
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<UIKitTextField>) -> UITextField{
        //textField의 delegate
        textField.delegate = context.coordinator
        
        //textField의 style
        textField.backgroundColor = .gray
        textField.layer.cornerRadius = 3
        
        //textField 우측에 UIButton으로 clearButton 삽입
        let btnImage = UIImage(systemName: "multiply")
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(btnImage, for: .normal)
        clearButton.tintColor = UIColor.lightGray
        
        helper.onClickCancelButton = {
            textField.text = ""
        }
        clearButton.addTarget(helper, action: #selector(helper.clickCancelButton), for: .touchUpInside)
        
        textField.rightView = clearButton
        textField.rightViewMode = .always
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<UIKitTextField>){
        print("🌸🌸🌸 updateUIView")
    }
    
    
    
    
    
    
    
    
    //makeCoordinator()
    func makeCoordinator() -> UIKitTextField.Coordinator {
        //UIKitTextField.Coordinator()
        print("🍑 makeCoordinator")
        return UIKitTextField.Coordinator(self)
        //Coordinator에서 var parent 정의해주었을 때!
        // 그러나 이 구조체 자체가 textField여서 따로 parent 변수 필요 없을 듯
        
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent : UIKitTextField
        init(_ textField: UIKitTextField) {
            self.parent = textField
        }
        
//        //텍스트 필드가 입력을 시작할 때 호출
//        func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//            return true
//        }
//
//        //글자 개수 제한
//        func textField(_ textField: UITextField,
//                       shouldChangeCharactersIn range: NSRange,
//                       replacementString string: String) -> Bool {
////            if (textField.text! + string).count <= 10 {
////                print("🍑🍑🍑🍑 10자 이하")
////            }
//            return (textField.text! + string).count <= 10
//        }
        
    }
    
        
}
*/
/*
struct CustomPickerTextField : UIViewRepresentable {
    private let textField = UITextField()
    private let picker = UIPickerView()
    private let toolbar = UIToolbar()
    private let helper = Helper()
    
    public var dataArrays : [String]
    public var placeholder: String = "입력하기"
    @Binding public var bindingString: String

    
    class Helper {
        public var onDoneButtonTapped: (() -> Void)?
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }

    //makeCoordinator()
    func makeCoordinator() -> CustomPickerTextField.Coordinator {
        CustomPickerTextField.Coordinator(self)
    }

    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPickerTextField>) -> UITextField {
        let defaultIndex : Int = 0
        
        //날짜 피커
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.selectRow(defaultIndex, inComponent: 0, animated: true)
        
//        textField.text = bindingString == "" ? "" : bindingString
        textField.placeholder = placeholder
        textField.inputView = picker
        
        //툴바
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        helper.onDoneButtonTapped = {
            textField.resignFirstResponder()
        }

        return textField

    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomPickerTextField>) {
        uiView.text = bindingString
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPickerTextField
        init(_ pickerView: CustomPickerTextField) {
            self.parent = pickerView
        }
        
        //Number Of Components: 컴포넌트 개수 ( 열 )
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
//            return parent.dataArrays.count
            return 1
        }
        
        //Number Of Rows In Component: 각 컴포넌트 별 행
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays.count
        }

        //Width for component: 각 컴포넌트의 width
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//            return UIScreen.main.bounds.width/3
            return UIScreen.main.bounds.width
        }

        //Row height:
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }

        //View for Row : 열이 생길 때마다 한번씩 호출??
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: 60))
            let pickerLabel = UILabel(frame: view.bounds)
            pickerLabel.text = parent.dataArrays[row]
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0

            view.addSubview(pickerLabel)
            view.clipsToBounds = true

            return view
        }
        
        //사용자가 picker에서 입력값 선택했을 때마다 호출 : bindingString값을 입력한 값으로 바인딩 시킨다
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.bindingString = parent.dataArrays[pickerView.selectedRow(inComponent: component)]
        }
    }
}
 */


/*
struct CustomPickerTextField : UIViewRepresentable {
    private let textField = UITextField()
    private let picker = UIPickerView()
    private let toolbar = UIToolbar()
//    private let helper = Helper()
    
    public var dataArrays : [String]
    public var placeholder: String = "입력하기"
    @Binding public var bindingString: String

    
//    class Helper {
//        public var onDoneButtonTapped: (() -> Void)?
//        @objc func doneButtonTapped() {
//            onDoneButtonTapped?()
//        }
//
//        public var onClickCancelButton: (() -> Void)?
//        @objc func clickCancelButton() {
//            onClickCancelButton?()
//        }
//    }


    //makeUIView(context:)
    func makeUIView(context: UIViewRepresentableContext<CustomPickerTextField>) -> UITextField {
//        let defaultIndex : Int = 0
        
        //날짜 피커
//        picker.dataSource = context.coordinator
//        picker.delegate = context.coordinator
//        picker.selectRow(defaultIndex, inComponent: 0, animated: true)
        
//        textField.text = bindingString == "" ? "" : bindingString
        textField.placeholder = placeholder
        textField.inputView = picker
        
        //툴바
        toolbar.sizeToFit()
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
////
//        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
//
//        helper.onDoneButtonTapped = {
//            textField.resignFirstResponder()
//        }

        return textField

    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomPickerTextField>) {
        print("🌸🌸🌸🌸🌸🌸updateUIView---")
//        uiView.text = bindingString
    }

}
 
 */

struct CustomPickerTextField : UIViewRepresentable {
    private let textField = UITextField()
    private let picker = UIPickerView()
    private let toolbar = UIToolbar()
    private let helper = Helper()
    
    public var dataArrays : [String]
    public var placeholder: String = "입력하기"
    @Binding public var bindingString: String

    
    class Helper {
        public var onDoneButtonTapped: (() -> Void)?
        @objc func doneButtonTapped() {
            onDoneButtonTapped?()
        }
    }

    //makeCoordinator()
    func makeCoordinator() -> CustomPickerTextField.Coordinator {
        CustomPickerTextField.Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<CustomPickerTextField>) -> UITextField {
        let defaultIndex : Int = 0
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        picker.selectRow(defaultIndex, inComponent: 0, animated: true)
        
        textField.placeholder = placeholder
        textField.inputView = picker
        
                //툴바
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: helper, action: #selector(helper.doneButtonTapped))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        textField.inputAccessoryView = toolbar
        
        helper.onDoneButtonTapped = {
            textField.resignFirstResponder()
        }
        

        return textField

    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomPickerTextField>) {
                //🌸 UITextField에 사용자가 입력한 값이 반영 될 수 있도록한다.
                uiView.text = bindingString
    }

    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: CustomPickerTextField
        init(_ pickerView: CustomPickerTextField) {
            self.parent = pickerView
        }
        
        //Number Of Components
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        //Number Of Rows In Component
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.dataArrays.count
        }

        //Width for component
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return UIScreen.main.bounds.width
        }

        //Row height
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 40
        }

        //View for Row
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/4, height: 60))
            let pickerLabel = UILabel(frame: view.bounds)
            pickerLabel.text = parent.dataArrays[row]
            pickerLabel.adjustsFontSizeToFitWidth = true
            pickerLabel.textAlignment = .center
            pickerLabel.lineBreakMode = .byWordWrapping
            pickerLabel.numberOfLines = 0

            view.addSubview(pickerLabel)
            view.clipsToBounds = true

            return view
        }

                //🌸 사용자가 picker에서 입력값 선택했을 때마다 호출
                // bindingString값을 사용자가 입력한 값으로 바인딩 시킨다. (UIKit -> SwiftUI 방향으로의 데이터 전달)
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.bindingString = parent.dataArrays[pickerView.selectedRow(inComponent: component)]
        }
        
    }
}
