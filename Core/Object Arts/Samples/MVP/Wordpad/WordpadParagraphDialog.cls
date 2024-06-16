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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 34 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 608 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 608 nil 8 1759000288 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 193 640 nil 608 834 #setMarginWidths: 34 1 8 #(3 3) 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'firstLine' 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 1072 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 688 nil 5 nil nil nil 1072 nil 8 1758616864 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() 401 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[80 0 0 0 145 0 0 0 170 0 0 0 109 1 0 0] 193 1104 8 '' 1072 3 8 #() 1026 193 193 nil 27 8 'alignment' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 1504 nil 688 nil 5 nil nil nil 1504 nil 8 1759000288 722 nil 752 nil 1 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 193 1536 nil 1504 834 #setMarginWidths: 34 1 8 #(3 3) 1504 3 8 #() 1026 193 193 nil 27 8 'right' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1141055616 1025 1824 nil 688 nil 5 nil nil nil 1824 nil 8 1759000288 722 nil 752 nil 1 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 193 1856 nil 1824 834 #setMarginWidths: 34 1 8 #(3 3) 1824 3 8 #() 1026 193 193 nil 27 8 'left' 590342 ##(Smalltalk.Rectangle) 1026 21 21 1026 21 21 nil nil nil nil 13947 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2006356512 nil nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 2146 1026 1 1 1026 591 431 193 416 834 #setWindowText: 34 1 8 'Paragraph' 416 1 34 10 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 2480 nil nil nil 5 nil nil nil 2480 nil 8 1759007584 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 193 2512 8 'Indentation' 2480 3 8 #() 1026 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2736 nil nil nil 5 nil nil nil 2736 nil 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[20 0 0 0 33 0 0 0 64 0 0 0 49 0 0 0] 193 2768 nil 2736 834 #text: 34 1 8 '&Left:' 2736 3 8 #() 1026 193 193 nil 27 1824 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3056 nil nil nil 5 nil nil nil 3056 nil 8 1759212608 2818 nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[20 0 0 0 67 0 0 0 64 0 0 0 83 0 0 0] 193 3088 nil 3056 834 #text: 34 1 8 '&Right:' 3056 3 8 #() 1026 193 193 nil 27 1504 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3360 nil nil nil 5 nil nil nil 3360 nil 8 1759212608 2818 nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[20 0 0 0 103 0 0 0 67 0 0 0 119 0 0 0] 193 3392 nil 3360 834 #text: 34 1 8 '&First line:' 3360 3 8 #() 1026 193 193 nil 27 608 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3664 nil nil nil 5 nil nil nil 3664 nil 8 1759212608 2818 nil nil nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[16 0 0 0 148 0 0 0 72 0 0 0 164 0 0 0] 193 3696 nil 3664 834 #text: 34 1 8 '&Alignment:' 3664 3 8 #() 1026 193 193 nil 27 1072 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1141047296 131073 3968 nil nil nil 5 nil nil nil 3968 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 193 4000 8 '' 3968 3 1184 1026 193 193 nil 27 1026 193 193 nil 29 )! !

!WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

