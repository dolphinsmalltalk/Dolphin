"Filed out from Dolphin Smalltalk"!

RefactoryVariableChange subclass: #AddInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AddInstanceVariableChange guid: (GUID fromString: '{b6ad3820-2921-48e3-abf0-439da4482d55}')!

AddInstanceVariableChange comment: ''!

!AddInstanceVariableChange categoriesForClass!Refactory-Change Objects! !

!AddInstanceVariableChange methodsFor!

asUndoOperation
	^RemoveInstanceVariableChange remove: variable from: self changeClass!

changeString
	^'Add instance variable named, <1s>, from <2s>' 
		expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#addInstVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!! !

!AddInstanceVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeString!printing!public! !
changeSymbol!private! !
printOn:!printing!public! !
!

