"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AXEventSinkTest
	instanceVariableNames: 'sink object received'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AXEventSinkTest guid: (GUID fromString: '{cdbe5d5c-f0bc-4943-b0d4-2d5e7e6419ca}')!
AXEventSinkTest comment: ''!
!AXEventSinkTest categoriesForClass!Unclassified! !
!AXEventSinkTest methodsFor!

onAxEvent: aSymbol withArguments: anArray 

	received addLast: aSymbol -> (anArray collect: [:each | each copy])!

setUp
	| itf  analyzer |
	analyzer := TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip].
	itf := Smalltalk at: #TLATESTLibITestFireEvents
				ifAbsent: 
					[
					[
					(analyzer at: #ITestFireEvents) generate]
							on: Compiler errorClass
							do: [:ex | self assert: false description: ex description].
					Smalltalk at: #TLATESTLibITestFireEvents].
	sink := AXEventSink target: self sourceTypeInfo: (TestTypelib current analyzer at: '_DTestEvents').
	object := itf onCLSID: (CLSID fromString: '{B9C597B8-1712-4100-A470-A06D15D60CC2}').
	sink connect: object.
	sink triggerGenericEvent: true.
	self
		when: #axEvent:withArguments:
		send: #onAxEvent:withArguments:
		to: self.
	received := OrderedCollection new!

tearDown
	super tearDown.
	sink ifNotNil: [sink disconnect].
	object ifNotNil: [object free].
	received ifNotNil: [received do: [:each | each value free]].
	(MemoryManager current)
		collectGarbage;
		administerLastRites!

testNoArgs
	self assert: received isEmpty.
	object fire_NoArgs.
	self assert: received size = 1.
	self assert: received first key == #NoArgs.
	self assert: received first value = #()!

testOneArgs
	| repeat |
	self assert: received isEmpty.
	repeat := 5000.
	repeat timesRepeat: [object fire_OneVariant].
	self assert: received size = repeat.
	self 
		assert: (received allSatisfy: 
					[:each | 
					each key == #OneVariant: 
						and: [each value size = 1 and: [each value first asObject = #[0 1 2 3 4 5 6 7 8 9]]]])! !
!AXEventSinkTest categoriesFor: #onAxEvent:withArguments:!private!unit tests! !
!AXEventSinkTest categoriesFor: #setUp!public!unit tests! !
!AXEventSinkTest categoriesFor: #tearDown!public!unit tests! !
!AXEventSinkTest categoriesFor: #testNoArgs!public!unit tests! !
!AXEventSinkTest categoriesFor: #testOneArgs!public!unit tests! !

!AXEventSinkTest class methodsFor!

resources
	^Array with: TestTypelib! !
!AXEventSinkTest class categoriesFor: #resources!public!unit tests! !

