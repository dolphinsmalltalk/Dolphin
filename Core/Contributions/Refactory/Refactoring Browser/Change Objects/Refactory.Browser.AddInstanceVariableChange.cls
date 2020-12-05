"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.AddInstanceVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.AddInstanceVariableChange guid: (Core.GUID fromString: '{b6ad3820-2921-48e3-abf0-439da4482d55}')!
Refactory.Browser.AddInstanceVariableChange comment: ''!
!Refactory.Browser.AddInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.AddInstanceVariableChange methodsFor!

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
!Refactory.Browser.AddInstanceVariableChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.AddInstanceVariableChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.AddInstanceVariableChange categoriesFor: #changeSymbol!private! !
!Refactory.Browser.AddInstanceVariableChange categoriesFor: #printOn:!printing!public! !

