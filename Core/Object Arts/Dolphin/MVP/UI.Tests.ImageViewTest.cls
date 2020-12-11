"Filed out from Dolphin Smalltalk 7"!

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
	^Bitmap fromFile: 'Resources\IdeaSpaceBackdrop.bmp' usingLocator: FileLocator installRelative! !
!UI.Tests.ImageViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.ImageViewTest categoriesFor: #image!private!Running! !

