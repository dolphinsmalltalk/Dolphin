"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'External.Tests.FLOATArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Tests.FLOATArrayTest guid: (Core.GUID fromString: '{fa2c5d39-ea1c-431f-8a0d-f4fe888c1305}')!

External.Tests.FLOATArrayTest comment: ''!

!External.Tests.FLOATArrayTest methodsFor!

testDisplayString
	"We expect at most 6 significant figures for the elements because this is the maximum decimal precision that can we round trip to a string."

	| subject expr expected |
	subject := FLOATArray
				withAll: #(0.1 1.2 1.23 12.34 123.456 1234.567 12345.678 123456.789 1234567.089).
	expr := subject displayString.
	expected := Locale default listSeparator , ' '
				join: #('(0.1' '1.2' '1.23' '12.34' '123.456' '1234.57' '12345.7' '123457.0' '1234570.0)').
	self assert: expr equals: expected! !

!External.Tests.FLOATArrayTest categoriesForMethods!
testDisplayString!public!unit tests! !
!

!External.Tests.FLOATArrayTest class methodsFor!

arrayClass
	^FLOATArray!

elementFromIndex: anInteger
	^##({ 0.0. 1.25. Float infinity. Float negativeInfinity. FLOAT maximum value. FLOAT minimum value}) at: anInteger! !

!External.Tests.FLOATArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

