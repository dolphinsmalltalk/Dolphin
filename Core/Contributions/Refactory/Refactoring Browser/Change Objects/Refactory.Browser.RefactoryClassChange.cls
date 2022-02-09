"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange subclass: #'Refactory.Browser.RefactoryClassChange'
	instanceVariableNames: 'classReference'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.RefactoryClassChange guid: (Core.GUID fromString: '{5955dfd7-6b22-491c-b86d-3e6a0061c426}')!
Refactory.Browser.RefactoryClassChange isNonInstantiable: true!
Refactory.Browser.RefactoryClassChange comment: ''!
!Refactory.Browser.RefactoryClassChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.RefactoryClassChange methodsFor!

= aRefactoryClassChange 
	self class = aRefactoryClassChange class ifFalse: [^false].
	^self classReference = aRefactoryClassChange classReference!

asUndoOperation
	^self subclassResponsibility!

changeClass
	^self classReference valueOrNil!

changeClass: aBehavior
	classReference := aBehavior fullName asQualifiedReference!

changeClassName
	^self classReference instance asString!

changeClassName: aSymbol
	| wasMeta |
	wasMeta := classReference notNil and: [classReference isMeta].
	classReference := BindingReference pathString: aSymbol.
	wasMeta ifTrue: [classReference := classReference meta]!

changeString
	^self displayClassName!

classReference
	^classReference!

displayClassName
	^self classReference asString!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

hash
	^self classReference hash!

isMeta
	^self classReference isMeta!

methodSourceFor: aSymbol
	^self changeClass
		ifNotNil: [:class | (class includesSelector: aSymbol) ifTrue: [class sourceCodeAt: aSymbol]]!

primitiveExecute
	^self subclassResponsibility!

printOn: aStream
	aStream nextPutAll: self displayString!

renameChangesForClass: aClassName to: newClassName 
	self changeClassName = aClassName 
		ifTrue: 
			[^(self copy)
				changeClassName: newClassName;
				yourself].
	^self! !
!Refactory.Browser.RefactoryClassChange categoriesForMethods!
=!comparing!public! !
asUndoOperation!converting!public! !
changeClass!accessing!public! !
changeClass:!accessing!public! !
changeClassName!accessing!public! !
changeClassName:!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
displayClassName!printing!public! !
executeNotifying:!applying!private! !
hash!comparing!public! !
isMeta!private!testing! !
methodSourceFor:!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
renameChangesForClass:to:!helpers!private! !
!

