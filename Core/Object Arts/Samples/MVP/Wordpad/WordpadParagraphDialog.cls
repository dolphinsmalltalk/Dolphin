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

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #dialog nil 133 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 416 nil 170 192 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 608 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 608 nil 8 1961712944 459270 ##(Smalltalk.Message) #displayString 8 #() 8 #() 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[80 0 0 0 145 0 0 0 170 0 0 0 109 1 0 0] 193 640 8 '' 608 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'alignment' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 1152 nil 784 nil 7 nil nil nil 1152 nil 8 1962096352 852742 ##(Smalltalk.IntegerToText) nil 8 '' nil 1 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 193 1184 nil 1152 946 #setMarginWidths: 34 1 8 #(3 3) 1152 3 8 #() 1106 193 193 nil 27 8 'right' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1141055616 1025 1504 nil 784 nil 7 nil nil nil 1504 nil 8 1962096352 1234 nil 1264 nil 1 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 193 1536 nil 1504 946 #setMarginWidths: 34 1 8 #(3 3) 1504 3 8 #() 1106 193 193 nil 27 8 'left' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140924544 1025 1824 nil 784 nil 7 nil nil nil 1824 nil 8 1962096352 1234 nil 1264 nil 1 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 193 1856 nil 1824 946 #setMarginWidths: 34 1 8 #(3 3) 1824 3 8 #() 1106 193 193 nil 27 8 'firstLine' 590342 ##(Smalltalk.Rectangle) 1106 21 21 1106 21 21 nil nil nil nil 14149 nil nil nil nil 1 nil 193 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2011073808 882 138 144 34 2 946 #createWindow: 34 1 786950 ##(Smalltalk.CreateDialog) 1026 8 #[255 9 0 0 10 0 0 0 38 11 0 0 225 0 0 0] 193 416 946 #setWindowText: 34 1 8 'Paragraph' 416 1 34 10 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 2464 nil nil nil 7 nil nil nil 2464 nil 8 1962103648 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 193 2496 8 'Indentation' 2464 3 8 #() 1106 193 193 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2720 nil nil nil 7 nil nil nil 2720 nil 8 1962308672 852486 ##(Smalltalk.NullConverter) nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[20 0 0 0 33 0 0 0 64 0 0 0 49 0 0 0] 193 2752 nil 2720 946 #text: 34 1 8 '&Left:' 2720 3 8 #() 1106 193 193 nil 27 1504 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3040 nil nil nil 7 nil nil nil 3040 nil 8 1962308672 2802 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[20 0 0 0 67 0 0 0 64 0 0 0 83 0 0 0] 193 3072 nil 3040 946 #text: 34 1 8 '&Right:' 3040 3 8 #() 1106 193 193 nil 27 1152 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3344 nil nil nil 7 nil nil nil 3344 nil 8 1962308672 2802 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[20 0 0 0 103 0 0 0 67 0 0 0 119 0 0 0] 193 3376 nil 3344 946 #text: 34 1 8 '&First line:' 3344 3 8 #() 1106 193 193 nil 27 1824 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3648 nil nil nil 7 nil nil nil 3648 nil 8 1962308672 2802 nil nil nil 882 138 144 34 2 946 #createWindow: 34 1 994 1026 8 #[16 0 0 0 148 0 0 0 72 0 0 0 164 0 0 0] 193 3680 nil 3648 946 #text: 34 1 8 '&Alignment:' 3648 3 8 #() 1106 193 193 nil 27 608 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1141047296 131073 3952 nil nil nil 7 nil nil nil 3952 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 882 138 144 34 1 946 #createWindow: 34 1 994 1026 8 #[191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 193 3984 8 '' 3952 3 720 1106 193 193 nil 27 1106 193 193 nil 27 )! !

!WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

