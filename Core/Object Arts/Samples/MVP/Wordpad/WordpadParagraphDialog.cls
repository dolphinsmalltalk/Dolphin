"Filed out from Dolphin Smalltalk"!

Dialog subclass: #WordpadParagraphDialog
	instanceVariableNames: 'leftPresenter rightPresenter firstLinePresenter alignmentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

WordpadParagraphDialog guid: (GUID fromString: '{5afd840c-a050-45b7-9346-e40a2217b331}')!

WordpadParagraphDialog comment: '`WordpadParagraphDialog` is a sample dialog that offers a subset of the settings in the paragraph dialog of the real Wordpad application. It is intended as an example of an MVP `Dialog` that employes `AspectBuffer`s and `TypeConverter`s, `NumberPresenter`s and a `ChoicePresenter`.

## Instance Variables:
  `leftPresenter`			`NumberPresenter` presenting the paragraph left indent
  `rightPresenter`			`NumberPresenter` presenting the paragraph right indent
  `firstLinePresenter`		`NumberPresenter` presenting the left indent of the first line of the paragraph
  `alignmentPresenter`		`ChoicePresenter` presenting the paragraph alignment, i.e. left or right justified, or centred

'!

!WordpadParagraphDialog categoriesForClass!MVP-Presenters! !

!WordpadParagraphDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	leftPresenter := self add: NumberPresenter new name: 'left'.
	rightPresenter := self add: NumberPresenter new name: 'right'.
	firstLinePresenter := self add: NumberPresenter new name: 'firstLine'.
	alignmentPresenter := self add: (ChoicePresenter new choices: self paragraphAlignments)
				name: 'alignment'!

model: aPARAFORMAT
	| aspectBuffer pointsToTwips |
	super model: aPARAFORMAT.
	aspectBuffer := self model.
	"The real wordpad paragraph dialog shows the indents in units of centimetres or inches, but to keep things simple we use points."
	pointsToTwips := PluggableTypeConverter leftToRight: [:twips | twips // 20]
				rightToLeft: [:points | points * 20].
	leftPresenter
		model: (ValueConverter subject: (aspectBuffer aspectValue: #dxOffset) typeConverter: pointsToTwips).
	rightPresenter model: (ValueConverter subject: (aspectBuffer aspectValue: #dxRightIndent)
				typeConverter: pointsToTwips).
	firstLinePresenter model: (ValueConverter subject: (aspectBuffer aspectValue: #dxStartIndent)
				typeConverter: pointsToTwips).
	"We need to map Left <-> 1, Right <-> 2, Center <-> 3"
	alignmentPresenter model: (ValueConverter subject: (aspectBuffer aspectValue: #wAlignment)
				typeConverter: (MappingConverter
						leftToRight: (LookupTable withAll: self paragraphAlignments associations)))!

paragraphAlignments
	^#('Left' 'Right' 'Center')! !

!WordpadParagraphDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
paragraphAlignments!constants!private! !
!

!WordpadParagraphDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^WordPad icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 640 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 640 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 752 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 161 291 578 181 43 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 145 0 0 0 170 0 0 0 166 0 0 0] 8 #() 578 193 193 nil 27 8 'alignment' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 1136 nil 816 nil 7 nil nil nil 1136 nil 8 1903872368 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 578 161 127 578 181 47 1136 962 #setMarginWidths: 34 1 8 #(3 3) 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 8 #() 1104 nil 27 8 'right' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 1488 nil 816 nil 7 nil nil nil 1488 nil 8 1903872368 1218 nil 1248 nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 578 161 195 578 181 47 1488 962 #setMarginWidths: 34 1 8 #(3 3) 1488 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 8 #() 1104 nil 27 8 'firstLine' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1141055616 1025 1808 nil 816 nil 7 nil nil nil 1808 nil 8 1903872368 1218 nil 1248 nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 578 161 61 578 181 47 1808 962 #setMarginWidths: 34 1 8 #(3 3) 1808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 8 #() 1104 nil 27 8 'left' 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 10391 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998684880 898 138 144 34 3 962 #createAt:extent: 34 2 578 3839 21 578 591 431 416 962 #text: 34 1 8 'Paragraph' 416 962 #updateMenuBar 752 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 166 8 0 0 225 0 0 0] 34 10 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 2464 nil nil nil 7 nil nil nil 2464 nil 8 1903885040 898 138 144 34 2 962 #createAt:extent: 34 2 578 23 23 578 347 245 2464 962 #text: 34 1 8 'Indentation' 2464 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 8 #() 1104 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2752 nil nil nil 7 nil nil nil 2752 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 41 67 578 89 27 2752 962 #text: 34 1 8 '&Left:' 2752 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 8 #() 1104 nil 27 1808 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3072 nil nil nil 7 nil nil nil 3072 nil 8 1903849936 2834 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 41 135 578 89 31 3072 962 #text: 34 1 8 '&Right:' 3072 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 8 #() 1104 nil 27 1136 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3376 nil nil nil 7 nil nil nil 3376 nil 8 1903849936 2834 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 41 207 578 95 31 3376 962 #text: 34 1 8 '&First line:' 3376 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 67 0 0 0 118 0 0 0] 8 #() 1104 nil 27 1488 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3680 nil nil nil 7 nil nil nil 3680 nil 8 1903849936 2834 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 578 33 297 578 113 27 3680 962 #text: 34 1 8 '&Alignment:' 3680 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 148 0 0 0 72 0 0 0 161 0 0 0] 8 #() 1104 nil 27 640 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1141047296 131073 3984 nil nil nil 7 nil nil nil 3984 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 898 138 144 34 1 962 #createAt:extent: 34 2 578 383 19 578 161 141 3984 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 752 1104 nil 27 1104 nil 27 )! !

!WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

