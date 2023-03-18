"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.BSTRArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.BSTRArrayTest guid: (Core.GUID fromString: '{e90f2fcf-c993-418f-bb52-ee22925cf849}')!
OS.COM.Tests.BSTRArrayTest comment: ''!
!OS.COM.Tests.BSTRArrayTest methodsFor!

arrayClass
	^BSTRArray!

elementFromValue: anInteger
	^anInteger printString!

newArrayOfIntegers: anArray
	^self arrayClass withAll: (anArray collect: [:each | self elementFromValue: each])!

numericElementClass
	^BSTR

!

testFinalizable
	| bstrs pbstrs |
	bstrs := BSTRArray withAll: #('foo' 'bar').
	self assert: bstrs isFinalizable.
	pbstrs := BSTRArray fromAddress: bstrs yourAddress length: 2.
	self assert: pbstrs asArray equals: #('foo' 'bar').
	self deny: pbstrs isFinalizable.
	bstrs free! !
!OS.COM.Tests.BSTRArrayTest categoriesForMethods!
arrayClass!private! !
elementFromValue:!public!unit tests! !
newArrayOfIntegers:!private! !
numericElementClass!private! !
testFinalizable!public! !
!

