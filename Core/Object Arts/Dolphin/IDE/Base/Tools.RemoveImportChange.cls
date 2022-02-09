"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange subclass: #'Tools.RemoveImportChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.RemoveImportChange guid: (Core.GUID fromString: '{dc8b3bc9-6d9d-4e17-aa32-596044261886}')!
Tools.RemoveImportChange comment: 'Dolphin-specific change object to remove an import from a class. Replaces RemovePoolVariableChange.'!
!Tools.RemoveImportChange categoriesForClass!Refactory-Change Objects! !
!Tools.RemoveImportChange methodsFor!

asUndoOperation
	^AddImportChange add: variable to: self changeClass!

changeObject
	^variable asQualifiedReference!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeStringFormat
	^'Remove import <1d>, from <2s>'!

changeSymbol
	^#removeImport:!

variableName
	^variable asString! !
!Tools.RemoveImportChange categoriesForMethods!
asUndoOperation!converting!public! !
changeObject!private! !
changesFileTemplate!constants!private! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
variableName!accessing!private! !
!

