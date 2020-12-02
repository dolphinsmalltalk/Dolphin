"Filed out from Dolphin Smalltalk 7"!

Refactoring subclass: #MethodRefactoring
	instanceVariableNames: 'class'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MethodRefactoring guid: (GUID fromString: '{f93954e7-217f-4070-b44d-b7d1f1bc74d3}')!
MethodRefactoring comment: ''!
!MethodRefactoring categoriesForClass!Refactory-Refactorings! !
!MethodRefactoring methodsFor!

buildSelectorString: aSelector
	aSelector argumentCount = 0 ifTrue: [^aSelector].
	^self buildSelectorString: aSelector
		withPermuteMap: (1 to: aSelector argumentCount)!

buildSelectorString: aSelector withPermuteMap: anIntegerCollection
	| stream keywords |
	aSelector argumentCount == 0 ifTrue: [^aSelector asString].
	stream := WriteStream on: String new.
	keywords := aSelector keywords.
	keywords with: anIntegerCollection
		do: 
			[:each :i | 
			stream
				nextPutAll: each;
				nextPutAll: ' ``@arg';
				print: i;
				nextPut: $ ].
	^stream contents! !
!MethodRefactoring categoriesFor: #buildSelectorString:!private! !
!MethodRefactoring categoriesFor: #buildSelectorString:withPermuteMap:!private! !

