"Filed out from Dolphin Smalltalk"!

PoolDictionary variableSubclass: #PoolConstantsDictionary
	instanceVariableNames: 'name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

at: key put: anObject 
	"Store the argument anObject with the external key, aKey,
	in the receiver. Answer anObject. Ensure the key is a String.
	If the key already exists in the receiver, raise an exception
	because the receiver is supposed to contain constants."

	| value keyString |
	keyString := self keyString: key.
	value := self at: keyString
				ifAbsent: 
					["New element added"
					self isChanged: true.
					^super at: keyString put: anObject].
	^value = anObject 
		ifTrue: [anObject	"No attempt was made to change the value"]
		ifFalse: [self errorModify: keyString value: anObject]!

classesReferencing
	^self environment allClasses select: [:c | c allSharedPools includes: self]!

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

	^name ifNil: [self environment keyAtValue: self ifAbsent: ['Anon']]!

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

!PoolConstantsDictionary categoriesForMethods!
add:!adding!public! !
at:ifAbsentPut:!accessing!development!public! !
at:put:!adding!development!public! !
classesReferencing!development!private! !
isValidKey:!adding!development!private! !
keyString:!adding!development!private! !
name!accessing!public! !
name:!accessing!private! !
newAssociation:value:!helpers!private! !
preResize:!adding!private! !
recompileReferencesToVarNamed:!development!private! !
removeIndex:!development!private!removing! !
!

!PoolConstantsDictionary class methodsFor!

named: aSymbol 
	^(self new)
		name: aSymbol;
		yourself! !

!PoolConstantsDictionary class categoriesForMethods!
named:!instance creation!public! !
!

