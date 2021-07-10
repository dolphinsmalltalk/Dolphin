"Filed out from Dolphin Smalltalk"!

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

changeStringFormat
	^'Add instance variable named, <1s>, to <2s>'!

changeSymbol
	^#addInstVarName:! !
!Refactory.Browser.AddInstanceVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
!

