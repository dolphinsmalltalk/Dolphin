"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoryVariableChange subclass: #RemoveInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveInstanceVariableChange comment: ''!

RemoveInstanceVariableChange guid: (GUID fromString: '{E9C39339-A730-4CFC-A1E7-C0C44EC0E681}')!

!RemoveInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!RemoveInstanceVariableChange methodsFor!

asUndoOperation
	^AddInstanceVariableChange add: variable to: self changeClass!

changeString
	^'Remove instance variable named, <1s>, from <2s>' 
		expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#removeInstVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!! !
!RemoveInstanceVariableChange categoriesFor: #asUndoOperation!converting!public! !
!RemoveInstanceVariableChange categoriesFor: #changeString!printing!public! !
!RemoveInstanceVariableChange categoriesFor: #changeSymbol!*-unclassified!private! !
!RemoveInstanceVariableChange categoriesFor: #printOn:!printing!public! !

