"Filed out from Dolphin Smalltalk"!

Refactory.Browser.RefactoryChange
	subclass: #'Refactory.Browser.RefactoryClassChange'
	instanceVariableNames: ''
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

afterText
	^(self getClassDetails ifNil: [self]) fullPrintString!

asUndoOperation
	^self subclassResponsibility!

beforeText
	^self changeClass ifNil: [''] ifNotNil: [:class | class definition]!

changeClass
	^self classReference valueOrNil!

changeClass: aBehavior
	self classReference: aBehavior fullName asQualifiedReference!

changeClassName
	^self classReference instance asString!

changeClassName: aSymbol
	| wasMeta oldRef newRef |
	oldRef := self classReference.
	wasMeta := oldRef notNil and: [oldRef isMeta].
	newRef := BindingReference pathString: aSymbol.
	wasMeta ifTrue: [newRef := newRef meta].
	self classReference: newRef!

changeString
	^self classReference asString!

classReference
	^self subclassResponsibility!

classReference: aBindingReference
	self subclassResponsibility!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

getClassDetails
	| details |
	details := self changeClass
				ifNil: 
					[ClassDetails new
						className: self classReference;
						yourself]
				ifNotNil: [:class | ClassDetails fromClass: class].
	self mutateClassDetails: details.
	^details!

hash
	^self classReference hash!

isMeta
	^self classReference isMeta!

mutateClassDetails: aClassDetails
	"Alter the <ClassDetails> argument to reflect the change described by the receiver."

	!

primitiveExecute
	self subclassResponsibility!

printOn: aStream
	aStream nextPutAll: self displayString!

renameChangesForClass: aClassName to: newClassName 
	self changeClassName = aClassName 
		ifTrue: 
			[^(self copy)
				changeClassName: newClassName;
				yourself].
	^self!

sourceFilerClass
	^self getClassDetails sourceFilerClass! !
!Refactory.Browser.RefactoryClassChange categoriesForMethods!
=!comparing!public! !
afterText!printing!public! !
asUndoOperation!converting!public! !
beforeText!printing!public! !
changeClass!accessing!public! !
changeClass:!accessing!public! !
changeClassName!accessing!public! !
changeClassName:!accessing!public! !
changeString!printing!public! !
classReference!accessing!public! !
classReference:!accessing!private! !
executeNotifying:!applying!private! !
getClassDetails!printing!private! !
hash!comparing!public! !
isMeta!private!testing! !
mutateClassDetails:!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
renameChangesForClass:to:!helpers!private! !
sourceFilerClass!constants!private! !
!

