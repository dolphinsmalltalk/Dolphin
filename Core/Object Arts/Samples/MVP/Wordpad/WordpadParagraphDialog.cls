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

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.DialogView) 34 30 nil nil 8 #(13107200 65536) 416 nil 786950 ##(Smalltalk.ThemeColor) #dialog nil 165 nil 263174 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[245 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 83 0 101 0 103 0 111 0 101 0 32 0 85 0 73 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 416 nil 170 192 34 8 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 640 nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 7 nil nil nil 640 nil 8 1904329520 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 578 161 195 578 181 47 640 866 #setMarginWidths: 34 1 8 #(3 3) 640 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 97 0 0 0 170 0 0 0 120 0 0 0] 8 #() 578 193 193 nil 27 8 'firstLine' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916352 1025 1088 nil 706 736 nil 7 nil nil nil 1088 nil 8 1904329520 770 nil nil 1 802 138 144 34 2 866 #createAt:extent: 34 2 578 161 127 578 181 47 1088 866 #setMarginWidths: 34 1 8 #(3 3) 1088 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 63 0 0 0 170 0 0 0 86 0 0 0] 8 #() 1056 nil 27 8 'right' 410 ##(Smalltalk.ComboBox) 34 17 nil 416 34 2 8 1144063491 1025 1424 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 706 736 nil 7 nil nil nil 1424 nil 8 1904163952 459270 ##(Smalltalk.Message) #displayString 8 #() 1536 401 802 138 144 34 1 866 #createAt:extent: 34 2 578 161 291 578 181 43 1424 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 145 0 0 0 170 0 0 0 166 0 0 0] 8 #() 1056 nil 27 8 'alignment' 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1141047424 1025 1840 nil 706 736 nil 7 nil nil nil 1840 nil 8 1904329520 770 nil nil 1 802 138 144 34 2 866 #createAt:extent: 34 2 578 161 61 578 181 47 1840 866 #setMarginWidths: 34 1 8 #(3 3) 1840 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 80 0 0 0 30 0 0 0 170 0 0 0 53 0 0 0] 8 #() 1056 nil 27 8 'left' 590342 ##(Smalltalk.Rectangle) 578 21 21 578 21 21 nil nil nil nil 29287 nil nil nil nil 1 nil nil 590598 ##(Smalltalk.Semaphore) nil nil 1 nil 8 1998017184 802 138 144 34 3 866 #createAt:extent: 34 2 578 3839 21 578 591 431 416 866 #text: 34 1 8 'Paragraph' 416 866 #updateMenuBar 1536 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 166 8 0 0 225 0 0 0] 34 10 410 ##(Smalltalk.GroupBox) 34 14 nil 416 34 2 8 1140850695 65 2512 nil nil nil 7 nil nil nil 2512 nil 8 1904336528 802 138 144 34 2 866 #createAt:extent: 34 2 578 23 23 578 347 245 2512 866 #text: 34 1 8 'Indentation' 2512 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 184 0 0 0 133 0 0 0] 8 #() 1056 nil 27 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 2800 nil nil nil 7 nil nil nil 2800 nil 8 1904285872 770 nil nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 578 41 67 578 89 27 2800 866 #text: 34 1 8 '&Left:' 2800 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 8 #() 1056 nil 27 1840 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3104 nil nil nil 7 nil nil nil 3104 nil 8 1904285872 770 nil nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 578 41 135 578 89 31 3104 866 #text: 34 1 8 '&Right:' 3104 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 8 #() 1056 nil 27 1088 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3408 nil nil nil 7 nil nil nil 3408 nil 8 1904285872 770 nil nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 578 41 207 578 95 31 3408 866 #text: 34 1 8 '&First line:' 3408 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 67 0 0 0 118 0 0 0] 8 #() 1056 nil 27 640 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850944 1 3712 nil nil nil 7 nil nil nil 3712 nil 8 1904285872 770 nil nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 578 33 297 578 113 27 3712 866 #text: 34 1 8 '&Alignment:' 3712 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 0 0 0 148 0 0 0 72 0 0 0 161 0 0 0] 8 #() 1056 nil 27 1424 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1141047296 131073 4016 nil nil nil 7 nil nil nil 4016 1180166 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Presenter) #resource_OK_Cancel_button_block nil 802 138 144 34 1 866 #createAt:extent: 34 2 578 383 19 578 161 141 4016 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 0 0 0 9 0 0 0 15 1 0 0 79 0 0 0] 1536 1056 nil 27 1056 nil 27)! !
!WordpadParagraphDialog class categoriesFor: #icon!constants!public! !
!WordpadParagraphDialog class categoriesFor: #resource_Default_view!public!resources-views! !

