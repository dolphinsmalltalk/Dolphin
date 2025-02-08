"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.RandomTest'
	instanceVariableNames: 'gen'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.RandomTest guid: (Core.GUID fromString: '{e7d2feed-3b86-4c49-a1ef-784f24c9007b}')!

Core.Tests.RandomTest comment: ''!

!Core.Tests.RandomTest methodsFor!

assert: rng generates: anArray epsilon: aFloat 
	anArray do: 
			[:expected | 
			| next |
			self assert: (rng peek equals: rng peek).
			self assert: (self 
						compare: rng peek
						to: expected
						epsilon: aFloat).
			next := rng next.
			self assert: (self 
						compare: next
						to: expected
						epsilon: aFloat)]!

expectedAnsiProtocolNames
	^#(#gettableStream #Object)!

newStream
	^Random new!

setUp
	super setUp.
	gen := Random seed: 112629!

testCRT
	| crt expected subject |
	crt := #{OS.RandomCRT} valueOrNil.
	crt isNil ifTrue: [self skip: 'RandomCRT class not present to test'].
	expected := #(41 18467 6334 26500 19169 15724 11478 29358 26962 24464)
				collect: [:each | each / ((OS.CRTConstants at: 'RAND_MAX') + 1.0)].
	subject := crt seed: 1.
	self
		assert: subject
		generates: expected
		epsilon: 1.0e-10.
	self deny: (subject peekFor: Object new).
	self deny: (subject peekFor: 0.17410278).
	self assert: (subject peekFor: 0.174102783).
	self deny: (subject peekFor: 0.174102783).
	self assert: (subject peekFor: 0.858917236)!

testLCG
	| subject lcg |
	lcg := #{RandomLinearCongruential} valueOrNil.
	lcg isNil ifTrue: [self skip: 'RandomLinearCongruential class not present to test'].
	subject := (lcg
				newModulus: 31
				multiplier: 13
				increment: 0)
				seed: 1;
				yourself.
	#(0.4194 0.4516 0.8710 0.3226 0.1935 0.5161) do: 
			[:expected |
			| next |
			self assert: (subject peek equals: subject peek).
			self assert: ((subject peek roundTo: 1.0e-4) equals: expected).
			next := subject next.
			self assert: ((next roundTo: 1.0e-4) equals: expected)].
	self deny: (subject peekFor: Object new).
	self deny: (subject peekFor: 0.709).
	self assert: (subject peekFor: 0.7096774193548387).
	self deny: (subject peekFor: 0.7096774193548387).
	self assert: (subject peekFor: 0.2258064516)!

testNext
	10000 timesRepeat: 
			[| next |
			next := gen next.
			self assert: next >= 0.
			self assert: next < 1]!

testParkMiller
	| subject |
	subject := Random new
				seed: 2345678901;
				yourself.
	self
		assert: subject
		generates: #(0.1492432697 0.3316330217 0.7561964480 0.3937015400 0.9417831814 0.5499291939 0.6599625962 0.9913545591 0.6960744326 0.9229878997)
		epsilon: 1.0e-9.
	self deny: (subject peekFor: Object new).
	self deny: (subject peekFor: 0.17410278).
	self assert: (subject peekFor: 0.657630378).
	self deny: (subject peekFor: 0.657630378).
	self assert: (subject peekFor: 0.793766760)! !

!Core.Tests.RandomTest categoriesForMethods!
assert:generates:epsilon:!helpers!private! !
expectedAnsiProtocolNames!constants!private! !
newStream!public! !
setUp!public!setup! !
testCRT!public!unit tests! !
testLCG!public!unit tests! !
testNext!public!testing / accessing! !
testParkMiller!public!unit tests! !
!

!Core.Tests.RandomTest class methodsFor!

streamClass
	^Random! !

!Core.Tests.RandomTest class categoriesForMethods!
streamClass!private! !
!

