"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SliderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SliderTest guid: (GUID fromString: '{7befb3d7-8dc5-4dbb-92c2-7edaab76f305}')!

SliderTest comment: ''!

!SliderTest categoriesForClass!Unclassified! !

!SliderTest methodsFor!

classToTest
	^Slider!

testHasTicks
	presenter hasTicks: false.
	self deny: presenter hasTicks.
	self deny: presenter hasAutoTicks.
	presenter ticks: #().
	self deny: presenter hasTicks.
	self deny: presenter hasAutoTicks.
	presenter ticks: #(0 100).
	self assert: presenter hasTicks.
	self deny: presenter hasAutoTicks.
!

testRange
	| range |
	presenter hasAutoTicks: true.
	0 to: 5
		do: 
			[:start |
			start + 1 to: start + 10
				do: 
					[:stop |
					1 to: (stop - start) // 2
						do: 
							[:step |
							range := start to: stop by: step.
							presenter range: range.
							self assert: presenter range equals: range]]].
	"Empty range can be set, although only logically"
	presenter range: (1 to: 0).
	self assert: presenter range equals: (1 to: 0)!

verifyStbUpgrade: anInteger
	| notifications |
	notifications := super verifyStbUpgrade: anInteger.
	self assert: notifications single description
		equals: 'Deprecated message sent: <1p> from: <2p>'
				<< {Slider >> #selection:. MessageSendAbstract >> #value}.
	^#()!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view interactor identicalTo: view.
	self assert: view hasTicks.
	self assert: view tickStyle identicalTo: #bottom.
	anInteger < 10
		ifTrue: 
			[self assert: view typeconverter isNullConverter.
			self assert: view backcolor identicalTo: Color default.
			self deny: view hasAutoTicks.
			self assert: view range equals: (0 to: 100)]
		ifFalse: 
			[self assertIsNil: view backcolor.
			self assert: view hasAutoTicks.
			self assert: view range equals: (0 to: 100 by: 10)]! !

!SliderTest categoriesForMethods!
classToTest!helpers!private! !
testHasTicks!public!unit tests! !
testRange!public!unit tests! !
verifyStbUpgrade:!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

