"Filed out from Dolphin Smalltalk 7"!

PoolDictionary variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PoolConstantsDictionary guid: (GUID fromString: '{87b4c52e-026e-11d3-9fd7-00a0cc3e4a32}')!
PoolConstantsDictionary comment: ''!
!PoolConstantsDictionary categoriesForClass!Collections-Unordered!System-Support! !
!PoolConstantsDictionary methodsFor!

add: anAssociation
	"Add the key/value pair provided in the <Association> argument to the receiver.
	The actual <Association> is not added as there are many constraints so it is safe to add a newly formed constant VariableBinding."

	self at: anAssociation key put: anAssociation value.
	^anAssociation!

at: key ifAbsentPut: operation 
	"Answer the value of the receiver keyed by the <Object> argument, key.
	If key is not one of the receiver's keys, then add the result of evaluating 
	the <niladicValuable>, operation, at key, and answer that result."

	^super at: key asString
		ifAbsentPut: 
			[self isChanged: true.
			operation value]!

classesReferencing
	^Smalltalk allClasses select: [:c | c allSharedPools includes: self]!

isValidKey: aString
	^aString notEmpty and: 
			[| initial |
			initial := aString first.
			(initial == $_ or: [initial isLetter])
				and: [aString allSatisfy: [:each | each == $_ or: [each isAlphaNumeric]]]]!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

name
	"Answer the receiver's name."

	^name ifNil: [super name]!

name: aSymbol 
	name := aSymbol asSymbol!

newAssociation: keyObject value: valueObject 
	^(super newAssociation: keyObject value: valueObject)
		isImmutable: true;
		yourself!

preResize: newMe 
	"Private - This message is sent by the receiver when resizing, before the
	receiver's elements are added to newMe. We must assign across the
	search policy."

	name isNil ifFalse: [newMe name: name]!

recompileReferencesToVarNamed: keyString
	"Private - Recompile any methods which references the named key, assumed to
	be a variable name from the receiver."

	| var |
	Notification
		signal: ('Recompiling references to <1p> in <2s>' expandMacrosWith: keyString with: self name).
	var := self associationAt: keyString.
	self classesReferencing do: 
			[:c |
			c recompileReferencesToLiteral: var.
			c class recompileReferencesToLiteral: var]!

removeIndex: anInteger
	"Private - Remove the element at index, anInteger, in the receiver. Does not
	check that the element is empty."

	super removeIndex: anInteger.
	self isChanged: true! !
!PoolConstantsDictionary categoriesFor: #add:!adding!public! !
!PoolConstantsDictionary categoriesFor: #at:ifAbsentPut:!accessing!development!public! !
!PoolConstantsDictionary categoriesFor: #classesReferencing!development!private! !
!PoolConstantsDictionary categoriesFor: #isValidKey:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #keyString:!adding!development!private! !
!PoolConstantsDictionary categoriesFor: #name!accessing!public! !
!PoolConstantsDictionary categoriesFor: #name:!accessing!private! !
!PoolConstantsDictionary categoriesFor: #newAssociation:value:!helpers!private! !
!PoolConstantsDictionary categoriesFor: #preResize:!adding!private! !
!PoolConstantsDictionary categoriesFor: #recompileReferencesToVarNamed:!development!private! !
!PoolConstantsDictionary categoriesFor: #removeIndex:!development!private!removing! !

!PoolConstantsDictionary class methodsFor!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !
!PoolConstantsDictionary class categoriesFor: #named:!instance creation!public! !

