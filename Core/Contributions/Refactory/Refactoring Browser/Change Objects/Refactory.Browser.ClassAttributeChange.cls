"Filed out from Dolphin Smalltalk"!

Refactory.Browser.ClassModificationChange subclass: #'Refactory.Browser.ClassAttributeChange'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.ClassAttributeChange guid: (Core.GUID fromString: '{adabd533-923e-41d1-bee0-9cd1062d9a8e}')!
Refactory.Browser.ClassAttributeChange isNonInstantiable: true!
Refactory.Browser.ClassAttributeChange comment: ''!
!Refactory.Browser.ClassAttributeChange categoriesForClass!Refactory-Change Objects! !
!Refactory.Browser.ClassAttributeChange methodsFor!

afterText
	^self printString!

beforeText
	^self changeClass
		ifNil: ['']
		ifNotNil: 
			[:class |
			| stream filer |
			stream := String writeStream.
			filer := class sourceFilerClass on: stream.
			self emitAttributeOf: class with: filer.
			stream contents]!

changeClass: aBehavior
	super changeClass: aBehavior.
	classReference := classReference instance!

emitAttributeOf: aClass with: aChunkSourceFiler
	self subclassResponsibility!

printOn: aStream
	| details |
	details := ClassDetails new.
	details className: classReference.
	self mutateClassDetails: details.
	self emitAttributeOf: details with: (self sourceFilerClass on: aStream)! !
!Refactory.Browser.ClassAttributeChange categoriesForMethods!
afterText!printing!public! !
beforeText!printing!public! !
changeClass:!accessing!public! !
emitAttributeOf:with:!printing!private! !
printOn:!printing!public! !
!

