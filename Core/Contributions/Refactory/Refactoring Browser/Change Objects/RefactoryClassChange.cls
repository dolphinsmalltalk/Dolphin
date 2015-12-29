"Filed out from Dolphin Smalltalk X6"!

RefactoryChange subclass: #RefactoryClassChange
	instanceVariableNames: 'className isMeta'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RefactoryClassChange guid: (GUID fromString: '{5955DFD7-6B22-491C-B86D-3E6A0061C426}')!
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
!RefactoryClassChange categoriesFor: #=!comparing!public! !
!RefactoryClassChange categoriesFor: #asUndoOperation!converting!public! !
!RefactoryClassChange categoriesFor: #changeClass!accessing!public! !
!RefactoryClassChange categoriesFor: #changeClass:!accessing!public! !
!RefactoryClassChange categoriesFor: #changeClassName!accessing!public! !
!RefactoryClassChange categoriesFor: #changeClassName:!accessing!public! !
!RefactoryClassChange categoriesFor: #changeString!printing!public! !
!RefactoryClassChange categoriesFor: #displayClassName!printing!public! !
!RefactoryClassChange categoriesFor: #executeNotifying:!private! !
!RefactoryClassChange categoriesFor: #hash!comparing!public! !
!RefactoryClassChange categoriesFor: #isMeta!private! !
!RefactoryClassChange categoriesFor: #methodSourceFor:!accessing!public! !
!RefactoryClassChange categoriesFor: #primitiveExecute!private! !
!RefactoryClassChange categoriesFor: #printOn:!printing!public! !
!RefactoryClassChange categoriesFor: #renameChangesForClass:to:!accessing!public! !

