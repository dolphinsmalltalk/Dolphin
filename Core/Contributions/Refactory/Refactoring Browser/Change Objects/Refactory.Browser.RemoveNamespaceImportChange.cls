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
	| dictionary |
	dictionary := variable isString 
				ifTrue: [variable asQualifiedReference value]
				ifFalse: [variable].
	^dictionary!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeString
	^'Remove pool variable named, <1d>, from <2s>' expandMacrosWith: variable
		with: self displayClassName!

changeSymbol
	^#removeSharedPool:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' removeSharedPool: ';
		nextPutAll: self variable;
		nextPut: $!!!

variable
	^variable isString
		ifTrue: [variable]
		ifFalse: [Smalltalk keyAtValue: variable ifAbsent: [self error: 'Cannot find value']]! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeObject!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changesFileTemplate!constants!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #changeSymbol!private! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RemoveNamespaceImportChange categoriesFor: #variable!accessing!private! !

