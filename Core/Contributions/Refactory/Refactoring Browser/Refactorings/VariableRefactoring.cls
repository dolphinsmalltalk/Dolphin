"Filed out from Dolphin Smalltalk 7"!

Refactoring subclass: #VariableRefactoring
	instanceVariableNames: 'class variableName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
VariableRefactoring guid: (GUID fromString: '{0ef75a5c-d99d-489e-b05f-2cf5a57d0f2c}')!
VariableRefactoring isAbstract: true!
VariableRefactoring comment: ''!
!VariableRefactoring categoriesForClass!Refactory-Refactorings! !
!VariableRefactoring methodsFor!

storeOn: aStream 
	aStream nextPut: $(.
	self class storeOn: aStream.
	aStream nextPutAll: ' variable: '.
	variableName storeOn: aStream.
	aStream nextPutAll: ' class: '.
	class storeOn: aStream.
	aStream nextPut: $)!

variable: aVarName class: aClass 
	#rbFix. "Ensure displayString works when model is lazily created for Undo/Redo name (needs inst. vars set up)."
	class := aClass.
	variableName := aVarName.
	class := self classObjectFor: aClass.
! !
!VariableRefactoring categoriesFor: #storeOn:!printing!public! !
!VariableRefactoring categoriesFor: #variable:class:!initialize/release!public! !

!VariableRefactoring class methodsFor!

model: aRBNamespace variable: aVarName class: aClass 
	^(self new)
		model: aRBNamespace;
		variable: aVarName class: aClass;
		yourself!

variable: aVarName class: aClass
	^self new variable: aVarName class: aClass! !
!VariableRefactoring class categoriesFor: #model:variable:class:!instance creation!public! !
!VariableRefactoring class categoriesFor: #variable:class:!instance creation!public! !

