"Filed out from Dolphin Smalltalk 7"!

RefactoryVariableChange subclass: #AddInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddInstanceVariableChange guid: (GUID fromString: '{b6ad3820-2921-48e3-abf0-439da4482d55}')!
AddInstanceVariableChange comment: ''!
!AddInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!AddInstanceVariableChange methodsFor!

asUndoOperation
	^RemoveInstanceVariableChange remove: variable from: self changeClass!

changeString
	^'Add instance variable named, <1s>, from <2s>' expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#addInstVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!! !
!AddInstanceVariableChange categoriesFor: #asUndoOperation!converting!public! !
!AddInstanceVariableChange categoriesFor: #changeString!printing!public! !
!AddInstanceVariableChange categoriesFor: #changeSymbol!private! !
!AddInstanceVariableChange categoriesFor: #printOn:!printing!public! !

