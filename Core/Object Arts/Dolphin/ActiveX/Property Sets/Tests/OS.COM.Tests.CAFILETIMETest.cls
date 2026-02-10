"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.CountedArrayTest
	subclass: #'OS.COM.Tests.CAFILETIMETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CAFILETIMETest guid: (Core.GUID fromString: '{a04da324-98db-4236-9e12-e815e1f57ce7}')!

OS.COM.Tests.CAFILETIMETest comment: ''!

!OS.COM.Tests.CAFILETIMETest methodsFor!

testSelfEvaluating
	| subject elements |
	elements := self exampleElements: 6.
	subject := self newTestSubjectWithElements: elements.
	self deny: subject isSelfEvaluating.
	self assert: subject printString
		equals: (String streamContents: 
					[:strm |
					strm nextPutAll: 'a COM.CAFILETIME('.
					elements do: [:each | each printOn: strm] separatedBy: [strm space].
					strm nextPut: $)])! !

!OS.COM.Tests.CAFILETIMETest categoriesForMethods!
testSelfEvaluating!public! !
!

!OS.COM.Tests.CAFILETIMETest class methodsFor!

arrayClass
	^CAFILETIME!

externalArrayTestClass
	^OS.Tests.FILETIMEArrayTest! !

!OS.COM.Tests.CAFILETIMETest class categoriesForMethods!
arrayClass!constants!private! !
externalArrayTestClass!constants!private! !
!

