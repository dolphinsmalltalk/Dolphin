"Filed out from Dolphin Smalltalk"!

RefactoryChange subclass: #RefactoryClassChange
	instanceVariableNames: 'className isMeta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RefactoryClassChange guid: (GUID fromString: '{5955dfd7-6b22-491c-b86d-3e6a0061c426}')!

RefactoryClassChange isAbstract: true!

RefactoryClassChange comment: ''!

!RefactoryClassChange categoriesForClass!Refactory-Change Objects! !

!RefactoryClassChange methodsFor!

= aRefactoryClassChange 
	self class = aRefactoryClassChange class ifFalse: [^false].
	^className = aRefactoryClassChange changeClassName 
		and: [isMeta = aRefactoryClassChange isMeta]!

asUndoOperation
	^self subclassResponsibility!

changeClass
	| class |
	class := Smalltalk at: self changeClassName ifAbsent: [^nil].
	^isMeta ifTrue: [class class] ifFalse: [class]!

changeClass: aBehavior 
	isMeta := aBehavior isMeta.
	className := isMeta 
				ifTrue: [aBehavior soleInstance name]
				ifFalse: [aBehavior name]!

changeClassName
	^className!

changeClassName: aSymbol 
	className := aSymbol.
	isMeta isNil ifTrue: [isMeta := false]!

changeString
	^self displayClassName!

displayClassName
	^isMeta 
		ifTrue: [self changeClassName , ' class']
		ifFalse: [self changeClassName asString]!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

hash
	^self changeClassName hash!

isMeta
	^isMeta!

methodSourceFor: aSymbol 
	(self changeClass includesSelector: aSymbol) ifFalse: [^nil].
	^self changeClass sourceCodeAt: aSymbol!

primitiveExecute
	^self subclassResponsibility!

printOn: aStream
	aStream nextPutAll: self displayString!

renameChangesForClass: aClassName to: newClassName 
	self changeClassName == aClassName 
		ifTrue: 
			[^(self copy)
				changeClassName: newClassName;
				yourself].
	^self! !

!RefactoryClassChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeClass!accessing!public! !
changeClass:!accessing!public! !
changeClassName!accessing!public! !
changeClassName:!accessing!public! !
changeString!printing!public! !
displayClassName!printing!public! !
executeNotifying:!private! !
hash!comparing!public! !
isMeta!private! !
methodSourceFor:!accessing!public! !
primitiveExecute!private! !
printOn:!printing!public! !
renameChangesForClass:to:!accessing!public! !
!

