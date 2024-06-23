"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.CURRENCYTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CURRENCYTest guid: (Core.GUID fromString: '{f436bdf8-12ff-47e4-ad1a-c96795760912}')!

OS.COM.Tests.CURRENCYTest comment: ''!

!OS.COM.Tests.CURRENCYTest methodsFor!

testAsVariant
	{CURRENCY.MaxValue. CURRENCY.MaxValue negated. CURRENCY.MinValue. 0. 1. -1. 1 / 4. 123.456s4} do: 
			[:each |
			| variant subject |
			subject := CURRENCY new value: each.
			variant := subject asVariant.
			self assert: variant value equals: subject.
			self assert: variant value value equals: (each asScaledDecimal: 4)]!

testDisplayString
	| subject stream actual |
	subject := CURRENCY new value: CURRENCY.MaxValue.
	stream := String writeStream
				locale: (Locale named: 'fr-FR');
				yourself.
	actual := stream
				display: subject;
				contents.
	self assert: actual equals: '922337203685477,5807'.
	subject := CURRENCY new value: 0s2.
	"Note that unlike DECIMAL, the minimum scale is used so the number prints like FP"
	self assert: subject displayString equals: '0'.
	subject := CURRENCY new value: CURRENCY.MinValue.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '-922337203685477,5808'.
	subject := CURRENCY new value: 123.456s4.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '123,456'!

testMaxValue
	| subject |
	subject := CURRENCY new value: CURRENCY.MaxValue.
	self assert: subject scale equals: 4.
	self assert: subject value equals: CURRENCY.MaxValue.
	subject := CURRENCY new value: CURRENCY.MaxValue negated.
	self assert: subject scale equals: 4.
	self assert: subject value equals: CURRENCY.MaxValue negated.
	self
		should: [CURRENCY new value: CURRENCY.MaxValue + 0.0001s]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter2)]!

testMinValue
	| subject |
	subject := CURRENCY new value: CURRENCY.MinValue.
	self assert: subject scale equals: 4.
	self assert: subject value equals: CURRENCY.MinValue.
	"Uses 2's complement integer representation, so absolute value of largest negative is one larger than largest positive"
	self
		should: [CURRENCY new value: CURRENCY.MinValue negated]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter2)]!

testPrintString
	| subject |
	subject := CURRENCY new value: CURRENCY.MaxValue.
	self assert: subject printString equals: 'a COM.CURRENCY(<1p>)' << CURRENCY.MaxValue.
	subject := CURRENCY new value: 0.
	self assert: subject printString equals: 'a COM.CURRENCY(0.0000s)'.
	subject := CURRENCY new value: CURRENCY.MinValue.
	self assert: subject printString equals: 'a COM.CURRENCY(<1p>)' << CURRENCY.MinValue.
	subject := CURRENCY new value: 123.456s4.
	self assert: subject printString equals: 'a COM.CURRENCY(123.4560s)'!

testValue
	"Test some simple values, and check in particular that the scale is preserved."

	| subject value |
	subject := CURRENCY new.
	value := subject value.
	self assert: value equals: 0.
	self assert: value isKindOf: ScaledDecimal.
	self assert: value scale equals: 4.
	subject value: 123.456s.
	value := subject value.
	self assert: value equals: 123.456.
	self assert: value scale equals: 4.
	subject value: 123.4567s.
	value := subject value.
	self assert: value equals: 123.4567s.
	"If more precision provided than can be represented, the value is rounded to 4 decimal places"
	subject value: 123.45675s.
	value := subject value.
	self assert: value equals: 123.4568s.
	subject value: 123.45674s.
	value := subject value.
	self assert: value equals: 123.4567s! !

!OS.COM.Tests.CURRENCYTest categoriesForMethods!
testAsVariant!public!unit tests! !
testDisplayString!public!unit tests! !
testMaxValue!public!unit tests! !
testMinValue!public!unit tests! !
testPrintString!public!unit tests! !
testValue!public!unit tests! !
!

