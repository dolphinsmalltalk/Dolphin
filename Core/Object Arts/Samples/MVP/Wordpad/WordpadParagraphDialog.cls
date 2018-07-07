"Filed out from Dolphin Smalltalk 7"!

Dialog subclass: #WordpadParagraphDialog
	instanceVariableNames: 'leftPresenter rightPresenter firstLinePresenter alignmentPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WordpadParagraphDialog guid: (GUID fromString: '{5afd840c-a050-45b7-9346-e40a2217b331}')!
WordpadParagraphDialog comment: ''!
!WordpadParagraphDialog categoriesForClass!MVP-Presenters! !
!WordpadParagraphDialog methodsFor!

createComponents
	"Create the presenters contained by the receiver"

	super createComponents.
	leftPresenter := self add: TextPresenter new name: 'left'.
	rightPresenter := self add: TextPresenter new name: 'right'.
	firstLinePresenter := self add: TextPresenter new name: 'firstLine'.
	alignmentPresenter := self add: (ChoicePresenter new choices: #('Left' 'Right' 'Center') yourself)
				name: 'alignment'! !
!WordpadParagraphDialog categoriesFor: #createComponents!initializing!public! !

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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 167 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 1 2 1 34 77 0 83 0 32 0 83 0 97 0 110 0 115 0 32 0 83 0 101 0 114 0 105 0 102 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 8 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 656 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 466 496 nil 7 nil nil nil 656 nil 8 1906654144 459270 ##(Smalltalk.Message) #displayString 8 #() 768 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 594 155 291 594 181 43 656 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 145 0 0 0 167 0 0 0 166 0 0 0] 8 #() 594 193 193 nil 27 8 'alignment' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1141047424 1025 1136 nil 466 496 nil 7 nil nil nil 1136 nil 8 1906818384 852486 ##(Smalltalk.NullConverter) nil nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 594 155 61 594 181 47 1136 962 #setMarginWidths: 34 1 8 #(3 3) 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 30 0 0 0 167 0 0 0 53 0 0 0] 8 #() 1104 nil 27 8 'left' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1488 nil 466 496 nil 7 nil nil nil 1488 nil 8 1906818384 1234 nil nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 594 155 127 594 181 47 1488 962 #setMarginWidths: 34 1 8 #(3 3) 1488 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 63 0 0 0 167 0 0 0 86 0 0 0] 8 #() 1104 nil 27 8 'right' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1824 nil 466 496 nil 7 nil nil nil 1824 nil 8 1906818384 1234 nil nil 1 898 138 144 34 2 962 #createAt:extent: 34 2 594 155 195 594 181 47 1824 962 #setMarginWidths: 34 1 8 #(3 3) 1824 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 97 0 0 0 167 0 0 0 120 0 0 0] 8 #() 1104 nil 27 8 'firstLine' 590342 ##(Smalltalk.Rectangle) 594 21 21 594 21 21 nil nil nil nil 25933 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 2010075552 898 138 144 34 3 962 #createAt:extent: 34 2 594 3839 21 594 569 429 416 962 #text: 34 1 8 'Paragraph' 416 962 #updateMenuBar 768 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 155 8 0 0 224 0 0 0] 34 11 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 2496 nil 466 496 nil 7 nil nil nil 2496 nil 8 1906824432 898 138 144 34 2 962 #createAt:extent: 34 2 594 23 23 594 343 245 2496 962 #text: 34 1 8 'Indentation' 2496 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 182 0 0 0 133 0 0 0] 8 #() 1104 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2800 nil nil nil 7 nil nil nil 2800 nil 8 1906774720 1234 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 594 41 67 594 89 27 2800 962 #text: 34 1 8 '&Left' 2800 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 8 #() 1104 nil 27 1136 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3104 nil nil nil 7 nil nil nil 3104 nil 8 1906774720 1234 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 594 41 135 594 89 31 3104 962 #text: 34 1 8 '&Right:' 3104 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 8 #() 1104 nil 27 1488 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3408 nil nil nil 7 nil nil nil 3408 nil 8 1906774720 1234 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 594 41 207 594 89 31 3408 962 #text: 34 1 8 '&First line:' 3408 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 64 0 0 0 118 0 0 0] 8 #() 1104 nil 27 1824 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3712 nil nil nil 7 nil nil nil 3712 nil 8 1906774720 1234 nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 594 41 301 594 113 27 3712 962 #text: 34 1 8 '&Alignment:' 3712 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 150 0 0 0 76 0 0 0 163 0 0 0] 8 #() 1104 nil 27 656 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1141055488 1 4016 nil 466 496 nil 7 nil nil nil 4016 nil 8 1906824432 1180998 4 ##(Smalltalk.CommandDescription) #ok 8 'OK' 1 1 nil nil true nil nil nil 898 138 144 34 3 962 #createAt:extent: 34 2 594 385 33 594 151 47 4016 962 #isEnabled: 8 #(false) 4016 962 #text: 34 1 8 'OK' 4016 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 16 0 0 0 11 1 0 0 39 0 0 0] 8 #() 1104 nil 29 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 4400 nil 466 496 nil 7 nil nil nil 4400 nil 8 1906824432 4114 #cancel 8 'Cancel' 1 1 nil nil false nil nil nil 898 138 144 34 2 962 #createAt:extent: 34 2 594 385 89 594 151 47 4400 962 #text: 34 1 8 'Cancel' 4400 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 44 0 0 0 11 1 0 0 67 0 0 0] 8 #() 1104 nil 29 1104 nil 27 )! !
!WordpadParagraphDialog class categoriesFor: #icon!constants!public! !
!WordpadParagraphDialog class categoriesFor: #resource_Default_view!public!resources-views! !

