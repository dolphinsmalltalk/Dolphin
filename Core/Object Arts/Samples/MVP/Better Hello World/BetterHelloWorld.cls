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
	^TextTileIcon
		text: '你好'
		color: Color red

!

initialize
	"
	self initialize.
	"
	Smalltalk developmentSystem addSamplesFolderIconFor: self description: 'Better Hello World'!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 0 0 416 0 234 256 98 2 410 8 ##(Smalltalk.StaticText)  98 16 0 416 98 2 8 1140850945 1 560 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 196934 1 ##(Smalltalk.RGB)  25231361 8 4294902249 852486 ##(Smalltalk.NullConverter)  0 0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 722 231 241 722 731 131 560 898 8 #text: 98 1 8 'Static Text' 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 115 0 0 0 120 0 0 0 224 1 0 0 185 0 0 0] 98 0 722 193 193 0 27 8 'textToDisplay' 0 0 0 0 0 9667 0 0 0 0 1 0 0 834 202 208 98 2 898 928 98 2 722 5119 21 722 1201 801 416 898 8 #updateMenuBar 98 0 416 1058 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 9 0 0 10 0 0 0 87 12 0 0 154 1 0 0] 98 2 560 410 8 ##(Smalltalk.PushButton)  98 17 0 416 98 2 8 1140924416 1 1360 0 0 0 7 0 0 0 1360 0 8 4294902703 1180998 4 ##(Smalltalk.CommandDescription)  8 #editMe 8 'Edit' 1 1 0 0 16 834 202 208 98 3 898 928 98 2 722 365 411 722 471 161 1360 898 8 #isEnabled: 98 1 32 1360 898 1008 98 1 8 'Edit' 1360 1058 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 182 0 0 0 205 0 0 0 161 1 0 0 29 1 0 0] 98 0 1120 0 27 1120 0 27 )!

resource_Editable_view
	"Answer the literal data from which the 'Editable view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Editable_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 39 0 0 0 416 0 234 256 98 2 410 8 ##(Smalltalk.TextEdit)  98 16 0 416 98 2 8 1140916353 1 560 0 0 0 7 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[224 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 86 101 114 100 97 110 97 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 560 196934 1 ##(Smalltalk.RGB)  8454655 8 4294902855 852486 ##(Smalltalk.NullConverter)  0 0 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 4 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 722 191 151 722 801 151 560 898 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 560 898 8 #isTextModified: 98 1 32 560 898 8 #setMarginWidths: 98 1 98 2 21 21 560 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 95 0 0 0 75 0 0 0 239 1 0 0 150 0 0 0] 98 0 722 193 193 0 27 8 'textToDisplay' 0 0 0 0 0 1 0 0 0 0 1 0 0 834 202 208 98 2 898 928 98 2 722 5107 21 722 1201 801 416 898 8 #updateMenuBar 98 0 416 1186 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 249 9 0 0 10 0 0 0 81 12 0 0 154 1 0 0] 98 1 560 1248 0 27 )!

uninitialize
	Smalltalk developmentSystem removeSystemFolderIconNamed: 'Better Hello World'! !
!BetterHelloWorld class categoriesFor: #defaultModel!public! !
!BetterHelloWorld class categoriesFor: #icon!constants!public! !
!BetterHelloWorld class categoriesFor: #initialize!public! !
!BetterHelloWorld class categoriesFor: #resource_Default_view!public!resources-views! !
!BetterHelloWorld class categoriesFor: #resource_Editable_view!public!resources-views! !
!BetterHelloWorld class categoriesFor: #uninitialize!public! !

