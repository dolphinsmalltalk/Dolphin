"Filed out from Dolphin Smalltalk"!

StaticViewTest subclass: #StaticBitmapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StaticBitmapTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

StaticBitmapTest comment: ''!

!StaticBitmapTest categoriesForClass!Unclassified! !

!StaticBitmapTest methodsFor!

classToTest
	^StaticBitmap!

oldDolphinVersionsForStbUpgrade
	^2 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view backcolor.
	self assertIsNil: view image!

vuFile
	^'ImagePresenter.Static bitmap.vu'! !

!StaticBitmapTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!StaticBitmapTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(StaticBitmap) 98 17 0 0 98 2 8 1149239566 1 416 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #== 98 0 562 8 #hash 98 0 0 0 0 5 0 0 0 416 0 8 4294906439 852486 ##(NullConverter) 0 0 32 0 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 850 441 331 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 225 0 0 0 170 0 0 0] 98 0 850 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticBitmap) 34 17 nil nil 34 2 8 1149239566 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #== 8 #() 546 #hash 8 #() nil nil nil 5 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil false nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 786 441 331 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 225 0 0 0 170 0 0 0] 8 #() 786 193 193 nil 27 )! !

!StaticBitmapTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

