"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.WINDOWPLACEMENTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.WINDOWPLACEMENTTest guid: (Core.GUID fromString: '{f7f9b37b-2bd2-4de5-b3d8-8c238e5c1e21}')!

OS.Tests.WINDOWPLACEMENTTest comment: ''!

!OS.Tests.WINDOWPLACEMENTTest methodsFor!

testGeometry
	| subject |
	subject := WINDOWPLACEMENT
				fromBytes: #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 236 6 0 0 4 0 0 0 1 8 0 0 37 0 0 0].
	self assert: subject origin equals: 1772 @ 4.
	self assert: subject corner equals: 2049 @ 37.
	self assert: subject width equals: 277.
	self assert: subject height equals: 33.
	subject height: 51.
	self assert: subject height equals: 51.
	self assert: subject width equals: 277.
	self assert: subject origin equals: 1772 @ 4.
	self assert: subject corner equals: 2049 @ 55.
	subject width: 177.
	self assert: subject width equals: 177.
	self assert: subject height equals: 51.
	self assert: subject origin equals: 1772 @ 4.
	self assert: subject corner equals: 1949 @ 55.
	subject position: 100 @ 200.
	self assert: subject origin equals: 100 @ 200.
	self assert: subject width equals: 177.
	self assert: subject height equals: 51.
	self assert: subject corner equals: 277 @ 251! !

!OS.Tests.WINDOWPLACEMENTTest categoriesForMethods!
testGeometry!public! !
!

