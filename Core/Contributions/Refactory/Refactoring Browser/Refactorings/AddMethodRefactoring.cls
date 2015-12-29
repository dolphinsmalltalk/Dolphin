"Filed out from Dolphin Smalltalk XP 2002 release 5.05"!

MethodRefactoring subclass: #AddMethodRefactoring
	instanceVariableNames: 'protocols source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddMethodRefactoring guid: (GUID fromString: '{0B0BB59D-7DE6-47B2-80AA-A0E9868E6AC4}')!
AddMethodRefactoring comment: ''!
!AddMethodRefactoring categoriesForClass!Refactory-Refactorings! !
!AddMethodRefactoring methodsFor!

addMethod: aString toClass: aClass inProtocols: protocolList 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	source := aString.
	protocols := protocolList.
	class := self classObjectFor: aClass.
!

preconditions
	| selector method |
	method := RBParser parseMethod: source
				onError: 
					[:string :position | 
					^RBCondition 
						withBlock: [self refactoringError: 'The sources could not be parsed']].
	selector := method selector.
	selector isNil ifTrue: [self refactoringError: 'Invalid source.'].
	^(RBCondition canUnderstand: selector in: class) not!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream
		nextPutAll: ' addMethod: ''';
		nextPutAll: source;
		nextPutAll: ''' toClass: '.
	class storeOn: aStream.
	aStream nextPutAll: ' inProtocols: '.
	protocols storeOn: aStream.
	aStream nextPut: $)!

transform
	class compile: source classified: protocols! !
!AddMethodRefactoring categoriesFor: #addMethod:toClass:inProtocols:!initialize/release!public! !
!AddMethodRefactoring categoriesFor: #preconditions!preconditions!public! !
!AddMethodRefactoring categoriesFor: #storeOn:!printing!public! !
!AddMethodRefactoring categoriesFor: #transform!public!transforming! !

!AddMethodRefactoring class methodsFor!

addMethod: aString toClass: aClass inProtocols: protocolList 
	^self new addMethod: aString
		toClass: aClass
		inProtocols: protocolList!

model: aRBNamespace addMethod: aString toClass: aClass inProtocols: protocolList 
	^(self new)
		model: aRBNamespace;
		addMethod: aString
			toClass: aClass
			inProtocols: protocolList;
		yourself! !
!AddMethodRefactoring class categoriesFor: #addMethod:toClass:inProtocols:!instance creation!public! !
!AddMethodRefactoring class categoriesFor: #model:addMethod:toClass:inProtocols:!instance creation!public! !

