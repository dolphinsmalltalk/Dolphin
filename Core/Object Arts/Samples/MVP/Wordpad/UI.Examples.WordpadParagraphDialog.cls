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

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.DialogView} 38 #{Core.Array} 34 nil nil 8 #(13107200 65536) 32 nil 518 #{Graphics.ThemeColor} #dialog nil 133 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[244 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 32 nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ComboBox} 50 17 nil 32 50 2 8 1144063491 1025 256 838 2 #{UI.ListModel} 550 #{Core.OrderedCollection} 0 nil 6 #{Kernel.IdentitySearchPolicy} 6 #{Graphics.Color} #default nil 5 nil nil nil 256 nil nil 518 #{Core.Message} #displayString 8 #() 8 #() 401 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[80 0 0 0 145 0 0 0 170 0 0 0 108 1 0 0] 193 288 8 '' 256 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'alignment' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140924544 1025 768 nil 432 nil 5 nil nil nil 768 nil nil 1094 1 #{UI.IntegerToText} nil 8 '' 326 1 #{Core.Locale} #userDefault nil 1 #focusLost nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 193 800 nil 768 562 #setMarginWidths: 50 1 8 #(3 3) 768 3 8 #() 722 193 193 nil 45 8 'firstLine' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1141055616 1025 1120 nil 432 nil 5 nil nil nil 1120 nil nil 834 nil 864 896 nil 1 #focusLost nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 193 1152 nil 1120 562 #setMarginWidths: 50 1 8 #(3 3) 1120 3 8 #() 722 193 193 nil 45 8 'left' 18 #{UI.TextEdit} 50 20 nil 32 50 2 8 1140924544 1025 1408 nil 432 nil 5 nil nil nil 1408 nil nil 834 nil 864 896 nil 1 #focusLost nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 193 1440 nil 1408 562 #setMarginWidths: 50 1 8 #(3 3) 1408 3 8 #() 722 193 193 nil 45 8 'right' 518 #{Graphics.Rectangle} 722 21 21 722 21 21 nil nil nil nil 1 nil nil nil nil 1 nil 193 774 #{Core.Semaphore} nil nil 1 nil nil nil nil nil nil 514 50 2 562 #createWindow: 50 1 518 #{UI.CreateDialog} 1698 722 7679 21 722 8269 451 193 32 562 #setWindowText: 50 1 8 'Paragraph' 32 1 50 10 18 #{UI.GroupBox} 50 14 nil 32 50 2 8 1140850695 65 2000 nil nil nil 5 nil nil nil 2000 nil nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 193 2032 8 'Indentation' 2000 3 8 #() 722 193 193 nil 27 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2224 nil nil nil 5 nil nil nil 2224 nil nil 518 #{UI.NullConverter} nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[20 0 0 0 33 0 0 0 64 0 0 0 49 0 0 0] 193 2256 nil 2224 562 #text: 50 1 8 '&Left:' 2224 3 8 #() 722 193 193 nil 27 1120 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2512 nil nil nil 5 nil nil nil 2512 nil nil 2290 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[20 0 0 0 67 0 0 0 64 0 0 0 83 0 0 0] 193 2544 nil 2512 562 #text: 50 1 8 '&Right:' 2512 3 8 #() 722 193 193 nil 27 1408 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 2784 nil nil nil 5 nil nil nil 2784 nil nil 2290 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[20 0 0 0 103 0 0 0 67 0 0 0 119 0 0 0] 193 2816 nil 2784 562 #text: 50 1 8 '&First line:' 2784 3 8 #() 722 193 193 nil 27 768 18 #{UI.StaticText} 50 16 nil 32 50 2 8 1140850944 1 3056 nil nil nil 5 nil nil nil 3056 nil nil 2290 nil nil nil 514 50 2 562 #createWindow: 50 1 610 642 8 #[16 0 0 0 148 0 0 0 72 0 0 0 164 0 0 0] 193 3088 nil 3056 562 #text: 50 1 8 '&Alignment:' 3056 3 8 #() 722 193 193 nil 27 256 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1141047296 131073 3328 nil nil nil 5 nil nil nil 3328 582 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 514 50 1 562 #createWindow: 50 1 610 642 8 #[191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 193 3360 8 '' 3328 3 8 #() 722 193 193 nil 27 722 193 193 nil 29)! !

!UI.Examples.WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

