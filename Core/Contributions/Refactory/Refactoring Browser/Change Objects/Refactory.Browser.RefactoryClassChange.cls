"Filed out from Dolphin Smalltalk 7"!

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
	^classReference = aRefactoryClassChange classReference!

asUndoOperation
	^self subclassResponsibility!

changeClass
	^classReference valueOrNil!

changeClass: aBehavior
	classReference := aBehavior fullyQualifiedReference!

changeClassName
	^classReference instance asString!

changeClassName: aSymbol 
	| wasMeta |
	wasMeta := classReference notNil and: [classReference isMeta].
	classReference := BindingReference pathString: aSymbol.
	wasMeta ifTrue: [classReference := classReference meta]
!

changeString
	^self displayClassName!

classReference
	^classReference!

displayClassName
	^classReference asString!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

hash
	^classReference hash!

isMeta
	^classReference isMeta!

methodSourceFor: aSymbol 
	(self changeClass includesSelector: aSymbol) ifFalse: [^nil].
	^self changeClass sourceCodeAt: aSymbol!

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
!Refactory.Browser.RefactoryClassChange categoriesFor: #=!comparing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #asUndoOperation!converting!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #changeClass!accessing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #changeClass:!accessing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #changeClassName!accessing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #changeClassName:!accessing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #changeString!printing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #classReference!accessing!private! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #displayClassName!printing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #executeNotifying:!private! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #hash!comparing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #isMeta!private! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #methodSourceFor:!accessing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #primitiveExecute!private! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #printOn:!printing!public! !
!Refactory.Browser.RefactoryClassChange categoriesFor: #renameChangesForClass:to:!accessing!public! !

