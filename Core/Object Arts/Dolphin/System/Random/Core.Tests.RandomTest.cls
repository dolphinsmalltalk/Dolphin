"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.RandomTest'
	instanceVariableNames: 'gen'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.RandomTest guid: (Core.GUID fromString: '{e7d2feed-3b86-4c49-a1ef-784f24c9007b}')!
Core.Tests.RandomTest comment: ''!
!Core.Tests.RandomTest categoriesForClass!Unclassified! !
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

setUp
	gen := Random seed: 112629!

testCRT
	| rnd |
	rnd := #{RandomCRT} valueOrNil.
	rnd isNil ifTrue: [self skip: 'RandomCRT class not present to test'].
	self 
		assert: (rnd seed: 1)
		generates: (#(41 18467 6334 26500 19169 15724 11478 29358 26962 24464) 
				collect: [:each | each / ((OS.CRTConstants at: 'RAND_MAX') + 1.0)])
		epsilon: 1.0e-10!

testLCG
	| rng rnd |
	rnd := #{RandomLinearCongruential} valueOrNil.
	rnd isNil ifTrue: [self skip: 'RandomLinearCongruential class not present to test'].
	rng := (rnd 
				newModulus: 31
				multiplier: 13
				increment: 0)
				seed: 1;
				yourself.
	#(0.4194 0.4516 0.8710 0.3226 0.1935 0.5161) do: 
			[:expected | 
			| next |
			self assert: (rng peek equals: rng peek).
			self assert: ((rng peek roundTo: 1.0e-4) equals: expected).
			next := rng next.
			self assert: ((next roundTo: 1.0e-4) equals: expected)]!

testNext
	10000 timesRepeat: 
			[| next |
			next := gen next.
			self assert: next >= 0.
			self assert: next < 1]!

testParkMiller
	self 
		assert: (Random new
				seed: 2345678901;
				yourself)
		generates: #(0.1492432697 0.3316330217 0.7561964480 0.3937015400 0.9417831814 0.5499291939 0.6599625962 0.9913545591 0.6960744326 0.9229878997)
		epsilon: 1.0e-9! !
!Core.Tests.RandomTest categoriesFor: #assert:generates:epsilon:!helpers!private! !
!Core.Tests.RandomTest categoriesFor: #setUp!public!setup! !
!Core.Tests.RandomTest categoriesFor: #testCRT!public!unit tests! !
!Core.Tests.RandomTest categoriesFor: #testLCG!public!unit tests! !
!Core.Tests.RandomTest categoriesFor: #testNext!public!testing / accessing! !
!Core.Tests.RandomTest categoriesFor: #testParkMiller!public!unit tests! !

