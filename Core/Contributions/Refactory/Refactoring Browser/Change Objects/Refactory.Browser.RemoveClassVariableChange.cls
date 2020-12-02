"Filed out from Dolphin Smalltalk 7"!

RefactoryVariableChange subclass: #RemoveClassVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemoveClassVariableChange guid: (GUID fromString: '{b2ce8c91-bd3b-4c5a-9210-f0443a0bd159}')!
RemoveClassVariableChange comment: ''!
!RemoveClassVariableChange categoriesForClass!Refactory-Change Objects! !
!RemoveClassVariableChange methodsFor!

asUndoOperation
	^AddClassVariableChange add: variable to: self changeClass!

changeString
	^'Remove class variable named, <1s>, from <2s>' expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#removeClassVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeClassVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!!

variable
	^variable asSymbol! !
!RemoveClassVariableChange categoriesFor: #asUndoOperation!converting!public! !
!RemoveClassVariableChange categoriesFor: #changeString!printing!public! !
!RemoveClassVariableChange categoriesFor: #changeSymbol!private! !
!RemoveClassVariableChange categoriesFor: #printOn:!printing!public! !
!RemoveClassVariableChange categoriesFor: #variable!private! !

