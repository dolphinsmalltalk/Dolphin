"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.SliderTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SliderTest guid: (Core.GUID fromString: '{7befb3d7-8dc5-4dbb-92c2-7edaab76f305}')!
UI.Tests.SliderTest comment: ''!
!UI.Tests.SliderTest categoriesForClass!Unclassified! !
!UI.Tests.SliderTest methodsFor!

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
!UI.Tests.SliderTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.SliderTest categoriesFor: #testRange!public!unit tests! !

