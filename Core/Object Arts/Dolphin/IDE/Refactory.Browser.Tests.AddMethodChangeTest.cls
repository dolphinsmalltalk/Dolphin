"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Refactory.Browser.Tests.AddMethodChangeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddMethodChangeTest guid: (Core.GUID fromString: '{08457a65-10d4-409d-93df-440bce0fac93}')!
Refactory.Browser.Tests.AddMethodChangeTest comment: ''!
!Refactory.Browser.Tests.AddMethodChangeTest categoriesForClass!Unclassified! !
!Refactory.Browser.Tests.AddMethodChangeTest methodsFor!

changeClass
	^DolphinAddMethodChange!

testPrintOn
	| change |
	change := self changeClass
				compile: 'isAbstract ^false'
				in: Refactory.Browser.Tests.AddMethodChangeTest class
				classified: 'testing'.
	self assert: change printString readStream nextLine
		equals: '!!Refactory.Browser.Tests.AddMethodChangeTest class methodsFor: ''testing''!!'.
	#'1593'.
	change protocols: #().
	self assertIsNil: change protocol.
	self assert: change printString readStream nextLine
		equals: '!!Refactory.Browser.Tests.AddMethodChangeTest class methodsFor: ''''!!'! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesFor: #changeClass!public!unit tests! !
!Refactory.Browser.Tests.AddMethodChangeTest categoriesFor: #testPrintOn!public!unit tests! !

