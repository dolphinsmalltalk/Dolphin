"Filed out from Dolphin Smalltalk"!

UI.TextPresenter
	subclass: #'UI.RichTextPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.CommonDialogConstants} #{OS.RichEditConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.RichTextPresenter guid: (Core.GUID fromString: '{87b4c6d4-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.RichTextPresenter comment: 'RichTextPresenter is a <valuePresenter> that displays a <valueModel> onto a <richString> value. A RichTextPresenter can be connected to any <valueView> capable of displaying <richString> values. Often, this will be a <RichTextEdit> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!UI.RichTextPresenter categoriesForClass!MVP-Presenters! !
!UI.RichTextPresenter methodsFor!

alignParagraphCenter
	"Align the receiver's paragraph selection to centre"

	self view paragraphAlignment: #center!

alignParagraphLeft
	"Align the receiver's selection paragraph to the left"

	self view paragraphAlignment: #left!

alignParagraphRight
	"Align the receiver's paragraph selection to the right"

	self view paragraphAlignment: #right!

bePlain
	"Set the selection in the receiver to plain text"

	self view bePlain!

chooseSelectionColor
	"Choose the color for the selection in the receiver"

	(ColorDialog on: (self view aspectValue: #selectionColor))
		caption: 'Selection Color';
		showModal!

chooseSelectionFont
	"Choose the font for the selection in the receiver - note that the user can also choose font
	colours and effects, and change one aspect of a selection range without affecting other
	aspects."

	| dialog struct charFormat |
	charFormat := self view selectionCharFormat.
	dialog := FontDialog on: charFormat font.
	struct := dialog winStruct.
	charFormat populateChooseFont: struct.
	dialog showModal.
	dialog isConfirmed ifTrue: [self view selectionCharFormat: (CHARFORMAT2W fromChooseFont: struct)]!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| cmd answer |
	answer := super queryCommand: query.		"Supersend to get enablement of understood selectors"
	cmd := query commandSymbol.

	cmd == #toggleBold ifTrue: [
		query isChecked: self view isBold.
		^true].
	cmd == #toggleItalic ifTrue: [
		query isChecked: self view isItalic.
		^true].
	cmd == #toggleUnderlined ifTrue: [
		query isChecked: self view isUnderlined.
		^true].

	cmd == #alignParagraphLeft ifTrue: [
		query isChecked: self view paragraphAlignment == #left.
		^true].
	cmd == #alignParagraphCenter ifTrue: [
		query isChecked: self view paragraphAlignment == #center.
		^true].
	cmd == #alignParagraphRight ifTrue: [
		query isChecked: self view paragraphAlignment == #right.
		^true].

	^answer!

toggleBold
	"Toggle bold mode for the selection in the receiver"

	<acceleratorKey: 'Ctrl+B'>
	self view isBold: self view isBold not!

toggleItalic
	"Toggle italic mode for the selection in the receiver"

	<acceleratorKey: 'Ctrl+I'>
	self view isItalic: self view isItalic not!

toggleUnderlined
	"Toggle underline mode for the selection in the receiver"

	<acceleratorKey: 'Ctrl+U'>
	self view isUnderlined: self view isUnderlined not! !
!UI.RichTextPresenter categoriesForMethods!
alignParagraphCenter!commands!public! !
alignParagraphLeft!commands!public! !
alignParagraphRight!commands!public! !
bePlain!commands!public! !
chooseSelectionColor!commands!public! !
chooseSelectionFont!commands!public! !
queryCommand:!commands!private! !
toggleBold!commands!public! !
toggleItalic!commands!public! !
toggleUnderlined!commands!public! !
!

!UI.RichTextPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asRichText asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.RichTextEdit} 34 18 nil nil 34 2 8 1140920644 1025 416 nil 917510 #{Graphics.Color} #default nil 7 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 562 1 594 #bePlain 8 '&Plain' 1 1 nil nil nil 562 1 594 #toggleBold 8 '&Bold' 1 1 nil nil nil 562 1 594 #toggleItalic 8 '&Italic' 1 1 nil nil nil 562 1 594 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 642 4097 514 nil true 34 3 562 1025 594 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 562 1025 594 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 562 1025 594 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 642 4097 562 1 594 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 416 nil 8 1348699616 1049094 #{UI.NullConverter} nil nil 9 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 32 0 112 5] 1310982 #{Core.MessageSequence} 34 5 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 1346 421 351 416 1298 #contextMenu: 34 1 528 416 1298 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22\par
}
' 416 1298 #textLimit: 8 #(1073741823) 416 1298 #resetCharFormat 8 #() 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 209 24 0 0 185 0 0 0] 8 #() 1346 193 193 nil 27)!

resource_Static_text
	"Answer the literal data from which the 'Static text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Static_text)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.RichTextEdit} 34 18 nil nil 34 2 8 1140855108 1025 416 nil 917510 #{Graphics.Color} #default nil 7 461638 4 #{UI.Menu} nil true 34 10 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 562 1 594 #bePlain 8 '&Plain' 1 1 nil nil nil 562 1 594 #toggleBold 8 '&Bold' 1 1 nil nil nil 562 1 594 #toggleItalic 8 '&Italic' 1 1 nil nil nil 562 1 594 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 642 4097 514 nil true 34 3 562 1025 594 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 562 1025 594 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 562 1025 594 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 642 4097 562 1 594 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 416 nil 8 1348699616 1049094 #{UI.NullConverter} nil nil 43 nil 852230 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 16 0 112 5] 1310982 #{Core.MessageSequence} 34 5 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 1346 421 131 416 1298 #contextMenu: 34 1 528 416 1298 #text: 34 1 721158 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Times New Roman;}{\f1\froman Times New Roman;}}
\viewkind4\uc1\pard\qc\f0\fs22 Type \b Rich \b0\i Static \i0 text \ul here\ulnone .\f1\par
}
' 416 1298 #textLimit: 8 #(1073741823) 416 1298 #resetCharFormat 8 #() 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 209 24 0 0 75 0 0 0] 8 #() 1346 193 193 nil 27)! !
!UI.RichTextPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Static_text!public!resources-views! !
!

