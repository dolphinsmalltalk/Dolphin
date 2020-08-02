"Filed out from Dolphin Smalltalk 7"!

Object subclass: #UndefinedObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
UndefinedObject guid: (GUID fromString: '{87b4c4c9-026e-11d3-9fd7-00a0cc3e4a32}')!
UndefinedObject comment: 'UndefinedObject is the singleton class of the distinguished object, <nil>.

<nil> is the initial value of all new variables (instance or otherwise), and hence a  primary purpose of UndefinedObject is to provide a means of detecting errors, especially those resulting from the failure to correctly initialize variables.

<nil> is also useful for explicitly representing a null value, e.g. in a variable which has no value. A common use of this type is in conjunction with lazy initialization. In this respect <nil> has a similar purpose to the SQL <null> value.

When interfacing to external functions, etc, <nil> is treated as the null pointer, or zero, as appropriate to the parameter type.

UndefinedObject implements the following ANSI protocols:
	<Object>
	<nil>'!
!UndefinedObject categoriesForClass!Kernel-Objects! !
!UndefinedObject methodsFor!

?? anObject
	"Answer the receiver if not nil, else the operand."

	^anObject!

_deepCopy: copiesDictionary
	^self!

bindingFor: aString 
	"Answer a variable binding for the named variable in the scope of this class. 
	If there is no such variable, then answer nil."

	^nil!

deepCopy
	"Answer the receiver - there is only one instance, nil."

	^self!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see.
	The default is to do nothing, since, from the end-user perspective, the receiver is a null."!

ifNil: nilBlock 
	"As the receiver is the nil object, answer the result of evaluating the <niladicValuable>,
	nilBlock."

	"Implementation Note: This message is normally inlined by the compiler and so is never sent
	unless #perform'd."

	^nilBlock value!

ifNil: nilBlock ifNotNil: notNilBlock 
	"As the receiver is the nil object, answer the result of evaluating the <niladicValuable>,
	nilBlock."

	"Implementation Note: This message is normally inlined by the compiler and so is never sent
	unless #perform'd."

	^nilBlock value!

ifNotNil: notNilBlock 
	"As the receiver is the nil object, ignore the <valuable> argument and answer nil."

	"Implementation Note: This message is normally inlined by the compiler and so is never sent
	unless #perform'd."

	^self!

ifNotNil: notNilBlock ifNil: nilBlock 
	"As the receiver is the nil object, answer the result of evaluating the <niladicValuable>,
	nilBlock."

	"Implementation Note: This message is normally inlined by the compiler and so is never sent
	unless #perform'd."

	^nilBlock value!

includesBehavior: aBehavior
	"Answer whether the receiver includes the behavior, aClass
	(i.e. is aBehavior the receiver or a superclass of the receiver)"

	^aBehavior isNil!

isAtomic
	"Answer whether or not the receiver has a single unique instance for any individual value it
	can represent."

	"UndefinedObject has the single unique instance, nil"

	^true!

isLiteral
	"Answer whether or not the receiver has a literal representation (probably its
	printString) which is directly recognised by the Compiler. Of course nil does."

	^true!

isNil
	"Answer whether the receiver is the manifest constant, nil. Of course it is."

	^true
!

isNull
	"Private - Answer whether the receiver is 'Null'. A Dolphin object is Null
	if it is passed/returned to an external library function as the Null pointer.
	nil is interchangeable with 0 in this respect."

	^true!

name
	"Answer the name of a class."

	^'nil'!

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(ClassBuilder new)
		className: aClassSymbol;
		instanceVariableString: instVarString;
		classVariableString: classVarString;
		sharedPoolString: poolDictString;
		yourself!

notNil
	"Answer whether the receiver is not the manifest constant, nil. Of course it isn't."

	^false
!

notNull
	"Private - Answer whether the receiver is not 'Null'. See #isNull for
	further explanation."

	^false!

printOn: aStream
	"Append a short textual description of the receiver to <aStream>.
	Note that this override refines #printString to comply with the ANSI 
	protocol <nil>."
	
	aStream nextPutAll: 'nil'!

printString
	"Answer a <readableString> whose characters are a description of the receiver 
	as a developer would want to see it."

	^'nil'!

refersToLiteral: anObject
	^anObject isNil!

shallowCopy
	"Answer the receiver - there is only one instance, nil."

	^self!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString
	^(self 
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		modifyOrCreate!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString category: aCategoryOrString
	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString)
		categoryNames: {aCategoryOrString};
		modifyOrCreate!

subclass: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		poolDictionaries: poolDictString
		classInstanceVariableNames: classInstVarString
	"If aClassSymbol is not an existing class then create and answer a new fixed-pointer subclass,
	otherwise modify the class with name aClassSymbol to have the indicated features and answer it.
	Subclasses of nil are root classes, like Object, and special care is needed in their definition. 
	It is also the case that many modifications of Object are illegal (it cannot have named instance 
	variables for example)."

	| subclass |
	subclass := self 
				subclass: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				poolDictionaries: poolDictString.
	subclass class instanceVariableNames: classInstVarString.
	^subclass
!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString poolDictionaries: poolDictString classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"If aClassSymbol is not an existing class then create and answer a new fixed-pointer subclass,  otherwise modify the class with name aClassSymbol to have the indicated features and answer it. Subclasses of nil are root classes, like Object, and special care is needed in their definition.  It is also the case that many modifications of Object are illegal (it cannot have named instance variables for example)."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				poolDictionaries: poolDictString)
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

yourAddress
	"Private - Answer the address of the receiver.
	Nil is treated like a NULL pointer."

	^0! !
!UndefinedObject categoriesFor: #??!converting!public! !
!UndefinedObject categoriesFor: #_deepCopy:!copying!private! !
!UndefinedObject categoriesFor: #bindingFor:!binding!public! !
!UndefinedObject categoriesFor: #deepCopy!copying!public! !
!UndefinedObject categoriesFor: #displayOn:!displaying!public! !
!UndefinedObject categoriesFor: #ifNil:!control flow!public! !
!UndefinedObject categoriesFor: #ifNil:ifNotNil:!control flow!public! !
!UndefinedObject categoriesFor: #ifNotNil:!control flow!public! !
!UndefinedObject categoriesFor: #ifNotNil:ifNil:!control flow!public! !
!UndefinedObject categoriesFor: #includesBehavior:!class hierarchy-testing!public! !
!UndefinedObject categoriesFor: #isAtomic!public!testing! !
!UndefinedObject categoriesFor: #isLiteral!public!testing! !
!UndefinedObject categoriesFor: #isNil!public!testing! !
!UndefinedObject categoriesFor: #isNull!private!testing! !
!UndefinedObject categoriesFor: #name!accessing!public! !
!UndefinedObject categoriesFor: #newClassBuilder:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!private! !
!UndefinedObject categoriesFor: #notNil!public!testing! !
!UndefinedObject categoriesFor: #notNull!private!testing! !
!UndefinedObject categoriesFor: #printOn:!printing!public! !
!UndefinedObject categoriesFor: #printString!printing!public! !
!UndefinedObject categoriesFor: #refersToLiteral:!private!testing! !
!UndefinedObject categoriesFor: #shallowCopy!copying!public! !
!UndefinedObject categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:!class hierarchy-adding!public! !
!UndefinedObject categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:category:!class hierarchy-adding!public! !
!UndefinedObject categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:!class hierarchy-adding!public! !
!UndefinedObject categoriesFor: #subclass:instanceVariableNames:classVariableNames:poolDictionaries:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
!UndefinedObject categoriesFor: #yourAddress!accessing!private! !

!UndefinedObject class methodsFor!

new
	"Answer a new instance of the receiver.
	There can be only one!!"

	^nil! !
!UndefinedObject class categoriesFor: #new!instance creation!public! !

