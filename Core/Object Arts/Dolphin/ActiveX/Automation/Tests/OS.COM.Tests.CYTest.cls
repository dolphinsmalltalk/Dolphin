"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.CYTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.CY private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CYTest guid: (Core.GUID fromString: '{f436bdf8-12ff-47e4-ad1a-c96795760912}')!

OS.COM.Tests.CYTest comment: ''!

!OS.COM.Tests.CYTest methodsFor!

testAsVariant
	{MaxValue. MaxValue negated. MinValue. 0. 1. -1. 1 / 4. 123.456s4} do: 
			[:each |
			| variant subject |
			subject := CY new value: each.
			variant := subject asVariant.
			self assert: variant value equals: subject.
			self assert: variant value value equals: (each asScaledDecimal: 4)]!

testByteSize
	self assert: CY byteSize equals: 8.
	self assert: CY new byteSize equals: 8!

testDisplayString
	| subject actual french |
	subject := CY maximum.
	french := Locale named: 'fr-FR'.
	actual := french writeStream
				display: subject;
				contents.
	self assert: actual equals: '922337203685477,5807'.
	subject := CY new value: 0s2.
	"Note that unlike DECIMAL, the minimum scale is used so the number prints like FP"
	self assert: subject displayString equals: '0'.
	subject := CY minimum.
	actual := french writeStream
				display: subject;
				contents.
	self assert: actual equals: '-922337203685477,5808'.
	subject := CY new value: 123.456s4.
	actual := french writeStream
				display: subject;
				contents.
	self assert: actual equals: '123,456'!

testMaximum
	| subject |
	subject := CY maximum.
	self assert: subject scale equals: 4.
	self assert: subject = MaxValue.
	self assert: subject hash equals: MaxValue hash.
	subject := CY new value: MaxValue negated.
	self assert: subject scale equals: 4.
	self assert: subject value equals: MaxValue negated.
	self
		should: [CY new value: MaxValue + 0.0001s]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: VMLibrary.PrimitiveInvalidParameter2)]!

testMinimum
	| subject |
	subject := CY minimum.
	self assert: subject scale equals: 4.
	self assert: subject value equals: MinValue.
	"Uses 2's complement integer representation, so absolute value of largest negative is one larger than largest positive"
	self
		should: [CY new value: MinValue negated]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: VMLibrary.PrimitiveInvalidParameter2)]!

testPrintString
	{ MaxValue. 0s4. MinValue.  -0.5s4. 123.456s4 } do: 
			[:each |
			| subject |
			subject := CY new value: each.
			self assert: subject printString equals: 'a COM.CY(<1p>)' << each]!

testValue
	"Test some simple values, and check in particular that the scale is preserved."

	| subject |
	subject := CY new.
	self assert: subject value equals: 0.
	self assert: subject value isKindOf: ScaledDecimal.
	self assert: subject value scale equals: 4.
	subject value: 123.456s.
	self assert: subject scale equals: 4.
	self assert: subject value equals: 123.456s.
	subject value: 123.4567s.
	self assert: subject value equals: 123.4567s.
	"If more precision provided than can be represented, the value is rounded to 4 decimal places"
	subject value: 123.45675s.
	self assert: subject value equals: 123.4568s.
	subject value: 123.45674s.
	self assert: subject value equals: 123.4567s! !

!OS.COM.Tests.CYTest categoriesForMethods!
testAsVariant!public!unit tests! !
testByteSize!public!unit tests! !
testDisplayString!public!unit tests! !
testMaximum!public!unit tests! !
testMinimum!public!unit tests! !
testPrintString!public!unit tests! !
testValue!public!unit tests! !
!

