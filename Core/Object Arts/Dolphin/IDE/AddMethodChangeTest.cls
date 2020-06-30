"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AddMethodChangeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddMethodChangeTest guid: (GUID fromString: '{08457a65-10d4-409d-93df-440bce0fac93}')!
AddMethodChangeTest comment: ''!
!AddMethodChangeTest categoriesForClass!Unclassified! !
!AddMethodChangeTest methodsFor!

changeClass
	^DolphinAddMethodChange!

testPrintOn
	| change |
	change := self changeClass
				compile: 'isAbstract ^false'
				in: AddMethodChangeTest class
				classified: 'testing'.
	self assert: change printString readStream nextLine
		equals: '!!AddMethodChangeTest class methodsFor: ''testing''!!'.
	#'1593'.
	change protocols: #().
	self assertIsNil: change protocol.
	self assert: change printString readStream nextLine
		equals: '!!AddMethodChangeTest class methodsFor: ''''!!'! !
!AddMethodChangeTest categoriesFor: #changeClass!public!unit tests! !
!AddMethodChangeTest categoriesFor: #testPrintOn!public!unit tests! !

