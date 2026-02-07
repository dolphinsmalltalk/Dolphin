"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.LPBSTRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.LPBSTRTest guid: (Core.GUID fromString: '{e6217079-e162-4410-b9ad-d8c00630896a}')!

OS.COM.Tests.LPBSTRTest comment: ''!

!OS.COM.Tests.LPBSTRTest methodsFor!

stringWithNull
	^'a🐬' , (String with: $\x0 with: $b)!

testCopy
	{ ''. self stringWithNull } do: 
			[:each |
			| bstr subject copy |
			bstr := each asBSTR.
			self assert: bstr isFinalizable.
			subject := LPBSTR fromAddress: bstr basicYourAddress.
			self assert: subject isReferenceStruct.
			self deny: subject isFinalizable.
			self deny: subject needsFree.
			copy := subject copy.
			self deny: copy identicalTo: subject.
			self deny: copy asInteger equals: subject bytes asInteger.
			self assert: copy isNull equals: each isEmpty.
			self assert: copy value equals: bstr value.
			self assert: copy isFinalizable.
			bstr free.
			self assert: copy value equals: each.
			copy free]! !

!OS.COM.Tests.LPBSTRTest categoriesForMethods!
stringWithNull!constants!private! !
testCopy!public!unit tests! !
!

