"Filed out from Dolphin Smalltalk"!

UI.Dialog
	subclass: #'UI.Examples.WordpadParagraphDialog'
	instanceVariableNames: 'leftPresenter rightPresenter firstLinePresenter alignmentPresenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Examples.WordpadParagraphDialog guid: (Core.GUID fromString: '{5afd840c-a050-45b7-9346-e40a2217b331}')!
UI.Examples.WordpadParagraphDialog comment: '`WordpadParagraphDialog` is a sample dialog that offers a subset of the settings in the paragraph dialog of the real Wordpad application. It is intended as an example of an MVP `Dialog` that employes `AspectBuffer`s and `TypeConverter`s, `NumberPresenter`s and a `ChoicePresenter`.

## Instance Variables:
  `leftPresenter`			`NumberPresenter` presenting the paragraph left indent
  `rightPresenter`			`NumberPresenter` presenting the paragraph right indent
  `firstLinePresenter`		`NumberPresenter` presenting the left indent of the first line of the paragraph
  `alignmentPresenter`		`ChoicePresenter` presenting the paragraph alignment, i.e. left or right justified, or centred

'!
!UI.Examples.WordpadParagraphDialog categoriesForClass!MVP-Presenters! !
!UI.Examples.WordpadParagraphDialog methodsFor!

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
!UI.Examples.WordpadParagraphDialog categoriesForMethods!
createComponents!initializing!public! !
model:!accessing!public! !
paragraphAlignments!constants!private! !
!

!UI.Examples.WordpadParagraphDialog class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^WordPad icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 30 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1030 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 518 #{Graphics.Point} 193 193 nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ComboBox} 50 17 nil 32 50 2 8 1144063491 1025 288 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 288 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 210 161 291 210 181 43 288 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 145 0 0 0 170 0 0 0 166 0 0 0] 8 #() 210 193 193 nil 27 8 'alignment' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140924544 1025 768 nil 464 nil 5 nil nil nil 768 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 161 195 210 181 47 768 594 #setMarginWidths: 50 1 8 #(3 3) 768 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 8 #() 736 nil 45 8 'firstLine' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1141055616 1025 1120 nil 464 nil 5 nil nil nil 1120 nil nil 834 nil 864 896 nil 1 #focusLost nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 161 61 210 181 47 1120 594 #setMarginWidths: 50 1 8 #(3 3) 1120 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 8 #() 736 nil 45 8 'left' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140924544 1025 1408 nil 464 nil 5 nil nil nil 1408 nil nil 834 nil 864 896 nil 1 #focusLost nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 161 127 210 181 47 1408 594 #setMarginWidths: 50 1 8 #(3 3) 1408 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 8 #() 736 nil 45 8 'right' 518 #{Graphics.Rectangle} 210 21 21 210 21 21 nil nil nil nil 1 nil nil nil nil 1 nil nil 774 #{Core.Semaphore} nil nil 1 nil nil 546 50 2 594 #createAt:extent: 50 2 210 6143 21 210 591 431 32 594 #text: 50 1 8 'Paragraph' 32 674 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 38 13 0 0 225 0 0 0] 50 10 18 #{UI.GroupBox} 50 14 nil 32 50 2 8 1140850695 65 1984 nil nil nil 5 nil nil nil 1984 nil nil 546 50 2 594 #createAt:extent: 50 2 210 23 23 210 347 245 1984 594 #text: 50 1 8 'Indentation' 1984 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 8 #() 736 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2240 nil nil nil 5 nil nil nil 2240 nil nil 518 #{UI.NullConverter} nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 41 67 210 89 27 2240 594 #text: 50 1 8 '&Left:' 2240 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 8 #() 736 nil 27 1120 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2528 nil nil nil 5 nil nil nil 2528 nil nil 2306 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 41 135 210 89 31 2528 594 #text: 50 1 8 '&Right:' 2528 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 8 #() 736 nil 27 1408 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2800 nil nil nil 5 nil nil nil 2800 nil nil 2306 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 41 207 210 95 31 2800 594 #text: 50 1 8 '&First line:' 2800 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 67 0 0 0 118 0 0 0] 8 #() 736 nil 27 768 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3072 nil nil nil 5 nil nil nil 3072 nil nil 2306 nil nil nil 546 50 2 594 #createAt:extent: 50 2 210 33 297 210 113 27 3072 594 #text: 50 1 8 '&Alignment:' 3072 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 148 0 0 0 72 0 0 0 161 0 0 0] 8 #() 736 nil 27 288 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1141047296 131073 3344 nil nil nil 5 nil nil nil 3344 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 546 50 1 594 #createAt:extent: 50 2 210 383 19 210 161 141 3344 674 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 8 #() 736 nil 27 736 nil 27)! !
!UI.Examples.WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

