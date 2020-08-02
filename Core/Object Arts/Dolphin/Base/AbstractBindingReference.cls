"Filed out from Dolphin Smalltalk 7"!

Object subclass: #AbstractBindingReference
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractBindingReference guid: (GUID fromString: '{2d52489e-7275-4df4-9022-294a7b2f9381}')!
AbstractBindingReference isAbstract: true!
AbstractBindingReference comment: 'Abstract superclass of binding references.'!
!AbstractBindingReference categoriesForClass!System-Namespaces! !
!AbstractBindingReference methodsFor!

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
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self pathString!

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

	^false!

isWildcard
	"Answer whether the receiver represents a wildcard reference to match all the names in a namespace."

	^false!

literalTextStyle
	^#literalBindingReference!

meta
	"Answer a `MetaBindingReference` that resolves to the class of the value of the binding to which the receiver resolves."

	^self subclassResponsibility!

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
		display: self;
		nextPut: $}!

refersToLiteral: anObject
	"Private - Answer whether the receiver is a reference to the literal argument.
	This assumes that the receiver is in the role of a literal. Normally this would only be true of LiteralBindingReferences, but other types of BindingReferences could find their way into literal frames if they result from the evaluation of a static expression."

	^self = anObject or: 
			[anObject notNil
				and: [self bindingOrNil ifNil: [false] ifNotNil: [:binding | binding refersToLiteral: anObject]]]!

simpleName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^self path last!

species
	^BindingReference!

storeOn: aStream
	"This should probably store the full path."

	self printOn: aStream!

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
	Note that it will not be possible to define the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil ifNotNil: [:var | self valueOfBinding: var]! !
!AbstractBindingReference categoriesFor: #<=!comparing!public! !
!AbstractBindingReference categoriesFor: #=!comparing!public! !
!AbstractBindingReference categoriesFor: #asQualifiedReference!converting!public! !
!AbstractBindingReference categoriesFor: #asString!converting!public! !
!AbstractBindingReference categoriesFor: #asSymbol!converting!public! !
!AbstractBindingReference categoriesFor: #binding!accessing!public! !
!AbstractBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!AbstractBindingReference categoriesFor: #context!constants!public! !
!AbstractBindingReference categoriesFor: #declare!operations!public! !
!AbstractBindingReference categoriesFor: #declare:!operations!public! !
!AbstractBindingReference categoriesFor: #displayOn:!displaying!public! !
!AbstractBindingReference categoriesFor: #hash!comparing!public! !
!AbstractBindingReference categoriesFor: #home!accessing!public! !
!AbstractBindingReference categoriesFor: #ifDefined:!evaluating!public! !
!AbstractBindingReference categoriesFor: #ifDefined:ifNotDefined:!evaluating!public! !
!AbstractBindingReference categoriesFor: #ifDefinedDo:!evaluating!public! !
!AbstractBindingReference categoriesFor: #ifDefinedDo:elseDo:!evaluating!public! !
!AbstractBindingReference categoriesFor: #instance!converting!public! !
!AbstractBindingReference categoriesFor: #isDefined!public!testing! !
!AbstractBindingReference categoriesFor: #isLiteral!public!testing! !
!AbstractBindingReference categoriesFor: #isMeta!public!testing! !
!AbstractBindingReference categoriesFor: #isPrivate!public!testing! !
!AbstractBindingReference categoriesFor: #isWildcard!public!testing! !
!AbstractBindingReference categoriesFor: #literalTextStyle!constants!public! !
!AbstractBindingReference categoriesFor: #meta!converting!public! !
!AbstractBindingReference categoriesFor: #path!accessing!public! !
!AbstractBindingReference categoriesFor: #pathString!accessing!public! !
!AbstractBindingReference categoriesFor: #printOn:!printing!public! !
!AbstractBindingReference categoriesFor: #refersToLiteral:!private!testing! !
!AbstractBindingReference categoriesFor: #simpleName!accessing!public! !
!AbstractBindingReference categoriesFor: #species!comparing!public! !
!AbstractBindingReference categoriesFor: #storeOn:!public!storing! !
!AbstractBindingReference categoriesFor: #value!accessing!public! !
!AbstractBindingReference categoriesFor: #valueOfBinding:!accessing!private! !
!AbstractBindingReference categoriesFor: #valueOrDo:!accessing!public! !
!AbstractBindingReference categoriesFor: #valueOrNil!accessing!public! !

!AbstractBindingReference class methodsFor!

errorInvalidIdentifier: aString
	^self error: ('Invalid identifier: ''<s>''' expandMacrosWith: aString)!

initialize
	Undeclared := UndeclaredVariable new!

internQualifiers: aSequencedReadableCollection
	"Private - Convert the argument to an <Array> of <Symbol>, validating that each qualifier (i.e. not including the last part) is valid as part of a static variable name."

	| size path |
	size := aSequencedReadableCollection size.
	size == 0 ifTrue: [^#()].
	path := Array writeStream: size.
	aSequencedReadableCollection
		from: 1
		to: size - 1
		do: 
			[:each |
			(self isValidUnqualifiedName: each) ifFalse: [^self errorInvalidIdentifier: each].
			path nextPut: each].
	path nextPut: (aSequencedReadableCollection at: size).
	^path collection!

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

	| path depth |
	path := self internQualifiers: aSequencedReadableCollection.
	depth := path size.
	^depth == 0
		ifTrue: [self new]
		ifFalse: 
			[| last |
			last := path last.
			(self isValidUnqualifiedName: last)
				ifTrue: [self newPath: path context: anObject]
				ifFalse: [self errorInvalidIdentifier: last]]!

path: aSequencedReadableCollection home: aNamespaceOrNil
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection
		context: (aNamespaceOrNil == Smalltalk ifFalse: [aNamespaceOrNil])!

pathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument."

	^self pathString: aString context: nil!

pathString: aString context: anObject
	"Answer a new sub-instance of the receiver representing the qualified name identified by the <readableString> argument,
	which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method),
	and the new instance will be a ContextualBindingReference with that object as its starting point for resolving the binding."

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
!AbstractBindingReference class categoriesFor: #errorInvalidIdentifier:!exceptions!private! !
!AbstractBindingReference class categoriesFor: #initialize!class initialization!public! !
!AbstractBindingReference class categoriesFor: #internQualifiers:!helpers!private! !
!AbstractBindingReference class categoriesFor: #isQualifiedName:!enquiries!public! !
!AbstractBindingReference class categoriesFor: #isValidQualifiedName:!enquiries!public! !
!AbstractBindingReference class categoriesFor: #isValidUnqualifiedName:!enquiries!public! !
!AbstractBindingReference class categoriesFor: #new!instance creation!public! !
!AbstractBindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!AbstractBindingReference class categoriesFor: #path:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #path:context:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #path:home:!compatibility!instance creation!public! !
!AbstractBindingReference class categoriesFor: #pathString:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #pathString:context:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #pathString:home:!compatibility!instance creation!public! !
!AbstractBindingReference class categoriesFor: #simpleName:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #simpleName:in:!instance creation!public! !
!AbstractBindingReference class categoriesFor: #splitQualifiedName:!helpers!public! !

