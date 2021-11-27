"Filed out from Dolphin Smalltalk"!

UI.Tests.ImageViewAbstractTest subclass: #'UI.Tests.ImageViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ImageViewTest guid: (Core.GUID fromString: '{5bcfc9d0-64df-43d8-93aa-787955bf0611}')!
UI.Tests.ImageViewTest comment: ''!
!UI.Tests.ImageViewTest categoriesForClass!Unclassified! !
!UI.Tests.ImageViewTest methodsFor!

classToTest
	^ImageView!

image
	| bitmap |
	bitmap := Bitmap fromFile: 'Resources\Beach Ball.bmp' usingLocator: FileLocator installRelative.
	self assert: bitmap handle notNull.
	bitmap free.
	^bitmap! !
!UI.Tests.ImageViewTest categoriesForMethods!
classToTest!helpers!private! !
image!private!Running! !
!

