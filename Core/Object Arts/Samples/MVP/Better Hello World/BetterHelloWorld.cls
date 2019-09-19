"Filed out from Dolphin Smalltalk 7"!

Shell subclass: #BetterHelloWorld
	instanceVariableNames: 'textToDisplayPresenter'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BetterHelloWorld guid: (GUID fromString: '{00e258da-1b1a-42c4-89c3-e3ed1983a682}')!
BetterHelloWorld comment: 'This is the presenter for the Better Hello World example package. The full sample shows an MVP "triad" of elements consisting of a ValueModel, a composite ShellView (drawn with the ViewComposer) and this presenter class that ties all the pieces together. See the package comment for more details and links to tutorial videos that explain how this example was put together.'!
!BetterHelloWorld categoriesForClass!Unclassified! !
!BetterHelloWorld methodsFor!

createComponents
	super createComponents.
	textToDisplayPresenter := self add: TextPresenter new name: 'textToDisplay'.
	!

editMe
	BetterHelloWorld show: 'Editable view' on: self model!

model: aModel
	super model: aModel.
	textToDisplayPresenter model: aModel! !
!BetterHelloWorld categoriesFor: #createComponents!public! !
!BetterHelloWorld categoriesFor: #editMe!public! !
!BetterHelloWorld categoriesFor: #model:!public! !

!BetterHelloWorld class methodsFor!

defaultModel
	^'Hello World' asValue!

icon
	"Answers an Icon that can be used to represent this class."

	^##((TextTileIcon text: $\x1F389 color: Color crimson)
		fontStyle: #bold;
		yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 416 nil 170 192 34 2 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 544 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 196934 1 ##(Smalltalk.RGB) 25231361 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 231 241 690 731 131 544 866 #text: 34 1 8 'Static Text' 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 8 #() 690 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 9957 nil nil nil nil 1 nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 690 417 417 690 1201 801 416 866 #updateMenuBar 8 #() 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 208 0 0 0 208 0 0 0 40 3 0 0 96 2 0 0] 34 2 544 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1280 nil nil nil 5 nil nil nil 1280 nil 8 1915188384 1180998 4 ##(Smalltalk.CommandDescription) #editMe 8 'Edit' 1 1 nil nil true nil nil nil 802 138 144 34 3 866 #createAt:extent: 34 2 690 365 411 690 471 161 1280 866 #isEnabled: 8 #(false) 1280 866 #text: 34 1 8 'Edit' 1280 994 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 8 #() 1056 nil 29 1056 nil 27 )!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 786694 ##(Smalltalk.ColorDefault) 8 4278190080 nil 5 nil nil nil 416 nil 170 192 34 2 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916353 1 544 nil nil nil 5 nil 263174 ##(Smalltalk.Font) nil true 459014 ##(Smalltalk.LOGFONT) 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point) 193 193 nil 544 196934 1 ##(Smalltalk.RGB) 8454655 8 1915280032 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 690 191 151 690 801 151 544 866 #setMarginWidths: 34 1 8 #(10 10) 544 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 8 #() 690 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil nil 802 138 144 34 2 866 #createAt:extent: 34 2 690 469 469 690 1201 801 416 866 #updateMenuBar 8 #() 416 994 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 234 0 0 0 234 0 0 0 66 3 0 0 122 2 0 0] 34 1 544 1056 nil 27 )! !
!BetterHelloWorld class categoriesFor: #defaultModel!public! !
!BetterHelloWorld class categoriesFor: #icon!constants!public! !
!BetterHelloWorld class categoriesFor: #resource_Default_view!public!resources-views! !
!BetterHelloWorld class categoriesFor: #resource_Editable_view!public!resources-views! !

