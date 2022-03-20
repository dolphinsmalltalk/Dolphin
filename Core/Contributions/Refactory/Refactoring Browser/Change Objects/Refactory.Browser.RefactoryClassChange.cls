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

afterText
	| attributes stream |
	attributes := self getClassAttributes.
	attributes ifNil: [^self printString].
	stream := String writeStream: 256.
	(self sourceFilerClass on: stream) printBasicDefinitionOfClass: attributes.
	^stream contents!

asUndoOperation
	^self subclassResponsibility!

beforeText
	^self changeClass ifNil: [''] ifNotNil: [:class | class definition]!

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
	^self classReference asString!

classReference
	^classReference!

executeNotifying: aBlock 
	| undo |
	undo := self asUndoOperation.
	undo name: self name.
	self primitiveExecute.
	aBlock value.
	^undo!

getClassAttributes
	^self changeClass
		ifNotNil: 
			[:class |
			| attributes |
			attributes := ClassAttributes fromClass: class.
			self mutateAttributes: attributes.
			^attributes]!

hash
	^self classReference hash!

isMeta
	^self classReference isMeta!

mutateAttributes: aClassAttributes
	"Alter the <ClassAttributes> argument to reflect the change described by the receiver."!

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
	^self changeClass sourceFilerClass! !
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
executeNotifying:!applying!private! !
getClassAttributes!printing!private! !
hash!comparing!public! !
isMeta!private!testing! !
mutateAttributes:!helpers!private! !
primitiveExecute!applying!private! !
printOn:!printing!public! !
renameChangesForClass:to:!helpers!private! !
sourceFilerClass!constants!private! !
!

