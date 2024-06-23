"Filed out from Dolphin Smalltalk"!

TestCase subclass: #IconWithExtentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IconWithExtentTest guid: (GUID fromString: '{85e0b80b-0faa-4b3a-b790-ec85893aa5a2}')!

IconWithExtentTest comment: ''!

!IconWithExtentTest categoriesForClass!SUnit! !

!IconWithExtentTest methodsFor!

testStbConvertFromVersion3
	| rehydrated |
	rehydrated := (Object fromLiteralStoreArray: #(#'!!STL' 4 919110 3 ##(Smalltalk.IconWithExtent) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Collection.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil 328198 ##(Smalltalk.Point) 49 49)).
	self assert: rehydrated extent equals: 24@24
! !

!IconWithExtentTest categoriesForMethods!
testStbConvertFromVersion3!public! !
!

