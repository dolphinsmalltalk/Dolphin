"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.DECIMALTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.AutomationConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DECIMALTest guid: (Core.GUID fromString: '{f436bdf8-12ff-47e4-ad1a-c96795760912}')!

OS.COM.Tests.DECIMALTest comment: ''!

!OS.COM.Tests.DECIMALTest methodsFor!

testAsVariant
	{DECIMAL.MaxValue.
		DECIMAL.MaxValue negated.
		DECIMAL.SmallestValue.
		DECIMAL.SmallestValue negated.
		123.456s4} do: 
				[:each |
				| variant subject |
				subject := DECIMAL new value: each.
				variant := subject asVariant.
				self assert: variant value equals: subject.
				self assert: variant value value equals: each]!

testDisplayString
	| subject stream actual |
	subject := DECIMAL new value: DECIMAL.MaxValue.
	stream := String writeStream
				locale: (Locale named: 'fr-FR');
				yourself.
	actual := stream
				display: subject;
				contents.
	self assert: actual equals: DECIMAL.MaxValue printString.
	subject := DECIMAL new value: 0.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '0'.
	subject scale: DECIMAL.MaxScale.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '0'.
	subject := DECIMAL new value: DECIMAL.SmallestValue.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '0,' , (String new: DECIMAL.MaxScale - 1 withAll: $0) , '1'.
	subject := DECIMAL new value: 123.456s4.
	self assert: subject value equals: 123.456.
	actual := stream
				reset;
				display: subject;
				contents.
	self assert: actual equals: '123,456'!

testMaxValue
	| subject |
	subject := DECIMAL new value: DECIMAL.MaxValue.
	self assert: subject scale equals: 0.
	self assert: subject sign equals: 0.
	self assert: subject value equals: DECIMAL.MaxValue.
	subject scale: DECIMAL.MaxScale.
	self assert: subject value
		equals: (DECIMAL.MaxValue / DECIMAL.MaxScale exp10 asScaledDecimal: DECIMAL.MaxScale).
	"Sign is held separately, so min and max values have the same magnitude"
	subject := DECIMAL new value: DECIMAL.MaxValue negated.
	self assert: subject scale equals: 0.
	self assert: subject value equals: DECIMAL.MaxValue negated.
	self assert: subject sign equals: -1.
	subject scale: DECIMAL.MaxScale.
	self assert: subject value
		equals: (DECIMAL.MaxValue / DECIMAL.MaxScale exp10 asScaledDecimal: DECIMAL.MaxScale) negated.
	self
		should: [DECIMAL new value: DECIMAL.MaxValue + 1]
		raise: HRESULTError
		matching: [:ex | ex hresult = (HRESULT fromPrimitiveFailureCode: _PrimitiveFailureCode.InvalidParameter2)]!

testPrintString
	| subject |
	subject := DECIMAL new value: DECIMAL.MaxValue.
	self assert: subject printString equals: 'a COM.DECIMAL(<1p>s)' << DECIMAL.MaxValue.
	subject := DECIMAL new value: 0.
	self assert: subject printString equals: 'a COM.DECIMAL(0s)'.
	subject := DECIMAL new value: 0s2.
	self assert: subject printString equals: 'a COM.DECIMAL(0.00s)'.
	subject scale: DECIMAL.MaxScale.
	self assert: subject printString
		equals: 'a COM.DECIMAL(0.<1s>s)' << (String new: DECIMAL.MaxScale withAll: $0).
	subject := DECIMAL new value: DECIMAL.SmallestValue.
	self assert: subject printString equals: 'a COM.DECIMAL(<1p>)' << DECIMAL.SmallestValue.
	subject := DECIMAL new value: 123.456s4.
	self assert: subject printString equals: 'a COM.DECIMAL(123.4560s)'!

testSmallestValue
	| subject value |
	subject := DECIMAL new value: DECIMAL.SmallestValue.
	self assert: subject scale equals: DECIMAL.MaxScale.
	self assert: subject sign equals: 0.
	value := subject value.
	self assert: value equals: DECIMAL.SmallestValue.
	self assert: value scale equals: DECIMAL.MaxScale.
	subject := DECIMAL new value: DECIMAL.SmallestValue negated.
	self assert: subject scale equals: DECIMAL.MaxScale.
	value := subject value.
	self assert: value equals: DECIMAL.SmallestValue negated.
	self assert: value scale equals: DECIMAL.MaxScale.
	self assert: subject sign equals: -1.
	self
		should: 
			[DECIMAL new value: (DECIMAL.SmallestValue asFraction / 10 asScaledDecimal: DECIMAL.MaxScale + 1)]
		raise: InvalidArgumentError
		matching: 
			[:ex |
			ex description = ('Invalid argument ''anInteger'': Scale <1p> is outside permitted range 0..<2p>'
						<< {DECIMAL.MaxScale + 1. DECIMAL.MaxScale})]!

testValue
	"Test some simple values, and check in particular that the scale is preserved."

	| subject value |
	subject := DECIMAL new.
	subject scale: 5.
	value := subject value.
	self assert: value equals: 0.
	self assert: value isKindOf: ScaledDecimal.
	self assert: value scale equals: 5.
	subject value: 123.456s4.
	value := subject value.
	self assert: value equals: 123.456.
	self assert: value scale equals: 4! !

!OS.COM.Tests.DECIMALTest categoriesForMethods!
testAsVariant!public!unit tests! !
testDisplayString!public!unit tests! !
testMaxValue!public!unit tests! !
testPrintString!public!unit tests! !
testSmallestValue!public!unit tests! !
testValue!public!unit tests! !
!

