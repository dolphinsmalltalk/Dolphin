"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange subclass: #'Tools.RemoveClassConstantChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RemoveClassConstantChange guid: (Core.GUID fromString: '{aee0ae9c-20ed-457d-85bb-913ea38ea2ab}')!
Tools.RemoveClassConstantChange comment: ''!
!Tools.RemoveClassConstantChange categoriesForClass!Refactory-Change Objects! !
!Tools.RemoveClassConstantChange methodsFor!

asUndoOperation
	^AddClassConstantChange add: variable to: self changeClass!

changeStringFormat
	^'Remove class constant named, <1s>, from <2s>'!

changeSymbol
	^#removeClassConstant:!

variableName
	^variable key! !
!Tools.RemoveClassConstantChange categoriesForMethods!
asUndoOperation!converting!public! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
variableName!accessing!private! !
!

