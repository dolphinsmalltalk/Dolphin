"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.DATEArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.DATEArrayTest guid: (Core.GUID fromString: '{4f0cc47f-b29c-4ea5-9d71-862c2a5125ce}')!

OS.COM.Tests.DATEArrayTest comment: ''!

!OS.COM.Tests.DATEArrayTest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: 'a <1p>(<2p> <3p> <4p> <5p> <6p> <7p>)'
				<< ({ self arrayClass } , ((1 to: 6) collect: [:i | self canonicalizeValue: i])).
	^self! !

!OS.COM.Tests.DATEArrayTest categoriesForMethods!
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.DATEArrayTest class methodsFor!

arrayClass
	^DATEArray!

elementFromIndex: anInteger
	^##({
		DATE new asDateAndTime.
		DATE minimum asDateAndTime.
		DATE maximum asDateAndTime.
		DATE now asDateAndTime.
		SYSTEMTIME new asDATE asDateAndTime.
		FILETIME new asDateAndTime
	}) at: anInteger! !

!OS.COM.Tests.DATEArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!private!unit tests! !
!

