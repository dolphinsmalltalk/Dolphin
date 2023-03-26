"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.SliderTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SliderTest guid: (Core.GUID fromString: '{7befb3d7-8dc5-4dbb-92c2-7edaab76f305}')!
UI.Tests.SliderTest comment: ''!
!UI.Tests.SliderTest methodsFor!

classToTest
	^Slider!

oldDolphinVersionsForStbUpgrade
	^#(4)!

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
							self assert: presenter range equals: range]]]!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
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
			self assert: view range equals: (0 to: 100 by: 10)]!

vuFile
	^'NumberPresenter.Slider view.vu'! !
!UI.Tests.SliderTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
testRange!public!unit tests! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

