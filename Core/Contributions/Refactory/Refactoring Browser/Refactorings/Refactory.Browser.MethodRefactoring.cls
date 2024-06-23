"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Refactoring
	subclass: #'Refactory.Browser.MethodRefactoring'
	instanceVariableNames: 'class'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.MethodRefactoring guid: (Core.GUID fromString: '{f93954e7-217f-4070-b44d-b7d1f1bc74d3}')!

Refactory.Browser.MethodRefactoring isNonInstantiable: true!

Refactory.Browser.MethodRefactoring comment: ''!

!Refactory.Browser.MethodRefactoring categoriesForClass!Refactory-Refactorings! !

!Refactory.Browser.MethodRefactoring methodsFor!

buildSelectorString: aSelector
	aSelector argumentCount = 0 ifTrue: [^aSelector].
	^self buildSelectorString: aSelector
		withPermuteMap: (1 to: aSelector argumentCount)!

buildSelectorString: aSelector withPermuteMap: anIntegerCollection
	| stream keywords |
	aSelector argumentCount == 0 ifTrue: [^aSelector asString].
	stream := WriteStream on: String new.
	keywords := aSelector keywords.
	keywords with: anIntegerCollection
		do: 
			[:each :i |
			stream
				nextPutAll: each;
				nextPutAll: ' ``@arg';
				print: i;
				nextPut: $\x20].
	^stream contents!

fullyQualifyReference: aQualifiedReferenceNode
	"Rewrite a qualified reference to the fully-qualified path of the static variable."

	^aQualifiedReferenceNode binding
		ifNil: [aQualifiedReferenceNode copy]
		ifNotNil: 
			[:binding |
			(aQualifiedReferenceNode copyWithName: binding fullName)
				isRelative: false;
				yourself]!

rewriteRelativeReference: aStQualifiedRefNode
	^aStQualifiedRefNode binding
		ifNil: [aStQualifiedRefNode copy]
		ifNotNil: [:binding | self rewriteRelativeReference: aStQualifiedRefNode toTarget: binding]!

shouldOverride: aSymbol in: aClass
	^(self lookupOption: #alreadyDefined)
		cull: self
		cull: aClass
		cull: aSymbol! !

!Refactory.Browser.MethodRefactoring categoriesForMethods!
buildSelectorString:!helpers!private! !
buildSelectorString:withPermuteMap:!helpers!private! !
fullyQualifyReference:!private!transforming! !
rewriteRelativeReference:!private!transforming! !
shouldOverride:in:!private!requests! !
!

