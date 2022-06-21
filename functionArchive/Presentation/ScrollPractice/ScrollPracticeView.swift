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

//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ 최종 이렇게!! ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ ⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️
//⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️ => but 스크롤 안정화를위해 progress 1초동안 보여줄수 있도록 했으므로 리팩토링 필요
//https://www.thirdrocktechkno.com/blog/implementing-reversed-scrolling-behaviour-in-swiftui/
//import SwiftUI
//import Combine
//
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
////            LazyVStack {
//            VStack {
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
//    @StateObject var vm: EducationChannelViewModel = EducationChannelViewModel()
//    @StateObject var feedbackModalVM : FeedbackModalViewModel = FeedbackModalViewModel()
//
//    @State private var rejectModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "")
//    @State private var cancelModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "", by : nil)
//    @State private var cancelConfirmModalState :ModalState = ModalState(isShown : false, relatedId: nil)
//    @State private var blockChangeModalState :ModalState = ModalState(isShown : false)
//    @State private var blockFeedbackWriteModalState :ModalState = ModalState(isShown : false)
//    @State private var blockZoomLinkModalState :ModalState = ModalState(isShown : false)
//    @State private var feedbackModalState :ModalState = ModalState(isShown : false, relatedId: nil, text : "", starRating : 0, operation: .create)
//    @State private var progress = true
//
//    //특정 멘토링에 대해 마지막 메시지의 인덱스 set
//    private var lastestMessageIndexs : [Int] {
//        var uniquedMentoringIds : [Int] = vm.messages.map{$0.mentoring_id}.uniqued()
//        return uniquedMentoringIds.map{ id in
//            //⭐️ messages가 생성된 시간 순으로 내리차순(최신이 맨 처음)이면
//            //            let latestMessageIndex = vm.messages.firstIndex(where: { el in
//            //                el.mentoring_id == id})
//            //⭐️ messages가 생성된 시간 순으로 오름차순(최신이 맨 나중)이면
//            let latestMessageIndex = vm.messages.lastIndex(where: { el in
//                el.mentoring_id == id})
//            return latestMessageIndex ?? -1
//        }
//    }
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
//                    print(lastestMessageIndexs)
//                }
//
//            ScrollViewReader{ scrollView in
//                ReversedScrollView(.vertical){
//                    //            ScrollView{
//                    ForEach(Array(vm.messages.enumerated()), id : \.offset){ index, message in
//
//                        HStack (alignment: .top) {
//
//                            VStack (alignment: .leading) {
//                                Image("appicon")
//                                    .resizable()
//                                    .frame(width: 48, height: 48)
//                            }
//
//                            VStack (alignment: .leading) {
//                                Text(message.text ?? "")
//                                    .font(.system(size: 14))
//                                    .padding()
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .background(customColor)
//                                    .cornerRadius(12)
//
//                                if TestUserType.type == "mentor" { //멘토
//                                    if (message.type == "request_pending" ||
//                                        message.type == "request_accepted" ||
//                                        message.type == "completed") {//요청됨, 확정됨, 종료됨
//                                        EducationChannelDetailMentoringOverall(
//                                            id: message.id,
//                                            type: message.type,
//                                            showButton : lastestMessageIndexs.contains(index), //특정 멘토링에 대해 마지막 메시지의 인덱스 set에 포함될 때만 버튼 보이도록하기 위해
//                                            mentoringId : message.mentoring_id,
//                                            rejectModalState:$rejectModalState,
//                                            cancelModalState:$cancelModalState,
//                                            cancelConfirmModalState : $cancelConfirmModalState,
//                                            blockZoomLinkModalState: $blockZoomLinkModalState,
//                                            feedbackModalState : $feedbackModalState)
//                                    } else if (message.type == "request_rejected" ||
//                                               message.type == "mentoring_rejected_extra" ||
//                                               message.type == "canceled_by_mentor" ||
//                                               message.type == "canceled_by_mentee") {//거절됨, 취소됨(?)
//                                        EducationChannelDetailMentoringRejectCancel(
//                                            id: message.id,
//                                            type: message.type,
//                                            userType:TestUserType.type,
//                                            showButton : lastestMessageIndexs.contains(index)
//                                        )
//
//                                    }else if (message.type == "mentoring_requested_extra") {
//                                        //                            EducationChannelDetailMentoringRequestedExtra(id: message.id, type: message.type)
//
//                                    } else {
//                                        Text("")
//                                    }
//                                } else { //멘티
//                                    if (message.type == "request_pending") {//요청됨
//                                        EducationChannelDetailMentoringCreated(
//                                            id: message.id,
//                                            type: message.type,
//                                            mentoringId : message.mentoring_id,
//                                            showButton : lastestMessageIndexs.contains(index),
//                                            cancelConfirmModalState : $cancelConfirmModalState,
//                                            cancelModalState:$cancelModalState,
//                                            blockChangeModalState:$blockChangeModalState)
//
//                                    } else if (message.type == "request_accepted") { //확정됨
//                                        EducationChannelDetailMentoringConfirmed(
//                                            id: message.id,
//                                            type: message.type,
//                                            mentoringId : message.mentoring_id,
//                                            showButton : lastestMessageIndexs.contains(index),
//                                            cancelConfirmModalState:$cancelConfirmModalState,
//                                            cancelModalState:$cancelModalState,
//                                            blockChangeModalState : $blockChangeModalState,
//                                            blockZoomLinkModalState: $blockZoomLinkModalState)
//
//                                    } else if (message.type == "completed") {//종료됨
//                                        //멘토링 종료에서는 피드백 버튼이 나오므로 마지막메시지이냐 아니냐 여부에 상관없이 버튼 보여주어서 showButton넘기지 않음
//                                        EducationChannelDetailMentoringComplete(
//                                            id: message.id,
//                                            type: message.type,
//                                            blockFeedbackWriteModalState : $blockFeedbackWriteModalState,
//                                            feedbackModalState : $feedbackModalState)
//
//                                    } else if (message.type == "request_rejected" ||
//                                               message.type == "mentoring_rejected_extra" ||
//                                               message.type == "canceled_by_mentor" || message.type == "canceled_by_mentee") {//거절됨, 취소됨(?)
//                                        EducationChannelDetailMentoringRejectCancel(
//                                            id: message.id,
//                                            type: message.type,
//                                            userType:TestUserType.type,
//                                            showButton : lastestMessageIndexs.contains(index))
//
//                                    }else if (message.type == "mentoring_requested_extra") {
//                                        //                            EducationChannelDetailMentoringRequestedExtra(id: message.id, type: message.type)
//
//                                    } else {
//                                        Text("")
//                                    }
//                                }
//                            }
//                        }
//
//                    }
//                    .padding()
//                    .onChange(of: vm.messages) { message in
//                        if message != []  {
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
//                                scrollView.scrollTo((Array(vm.messages.enumerated()).count-1), anchor: .top)
//                            }
//                        }
//                    }
//                    //            }
//                }
//            }
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
//            if(feedbackModalState.isShown){
//                FeedbackModalView
//            }
//
//
//        }
//        .onAppear {
//            vm.fetch(channelId : channel_id)
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                progress = false
//            }
//
//        }
//        .overlay {
//            //리팩토링 필요
//            // 메시지에서 스크롤 뷰가 안정화 될 때까지 ProgressView 띄워주려고
//            if (vm.messages.count == 0 || progress) {
//                GeometryReader{ geo in
//                    ProgressView()
//                        .frame(width: geo.size.width, height: geo.size.height)
//                        .background(Color.white)
//                }
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
//                    //                            .onTapGesture{
//                    //                                print(rejectModalState.text)
//                    //                            }
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
//                        vm.rejectMentoring(
//                            mentoringId: rejectModalState.relatedId ?? 0,
//                            memo: rejectModalState.text ?? ""
//                        )
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
//                    //                            .onTapGesture{
//                    //                                print(rejectModalState.text)
//                    //                            }
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
//                        vm.cancelMentoring(
//                            mentoringId: cancelModalState.relatedId ?? 0,
//                            memo: cancelModalState.text ?? "",
//                            by: cancelModalState.by ?? .mentor
//                        )
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
//                    //                            .onTapGesture{
//                    //                                print(rejectModalState.text)
//                    //                            }
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
//    var FeedbackModalView : some View { //멘티가 멘토에 대한 피드백 작서할 때, 멘토가 본인의 피드백 확인할 때
//        ZStack{
//            Color.black.opacity(0.3)
//                .edgesIgnoringSafeArea(.all)
//
//            if(feedbackModalState.operation == .create){
//                CustomNormalModal(
//                    showingModal: $feedbackModalState.isShown,
//                    header : {
//                        Text("별점을 선택해주세요")
//                            .font(.system(size:16, weight: .bold))
//
//                    },
//                    content : {
//
//                        VStack{
//                            RatingView(rating: $feedbackModalState.starRating, max: 5)
//
//                            Text("\(String(feedbackModalState.starRating!)).0")
//                                .font(.system(size: 12))
//                                .foregroundColor(.fontGray2)
//                                .padding(.vertical)
//
//
//                            ZStack{ //TextEditor에 따로 placeholder 넣는 기능이 없어서
//                                if feedbackModalState.text == "" {
//                                    TextEditor(text: Binding(
//                                        get: {"어떤점이 좋았나요?"},
//                                        set: {$0}
//                                    ))
//                                        .disabled(true)
//                                        .padding()
//                                        .foregroundColor(.gray)
//                                        .frame(height: 200)
//                                        .colorMultiply(Color.gray2)
//                                        .background(Color.gray2)
//                                        .cornerRadius(12)
//                                }
//
//                                TextEditor(text:Binding(
//                                    get: {feedbackModalState.text ?? ""},
//                                    set: {feedbackModalState.text = $0}
//                                ))
//                                    .padding()
//                                    .foregroundColor(.black)
//                                    .frame(height: 200)
//                                    .colorMultiply(Color.gray2)
//                                    .background(Color.gray2)
//                                    .opacity(feedbackModalState.text == "" ? 0.25 : 1)
//                                    .cornerRadius(12)
//                            }
//                        }
//                    },
//                    footer : {
//                        Button{
//                            print("로직")
//                            feedbackModalState.isShown = false //수업 취소 확인 모달은 사라지고
//
//                        } label : {
//                            Text("확인")
//                                .asGreenGradientButton()
//                        }
//                    }
//
//                )
//            }
//            if(feedbackModalState.operation == .view) {
//                CustomNormalModal(
//                    showingModal: $feedbackModalState.isShown,
//                    header : {
//                    },
//                    content : {
//                        VStack{
//                            RatingView(
//                                rating:  Binding(
//                                    get: {feedbackModalVM.feedback?.rate ?? 0},
//                                    set: {$0}
//                                ),
//                                max: 5,
//                                operation: .view)
//
//                            Text("\(String(feedbackModalVM.feedback?.rate ?? 0)).0")
//                                .font(.system(size: 12))
//                                .foregroundColor(.fontGray2)
//                                .padding(.vertical)
//
//                            TextEditor(text: Binding(
//                                get: {feedbackModalVM.feedback?.text ?? ""},
//                                set: {$0}
//                            ))
//                                .disabled(true)
//                                .padding()
//                                .foregroundColor(.black)
//                                .frame(height: 200)
//                                .colorMultiply(Color.gray2)
//                                .background(Color.gray2)
//                                .cornerRadius(12)
//                        }
//                        .onAppear{
//                            feedbackModalVM.fetch()
//                        }
//                    },
//                    footer : {
//                    }
//
//                )
//            }
//
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
