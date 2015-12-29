"Filed out from Dolphin Smalltalk 2000 release 5.00"!

RefactoryVariableChange subclass: #RemoveClassVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RemoveClassVariableChange guid: (GUID fromString: '{B2CE8C91-BD3B-4C5A-9210-F0443A0BD159}')!
RemoveClassVariableChange comment: ''!
!RemoveClassVariableChange categoriesForClass!Refactory-Change Objects! !
!RemoveClassVariableChange methodsFor!

asUndoOperation
	^AddClassVariableChange add: variable to: self changeClass!

changeString
	^'Remove class variable named, <1s>, from <2s>' 
		expandMacrosWith: variable
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
!RemoveClassVariableChange categoriesFor: #changeSymbol!*-unclassified!private! !
!RemoveClassVariableChange categoriesFor: #printOn:!printing!public! !
!RemoveClassVariableChange categoriesFor: #variable!*-unclassified!private! !

