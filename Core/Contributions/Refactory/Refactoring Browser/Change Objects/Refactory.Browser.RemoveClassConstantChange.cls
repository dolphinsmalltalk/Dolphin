"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.RemoveClassConstantChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveClassConstantChange guid: (Core.GUID fromString: '{aee0ae9c-20ed-457d-85bb-913ea38ea2ab}')!
Refactory.Browser.RemoveClassConstantChange comment: ''!
!Refactory.Browser.RemoveClassConstantChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveClassConstantChange methodsFor!

asUndoOperation
	^AddClassConstantChange add: variable to: self changeClass!

changeStringFormat
	^'Remove class constant named, <1s>, from <2s>'!

changeSymbol
	^#removeClassConstant:!

variableName
	^variable key! !
!Refactory.Browser.RemoveClassConstantChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveClassConstantChange categoriesFor: #changeStringFormat!constants!printing!private! !
!Refactory.Browser.RemoveClassConstantChange categoriesFor: #changeSymbol!constants!private! !
!Refactory.Browser.RemoveClassConstantChange categoriesFor: #variableName!accessing!private! !

