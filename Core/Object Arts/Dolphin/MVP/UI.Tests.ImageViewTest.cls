"Filed out from Dolphin Smalltalk"!

UI.Tests.ImageViewAbstractTest
	subclass: #'UI.Tests.ImageViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ImageViewTest guid: (Core.GUID fromString: '{5bcfc9d0-64df-43d8-93aa-787955bf0611}')!
UI.Tests.ImageViewTest comment: ''!
!UI.Tests.ImageViewTest methodsFor!

classToTest
	^ImageView!

image
	| bitmap |
	bitmap := Bitmap fromFile: 'Resources\Beach Ball.bmp' usingLocator: FileLocator installRelative.
	self assert: bitmap handle notNull.
	bitmap free.
	^bitmap!

oldDolphinVersionsForStbUpgrade
	^2 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor equals: Color default.
	self assert: view interactor identicalTo: view.
	self assert: view viewMode identicalTo: #scaleToFit!

vuFile
	^'ImagePresenter.Basic image.vu'! !
!UI.Tests.ImageViewTest categoriesForMethods!
classToTest!helpers!private! !
image!private!Running! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ImageViewTest class methodsFor!

resource_Basic_image_D6
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ImageView) 98 21 0 0 98 2 8 1140850944 1 416 721990 2 ##(ValueHolder) 0 0 1376774 ##(PluggableSearchPolicy) 459270 ##(Message) 8 #= 98 0 562 8 #hash 98 0 0 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903431 852486 ##(NullConverter) 0 0 0 0 8 #scaleToFit 1 0 0 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 914 225 201 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 117 0 0 0 105 0 0 0] 98 0 914 193 193 0 27)!

resource_Basic_image_D7
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ImageView) 34 21 nil nil 34 2 8 1140850944 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1376774 ##(Smalltalk.PluggableSearchPolicy) 459270 ##(Smalltalk.Message) #= 8 #() 546 #hash 8 #() nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 4294903431 852486 ##(Smalltalk.NullConverter) nil nil nil nil #scaleToFit 1 nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 818 225 201 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 239 7 0 0 110 0 0 0] 8 #() 818 193 193 nil 27)! !
!UI.Tests.ImageViewTest class categoriesForMethods!
resource_Basic_image_D6!public!resources-views! !
resource_Basic_image_D7!public!resources-views! !
!

