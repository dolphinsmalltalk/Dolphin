"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest subclass: #'External.Tests.FLOATArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.FLOATArrayTest guid: (Core.GUID fromString: '{fa2c5d39-ea1c-431f-8a0d-f4fe888c1305}')!
External.Tests.FLOATArrayTest comment: ''!
!External.Tests.FLOATArrayTest methodsFor!

arrayClass
	^FLOATArray!

elementFromValue: anObject 
	^anObject asFloat!

numericElementClass
	^FLOAT!

testDisplayString
	"We expect at most 6 significant figures for the elements because this is the maximum decimal precision that can we round trip to a string."

	| subject expr expected |
	subject := FLOATArray
				withAll: #(0.1 1.2 1.23 12.34 123.456 1234.567 12345.678 123456.789 1234567.089).
	expr := subject displayString.
	expected := Locale default listSeparator , ' '
				join: #('(0.1' '1.2' '1.23' '12.34' '123.456' '1234.57' '12345.7' '123457.0' '1234570.0)').
	self assert: expr equals: expected!

testPrintString
	"We expect at most 9 significant figures for the elements because this is the number we have to print to get a self-evaluable result"

	| subject expr |
	subject := FLOATArray
				withAll: #(0.1 1.2 1.23 12.34 123.456 1234.567 12345.678 123456.789 1234567.089).
	expr := subject printString.
	self assert: expr
		equals: '(FLOATArray withAll: #(0.100000001 1.20000005 1.23000002 12.3400002 123.456001 1234.56702 12345.6777 123456.789 1234567.13))'.
	self assert: (Compiler evaluate: expr) equals: subject! !
!External.Tests.FLOATArrayTest categoriesForMethods!
arrayClass!constants!private! !
elementFromValue:!private!unit tests! !
numericElementClass!constants!private! !
testDisplayString!public! !
testPrintString!public! !
!

