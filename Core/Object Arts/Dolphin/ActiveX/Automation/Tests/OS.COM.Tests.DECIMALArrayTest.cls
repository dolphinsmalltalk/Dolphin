"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.DECIMALArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DECIMALArrayTest guid: (Core.GUID fromString: '{662dc165-8535-41e8-a7b8-b12c0905e505}')!

OS.COM.Tests.DECIMALArrayTest comment: ''!

!OS.COM.Tests.DECIMALArrayTest class methodsFor!

arrayClass
	^DECIMALArray!

elementFromIndex: anInteger
	^##({
		0s.
		DECIMAL.MaxValue asScaledDecimal: 0.
		DECIMAL.SmallestValue.
		0s28.
		1.375s.
		-2.125s
	}) at: anInteger

! !

!OS.COM.Tests.DECIMALArrayTest class categoriesForMethods!
arrayClass!private! !
elementFromIndex:!private!unit tests! !
!

