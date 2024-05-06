"Filed out from Dolphin Smalltalk"!

RefactoryVariableChange subclass: #AddPoolVariableChange
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AddPoolVariableChange guid: (GUID fromString: '{48291ca4-180f-4a5e-b79e-409203e18930}')!

AddPoolVariableChange comment: ''!

!AddPoolVariableChange categoriesForClass!Refactory-Change Objects! !

!AddPoolVariableChange methodsFor!

asUndoOperation
	^RemovePoolVariableChange remove: variable from: self changeClass!

changeObject
	| dictionary |
	dictionary := variable isString 
				ifTrue: [Smalltalk at: variable asSymbol]
				ifFalse: [variable].
	^dictionary!

changesFileTemplate
	^'<1p> <2s> <3s>'!

changeString
	^'Add pool variable named, <1s>, from <2s>' 
		expandMacrosWith: self variable
		with: self displayClassName!

changeSymbol
	^#addSharedPool:!

printOn: aStream 
	aStream
		nextPutAll: self displayClassName;
		nextPutAll: ' addSharedPool: ';
		nextPutAll: self variable;
		nextPut: $!!!

variable
	^variable isString 
		ifTrue: [variable]
		ifFalse: 
			[Smalltalk keyAtValue: variable ifAbsent: [self error: 'Cannot find value']]! !

!AddPoolVariableChange categoriesForMethods!
asUndoOperation!converting!public! !
changeObject!private! !
changesFileTemplate!constants!private! !
changeString!printing!public! !
changeSymbol!private! !
printOn:!printing!public! !
variable!private! !
!

