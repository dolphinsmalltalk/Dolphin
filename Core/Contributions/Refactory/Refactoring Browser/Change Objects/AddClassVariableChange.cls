"Filed out from Dolphin Smalltalk 7"!

RefactoryVariableChange subclass: #AddClassVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddClassVariableChange guid: (GUID fromString: '{bf346b83-3f40-4ec7-bc19-26c86114e7e2}')!
AddClassVariableChange comment: ''!
!AddClassVariableChange categoriesForClass!Refactory-Change Objects! !
!AddClassVariableChange methodsFor!

asUndoOperation
	^RemoveClassVariableChange remove: variable from: self changeClass!

changeString
	^'Add class variable named, <1s>, from <2s>' 
		expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#addClassVarNamed:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addClassVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!!

variable
	^variable asSymbol! !
!AddClassVariableChange categoriesFor: #asUndoOperation!converting!public! !
!AddClassVariableChange categoriesFor: #changeString!printing!public! !
!AddClassVariableChange categoriesFor: #changeSymbol!constants!private! !
!AddClassVariableChange categoriesFor: #printOn:!printing!public! !
!AddClassVariableChange categoriesFor: #variable!private! !

