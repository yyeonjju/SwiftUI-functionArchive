//
//  FileManagerPracticeView.swift
//  functionArchive
//
//  Created by 하연주 on 2022/08/03.
//

import SwiftUI
import Combine

struct Note: Codable, Identifiable {
    
    // MARK: - Properties
    var id = UUID()
    let title: String
    let description: String
}

struct TextFieldAlert {

    // MARK: Properties
    let title: String
    let message: String?
    var isPresented: Binding<Bool>? = nil

    // MARK: - Methods
    func dismissable(_ isPresented: Binding<Bool>) -> TextFieldAlert {
        TextFieldAlert(title: title, message: message, isPresented: isPresented)
    }
}


extension TextFieldAlert: UIViewControllerRepresentable {

    typealias UIViewControllerType = TextFieldAlertViewController

    func makeUIViewController(context: UIViewControllerRepresentableContext<TextFieldAlert>) -> UIViewControllerType {
        TextFieldAlertViewController(title: title, message: message, isPresented: isPresented)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: UIViewControllerRepresentableContext<TextFieldAlert>) {}
}

struct TextFieldWrapper<PresentingView: View>: View {

    // MARK: - Properties
    @Binding var isPresented: Bool
    let presentingView: PresentingView
    let content: () -> TextFieldAlert

    // MARK: - UI Elements
    var body: some View {
        ZStack {
            if (isPresented) { content().dismissable($isPresented) }
            presentingView
        }
    }
}


struct FileManagerPracticeView: View {
    // MARK: - Properties
    @ObservedObject var dataProvider: DataProvider = DataProvider.shared
    @State private var alertShowing = false
    @State private var editMode: EditMode = .inactive

    // MARK: - UI Elements
    var body: some View {
        NavigationView {
            List {
                ForEach(dataProvider.allNotes) { note in
                    NoteListCell(note: note)
                }
                .onDelete(perform: dataProvider.delete)
                .onMove(perform: dataProvider.move)
            }
            .navigationTitle(Text("Notes"))
            .navigationBarItems(
                leading: EditButton(),
                trailing:  AddButton(editMode: $editMode, alertShowing: $alertShowing)
            )
            .textFieldAlert(isPresented: $alertShowing) {
                TextFieldAlert(title: "Write a note!", message: nil)
            }
            .listStyle(InsetListStyle())
            .environment(\.editMode, $editMode)
        }
    }
}

//struct FileManagerPracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileManagerPracticeView()
//    }
//}

class DataProvider: ObservableObject {

    // MARK: - Properties
    static let shared = DataProvider()
    private let dataSourceURL: URL
    @Published var allNotes = [Note]()
    
    
    // MARK: - Life Cycle
    init() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let notesPath = documentsPath.appendingPathComponent("notes").appendingPathExtension("json")
        dataSourceURL = notesPath
           
        _allNotes = Published(wrappedValue: getAllNotes())
    }
    
    // MARK: - Methods
    private func getAllNotes() -> [Note] {
        do {
            let decoder = PropertyListDecoder()
            let data = try Data(contentsOf: dataSourceURL)
            let decodedNotes = try! decoder.decode([Note].self, from: data)
                
            return decodedNotes
        } catch {
            return []
        }
    }
    
    
    private func saveNotes() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allNotes)
            try data.write(to: dataSourceURL)
        } catch {

        }
    }
    
    func create(note: Note) {
        allNotes.insert(note, at: 0)
        saveNotes()
    }
    
    func changeNote(note: Note, index: Int) {
        allNotes[index] = note
        saveNotes()
    }
    
    func delete(_ offsets: IndexSet) {
        allNotes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    func move(source: IndexSet, destination: Int) {
        allNotes.move(fromOffsets: source, toOffset: destination)
        saveNotes()
    }
}


struct NoteListCell: View {
    
    // MARK: - Properties
    let note: Note
    
    // MARK: - UI Elements
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(note.title)")
                .font(.headline)
            
            Text("\(note.description)")
                .font(.footnote)
        }
    }
}

struct AddButton: View {

    // MARK: - Properties
    @Binding var editMode: EditMode
    @Binding var alertShowing: Bool

    // MARK: - UI Elements
    var body: some View {
        if editMode == .inactive {
            return AnyView(Button(action: {
                    withAnimation {
                        if alertShowing {
                            alertShowing = false
                        } else {
                            alertShowing = true
                        }
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                })
        } else {
            return AnyView(EmptyView())
        }
    }
}


class TextFieldAlertViewController: UIViewController {

    // MARK: - Properties
    private let alertTitle: String
    private let message: String?
    private var isPresented: Binding<Bool>?

    private var subscription: AnyCancellable?
    
    // MARK: - Life Cycle
    init(title: String, message: String?, isPresented: Binding<Bool>?) {
        self.alertTitle = title
        self.message = message
        self.isPresented = isPresented
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        presentAlertController()
    }

    // MARK: - Methods
    private func presentAlertController() {
        guard subscription == nil else { return }
        let ac = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        
        ac.view.tintColor = .red
        
        ac.addTextField()
        ac.addTextField()
        ac.textFields![0].placeholder = "Title"
        ac.textFields![1].placeholder = "Description"

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.isPresented?.wrappedValue = false
        }
        let createAction = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            let title = ac.textFields![0].text!
            let description = ac.textFields![1].text!
            let note = Note(title: title, description: description)
            
            DataProvider.shared.create(note: note)
        }
        
        ac.addAction(cancelAction)
        ac.addAction(createAction)
        present(ac, animated: true, completion: nil)
    }
}

extension View {
    
    // MARK: - Methods
    func textFieldAlert(isPresented: Binding<Bool>, content: @escaping () -> TextFieldAlert) -> some View {
        TextFieldWrapper(isPresented: isPresented, presentingView: self, content: content)
    }
}
