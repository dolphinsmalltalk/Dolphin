"Filed out from Dolphin Smalltalk"!

MethodRefactoring subclass: #AddMethodRefactoring
	instanceVariableNames: 'protocols source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AddMethodRefactoring guid: (GUID fromString: '{0b0bb59d-7de6-47b2-80aa-a0e9868e6ac4}')!

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

!AddMethodRefactoring categoriesForMethods!
addMethod:toClass:inProtocols:!initialize/release!public! !
preconditions!preconditions!public! !
storeOn:!printing!public! !
transform!public!transforming! !
!

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

!AddMethodRefactoring class categoriesForMethods!
addMethod:toClass:inProtocols:!instance creation!public! !
model:addMethod:toClass:inProtocols:!instance creation!public! !
!

