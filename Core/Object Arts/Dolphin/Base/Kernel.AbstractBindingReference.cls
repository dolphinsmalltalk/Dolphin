"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.AbstractBindingReference'
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AbstractBindingReference guid: (Core.GUID fromString: '{2d52489e-7275-4df4-9022-294a7b2f9381}')!
Kernel.AbstractBindingReference isNonInstantiable: true!
Kernel.AbstractBindingReference comment: 'Abstract superclass of binding references.'!
!Kernel.AbstractBindingReference categoriesForClass!System-Namespaces! !
!Kernel.AbstractBindingReference methodsFor!

<= aBindingReference
	"Answer whether the receiver should sort before the argument."

	^aBindingReference == self or: 
			[| cmp |
			cmp := self pathString <==> aBindingReference pathString.
			cmp == 0 ifTrue: [self isMeta not or: [aBindingReference isMeta]] ifFalse: [cmp < 0]]!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable."

	^self == anObject or: 
			[self class == anObject class
				and: [self pathString = anObject pathString and: [self context == anObject context]]]!

append: aString
	"Answer a new <BindingReference> that refers to the nested name identified by the <readableString> argument within the receiver's scope."

	^self class path: (self path copyWith: aString) context: self context!

asFullyQualifiedReference
	"Answer a<BindingReference> that references the same binding as the receiver does currently in its home context, but from Smalltalk or Root."

	^BindingReference path: (self namespace fullPath copyWith: self unqualifiedName)!

asQualifiedReference
	"Answer the <BindingReference> equivalent of the receiver."

	^self!

asString
	"Answer a <readableString> that describes the receiver as a qualified name in the context of the home namespace."

	^self subclassResponsibility!

asSymbol
	"Answer the <symbol> corresponding to the receiver's fully-qualified name."

	^self asString asSymbol!

binding
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable)."

	^self bindingOrNil ifNil: [self home errorNotFound: self]!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^self subclassResponsibility!

context
	"The name context in which resolution of the binding should be initiated."

	^self subclassResponsibility!

declare
	"Create a binding in the target namespace that would be resolved by the receiver, if none currently exists."

	| p nsPath ns |
	p := self path.
	nsPath := p allButLast.
	ns := self home.
	nsPath isEmpty
		ifFalse: 
			[(self home resolveBindingPath: nsPath)
				ifNil: [^self home errorNotFound: (BindingReference path: nsPath context: self context)]
				ifNotNil: [:nsBinding | ns := nsBinding targetVariable value]].
	^ns declareVariable: p last!

declare: anObject
	"Create a binding in the target namespace that would be resolved by the receiver, if none currently exists.
	Set the value of the new or existing binding to the argument."

	self declare value: anObject!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self pathString!

environment
	"Answer the in namespace which the referenced binding should be found, or nil if any of the namespaces on the path do not exist."

	| parts |
	parts := self path.
	^parts size > 1
		ifTrue: [(self home resolveBindingPath: parts allButLast) ifNotNil: [:ns | ns value]]
		ifFalse: [self home]!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the home context."

	| stream parts first |
	parts := self path.
	stream := String writeStream: 32.
	first := false.
	self context
		ifNil: [
			parts size <= 1
				ifTrue: [Smalltalk printFullNameOn: stream]
				ifFalse: [first := true]]
		ifNotNil: [:ctxt | ctxt localEnvironment printFullNameOn: stream].
	1 to: parts size - 1
		do: 
			[:i |
			first ifTrue: [first := false] ifFalse: [stream nextPut: $.].
			stream nextPutAll: (parts at: i)].
	^stream contents!

hash
	"Answer the <integer> hash value for the receiver."

	^self subclassResponsibility!

home
	"Answer the home <Namespace> to which this binding reference is relative."

	^self subclassResponsibility!

ifDefined: aMonadicValuable
	"If the receiver is defined (see #isDefined), then evaluate the <monadicValuable> argument with the value of the resolved variable.
	Answer the result of the evaluation, or nil if the binding is undefined."

	^self bindingOrNil ifNotNil: [:var | aMonadicValuable value: (self valueOfBinding: var)]!

ifDefined: aMonadicValuable ifNotDefined: aNiladicValuable
	"Answer the result of evaluating either the <monadicValuable> argument, if the receiver is defined (see #isDefined), with the value of the resolved variable, or the result of evaluating the <niladicValuable> argument if the receiver is not defined."

	^self bindingOrNil
		ifNil: [aNiladicValuable value]
		ifNotNil: [:var | aMonadicValuable value: (self valueOfBinding: var)]!

ifDefinedDo: aMonadicValuable
	"Ugly selector, but for compatibility. Prefer #ifDefined:"

	^self ifDefined: aMonadicValuable!

ifDefinedDo: aMonadicValuable elseDo: aNiladicValuable
	"Ugly selector, but for compatibility. Prefer #ifDefined:ifNotDefined:"

	^self ifDefined: aMonadicValuable ifNotDefined: aNiladicValuable!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^self subclassResponsibility!

isDefined
	"Answer whether the receiver refers to a defined variable."

	^self bindingOrNil notNil!

isLiteral
	"Answer whether or not the receiver has a literal representation (probably its printString) which is directly recognised by the Compiler"

	^true!

isMeta
	"Is this a meta binding reference?"

	^false!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^self subclassResponsibility!

isPrivate: aBoolean
	self subclassResponsibility!

isQualifiedName
	"Answer whether the receiver is a name with more than one component."

	^self path size > 1!

literalTextStyle
	^#literalBindingReference!

meta
	"Answer a `MetaBindingReference` that resolves to the class of the value of the binding to which the receiver resolves."

	^self subclassResponsibility!

namespace
	"Answer the <Namespace> in which the referenced binding should be found, or nil if the namespace path is incomplete."

	| p |
	p := self path.
	^p size > 1
		ifTrue: [(self home resolveBindingPath: p allButLast) value]
		ifFalse: [self home localEnvironment]!

namespaceBinding
	"Answer the namespace in which the referenced binding should be found (if it exists). If any of the namespaces on the binding path do not exist, an error will be thrown."

	| p |
	p := self path.
	^p size > 1
		ifTrue: [self home resolveBindingPath: p allButLast]
		ifFalse: [self home localEnvironment binding]!

owningPackage: aPackage 
	^self instance value owningPackage: aPackage!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^self subclassResponsibility!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

	^self subclassResponsibility!

printOn: aStream
	"Append a text to the <puttableStream> argument representing the receiver in the textual form a developer would want (i.e. as a literal qualified reference)."

	aStream
		nextPutAll: '#{';
		display: self.
	self isPrivate ifTrue: [aStream nextPutAll: ' private'].
	aStream nextPut: $}!

private
	self isPrivate: true.
	^self!

refersToLiteral: anObject
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal. Normally this would only be true of LiteralBindingReferences, but other types of BindingReferences could find their way into literal frames if they result from the evaluation of a static expression."

	^self = anObject or: 
			[anObject notNil
				and: [self bindingOrNil ifNil: [false] ifNotNil: [:binding | binding refersToLiteral: anObject]]]!

shortName
	"Answer the shorted <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^Smalltalk shortNameFor: self unqualifiedName in: self namespace!

simpleName
	"Answer the unqualified name part of the receiver (the final component of the name).
	This is defined for compatibility. Use #unqualifiedName by preference."

	^self unqualifiedName!

species
	^BindingReference!

storeOn: aStream
	"This should probably store the full path."

	self printOn: aStream!

undeclare
	"Remove the binding in the target namespace that would be resolved by the receiver, if it exists."

	| p nsPath ns |
	p := self path.
	nsPath := p allButLast.
	ns := self home.
	nsPath isEmpty
		ifFalse: 
			[(self home resolveBindingPath: nsPath)
				ifNil: [^self]
				ifNotNil: [:nsBinding | ns := nsBinding targetVariable value]].
	^ns removeLocalBindingFor: p last!

unqualifiedName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^self path last!

value
	"Answer the value of the variable named by the receiver. Raise an error if the variable is not defined."

	^self valueOfBinding: self binding!

valueOfBinding: aVariableBinding
	^aVariableBinding value!

valueOrDo: aNiladicValuable
	"Answer the value of the variable named by the receiver, or the result of evaluating the <niladicValuable> argument if not defined."

	^self bindingOrNil ifNil: [aNiladicValuable value] ifNotNil: [:var | self valueOfBinding: var]!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined.
	Note that it will not be possible to distinguish the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil ifNotNil: [:var | self valueOfBinding: var]! !
!Kernel.AbstractBindingReference categoriesFor: #<=!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #=!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #append:!copying!public! !
!Kernel.AbstractBindingReference categoriesFor: #asFullyQualifiedReference!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #asQualifiedReference!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #asString!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #asSymbol!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #binding!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #context!constants!public! !
!Kernel.AbstractBindingReference categoriesFor: #declare!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #declare:!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #displayOn:!displaying!public! !
!Kernel.AbstractBindingReference categoriesFor: #environment!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #environmentName!public! !
!Kernel.AbstractBindingReference categoriesFor: #hash!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #home!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefined:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefined:ifNotDefined:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefinedDo:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefinedDo:elseDo:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #instance!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #isDefined!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isLiteral!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isMeta!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isPrivate!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isPrivate:!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #isQualifiedName!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #literalTextStyle!constants!public! !
!Kernel.AbstractBindingReference categoriesFor: #meta!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #namespace!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #namespaceBinding!public! !
!Kernel.AbstractBindingReference categoriesFor: #owningPackage:!accessing!development!private! !
!Kernel.AbstractBindingReference categoriesFor: #path!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #printOn:!printing!public! !
!Kernel.AbstractBindingReference categoriesFor: #private!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #refersToLiteral:!private!testing! !
!Kernel.AbstractBindingReference categoriesFor: #shortName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #simpleName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #species!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #storeOn:!public!storing! !
!Kernel.AbstractBindingReference categoriesFor: #undeclare!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #unqualifiedName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #value!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #valueOfBinding:!accessing!private! !
!Kernel.AbstractBindingReference categoriesFor: #valueOrDo:!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #valueOrNil!accessing!public! !

!Kernel.AbstractBindingReference class methodsFor!

errorInvalidIdentifier: aString
	^self error: ('Invalid identifier: ''<s>''' expandMacrosWith: aString)!

initialize
	Undeclared := UndeclaredVariable new!

isQualifiedName: aString
	"Answer whether the argument is probably a qualified name (as opposed to an unqualified, or simple, name)."

	^(aString
		nextIdentityIndexOf: $.
		from: 1
		to: aString size) ~~ 0!

isValidQualifiedName: aString
	"Answer whether the argument is a valid static variable name, qualified or unqualified."

	^(self isQualifiedName: aString)
		ifTrue: [(self splitQualifiedName: aString) allSatisfy: [:each | self isValidUnqualifiedName: each]]
		ifFalse: [self isValidUnqualifiedName: aString]!

isValidUnqualifiedName: aString
	| size |
	size := aString size.
	^size ~~ 0 and: 
			[| first |
			first := aString at: 1.
			"We allow identifiers to start with underscores or any letter. We don't insist on uppercase letters as this is a convention, not a syntax restriction."
			((first == $_ and: [size > 1]) or: [first isLetter])
				and: [aString allSatisfy: [:each | each isAlphaNumeric or: [each == $_]]]]!

new
	^self pathString: ''!

newPath: anArray context: anObject
	^self subclassResponsibility!

path: aSequencedReadableCollection
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection context: nil!

path: aSequencedReadableCollection context: anObject
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self newPath: aSequencedReadableCollection context: anObject!

path: aSequencedReadableCollection home: aNamespaceOrNil
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection
		context: (aNamespaceOrNil == Smalltalk ifFalse: [aNamespaceOrNil])!

pathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument."

	^self pathString: aString context: nil!

pathString: aString context: anObject
	"Answer a new sub-instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self subclassResponsibility!

pathString: aString home: aNamespace
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument,
	homed in the specified <Namespace>."

	^self pathString: aString context: (aNamespace == Smalltalk ifFalse: [aNamespace])!

simpleName: aString
	"Answer a new instance of the receiver representing the variable with the specified unqualified name."

	^self pathString: aString!

simpleName: aString in: aNamespace
	"Answer a new instance of the receiver representing the variable with the specified unqualified name in the specified <Namespace>."

	^self pathString: aString home: aNamespace!

splitQualifiedName: aString
	^$. split: aString! !
!Kernel.AbstractBindingReference class categoriesFor: #errorInvalidIdentifier:!exceptions!private! !
!Kernel.AbstractBindingReference class categoriesFor: #initialize!class initialization!public! !
!Kernel.AbstractBindingReference class categoriesFor: #isQualifiedName:!enquiries!public! !
!Kernel.AbstractBindingReference class categoriesFor: #isValidQualifiedName:!enquiries!public! !
!Kernel.AbstractBindingReference class categoriesFor: #isValidUnqualifiedName:!enquiries!public! !
!Kernel.AbstractBindingReference class categoriesFor: #new!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!Kernel.AbstractBindingReference class categoriesFor: #path:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:context:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:home:!compatibility!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:context:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:home:!compatibility!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #simpleName:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #simpleName:in:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #splitQualifiedName:!helpers!public! !

