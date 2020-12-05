"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.RemoveInstanceVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveInstanceVariableChange guid: (Core.GUID fromString: '{e9c39339-a730-4cfc-a1e7-c0c44ec0e681}')!
Refactory.Browser.RemoveInstanceVariableChange comment: ''!
!Refactory.Browser.RemoveInstanceVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveInstanceVariableChange methodsFor!

asUndoOperation
	^AddInstanceVariableChange add: variable to: self changeClass!

changeString
	^'Remove instance variable named, <1s>, from <2s>' expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#removeInstVarName:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeInstVarNamed: ';
		nextPutAll: variable;
		nextPut: $!!! !
!Refactory.Browser.RemoveInstanceVariableChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveInstanceVariableChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RemoveInstanceVariableChange categoriesFor: #changeSymbol!private! !
!Refactory.Browser.RemoveInstanceVariableChange categoriesFor: #printOn:!printing!public! !

