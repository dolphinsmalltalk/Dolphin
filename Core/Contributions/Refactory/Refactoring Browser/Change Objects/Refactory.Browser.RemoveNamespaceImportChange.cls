"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.RefactoryVariableChange subclass: #'Refactory.Browser.RemoveNamespaceImportChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RemoveNamespaceImportChange guid: (Core.GUID fromString: '{dc8b3bc9-6d9d-4e17-aa32-596044261886}')!
Refactory.Browser.RemoveNamespaceImportChange comment: ''!
!Refactory.Browser.RemoveNamespaceImportChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RemoveNamespaceImportChange methodsFor!

asUndoOperation
	^AddNamespaceImportChange add: variable to: self changeClass!

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
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeObject!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changesFileTemplate!constants!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeStringFormat!constants!printing!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeSymbol!constants!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #variableName!accessing!private! !

