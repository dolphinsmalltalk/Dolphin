"Filed out from Dolphin Smalltalk"!

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

changeStringFormat
	^'Remove instance variable named, <1s>, from <2s>'!

changeSymbol
	^#removeInstVarName:! !
!Refactory.Browser.RemoveInstanceVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
!

