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

add: anAssociation
	self at: anAssociation key put: anAssociation value.
	^anAssociation!

associationAt: key
	"Answer the association named by the argument, key.  If key is not found,
	raise an exception."

	^self classPool associationAt: key!

associationAt: key ifAbsent: aNiladicValuable
	^self classPool associationAt: key ifAbsent: aNiladicValuable!

associationsDo: aMonadicValuable 
	self classPool associationsDo: aMonadicValuable!

at: aString
	^self classPool at: (self keyString: aString)!

at: aString ifAbsent: aNiladicValuable
	^self classPool at: (self keyString: aString) ifAbsent: aNiladicValuable!

at: aString ifAbsentPut: operation
	"Answer the value of the receiver's named binding. If aString does not name one of the receiver's bindings, then a new constant binding of that name with the value that is the result of evaluating the <niladicValuable>, operation, and answer the value."

	| keyString |
	keyString := self keyString: aString.
	^self classPool at: keyString
		ifAbsent: [(self addClassConstant: keyString value: operation value) value]!

at: aString put: anObject
	"Add or update a constant binding in the receiver with the specified name and value."

	self addClassConstant: (self keyString: aString) value: anObject.
	^anObject!

bindingsDo: aMonadicValuable 
	self classPool associationsDo: aMonadicValuable!

classesReferencing
	^Smalltalk allClasses select: [:c | c allSharedPools includes: self]!

includesKey: aString 
	^self classPool includesKey: (self keyString: aString)!

isValidKey: aString
	^aString notEmpty and: 
			[| initial |
			initial := aString first.
			(initial == $_ or: [initial isLetter])
				and: [aString allSatisfy: [:each | each == $_ or: [each isAlphaNumeric]]]]!

keyAtValue: anObject
	^self classPool keyAtValue: anObject!

keys
	^self classPool keys!

keyString: anObject
	| answer |
	answer := anObject asString.
	(self isValidKey: answer) ifFalse: [^self error: ('Invalid key: <1p>' expandMacrosWith: answer)].
	^answer!

localEnvironment
	"Answer the nearest Namespace scope."

	^self!

newAssociation: aString value: anObject
	^self classPool newAssociation: aString value: anObject!

removeKey: aString 
	^self classPool removeKey: aString!

size
	^self classPool size!

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
!SharedPool class categoriesFor: #isValidKey:!adding!private! !
!SharedPool class categoriesFor: #keyAtValue:!accessing!public! !
!SharedPool class categoriesFor: #keys!accessing!public! !
!SharedPool class categoriesFor: #keyString:!adding!private! !
!SharedPool class categoriesFor: #localEnvironment!accessing!public! !
!SharedPool class categoriesFor: #newAssociation:value:!public! !
!SharedPool class categoriesFor: #removeKey:!public!removing! !
!SharedPool class categoriesFor: #size!accessing!public! !
!SharedPool class categoriesFor: #subclass:!class hierarchy-adding!public! !

