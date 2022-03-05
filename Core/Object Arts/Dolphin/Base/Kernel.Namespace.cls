"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.Namespace'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Namespace guid: (Core.GUID fromString: '{e40d6edd-5883-4edc-b117-c508f7c8d47c}')!
Kernel.Namespace isNonInstantiable: true!
Kernel.Namespace comment: '`Namespace` defines behavior common to all namespaces, although as Classes are namespaces much of the namespace functionality is inherited from `Class`. `Namespace` adds dictionary protocol for convenience and backwards compatibility. All `Namespace` behaviour is implemented on the class side as `Namespaces` are not instantiable.

It is a good practice to define sub-namespaces as subclasses of their enclosing namespace. This is a slight misuse of subclassing since a sub-namespace is not really a sub-type of its enclosing namespace in a behavioral sense, however it is convenient and means that existing tooling presents the hierarchy in a useful way.

Terminology:

Top-level namespace - a Namespace defined in Root, e.g. Smalltalk and Core.
Absolute name - Fully qualified name including ''Root'', e.g. Root.Core.Object, is the absolute name of the Object class.
Binding References or Qualified References - a smart name that should be used to refer indirectly to classes (and other static variables) where symbolic names might previously have been used, e.g. #{Core.Object}.
Full name - Fully qualified name bindable from any top-level namespace, e.g. Smalltalk , e.g. Core.Object is the full name of the Object class.
Simple name or unqualified name, e.g. Object
Short name - A name bindable in Smalltalk, preferring unqualified form where possible.
'!
!Kernel.Namespace categoriesForClass!Kernel-Objects! !
!Kernel.Namespace class methodsFor!

add: aVariableBinding
	"Add the <VariableBinding> argument to the receiver and answer it.
	Although very similar to at:put:, we store the actual association passed as an argument here in order to maintain its references, unless there is already an existing variable among the receiver's bindings that has the same key, in which case its value is updated.
	#addNewElement: can be used to distinguish whether or not the variable was added, or its value applied to an existing variable."

	self addBinding: aVariableBinding.
	^aVariableBinding!

addAll: aCollectionOfVariableBindings
	"Include all the elements of the <collection> argument as the receiver's elements and answer that collection.
	The elements of the collection must be VariableBindings."

	aCollectionOfVariableBindings do: [:each | self add: each].
	^aCollectionOfVariableBindings!

addNewElement: aVariableBinding
	"If there is already a binding in the receiver with the same identifier as the <VariableBinding> argument, then update its value from the argument and answer false. Otherwise add the argument as a new binding in the receiver and answer true."

	^self addBinding: aVariableBinding!

allBehaviors
	"Answer a <sequencedReadableCollection> of all of the Behaviors contained in the system in namespace (including any nested namespaces).
	The answer is ordered in the allBehaviorsDo: order. This only guarantees that instance classes immmediately precede metaclasses."

	| answer |
	answer := Array writeStream: 256.
	self allBehaviorsDo: [:behavior | answer nextPut: behavior].
	^answer contents!

allBehaviorsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for each of the Behaviors in namespace and any nested namespaces.
	N.B. No guarantee is made about ordering, except that the operation is evaluated for a subclass after its superclass."

	self allClassesDo: 
			[:class |
			aMonadicValuable value: class.
			aMonadicValuable value: class class]!

allBindings
	"Answer a collection of all the bindings in the receiver, including aliases, and recursively in any of the nested namespaces."

	| bindings |
	bindings := IdentitySet new.
	self allBindingsDo: [:each | bindings add: each] visited: (IdentitySet with: self).
	^bindings!

allSatisfy: aMonadicValuable
	^classPool allSatisfy: aMonadicValuable!

anySatisfy: aMonadicValuable
	^classPool anySatisfy: aMonadicValuable!

asArray
	^classPool asArray!

asBag
	^classPool asBag!

asByteArray
	^self shouldNotImplement!

asOrderedCollection
	^classPool asOrderedCollection!

asSet
	^classPool asSet!

associationAt: key
	"Answer the association named by the argument, key.  If key is not found, raise a <NotFoundError>."

	^(self associationAt: key ifAbsent: nil) ifNil: [self errorNotFound: key] ifNotNil: [:assoc | assoc]!

associationAt: aString ifAbsent: aNiladicValuable
	^classPool associationAt: aString ifAbsent: aNiladicValuable!

associationAt: aString ifPresent: aMonadicValuable
	^classPool associationAt: aString ifPresent: aMonadicValuable!

associations
	^classPool associations!

associationsDo: aMonadicValuable
	classPool associationsDo: aMonadicValuable!

asSortedCollection
	^classPool asSortedCollection!

asSortedCollection: aDyadicValuable
	^classPool asSortedCollection: aDyadicValuable!

at: anObject
	"Answer the value at the specified <Object> key in the receiver, or if the key	is not found raise a <NotFoundError>."

	| answer |
	answer := self at: anObject ifAbsent: Collection.AbsentCookie.
	^answer == Collection.AbsentCookie ifTrue: [self errorNotFound: anObject] ifFalse: [answer]!

at: aString ifAbsent: aNiladicValuable
	"Answer the value of the receiver's binding named by the <String> 1st argument.  If the identifier is not found, answer the result of evaluating the <niladicValuable> 2nd argument."

	^classPool at: aString ifAbsent: aNiladicValuable!

at: aString ifAbsentPut: aNiladicValuable
	"Answer the value of the binding in the receiver's scope identified by the <String> 1st argument.
	If the identifier is not one found in this scope, then add the result of evaluating the <niladicValuable> as a new <VariableBinding> with that identifier."

	"Implementation Note: We can't just delegate this to the classPool, as we need to ensure that a VariableBinding is added if the key is not already present."

	| value |
	value := self at: aString ifAbsent: Collection.AbsentCookie.
	^value == Collection.AbsentCookie
		ifTrue: [self at: aString put: aNiladicValuable value]
		ifFalse: [value]!

at: aString ifPresent: aMonadicValuable
	"Answer the result of evaluating the <moadicValuable> 2nd argument with the value of the binding in the receiver's scope identified by the <String> 1st argument, of nil if there is no variable with that identifier in this scope."

	^classPool at: aString ifPresent: aMonadicValuable!

at: aString put: anObject
	"Store the <Object> 2nd argument as the value of the <VariableBinding> in the receiver with the identifier which is the <String> 1st argument. 
	If no such variable curently exists, then a new binding is added. Otherwise the value of the existing binding is updated."

	self addBinding: (VariableBinding key: aString value: anObject).
	^anObject!

baseEnvironment
	"Private - Answer the default environment for new subclasses of the receiver that the ClassBuilder should use when the provided subclass name is unqualified."

	"Namespaces created with unqualified names should be dropped into Root, not Smalltalk."

	^Root!

basicClassPool: aPoolDictionary
	"Private - Store the dictionary of variables that are defined in the receiver. Namespaces always have a classPool even if empty - it must never be nil."

	classPool := aPoolDictionary ?? Dictionary new!

changeKey: aString to: aString2
	"Private - Low level operation to rename a binding, potentially moving it to another namespace. No update events are triggered, and binding caches are not flushed."

	| binding path targetNamespace |
	binding := self localBindingFor: aString.
	self basicRemoveBinding: binding.
	path := BindingReference.PathSeparator split: aString2.
	binding setKey: path last asSymbol.
	targetNamespace := (BindingReference path: path allButLast) value.
	targetNamespace basicAddBinding: binding.
	^binding!

collect: aMonadicValuable
	^classPool collect: aMonadicValuable!

declareVariable: aString
	^(self localBindingFor: aString)
		ifNil: 
			[| var |
			var := VariableBinding key: aString value: nil.
			self addBinding: var.
			^var]!

detect: aMonadicValuable
	^classPool detect: aMonadicValuable!

detect: aMonadicValuable ifNone: aNiladicValuable
	^classPool detect: aMonadicValuable ifNone: aNiladicValuable!

do:  aMonadicValuable
	classPool do: aMonadicValuable!

do: aMonadicValuable separatedBy: aNiladicValuable
	classPool do: aMonadicValuable separatedBy: aNiladicValuable!

errorNonInstantiable
	self error: 'Namespaces cannot have any instances'!

hierarchyBindingFor: aString
	"Answer a variable binding for the named variable in the scope of this class, i.e. one of its own class variables or those of its superclasses."

	^classPool bindingFor: aString!

includes: anObject
	^classPool includes: anObject!

includesKey: aString
	"Answer whether the receiver has a key equal to the <String> argument."

	"In the context of a Namespace, this will only be true if the argument is a <String> identifier with an associated binding in this namespace."

	^classPool includesKey: aString!

inject: anObject into: aDyadicValuable
	^classPool inject: anObject into: aDyadicValuable!

isEmpty
	^classPool isEmpty!

keyAtValue: anObject
	^classPool keyAtValue: anObject!

keyAtValue: anObject ifAbsent: aNiladicValuable
	^classPool keyAtValue: anObject ifAbsent: aNiladicValuable!

keys
	^classPool keys!

keysAndValuesDo: aDyadicValuable
	classPool keysAndValuesDo: aDyadicValuable!

keysDo: aMonadicValuable
	classPool keysDo: aMonadicValuable!

localEnvironment
	"Private - Answer the nearest <Namespace> scope."

	^self
!

lookup: keyObject
	"Answer the value named by the <Object> argument, keyObject, or nil if there is no such key in the receiver.
	Clearly if the receiver can contain nil values then it will not be possible to distinguish between the absence
	of the key and the key being associated with a nil value. However, this method expresses the
	very common pattern of passing an empty block as absent handler to #at:ifAbsent:, e.g.
		(dict at: key ifAbsent: []) ifNotNil: [:value | value ...]"

	^classPool lookup: keyObject!

newClassBuilder: aClassSymbol instanceVariableNames: instVarString classVariableNames: classVarString imports: anArrayOfBindingReferences
	^(super
		newClassBuilder: aClassSymbol
		instanceVariableNames: instVarString
		classVariableNames: classVarString
		imports: anArrayOfBindingReferences)
		beNonInstantiable;
		yourself!

notEmpty
	^classPool notEmpty!

occurrencesOf: anObject
	^classPool occurrencesOf: anObject!

rehash
	classPool rehash!

reject: aMonadicValuable
	^classPool reject: aMonadicValuable!

removeAllKeys: aCollection
	aCollection do: [:each | self removeKey: each]!

removeAllKeys: aCollection ifAbsent: aValuable
	aCollection do: [:each | self removeKey: each ifAbsent: [aValuable cull: each]]!

removeKey: aString
	^self removeKey: aString ifAbsent: [self errorNotFound: aString]!

removeKey: aString ifAbsent: aNiladicValuable
	^(self removeBindingFor: aString)
		ifNil: [aNiladicValuable value]
		ifNotNil: [:binding | binding value]!

select: aMonadicValuable
	^classPool select: aMonadicValuable!

size
	"Answer the number of variables defined directly in this namespace, not including any members of nested namespaces although those namespaces themselves form part of the count."

	^classPool size!

values
	^classPool values!

variableRenamed: aVariableBinding from: aString
	self bindingsChanged.
	Smalltalk
		trigger: #variableRenamed:from:
		with: aVariableBinding
		with: (self fullNameFor: aString) asQualifiedReference! !
!Kernel.Namespace class categoriesForMethods!
add:!dictionary-adding!public! !
addAll:!dictionary-adding!public! !
addNewElement:!dictionary-adding!public! !
allBehaviors!accessing!public! !
allBehaviorsDo:!enumerating!public! !
allBindings!enumerating!public! !
allSatisfy:!dictionary-enumerating!public! !
anySatisfy:!dictionary-enumerating!public! !
asArray!dictionary-converting!public! !
asBag!dictionary-converting!public! !
asByteArray!dictionary-converting!public! !
asOrderedCollection!dictionary-converting!public! !
asSet!dictionary-converting!public! !
associationAt:!accessing!public! !
associationAt:ifAbsent:!dictionary-accessing!public! !
associationAt:ifPresent:!dictionary-accessing!public! !
associations!private! !
associationsDo:!enumerating!public! !
asSortedCollection!dictionary-converting!public! !
asSortedCollection:!dictionary-converting!public! !
at:!accessing!public! !
at:ifAbsent:!dictionary-accessing!public! !
at:ifAbsentPut:!dictionary-accessing!public! !
at:ifPresent:!accessing!public! !
at:put:!dictionary-accessing!public! !
baseEnvironment!constants!private! !
basicClassPool:!binding!private! !
changeKey:to:!private! !
collect:!dictionary-enumerating!public! !
declareVariable:!public! !
detect:!dictionary-enumerating!public! !
detect:ifNone:!dictionary-enumerating!public! !
do:!dictionary-enumerating!public! !
do:separatedBy:!dictionary-enumerating!public! !
errorNonInstantiable!public! !
hierarchyBindingFor:!bindings!public! !
includes:!dictionary-searching!public! !
includesKey:!dictionary-searching!public! !
inject:into:!dictionary-enumerating!public! !
isEmpty!dictionary-testing!public! !
keyAtValue:!dictionary-accessing!public! !
keyAtValue:ifAbsent:!dictionary-accessing!public! !
keys!dictionary-accessing!public! !
keysAndValuesDo:!dictionary-enumerating!public! !
keysDo:!dictionary-enumerating!public! !
localEnvironment!accessing!private! !
lookup:!dictionary-accessing!public! !
newClassBuilder:instanceVariableNames:classVariableNames:imports:!class hierarchy-adding!private! !
notEmpty!dictionary-testing!public! !
occurrencesOf:!dictionary-searching!public! !
rehash!dictionary-operations!public! !
reject:!dictionary-enumerating!public! !
removeAllKeys:!dictionary-removing!public! !
removeAllKeys:ifAbsent:!dictionary-removing!public! !
removeKey:!dictionary-removing!public! !
removeKey:ifAbsent:!dictionary-removing!public! !
select:!dictionary-enumerating!public! !
size!accessing!dictionary-accessing!public! !
values!dictionary-accessing!public! !
variableRenamed:from:!events!private! !
!

Kernel.Namespace class methodProtocol: #abstractDictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!
Kernel.Namespace class methodProtocol: #Dictionary attributes: #(#ansi #readOnly) selectors: #(#addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:ifAbsentPut: #at:put: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #includesKey: #inject:into: #isEmpty #keyAtValue: #keyAtValue:ifAbsent: #keys #keysAndValuesDo: #keysDo: #notEmpty #occurrencesOf: #rehash #reject: #removeAllKeys: #removeAllKeys:ifAbsent: #removeKey: #removeKey:ifAbsent: #select: #size #values)!

