"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.ObjectTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ObjectTest guid: (Core.GUID fromString: '{0699f873-06b5-439d-adcb-6642d40c7360}')!
Core.Tests.ObjectTest comment: ''!
!Core.Tests.ObjectTest categoriesForClass!Unclassified! !
!Core.Tests.ObjectTest methodsFor!

newEventSource
	^Object new!

testAssert
	self shouldnt: [Object assert: [true]] raise: Error.
	self should: [Object assert: true] raise: MessageNotUnderstood.
	self should: [Object assert: [false]] raise: Error.
	self should: [Object assert: false] raise: MessageNotUnderstood!

testBecome
	| a b aIdHash bIdHash aHash bHash c |
	a := {1}.
	b := {2}.
	c := a.
	aHash := a hash.
	bHash := b hash.
	self deny: aHash equals: bHash.
	aIdHash := a identityHash.
	bIdHash := b identityHash.
	self deny: aIdHash equals: bIdHash.
	a become: b.
	"Referenced values are swapped - collections hashed by value will be broken"
	self assert: a equals: {2}.
	self assert: b equals: {1}.
	self assert: a hash equals: bHash.
	self assert: b hash equals: aHash.
	"c is still referencing the exact same thing as a, even though it is now the former b"
	self assert: c identicalTo: a.
	"But crucially identity is preserved. This is important, for example, so that identity-hashed collections are not broken by become:"
	self assert: a identityHash equals: aIdHash.
	self assert: b identityHash equals: bIdHash!

testDeepCopy
	"#2198"

	| ast copy |
	ast := Object parseTreeFor: #deepCopy.
	copy := ast deepCopy.
	self assert: copy equals: ast!

testEventCollectionWeakness
	| source target |
	source := self newEventSource.
	target := Object new.
	source when: #error: sendTo: target.
	self
		should: [source trigger: #error: with: 'goo goo ga ga']
		raise: Error
		matching: [:ex | ex messageText = 'goo goo ga ga'].
	target := nil.
	MemoryManager current collectGarbage.
	self shouldnt: [source trigger: #error: with: 'ignored'] raise: Error.
	self assert: (source events at: #error:) isEmpty!

testIfNilAndIfNotNil
	| obj evaluated |
	obj := Object new.
	evaluated := false.
	self assert: (obj ifNil: [evaluated := true]) identicalTo: obj.
	self assert: evaluated not.
	evaluated := false.
	self assert: (obj
				ifNotNil: 
					[:a |
					evaluated := true.
					a class name])
		identicalTo: #Object.
	self assert: evaluated.
	evaluated := false.
	self assert: (nil
				ifNil: 
					[evaluated := true.
					1])
		identicalTo: 1.
	self assert: evaluated.
	evaluated := false.
	self assertIsNil: (nil
				ifNotNil: 
					[:a |
					evaluated := true.
					a class name]).
	self assert: evaluated not!

testNilCoalesce
	| obj1 obj2 |
	obj1 := Object new.
	obj2 := Object new.
	self assert: obj1 ?? obj2 identicalTo: obj1.
	obj1 := nil.
	self assert: obj1 ?? obj2 identicalTo: obj2!

testObjectDependentsRegistry
	self verifyWeakRegistry: _DependentsRegister.
	_DependentsRegister keysAndValuesDo: [:key :value | self assert: value isWeak]!

testObjectEventRegistry
	self verifyWeakRegistry: _EventsRegister!

testObjectPropertyManager
	| subject |
	subject := Object._PropertyRegister.
	self assert: subject register hasWeakKeys.
	self deny: subject register hasWeakValues!

testOneArgEvent
	| source |
	source := self newEventSource.
	"One arg case - args at trigger time replace those registered by when:send:to:with:etc"
	self 
		should: [source trigger: #testOneArg:]
		trigger: #testOneArg:
		matching: [:arg | arg isNil]
		against: source.
	self 
		should: [source trigger: #testOneArg: with: 1]
		trigger: #testOneArg:
		matching: [:arg | arg = 1]
		against: source.
	self 
		should: 
			[source 
				trigger: #testOneArg:
				with: 1
				with: 2]
		trigger: #testOneArg:
		matching: [:arg | arg = 1]
		against: source.
	self 
		should: [source trigger: #testOneArg: withArguments: #()]
		trigger: #testOneArg:
		matching: [:arg | arg isNil]
		against: source.
	self 
		should: [source trigger: #testOneArg: withArguments: #(1)]
		trigger: #testOneArg:
		matching: [:arg | arg = 1]
		against: source.
	self 
		should: [source trigger: #testOneArg: withArguments: #(1 2)]
		trigger: #testOneArg:
		matching: [:arg | arg = 1]
		against: source.
	self 
		should: [source trigger: #testOneArg: withArguments: #(1 2 3)]
		trigger: #testOneArg:
		matching: [:arg | arg = 1]
		against: source!

testRemoveEventsTriggeredFor
	| objectA objectB objectC |
	objectA := Object new.
	objectB := Object new.
	objectC := Object new.
	1 to: 50 do: [:each | objectA when: (#x , each displayString) asSymbol sendTo: objectB].
	(1 to: 50 by: 2) do: [:each | objectA when: (#x , each displayString) asSymbol sendTo: objectC].
	self assert: objectA events size equals: 50.
	objectA removeEventsTriggeredFor: objectB.
	self assert: objectA events size equals: 25.
	objectA removeEventsTriggeredFor: objectC.
	self assert: objectA events size equals: 0!

testThreeArgEvent
	| source |
	source := self newEventSource.
	"Three arg case - args at trigger time replace those registered by when:send:to:with:etc"
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3:]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 isNil & arg2 isNil & arg3 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: with: 1]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & arg2 isNil & arg3 isNil]
		against: source.
	self 
		should: 
			[source 
				trigger: #testTwoArgs:arg2:arg3:
				with: 1
				with: 2]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & (arg2 = 2) & arg3 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: withArguments: #()]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 isNil & arg2 isNil & arg3 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: withArguments: #(1)]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & arg2 isNil & arg3 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: withArguments: #(1 2)]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & (arg2 = 2) & arg3 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: withArguments: #(1 2 3)]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & (arg2 = 2) & (arg3 = 3)]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2:arg3: withArguments: #(1 2 3 4)]
		trigger: #testTwoArgs:arg2:arg3:
		matching: [:arg1 :arg2 :arg3 | arg1 = 1 & (arg2 = 2) & (arg3 = 3)]
		against: source!

testTwoArgEvent
	| source |
	source := self newEventSource.
	"Two arg case - args at trigger time replace those registered by when:send:to:with:etc"
	self 
		should: [source trigger: #testTwoArgs:arg2:]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 isNil & arg2 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2: with: 1]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 = 1 & arg2 isNil]
		against: source.
	self 
		should: 
			[source 
				trigger: #testTwoArgs:arg2:
				with: 1
				with: 2]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 = 1 & (arg2 = 2)]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2: withArguments: #()]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 isNil & arg2 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2: withArguments: #(1)]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 = 1 & arg2 isNil]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2: withArguments: #(1 2)]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 = 1 & (arg2 = 2)]
		against: source.
	self 
		should: [source trigger: #testTwoArgs:arg2: withArguments: #(1 2 3)]
		trigger: #testTwoArgs:arg2:
		matching: [:arg1 :arg2 | arg1 = 1 & (arg2 = 2)]
		against: source!

testZeroArgEvent
	| source |
	source := self newEventSource.
	self 
		should: [source trigger: #testNoArgs]
		trigger: #testNoArgs
		against: source.
	self 
		should: [source trigger: #testNoArgs with: 1]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source.
	self 
		should: 
			[source 
				trigger: #testNoArgs
				with: 1
				with: 2]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source.
	self 
		should: [source trigger: #testNoArgs withArguments: #()]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source.
	self 
		should: [source trigger: #testNoArgs withArguments: #(1)]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source.
	self 
		should: [source trigger: #testNoArgs withArguments: #(1 2)]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source.
	self 
		should: [source trigger: #testNoArgs withArguments: #(1 2 3)]
		trigger: #testNoArgs
		matching: 
			["zero args expected"

			true]
		against: source!

verifyWeakRegistry: aWeakIdentitDictionary
	self assert: aWeakIdentitDictionary countElements equals: aWeakIdentitDictionary size.
	self assert: aWeakIdentitDictionary hasWeakKeys.
	self deny: aWeakIdentitDictionary hasWeakValues! !
!Core.Tests.ObjectTest categoriesFor: #newEventSource!helpers!private! !
!Core.Tests.ObjectTest categoriesFor: #testAssert!public!testing / error handling! !
!Core.Tests.ObjectTest categoriesFor: #testBecome!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testDeepCopy!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testEventCollectionWeakness!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testIfNilAndIfNotNil!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testNilCoalesce!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testObjectDependentsRegistry!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testObjectEventRegistry!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testObjectPropertyManager!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testOneArgEvent!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testRemoveEventsTriggeredFor!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testThreeArgEvent!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testTwoArgEvent!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #testZeroArgEvent!public!unit tests! !
!Core.Tests.ObjectTest categoriesFor: #verifyWeakRegistry:!public!unit tests! !

