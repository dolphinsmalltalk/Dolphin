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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.DialogView} 34 30 nil nil 8 #(13107200 65536) 416 nil 1245702 #{Graphics.ThemeColor} #dialog nil 167 nil 852998 #{Graphics.Font} nil true 721158 #{OS.LOGFONTW} 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 918022 #{Graphics.Point} 193 193 nil 416 nil 170 192 34 8 410 #{UI.ComboBox} 34 17 nil 416 34 2 8 1144063491 1025 640 787270 2 #{UI.ListModel} 138 144 8 #() nil 1769478 #{Kernel.IdentitySearchPolicy} 917510 #{Graphics.Color} #default nil 7 nil nil nil 640 nil 8 1814646992 786950 #{Core.Message} #displayString 8 #() 8 #() 401 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 578 161 291 578 181 43 640 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 145 0 0 0 170 0 0 0 166 0 0 0] 8 #() 578 193 193 nil 27 8 'alignment' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140924544 1025 1136 nil 816 nil 7 nil nil nil 1136 nil 8 1815092992 1049670 1 #{UI.IntegerToText} nil 8 '' 721222 1 #{Core.Locale} #userDefault nil 1 914 34 2 962 #createAt:extent: 34 2 578 161 127 578 181 47 1136 962 #setMarginWidths: 34 1 8 #(3 3) 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 8 #() 1104 nil 27 8 'right' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1140924544 1025 1504 nil 816 nil 7 nil nil nil 1504 nil 8 1815092992 1218 nil 1248 1280 nil 1 914 34 2 962 #createAt:extent: 34 2 578 161 195 578 181 47 1504 962 #setMarginWidths: 34 1 8 #(3 3) 1504 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 8 #() 1104 nil 27 8 'firstLine' 410 #{UI.TextEdit} 34 16 nil 416 34 2 8 1141055616 1025 1808 nil 816 nil 7 nil nil nil 1808 nil 8 1815092992 1218 nil 1248 1280 nil 1 914 34 2 962 #createAt:extent: 34 2 578 161 61 578 181 47 1808 962 #setMarginWidths: 34 1 8 #(3 3) 1808 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 8 #() 1104 nil 27 8 'left' 1180166 #{Graphics.Rectangle} 578 21 21 578 21 21 nil nil nil nil 54917 nil nil nil nil 1 nil nil 918278 #{Core.Semaphore} nil nil 1 nil 8 2004646672 914 34 2 962 #createAt:extent: 34 2 578 12287 21 578 591 431 416 962 #text: 34 1 8 'Paragraph' 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 38 25 0 0 225 0 0 0] 34 10 410 #{UI.GroupBox} 34 14 nil 416 34 2 8 1140850695 65 2416 nil nil nil 7 nil nil nil 2416 nil 8 1815097472 914 34 2 962 #createAt:extent: 34 2 578 23 23 578 347 245 2416 962 #text: 34 1 8 'Indentation' 2416 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 8 #() 1104 nil 27 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2688 nil nil nil 7 nil nil nil 2688 nil 8 1815137184 1049094 #{UI.NullConverter} nil nil nil 914 34 2 962 #createAt:extent: 34 2 578 41 67 578 89 27 2688 962 #text: 34 1 8 '&Left:' 2688 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 8 #() 1104 nil 27 1808 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 2992 nil nil nil 7 nil nil nil 2992 nil 8 1815137184 2770 nil nil nil 914 34 2 962 #createAt:extent: 34 2 578 41 135 578 89 31 2992 962 #text: 34 1 8 '&Right:' 2992 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 8 #() 1104 nil 27 1136 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3280 nil nil nil 7 nil nil nil 3280 nil 8 1815137184 2770 nil nil nil 914 34 2 962 #createAt:extent: 34 2 578 41 207 578 95 31 3280 962 #text: 34 1 8 '&First line:' 3280 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 67 0 0 0 118 0 0 0] 8 #() 1104 nil 27 1504 410 #{UI.StaticText} 34 16 nil 416 34 2 8 1140850944 1 3568 nil nil nil 7 nil nil nil 3568 nil 8 1815137184 2770 nil nil nil 914 34 2 962 #createAt:extent: 34 2 578 33 297 578 113 27 3568 962 #text: 34 1 8 '&Alignment:' 3568 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 148 0 0 0 72 0 0 0 161 0 0 0] 8 #() 1104 nil 27 640 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1141047296 131073 3856 nil nil nil 7 nil nil nil 3856 1376838 1 #{UI.ResourceIdentifier} #{UI.Presenter} #resource_OK_Cancel_button_block nil 914 34 1 962 #createAt:extent: 34 2 578 383 19 578 161 141 3856 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 752 1104 nil 27 1104 nil 27)! !
!UI.Examples.WordpadParagraphDialog class categoriesForMethods!
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

