"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.RemoveClassVariableChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassVariableChange guid: (Core.GUID fromString: '{b2ce8c91-bd3b-4c5a-9210-f0443a0bd159}')!
Refactory.Browser.RemoveClassVariableChange comment: ''!
!Refactory.Browser.RemoveClassVariableChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveClassVariableChange methodsFor!

asUndoOperation
	^AddClassVariableChange add: variable to: self changeClass!

changeStringFormat
	^'Remove class variable named, <1s>, from <2s>'!

changeSymbol
	^#removeClassVarName:! !
!Refactory.Browser.RemoveClassVariableChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveClassVariableChange categoriesFor: #changeStringFormat!constants!printing!private! !
!Refactory.Browser.RemoveClassVariableChange categoriesFor: #changeSymbol!constants!private! !

