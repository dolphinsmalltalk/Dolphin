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

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.DialogView)  98 30 0 0 98 2 26214401 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 167 0 0 0 416 0 234 256 98 8 410 8 ##(Smalltalk.ComboBox)  98 17 0 416 98 2 8 1144063491 1025 560 590662 2 ##(Smalltalk.ListModel)  202 208 98 0 0 1114638 ##(Smalltalk.STBSingletonProxy)  8 ##(Smalltalk.SearchPolicy)  8 #identity 482 512 0 7 0 0 0 560 0 8 4294903527 459270 ##(Smalltalk.Message)  8 #displayString 98 0 688 401 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  155 291 994 181 43 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 145 0 0 0 167 0 0 0 166 0 0 0] 98 0 994 193 193 0 27 8 'alignment' 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140916352 1025 1136 0 482 512 0 7 0 0 0 1136 0 8 4294903583 852486 ##(Smalltalk.NullConverter)  0 0 1 866 202 208 98 3 930 960 98 2 994 155 127 994 181 47 1136 930 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 1136 930 8 #isTextModified: 98 1 32 1136 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 63 0 0 0 167 0 0 0 86 0 0 0] 98 0 1104 0 27 8 'right' 410 1152 98 16 0 416 98 2 8 1141047424 1025 1584 0 482 512 0 7 0 0 0 1584 0 8 4294903583 1250 0 0 1 866 202 208 98 3 930 960 98 2 994 155 61 994 181 47 1584 930 1408 98 1 1442 3 1 3 1584 930 1488 98 1 32 1584 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 30 0 0 0 167 0 0 0 53 0 0 0] 98 0 1104 0 27 8 'left' 410 1152 98 16 0 416 98 2 8 1140916352 1025 1952 0 482 512 0 7 0 0 0 1952 0 8 4294903583 1250 0 0 1 866 202 208 98 3 930 960 98 2 994 155 195 994 181 47 1952 930 1408 98 1 1442 3 1 3 1952 930 1488 98 1 32 1952 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 77 0 0 0 97 0 0 0 167 0 0 0 120 0 0 0] 98 0 1104 0 27 8 'firstLine' 590342 ##(Smalltalk.Rectangle)  994 21 21 994 21 21 0 0 0 0 9103 0 0 0 0 1 0 0 590598 ##(Smalltalk.Semaphore)  0 0 1 0 8 2010572111 866 202 208 98 3 930 960 98 2 994 2799 21 994 569 429 416 930 8 #text: 98 1 8 'Paragraph' 416 930 8 #updateMenuBar 688 416 1042 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 147 6 0 0 224 0 0 0] 98 11 410 8 ##(Smalltalk.GroupBox)  98 14 0 416 98 2 8 1140850695 65 2688 0 482 512 0 7 0 0 0 2688 0 8 4294903591 866 202 208 98 2 930 960 98 2 994 23 23 994 343 245 2688 930 2560 98 1 8 'Indentation' 2688 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 0 11 0 0 0 182 0 0 0 133 0 0 0] 98 0 1104 0 27 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850944 1 3008 0 0 0 7 0 0 0 3008 0 8 4294903617 1250 0 0 0 866 202 208 98 2 930 960 98 2 994 41 67 994 89 27 3008 930 2560 98 1 8 '&Left' 3008 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 33 0 0 0 64 0 0 0 46 0 0 0] 98 0 1104 0 27 1584 410 3024 98 16 0 416 98 2 8 1140850944 1 3328 0 0 0 7 0 0 0 3328 0 8 4294903617 1250 0 0 0 866 202 208 98 2 930 960 98 2 994 41 135 994 89 31 3328 930 2560 98 1 8 '&Right:' 3328 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 67 0 0 0 64 0 0 0 82 0 0 0] 98 0 1104 0 27 1136 410 3024 98 16 0 416 98 2 8 1140850944 1 3632 0 0 0 7 0 0 0 3632 0 8 4294903617 1250 0 0 0 866 202 208 98 2 930 960 98 2 994 41 207 994 89 31 3632 930 2560 98 1 8 '&First line:' 3632 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 103 0 0 0 64 0 0 0 118 0 0 0] 98 0 1104 0 27 1952 410 3024 98 16 0 416 98 2 8 1140850944 1 3936 0 0 0 7 0 0 0 3936 0 8 4294903617 1250 0 0 0 866 202 208 98 2 930 960 98 2 994 41 301 994 113 27 3936 930 2560 98 1 8 '&Alignment:' 3936 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 150 0 0 0 76 0 0 0 163 0 0 0] 98 0 1104 0 27 560 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1141055488 1 4240 0 482 512 0 7 0 0 0 4240 0 8 4294903591 1180998 4 ##(Smalltalk.CommandDescription)  8 #ok 8 'OK' 1 1 0 0 16 866 202 208 98 3 930 960 98 2 994 385 33 994 151 47 4240 930 8 #isEnabled: 98 1 32 4240 930 2560 98 1 8 'OK' 4240 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 16 0 0 0 11 1 0 0 39 0 0 0] 98 0 1104 0 27 410 4256 98 17 0 416 98 2 8 1140924416 1 4672 0 482 512 0 7 0 0 0 4672 0 8 4294903591 4354 8 #cancel 8 'Cancel' 1 1 0 0 32 866 202 208 98 2 930 960 98 2 994 385 89 994 151 47 4672 930 2560 98 1 8 'Cancel' 4672 1042 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 192 0 0 0 44 0 0 0 11 1 0 0 67 0 0 0] 98 0 1104 0 27 1104 0 27 )! !
!WordpadParagraphDialog class categoriesFor: #icon!constants!public! !
!WordpadParagraphDialog class categoriesFor: #resource_Default_view!public!resources-views! !

