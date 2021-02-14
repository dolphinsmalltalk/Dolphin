"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.COM.Tests.EventSinkTest'
	instanceVariableNames: 'sink object received'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.EventSinkTest guid: (Core.GUID fromString: '{cdbe5d5c-f0bc-4943-b0d4-2d5e7e6419ca}')!
OS.COM.Tests.EventSinkTest comment: ''!
!OS.COM.Tests.EventSinkTest categoriesForClass!Unclassified! !
!OS.COM.Tests.EventSinkTest methodsFor!

onAxEvent: aSymbol withArguments: anArray 

	received addLast: aSymbol -> (anArray collect: [:each | each copy])!

setUp
	| itf analyzer |
	analyzer := TestTypelib current analyzer.
	analyzer isNil ifTrue: [self skip].
	itf := Smalltalk at: #TLATESTLibITestFireEvents
				ifAbsent: 
					[[(analyzer at: #ITestFireEvents) generate] on: Compiler errorClass
						do: [:ex | self assert: false description: ex description].
					Smalltalk at: #TLATESTLibITestFireEvents].
	sink := EventSink target: self
				sourceTypeInfo: (TestTypelib current analyzer at: '_DTestEvents').
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
!OS.COM.Tests.EventSinkTest categoriesFor: #onAxEvent:withArguments:!private!unit tests! !
!OS.COM.Tests.EventSinkTest categoriesFor: #setUp!public!unit tests! !
!OS.COM.Tests.EventSinkTest categoriesFor: #tearDown!public!unit tests! !
!OS.COM.Tests.EventSinkTest categoriesFor: #testNoArgs!public!unit tests! !
!OS.COM.Tests.EventSinkTest categoriesFor: #testOneArgs!public!unit tests! !

!OS.COM.Tests.EventSinkTest class methodsFor!

resources
	^{TestTypelib}! !
!OS.COM.Tests.EventSinkTest class categoriesFor: #resources!public!unit tests! !

