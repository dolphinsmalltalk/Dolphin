"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AddMethodChangeTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddMethodChangeTest guid: (GUID fromString: '{08457a65-10d4-409d-93df-440bce0fac93}')!
AddMethodChangeTest comment: ''!
!AddMethodChangeTest categoriesForClass!Unclassified! !
!AddMethodChangeTest methodsFor!

changeClass
	^AddMethodChange!

testPrintOn
	| change |
	change := self changeClass 
				compile: 'isAbstract ^false'
				in: AddMethodChangeTest class
				classified: 'testing'.
	self assert: change printString readStream nextLine 
				= '!!AddMethodChangeTest class methodsFor: ''testing''!!'.
	#'1593'.
	change protocols: #().
	self assert: change protocol isNil.
	self 
		assert: change printString readStream nextLine = '!!AddMethodChangeTest class methodsFor: ''''!!'! !
!AddMethodChangeTest categoriesFor: #changeClass!public!unit tests! !
!AddMethodChangeTest categoriesFor: #testPrintOn!public!unit tests! !

