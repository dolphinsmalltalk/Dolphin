"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Graphics.Tests.IconTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.IconTest guid: (Core.GUID fromString: '{96d9e7d9-8086-4706-b958-791a85a4e86c}')!
Graphics.Tests.IconTest comment: ''!
!Graphics.Tests.IconTest categoriesForClass!Unclassified! !
!Graphics.Tests.IconTest methodsFor!

testImageIndexDoesntRealize
	"A test for #2270. Ensure that #imageIndex won't realize an icon that has previously been added to an ImageManager"

	| icon |
	Object icon imageIndex.
	icon := Object icon.
	self assertIsNil: icon basicHandle.
	icon imageIndex.
	self assertIsNil: icon basicHandle! !
!Graphics.Tests.IconTest categoriesFor: #testImageIndexDoesntRealize!public! !

