"Filed out from Dolphin Smalltalk"!

External.Tests.ExternalArrayTest
	subclass: #'OS.COM.Tests.StringPointerArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.StringPointerArrayTest guid: (Core.GUID fromString: '{7bf0e3e1-4127-4cb2-99ad-b483ce8b9642}')!

OS.COM.Tests.StringPointerArrayTest isNonInstantiable: true!

OS.COM.Tests.StringPointerArrayTest comment: ''!

!OS.COM.Tests.StringPointerArrayTest methodsFor!

assertValidStrings: aStringPointerArray
	1 to: aStringPointerArray size do: [:i | self assert: (self isValidHeapString: (aStringPointerArray basicUncheckedAt: i))]!

denyValidStrings: aStringPointerArray equals: anArray
	self isNativeDebuggerPresent ifTrue: [^self].
	MemoryManager current
		collectGarbage;
		directFunerals.
	
	[| array |
	array := aStringPointerArray asArray.
	self deny: array equals: anArray] on: GPFault
			do: [:ex | ]!

isValidHeapString: anAddress
	| taskAllocator |
	taskAllocator := IMalloc task.
	^(taskAllocator didAlloc: anAddress) and: [(taskAllocator GetSize: anAddress) > 0]!

testFinalizable
	| subject pSubject strings |
	strings := self exampleElements: 6.
	subject := self class arrayClass withAll: strings.
	self assertIsNil: subject owner.
	self assert: subject isFinalizable.
	self assert: subject needsFree.
	self assertValidStrings: subject.
	pSubject := self class arrayClass fromAddress: subject yourAddress length: strings size.
	self assertValidStrings: pSubject.
	self assert: pSubject isReferenceStruct.
	self deny: pSubject isFinalizable.
	self deny: pSubject needsFree.
	self assert: pSubject asArray equals: strings.
	pSubject free.
	self assertValidStrings: subject.
	self assert: subject asArray equals: strings.
	pSubject := self class arrayClass fromAddress: subject yourAddress length: strings size.
	self assertValidStrings: pSubject.
	subject free.
	"The individual strings should have been freed, and therefore the heap pointers should no longer be valid"
	false ifTrue: [
		"Doesn't work reliably as the data in the heap may still be valid after freeing, even if the pointer is dangling. Need to track the frees to verify this properly"
		self denyValidStrings: pSubject equals: strings]!

verifyCopy: anArray
	| copy |
	copy := super verifyCopy: anArray.
	self assert: copy isValueStruct.
	self assertIsNil: copy owner.
	self assert: copy isFinalizable.
	self assert: copy needsFree.
	copy free! !

!OS.COM.Tests.StringPointerArrayTest categoriesForMethods!
assertValidStrings:!helpers!private! !
denyValidStrings:equals:!helpers!private! !
isValidHeapString:!helpers!private! !
testFinalizable!helpers!public! !
verifyCopy:!helpers!private!unit tests! !
!

