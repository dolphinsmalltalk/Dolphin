"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.StringPointerArrayTest
	subclass: #'OS.COM.Tests.LPSTRArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.LPSTRArrayTest guid: (Core.GUID fromString: '{615cc758-58fe-46cc-adfd-b5d901770159}')!

OS.COM.Tests.LPSTRArrayTest comment: ''!

!OS.COM.Tests.LPSTRArrayTest methodsFor!

verifyCopy: anArray
	| copy count copy2 ref subject |
	subject := self newTestSubjectWithElements: anArray.
	count := subject size.
	copy := subject copy.
	self assert: copy size equals: count.
	self assert: copy equals: subject.
	self deny: copy bytes identicalTo: subject bytes.
	self assert: copy isFinalizable equals: subject class requiresFinalization.
	ref := subject class
				fromAddress: subject bytes yourAddress
				length: count
				elementClass: subject elementClass.
	#todo.	"Only true for SAFEARRAY?
	self assert: ref isFinalizable equals: array class requiresFinalization."
	self deny: ref needsFree.
	self assert: ref size equals: count.
	self assert: ref equals: subject.
	copy2 := ref copy.
	self assert: copy2 size equals: count.
	self assert: copy2 equals: subject.
	self deny: copy2 bytes identicalTo: ref bytes.
	ref free.
	subject free.
	self deny: copy isNull.
	1 to: count
		do: 
			[:i |
			| elem |
			elem := self canonicalizeValue: i.
			self assert: (copy at: i) equals: elem.
			self assert: (copy2 at: i) equals: elem].
	^copy! !

!OS.COM.Tests.LPSTRArrayTest categoriesForMethods!
verifyCopy:!helpers!private!unit tests! !
!

!OS.COM.Tests.LPSTRArrayTest class methodsFor!

arrayClass
	^LPSTRArray!

elementFromIndex: anInteger
	^(#('' 'a' 'ab' '£' 'a£ë') lookup: anInteger)
		ifNil: [AnsiString fromByteArray: #[1 127 128 255]]! !

!OS.COM.Tests.LPSTRArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

