"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.VariableRefactoring'
	instanceVariableNames: 'class variableName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.VariableRefactoring guid: (Core.GUID fromString: '{0ef75a5c-d99d-489e-b05f-2cf5a57d0f2c}')!
Refactory.Browser.VariableRefactoring isNonInstantiable: true!
Refactory.Browser.VariableRefactoring comment: ''!
!Refactory.Browser.VariableRefactoring categoriesForClass!Refactory-Refactorings! !
!Refactory.Browser.VariableRefactoring methodsFor!

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
!Refactory.Browser.VariableRefactoring categoriesForMethods!
storeOn:!printing!public! !
variable:class:!initialize/release!public! !
!

!Refactory.Browser.VariableRefactoring class methodsFor!

model: aRBModel variable: aVarName class: aClass
	^self new
		model: aRBModel;
		variable: aVarName class: aClass;
		yourself!

variable: aVarName class: aClass
	^self new variable: aVarName class: aClass! !
!Refactory.Browser.VariableRefactoring class categoriesForMethods!
model:variable:class:!instance creation!public! !
variable:class:!instance creation!public! !
!

