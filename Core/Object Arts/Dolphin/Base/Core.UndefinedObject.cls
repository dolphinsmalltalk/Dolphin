"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.UndefinedObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.UndefinedObject guid: (Core.GUID fromString: '{87b4c4c9-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.UndefinedObject comment: 'UndefinedObject is the singleton class of the distinguished object, <nil>.

<nil> is the initial value of all new variables (instance or otherwise), and hence a  primary purpose of UndefinedObject is to provide a means of detecting errors, especially those resulting from the failure to correctly initialize variables.

<nil> is also useful for explicitly representing a null value, e.g. in a variable which has no value. A common use of this type is in conjunction with lazy initialization. In this respect <nil> has a similar purpose to the SQL <null> value.

When interfacing to external functions, etc, <nil> is treated as the null pointer, or zero, as appropriate to the parameter type.

UndefinedObject implements the following ANSI protocols:
	<Object>
	<nil>'!
!Core.UndefinedObject categoriesForClass!Kernel-Objects! !
!Core.UndefinedObject methodsFor!

?? anObject
	"Answer the receiver if not nil, else the operand."

	"N.B. This implementation cannot be overridden, and is never, in fact, received (unless #perform'd), because #?? is inlined by the VM."

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
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	The default is to do nothing, since, from the end-user perspective, the receiver is a null."!

fullName
	"Answer the <String> fully qualified name of the receiver, which is a dot-separated path that binds to the receiver from the global namespace, Root."

	^'nil'!

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

importsFromPoolsString: poolDictString
	^poolDictString subStrings distinct collect: [:each | each asQualifiedReference]!

includesEnvironment: aClass
	^false!

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

localBindingFor: aString
	"Answer a variable binding for the named variable directly in the scope of this class, i.e. one of its own class variables. If there is no such class variable, then answer nil."

	^nil!

name
	"Answer the name of a class."

	^'nil'!

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences
	^ClassBuilder new
		className: aClassSymbol;
		instanceVariableString: instVarString;
		classVariableString: classVarString;
		imports: anArrayOfBindingReferences;
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

refersTo: anObject asLiteralOf: aCompiledMethod
	^anObject isNil!

shallowCopy
	"Answer the receiver - there is only one instance, nil."

	^self!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray
	^(self
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: anArray) modifyOrCreate!

subclass: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArray classInstanceVariableNames: classInstVarString classConstants: anArrayOfAssociations
	"If aClassSymbol is not an existing class then create and answer a new fixed-pointer subclass,  otherwise modify the class with name aClassSymbol to have the indicated features and answer it. Subclasses of nil are root classes, like Object, and special care is needed in their definition.  It is also the case that many modifications of Object are illegal (it cannot have named instance variables for example)."

	| subclass |
	subclass := (self
				newClassBuilder: aClassSymbol
				instanceVariableNames: instVarString
				classVariableNames: classVarString
				imports: anArray)
				classConstants: anArrayOfAssociations;
				modifyOrCreate.
	subclass class instanceVariableNames: classInstVarString.
	^subclass!

yourAddress
	"Private - Answer the address of the receiver.
	Nil is treated like a NULL pointer."

	^0! !
!Core.UndefinedObject categoriesForMethods!
??!converting!public! !
_deepCopy:!copying!private! !
bindingFor:!bindings!public! !
deepCopy!copying!public! !
displayOn:!displaying!public! !
fullName!accessing!public! !
ifNil:!control flow!public! !
ifNil:ifNotNil:!control flow!public! !
ifNotNil:!control flow!public! !
ifNotNil:ifNil:!control flow!public! !
importsFromPoolsString:!class hierarchy-adding!private! !
includesEnvironment:!public!testing! !
isAtomic!public!testing! !
isLiteral!public!testing! !
isNil!public!testing! !
isNull!private!testing! !
localBindingFor:!bindings!public! !
name!accessing!public! !
newClassBuilder:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!private! !
notNil!public!testing! !
notNull!private!testing! !
printOn:!printing!public! !
printString!printing!public! !
refersTo:asLiteralOf:!private!testing! !
shallowCopy!copying!public! !
subclass:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!public! !
subclass:instanceVariableNames:classVariableNames:imports:classInstanceVariableNames:classConstants:!class hierarchy-adding!public! !
yourAddress!accessing!private! !
!

!Core.UndefinedObject class methodsFor!

new
	"Answer a new instance of the receiver.
	There can be only one!!"

	^nil! !
!Core.UndefinedObject class categoriesForMethods!
new!instance creation!public! !
!

