"Filed out from Dolphin Smalltalk 7"!

RefactoryVariableChange subclass: #RemovePoolVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RemovePoolVariableChange guid: (GUID fromString: '{dc8b3bc9-6d9d-4e17-aa32-596044261886}')!
RemovePoolVariableChange comment: ''!
!RemovePoolVariableChange categoriesForClass!Refactory-Change Objects! !
!RemovePoolVariableChange methodsFor!

asUndoOperation
	^AddPoolVariableChange add: variable to: self changeClass!

changeObject
	| dictionary |
	dictionary := variable isString 
				ifTrue: [variable asQualifiedReference value]
				ifFalse: [variable].
	^dictionary!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeString
	^'Remove pool variable named, <1s>, from <2s>' expandMacrosWith: self variable
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
		ifFalse: 
			[Smalltalk keyAtValue: variable ifAbsent: [self error: 'Cannot find value']]! !
!RemovePoolVariableChange categoriesFor: #asUndoOperation!converting!public! !
!RemovePoolVariableChange categoriesFor: #changeObject!private! !
!RemovePoolVariableChange categoriesFor: #changesFileTemplate!constants!private! !
!RemovePoolVariableChange categoriesFor: #changeString!printing!public! !
!RemovePoolVariableChange categoriesFor: #changeSymbol!private! !
!RemovePoolVariableChange categoriesFor: #printOn:!printing!public! !
!RemovePoolVariableChange categoriesFor: #variable!accessing!private! !

