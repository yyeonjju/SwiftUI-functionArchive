//
//  ScrollPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/06/16.
//

import SwiftUI

//https://stackoverflow.com/questions/58376681/swiftui-automatically-scroll-to-bottom-in-scrollview-bottom-first
struct ScrollPracticeView: View {
    let items :[String] = ["1", "2", "3", "4","5", "6", "7", "8", "9"]

    var body: some View {
        ScrollViewReader { sp in
            ScrollView{
                LazyVStack {
                    ForEach(items, id:\.self){ item in
                        Text(item)
                            .frame(width: 200, height: 200)
                            .background(.gray)


                    }
                }
                .onAppear{
                    sp.scrollTo(items.last!, anchor: .top)
                }
            }
        }
    }
}

struct ScrollPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollPracticeView()
    }
}

//https://www.hackingwithswift.com/quick-start/swiftui/how-to-make-a-scroll-view-move-to-a-location-using-scrollviewreader
//struct ScrollPracticeView: View {
//    let colors: [Color] = [.red, .green, .blue]
//
//    var body: some View {
//        ScrollView {
//            ScrollViewReader { value in
//                Button("Jump to #8") {
//                    value.scrollTo(8, anchor: .top)
//                }
//                .padding()
//
//                ForEach(0..<100) { i in
//                    Text("Example \(i)")
//                        .font(.title)
//                        .frame(width: 200, height: 200)
//                        .background(colors[i % colors.count])
//                        .id(i)
//                }
//            }
//        }
////        .frame(height: 350)
//    }
//}
//
//struct ScrollPracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScrollPracticeView()
//    }
//}


//https://www.thirdrocktechkno.com/blog/implementing-reversed-scrolling-behaviour-in-swiftui/
//import SwiftUI
//import Combine
//
//struct Stack<Content: View>: View {
//    var axis: Axis.Set
//    var content: Content
//
//    init(_ axis: Axis.Set = .vertical, @ViewBuilder builder: ()->Content) {
//        self.axis = axis
//        self.content = builder()
//    }
//
//    var body: some View {
//        switch axis {
//        case .horizontal:
//            HStack {
//                content
//            }
//        case .vertical:
//            LazyVStack {
////            VStack {
//                content
//            }
//        default:
//            VStack {
//                content
//            }
//        }
//    }
//}
//
//struct ReversedScrollView<Content: View>: View {
//    var axis: Axis.Set
//    var content: Content
//
//    func minWidth(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
//       axis.contains(.horizontal) ? proxy.size.width : nil
//    }
//
//    func minHeight(in proxy: GeometryProxy, for axis: Axis.Set) -> CGFloat? {
//       axis.contains(.vertical) ? proxy.size.height : nil
//    }
//
//    init(_ axis: Axis.Set = .horizontal, @ViewBuilder builder: ()->Content) {
//        self.axis = axis
//        self.content = builder()
//    }
//
//    var body: some View {
//        GeometryReader { proxy in
//            ScrollView(axis) {
//                Stack(axis) {
//                    Spacer()
//                    content
//                }
//                .frame(
//                   minWidth: minWidth(in: proxy, for: axis),
//                   minHeight: minHeight(in: proxy, for: axis),
//                   alignment: .bottom
//                )
//                .onAppear{
//                    print("✅✅✅✅✅✅")
//                    print(minWidth(in: proxy, for: axis))
//                    print(minHeight(in: proxy, for: axis))
//                }
//            }
//        }
//    }
//}
//
//struct EducationChannelDetailView: View {
//
//    @ObservedObject var vm: EducationChannelViewModel = EducationChannelViewModel()
//
//    @State private var rejectModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "")
//    @State private var cancelModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "")
//    @State private var cancelConfirmModalState :ModalState = ModalState(isShown : false, relatedId: nil)
//    @State private var blockChangeModalState :ModalState = ModalState(isShown : false)
//    @State private var blockFeedbackWriteModalState :ModalState = ModalState(isShown : false)
//    @State private var blockZoomLinkModalState :ModalState = ModalState(isShown : false)
//
//
//
//    var channel_id: Int
//
//    var body: some View {
//        ZStack{
//            Color.gray3
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture{
//                    print(vm.messages)
//                }
//            ScrollViewReader{ scrollView in
//                ReversedScrollView(.vertical){
//    //            ScrollView{
////                    LazyVStack{
//                        ForEach(vm.messages, id : \.self){ message in
//
//                            HStack (alignment: .top) {
//
//                                VStack (alignment: .leading) {
//                                    Image("appicon")
//                                        .resizable()
//                                        .frame(width: 48, height: 48)
//                                }
//
//                                VStack (alignment: .leading) {
//                                    Text(message.text ?? "")
//                                        .font(.system(size: 14))
//                                        .padding()
//                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                        .background(customColor)
//                                        .cornerRadius(12)
//
//                                    if TestUserType.type == "mentor" { //멘토
//                                        if (message.type == "request_pending" ||
//                                            message.type == "request_accepted" ||
//                                            message.type == "completed") {//요청됨, 확정됨, 종료됨
//                                            EducationChannelDetailMentoringOverall(
//                                                id: message.id,
//                                                type: message.type,
//                                                rejectModalState:$rejectModalState,
//                                                cancelModalState:$cancelModalState,
//                                                cancelConfirmModalState : $cancelConfirmModalState,
//                                                blockZoomLinkModalState: $blockZoomLinkModalState)
//                                        } else if (message.type == "request_rejected" ||
//                                                   message.type == "mentoring_rejected_extra" ||
//                                                   message.type == "canceled_by_mentor" ||
//                                                   message.type == "canceled_by_mentee") {//거절됨, 취소됨(?)
//                                            EducationChannelDetailMentoringRejectCancel(
//                                                id: message.id,
//                                                type: message.type,
//                                                userType:TestUserType.type)
//
//                                        }else if (message.type == "mentoring_requested_extra") {
//                                            //                            EducationChannelDetailMentoringRequestedExtra(id: message.id, type: message.type)
//
//                                        } else {
//                                            Text("")
//                                        }
//                                    } else { //멘티
//                                        if (message.type == "request_pending") {//요청됨
//                                            EducationChannelDetailMentoringCreated(
//                                                id: message.id,
//                                                type: message.type,
//                                                cancelConfirmModalState : $cancelConfirmModalState,
//                                                blockChangeModalState:$blockChangeModalState)
//
//                                        } else if (message.type == "request_accepted") { //확정됨
//                                            EducationChannelDetailMentoringConfirmed(
//                                                id: message.id,
//                                                type: message.type,
//                                                cancelConfirmModalState:$cancelConfirmModalState,
//                                                blockChangeModalState : $blockChangeModalState,
//                                                blockZoomLinkModalState: $blockZoomLinkModalState)
//
//                                        } else if (message.type == "completed") {//종료됨
//                                            EducationChannelDetailMentoringComplete(
//                                                id: message.id,
//                                                type: message.type,
//                                                blockFeedbackWriteModalState : $blockFeedbackWriteModalState)
//
//                                        } else if (message.type == "request_rejected" ||
//                                                   message.type == "mentoring_rejected_extra" ||
//                                                   message.type == "canceled_by_mentor" || message.type == "canceled_by_mentee") {//거절됨, 취소됨(?)
//                                            EducationChannelDetailMentoringRejectCancel(
//                                                id: message.id,
//                                                type: message.type,
//                                                userType:TestUserType.type)
//
//                                        }else if (message.type == "mentoring_requested_extra") {
//                                            //                            EducationChannelDetailMentoringRequestedExtra(id: message.id, type: message.type)
//
//                                        } else {
//                                            Text("")
//                                        }
//                                    }
//                                }
//                            }
//
//                        }
//                        .padding()
////                    }
//    //            }
//                }
//                .onChange(of: vm.messages) { message in
//                    if message != []  {
//
//                        // withAnimation(.default) {
//                        scrollView.scrollTo(message.last!, anchor: .top)
//                        // }
//                    }
//                }
//            }
//
//
//            if(rejectModalState.isShown){
//                rejectModalView
//            }
//            if(cancelConfirmModalState.isShown){
//                cancelComfirmModalView
//            }
//            if(cancelModalState.isShown){
//                cancelModalView
//            }
//
//            if(blockChangeModalState.isShown){
//                BasicModalView(title : "24시간 이전에는 일정을 변경할 수 없습니다.", isShown : $blockChangeModalState.isShown)
//            }
//            if(blockFeedbackWriteModalState.isShown){
//                BasicModalView(title : "피드백 작성 후 멘토의 피드백 확인이 가능합니다.", isShown : $blockFeedbackWriteModalState.isShown)
//            }
//            if(blockZoomLinkModalState.isShown){
//                BasicModalView(title : "멘토링 10분 전부터 참여가 가능합니다.", isShown : $blockZoomLinkModalState.isShown)
//            }
//
//        }
//        .onAppear {
//            vm.fetch(channelId : channel_id)
//        }
//        .overlay {
//            if (vm.messages.count == 0) {
//                ProgressView()
//            }
//        }
//
//    }
//}
//
//extension EducationChannelDetailView{
//    var rejectModalView : some View {
//        ZStack{
//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//
//            CustomNormalModal(
//                showingModal: $rejectModalState.isShown,
//                header : {
//                    Text("거절 사유를 적어주세요")
//                        .font(.system(size:16, weight: .bold))
////                            .onTapGesture{
////                                print(rejectModalState.text)
////                            }
//                },
//                content : {
//                    TextEditor(text:Binding(
//                        get: {rejectModalState.text ?? "" },
//                        set: {rejectModalState.text = $0}
//                    ))
//                        .padding()
//                        .foregroundColor(.black)
//                        .frame(height: 200)
//                        .colorMultiply(Color.gray2)
//                        .background(Color.gray2)
//                        .cornerRadius(12)
//                },
//                footer : {
//                    Button{
//                        print("로직")
//                        rejectModalState.isShown = false
//                    } label : {
//                        Text("확인")
//                            .asGreenGradientButton()
//                    }
//                }
//
//            )
//        }
//    }
//
//    var cancelModalView : some View {
//        ZStack{
//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//
//            CustomNormalModal(
//                showingModal: $cancelModalState.isShown,
//                header : {
//                    Text("취소 사유를 적어주세요")
//                        .font(.system(size:16, weight: .bold))
////                            .onTapGesture{
////                                print(rejectModalState.text)
////                            }
//                },
//                content : {
//                    TextEditor(text:Binding(
//                        get: {cancelModalState.text ?? "" },
//                        set: {cancelModalState.text = $0}
//                    ))
//                        .padding()
//                        .foregroundColor(.black)
//                        .frame(height: 200)
//                        .colorMultiply(Color.gray2)
//                        .background(Color.gray2)
//                        .cornerRadius(12)
//                },
//                footer : {
//                    Button{
//                        print("로직")
//                        cancelModalState.isShown = false
//                    } label : {
//                        Text("확인")
//                            .asGreenGradientButton()
//                    }
//                }
//
//            )
//        }
//    }
//
//    var cancelComfirmModalView : some View {
//        ZStack{
//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//
//            CustomNormalModal(
//                showingModal: $cancelConfirmModalState.isShown,
//                header : {
//                    Text("정말 수업을 취소하시겠어요?")
//                        .font(.system(size:16, weight: .bold))
////                            .onTapGesture{
////                                print(rejectModalState.text)
////                            }
//                },
//                content : {
//                    if TestUserType.type == "mentor" {
//                        VStack{
//                            Text("수업 시작 8시간 이내 취소 및 변경 시 패키지 기준 15만원이 패널티로 부여되며 이는 불참 멘토링 이후 정산시에 반영됩니다.")
//                                .multilineTextAlignment(.center)
//                                .padding(.bottom)
//                            Text("해당 패널티는 멘티 분에게 베네핏으로 제공되며,커리어스텝이 취하는 이익은 없습니다.")
//                                .multilineTextAlignment(.center)
//                                .padding(.bottom)
//                            Text("멘토 분들의 경우, 회사 상황을 고려해 8시간 이내 취소 정책을 가져가고 있지만 한달 내 2회 이상 반복 취소 시 2달간 멘토링 진행이 불가합니다.")
//                                .multilineTextAlignment(.center)
//                        }
//                        .foregroundColor(.gray7)
//                        .padding(.vertical)
//                    } else {
//                        VStack{
//                            Text("수업시작 24시간 이전")
//                            Text("&bull; 취소 및 변경 가능 (크레딧 환급)")
//                                .padding(.bottom)
//                            Text("수업시작 24시간 이내")
//                            Text("&bull; 취소 및 변경 불가 (크레딧 차감)")
//                        }
//                        .padding(.vertical)
//                        .foregroundColor(.gray7)
//                    }
//                },
//                footer : {
//                    Button{
//                        print("로직")
//                        cancelConfirmModalState.isShown = false //수업 취소 확인 모달은 사라지고
//                        cancelModalState.isShown = true //취소 사유 적는 모달이 뜸
//                    } label : {
//                        Text("확인")
//                            .asGreenGradientButton()
//                    }
//                }
//
//            )
//        }
//    }
//
//}
//
//struct EducationChannelView_Previews: PreviewProvider {
//    static var previews: some View {
//        EducationChannelDetailView(channel_id: 123)
//    }
//}


