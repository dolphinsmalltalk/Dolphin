"Filed out from Dolphin Smalltalk 7"!

MethodRefactoring subclass: #ExtractMethodToComponentRefactoring
	instanceVariableNames: 'selector extractionInterval extractedMethodSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ExtractMethodToComponentRefactoring guid: (GUID fromString: '{944c6f77-b242-48b5-bdee-ae64884630f6}')!
ExtractMethodToComponentRefactoring comment: ''!
!ExtractMethodToComponentRefactoring categoriesForClass!Refactory-Refactorings! !
!ExtractMethodToComponentRefactoring methodsFor!

extract: anInterval from: aSelector in: aClass 
	#rbFix. "Ensure the displayString works when the model name is initialized"
	class := aClass.
	selector := aSelector.
	extractionInterval := anInterval.
	class := self classObjectFor: aClass.
!

extractMethod
	| refactoring |
	refactoring := ExtractMethodRefactoring 
				model: self model
				extract: extractionInterval
				from: selector
				in: class.
	refactoring setOption: #methodName
		toUse: 
			[:ref :methodName | 
			extractedMethodSelector := ref 
						uniqueMethodNameFor: methodName arguments size.
			methodName
				selector: extractedMethodSelector;
				yourself].
	self performComponentRefactoring: refactoring!

inlineForwarder
	| refactoring |
	refactoring := InlineAllSendersRefactoring 
				model: self model
				sendersOf: extractedMethodSelector
				in: class.
	refactoring setOption: #inlineExpression toUse: [:ref :string | true].
	self performComponentRefactoring: refactoring!

moveMethod
	| variable refactoring |
	variable := self selectVariableToMoveMethodTo: extractedMethodSelector
				class: class.
	variable isNil 
		ifTrue: [^self refactoringAborted: 'Did not extract method'].
	refactoring := MoveMethodRefactoring 
				model: self model
				selector: extractedMethodSelector
				class: class
				variable: variable.
	self performComponentRefactoring: refactoring!

preconditions
	^RBCondition empty!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' extract: '.
	extractionInterval storeOn: aStream.
	aStream
		nextPutAll: ' from: #';
		nextPutAll: selector;
		nextPutAll: ' in: '.
	class storeOn: aStream.
	aStream nextPut: $)!

transform
	self
		extractMethod;
		moveMethod;
		inlineForwarder! !
!ExtractMethodToComponentRefactoring categoriesFor: #extract:from:in:!initialize/release!public! !
!ExtractMethodToComponentRefactoring categoriesFor: #extractMethod!public!transforming! !
!ExtractMethodToComponentRefactoring categoriesFor: #inlineForwarder!public!transforming! !
!ExtractMethodToComponentRefactoring categoriesFor: #moveMethod!public!transforming! !
!ExtractMethodToComponentRefactoring categoriesFor: #preconditions!preconditions!public! !
!ExtractMethodToComponentRefactoring categoriesFor: #storeOn:!printing!public! !
!ExtractMethodToComponentRefactoring categoriesFor: #transform!public!transforming! !

!ExtractMethodToComponentRefactoring class methodsFor!

extract: anInterval from: aSelector in: aClass 
	^self new
		extract: anInterval
		from: aSelector
		in: aClass!

model: aRBNamespace extract: anInterval from: aSelector in: aClass 
	^(self new)
		model: aRBNamespace;
		extract: anInterval
			from: aSelector
			in: aClass;
		yourself! !
!ExtractMethodToComponentRefactoring class categoriesFor: #extract:from:in:!instance creation!public! !
!ExtractMethodToComponentRefactoring class categoriesFor: #model:extract:from:in:!instance creation!public! !

