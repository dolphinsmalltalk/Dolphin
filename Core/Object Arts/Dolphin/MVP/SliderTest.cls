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
							self assert: presenter range equals: range]]]! !
!SliderTest categoriesForMethods!
classToTest!helpers!private! !
testRange!public!unit tests! !
!

