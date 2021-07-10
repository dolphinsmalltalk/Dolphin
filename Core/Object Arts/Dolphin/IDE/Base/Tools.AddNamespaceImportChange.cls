"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryVariableChange subclass: #'Tools.AddNamespaceImportChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.AddNamespaceImportChange guid: (Core.GUID fromString: '{48291ca4-180f-4a5e-b79e-409203e18930}')!
Tools.AddNamespaceImportChange comment: 'Dolphin-specific change object to add an import to a class. Replaces AddPoolVariableChange.'!
!Tools.AddNamespaceImportChange categoriesForClass!Refactory-Change Objects! !
!Tools.AddNamespaceImportChange methodsFor!

asUndoOperation
	^RemoveNamespaceImportChange remove: variable from: self changeClass!

changeObject
	^variable asQualifiedReference!

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
!Tools.AddNamespaceImportChange categoriesForMethods!
asUndoOperation!converting!public! !
changeObject!private! !
changesFileTemplate!constants!private! !
changeStringFormat!constants!printing!private! !
changeSymbol!constants!private! !
variable!private! !
variableName!accessing!private! !
!

