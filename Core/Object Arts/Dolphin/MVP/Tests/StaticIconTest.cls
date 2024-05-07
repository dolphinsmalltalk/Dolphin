"Filed out from Dolphin Smalltalk"!

StaticViewTest subclass: #StaticIconTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StaticIconTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

StaticIconTest comment: ''!

!StaticIconTest categoriesForClass!Unclassified! !

!StaticIconTest methodsFor!

classToTest
	^StaticIcon!

oldDolphinVersionsForStbUpgrade
	^2 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view backcolor.
	self assertIsNil: view image!

vuFile
	^'ImagePresenter.Static icon.vu'! !

!StaticIconTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!StaticIconTest class methodsFor!

resource_Static_icon_D6
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(StaticIcon) 98 17 0 0 98 2 8 1149239555 1 416 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #== 98 0 562 8 #hash 98 0 0 0 0 7 0 0 0 416 0 8 4294906439 852486 ##(NullConverter) 0 0 32 0 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 850 241 221 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 125 0 0 0 115 0 0 0] 98 0 850 193 193 0 27)!

resource_Static_icon_D7
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticIcon) 34 17 nil nil 34 2 8 1149239555 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #== 8 #() 546 #hash 8 #() nil nil nil 7 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil false nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 11 11 786 241 221 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 125 0 0 0 115 0 0 0] 8 #() 786 193 193 nil 27 )! !

!StaticIconTest class categoriesForMethods!
resource_Static_icon_D6!public!resources-views! !
resource_Static_icon_D7!public!resources-views! !
!

