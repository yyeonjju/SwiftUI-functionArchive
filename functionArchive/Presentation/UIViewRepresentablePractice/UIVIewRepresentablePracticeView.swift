//
//  UIVIewRepresentablePracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2023/06/05.
//

import SwiftUI

struct UIVIewRepresentablePracticeView: View {
    
    @State var picked : String = ""
    
    var body: some View {
        VStack{
            CustomPickerTextField(
                dataArrays :Array(0...100).map{String($0)},
                bindingString: self.$picked
            )
            
            Text("@State 확인")
                .onTapGesture {
                    print("@State var picked : ", picked)
                }
        }
        .padding()
        
    }
}

/*
 //q블로그에 작성할 UIViewRepresentable관련 예제 (@Binding / Coordinator)
struct UIVIewRepresentablePracticeView: View {
    @State var binding : Bool = true
    @State var comment : String = "글자수를 넘기지 않았습니다."
    
    var body: some View {
        
        VStack {
            Text(comment)
            
            UIKitTextField(binding : self.$binding, comment : self.$comment)
                .frame(height : 40)

            Text("toggle")
                .onTapGesture {
                    binding.toggle()
                }
        }
        .padding()
        
    }
}
 */

/*
struct UIVIewRepresentablePracticeView: View {
    @State var isAnimating: Bool = false
    @State var picked : String = ""
    
    @State private var heightCm = 0.0
    private let heightFormat = "%.0f cm"
    @State var isShowingOverlay: Bool = false
    
    @State var bindingString : String = ""
    @State var binding : Bool = true
    
    func TextFieldUIKit(text: Binding<String>) -> some View{
        UITextField.appearance().clearButtonMode = .whileEditing
        return TextField("Nombre", text: text)
    }
    
    var body: some View {
        //블로그 얘제
        /*
         VStack {
         ActivityIndicator(isAnimating: $isAnimating)
         Button(action: { self.isAnimating = !self.isAnimating },
         label: { Text("show/hide")
         .foregroundColor(Color.white)
         })
         .background(Color.black)
         }
         */
        
        //
        /*
         VStack{
         CustomPickerTextField(
         dataArrays :[
         Array(0...100).map{String($0)}
         ],
         bindingString: self.$picked
         )
         }
         */
        
        /*
        ZStack{
            VStack{
                //                TextField("입력",text : Binding(
                //                    get: {String(format: heightFormat, self.heightCm)},
                //                    set: {
                //                        print("🌸🌸🌸🌸🌸🌸🌸", $0)
                //                        heightCm = Double($0)!
                //
                //                    }
                //                ))
                ZStack{
                    if(isShowingOverlay
                       || (!isShowingOverlay && heightCm == 0.0)){
                        Text(String(format: heightFormat, self.heightCm))
                    } else {
                        Text("입력")
                    }
                    
                }
                .padding()
                .background(.gray)
                .onTapGesture {
                    self.isShowingOverlay = true
                }
                
                Spacer()
            }
            
            
            if isShowingOverlay{
                VStack{
                    Spacer()
                    Form{
                        BottomSheetPicker(selection: $heightCm, max: 300, format: heightFormat)
                            .frame(alignment: .bottom)
                            .transition(AnyTransition.move(edge: .bottom))
                            .animation(.easeInOut(duration: 0.5))
                        
                    }
                    //                    .toolbar{
                    //                        ToolbarItemGroup(placement:.automatic) {  // toolbar above keyboard
                    //                            Spacer()              // add whitespace first
                    //
                    //                            Button("Done") {      // the toolbar has a button labelled done
                    //                                self.isShowingOverlay = false  // pressing 'done' removes focus
                    //                            }
                    //                        }
                    //                    }
                    
                }
                
            }
            
        }
        */
        
        VStack {
            UIKitTextField(binding : self.$binding)
                .frame(height : 40)

            Text("확인")
                .onTapGesture {
                    binding.toggle()
                }
            
            
            //            TextFieldUIKit(text: self.$bindingString)
                        
            //            TextField("NAME", text: $bindingString)
            //                .modifier(ClearButton(text: $bindingString))
        }
        
        
        
        
    }
}

*/
//SEIFTUI에서 TextField에 clearButton 생성하기??
public struct ClearButton: ViewModifier {
    @Binding var text: String

    public init(text: Binding<String>) {
        self._text = text
    }

    public func body(content: Content) -> some View {
        HStack {
            content
            Spacer()
            Image(systemName: "multiply.circle.fill")
                .foregroundColor(.secondary)
                .opacity(text == "" ? 0 : 1)
                .onTapGesture { self.text = "" } // onTapGesture or plainStyle button
        }
    }
}

struct UIVIewRepresentablePracticeView_Previews: PreviewProvider {
    static var previews: some View {
        UIVIewRepresentablePracticeView()
    }
}

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.style = .large
        
        return view
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        if isAnimating {
            uiView.startAnimating()
        }
        else {
            uiView.stopAnimating()
        }
    }
}

struct BottomSheetPicker: View {
    @Binding var selection: Double
    
    var min: Double = 0.0
    let max: Double
    var by: Double = 1.0
    var format: String = "%d"
    
    var body: some View {
        Group {
            Picker("", selection: $selection) {
                ForEach(Array(stride(from: min, through: max, by: by)), id: \.self) { item in
                    Text(String(format: self.format, item))
                }
            }
            .pickerStyle(WheelPickerStyle())
            .foregroundColor(.white)
            .frame(height: 180)
            .padding()
        }.background(Color.gray)
    }
}
