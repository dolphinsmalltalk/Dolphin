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

	<commandQuery: #queryAlignParagraphCenter:>
	self view paragraphAlignment: #center!

alignParagraphLeft
	"Align the receiver's selection paragraph to the left"

	<commandQuery: #queryAlignParagraphLeft:>
	self view paragraphAlignment: #left!

alignParagraphRight
	"Align the receiver's paragraph selection to the right"

	<commandQuery: #queryAlignParagraphRight:>
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

queryAlignParagraphCenter: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view paragraphAlignment == #center!

queryAlignParagraphLeft: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view paragraphAlignment == #left!

queryAlignParagraphRight: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view paragraphAlignment == #right!

queryToggleBold: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view isBold!

queryToggleItalic: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view isItalic!

queryToggleUnderlined: aCommandQuery
	aCommandQuery
		isEnabled: true;
		isChecked: self view isUnderlined!

toggleBold
	"Toggle bold mode for the selection in the receiver"

	<commandQuery: #queryToggleBold:>
	<acceleratorKey: 'Ctrl+B'>
	self view isBold: self view isBold not!

toggleItalic
	"Toggle italic mode for the selection in the receiver"

	<commandQuery: #queryToggleItalic:>
	<acceleratorKey: 'Ctrl+I'>
	self view isItalic: self view isItalic not!

toggleUnderlined
	"Toggle underline mode for the selection in the receiver"

	<commandQuery: #queryToggleUnderlined:>
	<acceleratorKey: 'Ctrl+U'>
	self view isUnderlined: self view isUnderlined not! !
!UI.RichTextPresenter categoriesForMethods!
alignParagraphCenter!commands-actions!public! !
alignParagraphLeft!commands-actions!public! !
alignParagraphRight!commands-actions!public! !
bePlain!modes!public! !
chooseSelectionColor!commands-actions!public! !
chooseSelectionFont!commands-actions!public! !
queryAlignParagraphCenter:!commands-queries!private! !
queryAlignParagraphLeft:!commands-queries!private! !
queryAlignParagraphRight:!commands-queries!private! !
queryToggleBold:!commands-queries!private! !
queryToggleItalic:!commands-queries!private! !
queryToggleUnderlined:!commands-queries!private! !
toggleBold!commands-actions!public! !
toggleItalic!commands-actions!public! !
toggleUnderlined!commands-actions!public! !
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

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.RichTextEdit} 38 #{Core.Array} 22 nil nil 50 2 8 1140920644 1025 32 nil 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 194 1 226 #bePlain 8 '&Plain' 1 1 nil nil nil 194 1 226 #toggleBold 8 '&Bold' 1 1 nil nil nil 194 1 226 #toggleItalic 8 '&Italic' 1 1 nil nil nil 194 1 226 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 274 4097 146 nil true 50 3 194 1025 226 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 194 1025 226 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 194 1025 226 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 274 4097 194 1 226 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 262 #{Core.MessageSequence} 50 4 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 962 421 351 32 914 #text: 50 1 262 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22\par
}
' 32 914 #textLimit: 8 #(1073741823) 32 914 #resetCharFormat 8 #() 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 209 12 0 0 185 0 0 0] 8 #() 962 193 193 nil 45)!

resource_Static_text
	"Answer the literal data from which the 'Static text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Static_text)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.RichTextEdit} 38 #{Core.Array} 22 nil nil 50 2 8 1140855108 1025 32 nil 6 #{Graphics.Color} #default nil 5 2886 4 #{UI.Menu} nil true 50 10 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #chooseSelectionFont 8 '&Font…' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 194 1 226 #bePlain 8 '&Plain' 1 1 nil nil nil 194 1 226 #toggleBold 8 '&Bold' 1 1 nil nil nil 194 1 226 #toggleItalic 8 '&Italic' 1 1 nil nil nil 194 1 226 #toggleUnderlined 8 '&Underlined' 1 1 nil nil nil 274 4097 146 nil true 50 3 194 1025 226 #alignParagraphLeft 8 '&Left' 1 1 nil nil nil 194 1025 226 #alignParagraphCenter 8 '&Centre' 1 1 nil nil nil 194 1025 226 #alignParagraphRight 8 '&Right' 1 1 nil nil nil 8 '&Align' nil 1 nil nil nil nil nil 274 4097 194 1 226 #chooseSelectionColor 8 '&Colour…' 1 1 nil nil nil 8 '' nil 1 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 43 #focusLost nil nil nil nil 262 #{OS.EDITSTREAM} 8 #[0 0 0 0 0 0 0 0 0 0 0 0] 262 #{Core.MessageSequence} 50 4 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 962 421 131 32 914 #text: 50 1 262 #{UI.RichText} 8 '{\urtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Times New Roman;}{\f1\froman Times New Roman;}}
\viewkind4\uc1\pard\qc\f0\fs22 Type \b Rich \b0\i Static \i0 text \ul here\ulnone .\f1\par
}
' 32 914 #textLimit: 8 #(1073741823) 32 914 #resetCharFormat 8 #() 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 209 12 0 0 75 0 0 0] 8 #() 962 193 193 nil 45)! !
!UI.RichTextPresenter class categoriesForMethods!
defaultModel!models!public! !
resource_Default_view!public!resources-views! !
resource_Static_text!public!resources-views! !
!

