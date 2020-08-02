"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SystemDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SystemDictionaryTest guid: (GUID fromString: '{3eacc019-3785-40e9-8238-1678954b3460}')!
SystemDictionaryTest comment: ''!
!SystemDictionaryTest categoriesForClass!Unclassified! !
!SystemDictionaryTest methodsFor!

testWellFormed
	Smalltalk associationsDo: 
			[:each |
			self assert: each isKindOf: VariableBinding.
			self assert: each environment identicalTo: Smalltalk]! !
!SystemDictionaryTest categoriesFor: #testWellFormed!public!unit tests! !

