"Filed out from Dolphin Smalltalk 7"!

TextPresenter subclass: #RichTextPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants RichEditConstants'
	classInstanceVariableNames: ''!
RichTextPresenter guid: (GUID fromString: '{87b4c6d4-026e-11d3-9fd7-00a0cc3e4a32}')!
RichTextPresenter comment: 'RichTextPresenter is a <valuePresenter> that displays a <valueModel> onto a <richString> value. A RichTextPresenter can be connected to any <valueView> capable of displaying <richString> values. Often, this will be a <RichTextEdit> although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!RichTextPresenter categoriesForClass!MVP-Presenters! !
!RichTextPresenter methodsFor!

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

	self view isBold: self view isBold not!

toggleItalic
	"Toggle italic mode for the selection in the receiver"

	self view isItalic: self view isItalic not!

toggleUnderlined
	"Toggle underline mode for the selection in the receiver"

	self view isUnderlined: self view isUnderlined not! !
!RichTextPresenter categoriesFor: #alignParagraphCenter!commands!public! !
!RichTextPresenter categoriesFor: #alignParagraphLeft!commands!public! !
!RichTextPresenter categoriesFor: #alignParagraphRight!commands!public! !
!RichTextPresenter categoriesFor: #bePlain!commands!public! !
!RichTextPresenter categoriesFor: #chooseSelectionColor!commands!public! !
!RichTextPresenter categoriesFor: #chooseSelectionFont!commands!public! !
!RichTextPresenter categoriesFor: #queryCommand:!commands!private! !
!RichTextPresenter categoriesFor: #toggleBold!commands!public! !
!RichTextPresenter categoriesFor: #toggleItalic!commands!public! !
!RichTextPresenter categoriesFor: #toggleUnderlined!commands!public! !

!RichTextPresenter class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^String new asRichText asValue!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.RichTextEdit)  98 18 0 0 98 2 8 1140920644 1025 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 594 1 626 8 #bePlain 8 '&Plain' 1 1 0 0 0 594 1 626 8 #toggleBold 8 '&Bold' 1 1 0 0 0 594 1 626 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 594 1 626 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 690 4097 546 0 16 98 3 594 1025 626 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 594 1025 626 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 594 1025 626 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 690 4097 594 1 626 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 416 0 8 1833025437 852486 ##(Smalltalk.NullConverter)  0 0 9 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 48 0 132 1] 983302 ##(Smalltalk.MessageSequence)  202 208 98 6 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 1554 421 351 416 1490 8 #contextMenu: 98 1 560 416 1490 8 #text: 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\froman Times New Roman;}}
\viewkind4\uc1\pard\f0\fs22 
\par }
' 416 1490 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 1490 8 #isTextModified: 98 1 32 416 1490 8 #resetCharFormat 98 0 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 73 6 0 0 185 0 0 0] 98 0 1554 193 193 0 27 )!

resource_Static_text
	"Answer the literal data from which the 'Static text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_text)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.RichTextEdit)  98 18 0 0 98 2 8 1140855108 1025 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 7 265030 4 ##(Smalltalk.Menu)  0 16 98 10 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #chooseSelectionFont 8 '&Font...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 594 1 626 8 #bePlain 8 '&Plain' 1 1 0 0 0 594 1 626 8 #toggleBold 8 '&Bold' 1 1 0 0 0 594 1 626 8 #toggleItalic 8 '&Italic' 1 1 0 0 0 594 1 626 8 #toggleUnderlined 8 '&Underlined' 1 1 0 0 0 690 4097 546 0 16 98 3 594 1025 626 8 #alignParagraphLeft 8 '&Left' 1 1 0 0 0 594 1025 626 8 #alignParagraphCenter 8 '&Centre' 1 1 0 0 0 594 1025 626 8 #alignParagraphRight 8 '&Right' 1 1 0 0 0 8 '&Align' 0 1 0 0 0 0 0 690 4097 594 1 626 8 #chooseSelectionColor 8 '&Colour...' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 416 0 8 1833025437 852486 ##(Smalltalk.NullConverter)  0 0 43 0 655622 ##(Smalltalk.EDITSTREAM)  8 #[0 0 0 0 0 0 0 0 48 0 132 1] 983302 ##(Smalltalk.MessageSequence)  202 208 98 6 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 1554 421 131 416 1490 8 #contextMenu: 98 1 560 416 1490 8 #text: 98 1 524550 ##(Smalltalk.RichText)  8 '{\rtf1\ansi\ansicpg1252\deff0\deflang2057{\fonttbl{\f0\fnil\fcharset0 Times New Roman;}{\f1\froman Times New Roman;}}
\viewkind4\uc1\pard\qc\f0\fs22 Type \b Rich \b0\i Static \i0 text \ul here\ulnone .\f1 
\par }
' 416 1490 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 1490 8 #isTextModified: 98 1 32 416 1490 8 #resetCharFormat 98 0 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 73 6 0 0 75 0 0 0] 98 0 1554 193 193 0 27 )! !
!RichTextPresenter class categoriesFor: #defaultModel!models!public! !
!RichTextPresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!RichTextPresenter class categoriesFor: #resource_Static_text!public!resources-views! !

