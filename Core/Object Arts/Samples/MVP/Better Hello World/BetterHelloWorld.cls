"Filed out from Dolphin Smalltalk"!

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

!BetterHelloWorld categoriesForMethods!
createComponents!public! !
editMe!public! !
model:!public! !
!

!BetterHelloWorld class methodsFor!

defaultModel
	^'Hello World' asValue!

icon
	"Answers an Icon that can be used to represent this class."

	^##((TextTileIcon text: $\xED39 fontName: 'Segoe Fluent Icons' color: Color crimson)
		margin:1;
		yourself)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 170 192 34 2 410 ##(Smalltalk.StaticText) 34 16 nil 416 34 2 8 1140850945 1 528 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 86 0 101 0 114 0 100 0 97 0 110 0 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 466 #steelBlue 8 1759212608 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 193 560 nil 528 802 #text: 34 1 8 'Static Text' 528 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 10473 nil nil nil nil 1 nil 193 738 138 144 34 1 802 #createWindow: 34 1 850 590342 ##(Smalltalk.Rectangle) 994 1 1 994 1201 801 193 448 8 '' 416 1 34 2 528 410 ##(Smalltalk.PushButton) 34 20 nil 416 34 2 8 1140924416 1 1232 nil nil nil 5 nil nil nil 1232 nil 8 1759007584 1180998 4 ##(Smalltalk.CommandDescription) #editMe 8 'Edit' 1 1 nil nil true nil nil nil 738 138 144 34 2 802 #createWindow: 34 1 850 882 8 #[182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 193 1264 8 'Edit' 1232 802 #isEnabled: 8 #(false) 1232 3 8 #() 994 193 193 nil 29 994 193 193 nil 27 )!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 170 192 34 2 410 ##(Smalltalk.TextEdit) 34 16 nil 416 34 2 8 1140916353 1 528 nil nil nil 5 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 86 0 101 0 114 0 100 0 97 0 110 0 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 528 466 #coral 8 1759000288 852486 ##(Smalltalk.NullConverter) nil nil 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 193 560 nil 528 802 #setMarginWidths: 34 1 8 #(10 10) 528 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'textToDisplay' nil nil nil nil nil 1 nil nil nil nil 1 nil 193 738 138 144 34 1 802 #createWindow: 34 1 850 590342 ##(Smalltalk.Rectangle) 994 1 1 994 1201 801 193 448 8 '' 416 1 34 1 528 994 193 193 nil 27 )! !

!BetterHelloWorld class categoriesForMethods!
defaultModel!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
resource_Editable_view!public!resources-views! !
!

