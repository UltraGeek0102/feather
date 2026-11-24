import SwiftUI
import NimbleViews

// MARK: - View
struct SigningPropertiesView: View {
	@Environment(\.dismiss) var dismiss
	
	@State private var text: String
	
	var saveButtonDisabled: Bool {
		text == initialValue
	}
	
	var title: String
	var initialValue: String
	@Binding var bindingValue: String?
	var suggestion: String?
	
	init(
		title: String,
		initialValue: String,
		bindingValue: Binding<String?>,
		suggestion: String? = nil
	) {
		self.title = title
		self.initialValue = initialValue
		self._text = State(initialValue: initialValue)
		self._bindingValue = bindingValue
		self.suggestion = suggestion
	}
	
	// MARK: Body
	var body: some View {
		NBList(title) {
			Section {
				TextField(initialValue, text: $text)
					.textInputAutocapitalization(.none)
			}
			
			if let suggestion, suggestion != text {
				Section {
					Button {
						text = suggestion
					} label: {
						Label(.localized("Match to Certificate Identifier"), systemImage: "checkmark.seal")
					}
				} footer: {
					Text(verbatim: .localized("Use %@ from your selected provisioning profile.", arguments: suggestion))
				}
			}
		}
		.toolbar {
			NBToolbarButton(
				.localized("Save"),
				style: .text,
				placement: .topBarTrailing,
				isDisabled: saveButtonDisabled
			) {
				if !saveButtonDisabled {
					bindingValue = text
					dismiss()
				}
			}
		}
	}
}
