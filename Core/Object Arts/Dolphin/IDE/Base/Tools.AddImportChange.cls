"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange subclass: #'Tools.AddImportChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AddImportChange guid: (Core.GUID fromString: '{48291ca4-180f-4a5e-b79e-409203e18930}')!
Tools.AddImportChange comment: 'Dolphin-specific change object to add an import to a class. Replaces AddPoolVariableChange.'!
!Tools.AddImportChange categoriesForClass!Refactory-Change Objects! !
!Tools.AddImportChange methodsFor!

asUndoOperation
	^RemoveImportChange remove: variable from: self changeClass!

changeObject
	^variable asQualifiedReference realReference!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeStringFormat
	^'Import <1s>, into <2s>'!

changeSymbol
	^#addImport:!

variable
	^variable asString!

variableName
	^variable asString! !
!Tools.AddImportChange categoriesForMethods!
asUndoOperation!converting!public! !
changeObject!private! !
changesFileTemplate!constants!private! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
variable!private! !
variableName!accessing!private! !
!

