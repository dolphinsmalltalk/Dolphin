"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #SliderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SliderTest guid: (GUID fromString: '{7BEFB3D7-8DC5-4DBB-92C2-7EDAAB76F305}')!
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
							self assert: presenter range = range]]]! !
!SliderTest categoriesFor: #classToTest!helpers!private! !
!SliderTest categoriesFor: #testRange!public!unit tests! !

