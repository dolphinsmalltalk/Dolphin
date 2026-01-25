"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.CYArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CYArrayTest guid: (Core.GUID fromString: '{662dc165-8535-41e8-a7b8-b12c0905e505}')!

OS.COM.Tests.CYArrayTest comment: ''!

!OS.COM.Tests.CYArrayTest class methodsFor!

arrayClass
	^CYArray!

elementFromIndex: anInteger
	^##({
		0s4.
		CY.MinValue.
		CY.MaxValue.
		1.1234s.
		-1.234s.
		3.75s4
	}) at: anInteger! !

!OS.COM.Tests.CYArrayTest class categoriesForMethods!
arrayClass!private! !
elementFromIndex:!private!unit tests! !
!

