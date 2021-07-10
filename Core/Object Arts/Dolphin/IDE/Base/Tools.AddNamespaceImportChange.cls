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
!Tools.AddNamespaceImportChange categoriesFor: #asUndoOperation!converting!public! !
!Tools.AddNamespaceImportChange categoriesFor: #changeObject!private! !
!Tools.AddNamespaceImportChange categoriesFor: #changesFileTemplate!constants!private! !
!Tools.AddNamespaceImportChange categoriesFor: #changeStringFormat!constants!printing!private! !
!Tools.AddNamespaceImportChange categoriesFor: #changeSymbol!constants!private! !
!Tools.AddNamespaceImportChange categoriesFor: #variable!private! !
!Tools.AddNamespaceImportChange categoriesFor: #variableName!accessing!private! !

