"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SharedPool
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SharedPool guid: (GUID fromString: '{bcc094b0-f447-4e0c-a96b-884f8324757d}')!
SharedPool comment: ''!
!SharedPool categoriesForClass!Kernel-Objects! !
!SharedPool class methodsFor!

add: aVariableBinding 
	self classPool add: aVariableBinding!

associationAt: key
	"Answer the association named by the argument, key.  If key is not found,
	raise an exception."

	^self classPool associationAt: key!

associationAt: key ifAbsent: aNiladicValuable
	^self classPool associationAt: key ifAbsent: aNiladicValuable!

associationsDo: aMonadicValuable 
	self classPool associationsDo: aMonadicValuable!

at: aString
	^self classPool at: aString!

at: aString ifAbsent: aNiladicValuable
	"Answer the value of the receiver's binding named by the <String> 1st argument.  If the identifier is not found, answer the result of evaluating the <niladicValuable> 2nd argument."

	^classPool at: aString ifAbsent: aNiladicValuable!

at: key ifAbsentPut: operation
	"Answer the value of the receiver keyed by the <Object> argument, key.
	If key is not one of the receiver's keys, then add the result of evaluating 
	the <niladicValuable>, operation, at key, and answer that result."

	| keyString |
	keyString := self keyString: key.
	^(self classPool includesKey: keyString)
		ifFalse: [self addClassVariable: keyString value: operation value]!

at: aString put: anObject
	"Add or update a constant binding in the receiver with the specified name and value."

	self addClassConstant: (self keyString: aString) value: anObject.
	^anObject!

bindingsDo: aMonadicValuable 
	self classPool associationsDo: aMonadicValuable!

classesReferencing
	^Smalltalk allClasses select: [:c | c allSharedPools includes: self]!

includesKey: anObject
	"Answer whether the receiver has a key equal to the <Object> argument."

	"In the context of a Namespace, this will only be true if the argument is a <String> identifier with an associated binding in this namespace."

	^classPool includesKey: anObject!

isValidKey: aString
	^aString notEmpty and: 
			[| initial |
			initial := aString first.
			(initial == $_ or: [initial isLetter])
				and: [aString allSatisfy: [:each | each == $_ or: [each isAlphaNumeric]]]]!

keyAtValue: anInteger 
	^self classPool keyAtValue: anInteger!

keys
	^self classPool keys!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

newAssociation: aString value: anObject
	^self classPool newAssociation: aString value: anObject!

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

removeKey: aString 
	^self classPool removeKey: aString!

subclass: aSymbol
	^self
		subclass: aSymbol
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''! !
!SharedPool class categoriesFor: #add:!adding!public! !
!SharedPool class categoriesFor: #associationAt:!accessing!public! !
!SharedPool class categoriesFor: #associationAt:ifAbsent:!accessing!public! !
!SharedPool class categoriesFor: #associationsDo:!enumerating!public! !
!SharedPool class categoriesFor: #at:!accessing!public! !
!SharedPool class categoriesFor: #at:ifAbsent:!accessing!public! !
!SharedPool class categoriesFor: #at:ifAbsentPut:!accessing!development!public! !
!SharedPool class categoriesFor: #at:put:!adding!development!public! !
!SharedPool class categoriesFor: #bindingsDo:!enumerating!public! !
!SharedPool class categoriesFor: #classesReferencing!development!private! !
!SharedPool class categoriesFor: #includesKey:!accessing!public! !
!SharedPool class categoriesFor: #isValidKey:!adding!development!private! !
!SharedPool class categoriesFor: #keyAtValue:!accessing!public! !
!SharedPool class categoriesFor: #keys!accessing!public! !
!SharedPool class categoriesFor: #keyString:!adding!development!private! !
!SharedPool class categoriesFor: #newAssociation:value:!public! !
!SharedPool class categoriesFor: #recompileReferencesToVarNamed:!development!private! !
!SharedPool class categoriesFor: #removeKey:!public!removing! !
!SharedPool class categoriesFor: #subclass:!class hierarchy-adding!public! !

