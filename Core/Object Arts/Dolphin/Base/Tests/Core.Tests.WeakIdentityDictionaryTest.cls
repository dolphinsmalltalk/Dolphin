"Filed out from Dolphin Smalltalk"!

Core.Tests.LookupTableTest subclass: #'Core.Tests.WeakIdentityDictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.WeakIdentityDictionaryTest guid: (Core.GUID fromString: '{744bc1f2-18d8-4618-8db4-376fcdc25f6d}')!
Core.Tests.WeakIdentityDictionaryTest comment: ''!
!Core.Tests.WeakIdentityDictionaryTest methodsFor!

collectionClass
	^WeakIdentityDictionary!

testIsMourner
	| subject |
	self assert: self collectionClass isMourner.
	subject := self newDictionary.
	self assert: subject isWeak.
	"WeakIdentityDictionary instances also have weak values by default"
	self assert: subject basicValues isWeak

! !
!Core.Tests.WeakIdentityDictionaryTest categoriesForMethods!
collectionClass!helpers!private! !
testIsMourner!public! !
!

