"Filed out from Dolphin Smalltalk 7"!

RefactoryVariableChange subclass: #RemoveInstanceVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemoveInstanceVariableChange guid: (GUID fromString: '{e9c39339-a730-4cfc-a1e7-c0c44ec0e681}')!
RemoveInstanceVariableChange comment: ''!
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
!RemoveInstanceVariableChange categoriesFor: #changeSymbol!private! !
!RemoveInstanceVariableChange categoriesFor: #printOn:!printing!public! !

