"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #IconTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IconTest guid: (GUID fromString: '{96d9e7d9-8086-4706-b958-791a85a4e86c}')!
IconTest comment: ''!
!IconTest categoriesForClass!Unclassified! !
!IconTest methodsFor!

testImageIndexDoesntRealize
	"A test for #2270. Ensure that #imageIndex won't realize an icon that has previously been added to an ImageManager"

	| icon |
	Object icon imageIndex.
	icon := Object icon.
	self assert: icon basicHandle isNil.
	icon imageIndex.
	self assert: icon basicHandle isNil! !
!IconTest categoriesFor: #testImageIndexDoesntRealize!public! !

