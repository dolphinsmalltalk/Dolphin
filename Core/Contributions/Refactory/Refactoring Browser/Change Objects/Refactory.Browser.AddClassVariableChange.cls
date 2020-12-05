"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.AddClassVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddClassVariableChange guid: (Core.GUID fromString: '{bf346b83-3f40-4ec7-bc19-26c86114e7e2}')!
Refactory.Browser.AddClassVariableChange comment: ''!
!Refactory.Browser.AddClassVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddClassVariableChange methodsFor!

asUndoOperation
	^RemoveClassVariableChange remove: variable from: self changeClass!

changeString
	^'Add class variable named, <1s>, from <2s>' expandMacrosWith: variable with: self displayClassName!

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
!Refactory.Browser.AddClassVariableChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.AddClassVariableChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.AddClassVariableChange categoriesFor: #changeSymbol!constants!private! !
!Refactory.Browser.AddClassVariableChange categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.AddClassVariableChange categoriesFor: #variable!private! !

