"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.CountedArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.CountedArrayTest guid: (Core.GUID fromString: '{79be80ea-8442-443e-83fc-3326e1fc1d4b}')!

OS.COM.Tests.CountedArrayTest isNonInstantiable: true!

OS.COM.Tests.CountedArrayTest comment: ''!

!OS.COM.Tests.CountedArrayTest methodsFor!

instancesNeedFree
	^true!

testNew
	| subject |
	subject := self arrayClass new.
	"CountedArrays always require free'ing, even if we don't allocate anything initially. A normal scenario would be to pass such an empty instance to a function to receive output that it allocates, so we need to be sure to release that when the object goes out of scope (or explicitly)"
	self assert: subject needsFree.
	self assert: subject isFinalizable.
	self assert: subject size equals: 0.
	self assert: subject elements isNull.
	self assert: subject value isNull!

testNewColon
	| subject |
	subject := self arrayClass new: 1.
	self assert: subject isFinalizable.
	self assert: subject size equals: 1.
	self deny: (IMalloc task DidAlloc: subject pElems) equals: 0.
	subject free
! !

!OS.COM.Tests.CountedArrayTest categoriesForMethods!
instancesNeedFree!constants!private! !
testNew!public!unit tests! !
testNewColon!public!unit tests! !
!

!OS.COM.Tests.CountedArrayTest class methodsFor!

elementFromIndex: anInteger
	"Answers an element value to place an the specified index in a test subject array. The index will be in the range [1,6]"

	^self externalArrayTestClass elementFromIndex: anInteger!

externalArrayTestClass
	^self subclassResponsibility! !

!OS.COM.Tests.CountedArrayTest class categoriesForMethods!
elementFromIndex:!helpers!private! !
externalArrayTestClass!constants!private! !
!

