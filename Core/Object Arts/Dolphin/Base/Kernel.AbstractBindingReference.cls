"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.AbstractBindingReference'
	instanceVariableNames: ''
	classVariableNames: 'Undeclared'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MetaMask' -> 16r1.
		'PrivateMask' -> 16r2.
		'RelativeMask' -> 16r4
	}!
Kernel.AbstractBindingReference guid: (Core.GUID fromString: '{2d52489e-7275-4df4-9022-294a7b2f9381}')!
Kernel.AbstractBindingReference isNonInstantiable: true!
Kernel.AbstractBindingReference comment: '`AbstractBindingReference` is the abstract superclass of binding reference objects.'!
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
	to the same variable if bound at the same time."

	^self subclassResponsibility!

append: aString
	"Answer a new <BindingReference> that refers to the nested name identified by the <readableString> argument within the receiver's scope."

	^self class path: (self path copyWith: aString) scope: self scope!

asFullyQualifiedReference
	"Answer a<BindingReference> that references the same binding as the receiver does currently in its home context, but from Smalltalk or Root."

	^self isRelative
		ifTrue: [BindingReference path: (self environment fullPath copyWith: self unqualifiedName)]
		ifFalse: [self]!

asQualifiedReference
	"Answer the <BindingReference> equivalent of the receiver."

	^self!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^self subclassResponsibility!

asSymbol
	"Answer the <symbol> corresponding to the receiver's fully-qualified name."

	^self asString asSymbol!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	^self subclassResponsibility
	!

basicUnqualifiedName
	"Private - Answer the unqualified name part of the receiver (the final component of the name)."

	^self path last!

binding
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable)."

	^self bindingOrNil ifNil: [self bindingScope errorNotFound: self]!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^self subclassResponsibility!

bindingScope
	"Answer the <bindingScope> from which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	^self subclassResponsibility!

declare
	"Create a binding in the target namespace that would be resolved by the receiver, if none currently exists."

	^self environment
		ifNil: 
			[self bindingScope localScope
				errorNotFound: (BindingReference path: self path allButLast scope: self scope)]
		ifNotNil: [:env | env declareVariable: self path last]!

declare: anObject
	"Create a binding in the target namespace that would be resolved by the receiver, if none currently exists.
	Set the value of the new or existing binding to the argument."

	self declare setValue: anObject!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	| identifier |
	identifier := self pathString.
	(self isRelative and: [identifier includes: $.]) ifTrue: [aPuttableStream nextPutAll: '_.'].
	aPuttableStream nextPutAll: identifier!

environment
	"Answer the namespace (i.e. any Class, not just Namespaces) in which the target binding should be found, or nil if any of the namespaces on the path do not exist."

	| parts length scope |
	scope := self bindingScope.
	parts := self path.
	length := parts size.
	^length > 1
		ifTrue: 
			[(scope localScope resolveBindingPath: (parts copyFrom: 1 to: length - 1)
				environment: scope environment) ifNotNil: [:ns | ns value]]
		ifFalse: [scope localScope]!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the binding scope."

	^self subclassResponsibility!

hash
	"Answer the <integer> hash value for the receiver."

	^self subclassResponsibility!

home
	"Answer the 'namespace context' for this binding reference."

	"Implementation Note: This is defined for compabitility with the reference platform, but isn't otherwise particularly useful in Dolphin because Namespaces are classes and any Class can effectively be a namespace.
	Even in the reference platform it doesn't necessarily define the starting point for binding, since a binding reference can refer to a class shared variable."

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

isAbsolute
	"Answer whether the receiver specifies an absolute, fully-qualified, binding reference that always resolves to the same binding, no matter the initial binding context."

	^self isRelative not!

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

isRelative
	"Answer whether the receiver specifies a binding path relative to a specific binding root, or alternatively is an absolute (or fully-qualified) binding reference."

	^self subclassResponsibility!

literalTextStyle
	^#literalBindingReference!

meta
	"Answer a `MetaBindingReference` that resolves to the class of the value of the binding to which the receiver resolves."

	^self subclassResponsibility!

namespaceBinding
	"Answer a <VariableBinding> for the namespace (a Class, which may be a Namespace) in which the referenced binding should be found (if it exists). If any of the namespaces on the binding path do not exist, an error will be thrown."

	| parts scope |
	scope := self bindingScope.
	parts := self path.
	^parts size > 1
		ifTrue: [scope localScope resolveBindingPath: parts allButLast environment: scope environment]
		ifFalse: [scope localScope binding]!

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
	^self subclassResponsibility!

refersTo: anObject asLiteralOf: aCompiledCode
	"Private - Answer whether the receiver, a literal of the <CompiledCode> 2nd argument, is a reference to the <Object> first argument."

	^self = anObject or: 
			[anObject notNil and: 
					[self bindingOrNil
						ifNil: [false]
						ifNotNil: [:binding | binding refersTo: anObject asLiteralOf: aCompiledCode]]]!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution. For absolute references this should always be nil."

	^self subclassResponsibility!

shortName
	"Answer the shortest <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^Smalltalk shortNameFor: self basicUnqualifiedName in: self environment!

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

	self environment ifNotNil: [:env | env removeLocalBindingFor: self path last]!

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
!Kernel.AbstractBindingReference categoriesFor: #baseClass!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #basicUnqualifiedName!accessing!private! !
!Kernel.AbstractBindingReference categoriesFor: #binding!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #bindingScope!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #declare!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #declare:!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #displayOn:!displaying!public! !
!Kernel.AbstractBindingReference categoriesFor: #environment!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #environmentName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #hash!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #home!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefined:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefined:ifNotDefined:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefinedDo:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #ifDefinedDo:elseDo:!evaluating!public! !
!Kernel.AbstractBindingReference categoriesFor: #instance!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #isAbsolute!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isDefined!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isLiteral!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isMeta!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isPrivate!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isPrivate:!accessing!private! !
!Kernel.AbstractBindingReference categoriesFor: #isQualifiedName!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #isRelative!public!testing! !
!Kernel.AbstractBindingReference categoriesFor: #literalTextStyle!constants!public! !
!Kernel.AbstractBindingReference categoriesFor: #meta!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #namespaceBinding!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #owningPackage:!accessing!development!private! !
!Kernel.AbstractBindingReference categoriesFor: #path!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #printOn:!printing!public! !
!Kernel.AbstractBindingReference categoriesFor: #private!converting!public! !
!Kernel.AbstractBindingReference categoriesFor: #refersTo:asLiteralOf:!private!testing! !
!Kernel.AbstractBindingReference categoriesFor: #scope!constants!private! !
!Kernel.AbstractBindingReference categoriesFor: #shortName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #simpleName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #species!comparing!public! !
!Kernel.AbstractBindingReference categoriesFor: #storeOn:!public!storing! !
!Kernel.AbstractBindingReference categoriesFor: #undeclare!operations!public! !
!Kernel.AbstractBindingReference categoriesFor: #unqualifiedName!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #value!accessing!public! !
!Kernel.AbstractBindingReference categoriesFor: #valueOfBinding:!helpers!private! !
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
			((first == $_ and: [size > 1]) or: [first isEnglishLetter]) and: 
					[aString
						allSatisfy: [:each | 'ABCDEFGHIJKLMNOPQRSTUVWXYZ_abcdefghijklmnopqrstuvwxyz0123456789' includes: each]]]!

new
	^self pathString: ''!

newPath: anArray private: aBoolean scope: aBindingScope
	^self subclassResponsibility!

path: aSequencedReadableCollection
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection scope: nil!

path: aSequencedReadableCollection home: aNamespaceOrNil
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection
		scope: (aNamespaceOrNil == Smalltalk ifFalse: [aNamespaceOrNil])!

path: aSequencedReadableCollection private: aBoolean scope: aBindingScope
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self
		newPath: aSequencedReadableCollection
		private: aBoolean
		scope: aBindingScope!

path: aSequencedReadableCollection scope: aBindingScope
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self
		path: aSequencedReadableCollection
		private: false
		scope: aBindingScope!

pathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument."

	^self pathString: aString scope: nil!

pathString: aString home: aNamespace
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument,
	homed in the specified <Namespace>."

	^self pathString: aString scope: (aNamespace == Smalltalk ifFalse: [aNamespace])!

pathString: aString scope: aBindingScope
	"Answer a new sub-instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self subclassResponsibility!

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
!Kernel.AbstractBindingReference class categoriesFor: #newPath:private:scope:!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:home:!compatibility!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:private:scope:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #path:scope:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:home:!compatibility!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #pathString:scope:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #simpleName:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #simpleName:in:!instance creation!public! !
!Kernel.AbstractBindingReference class categoriesFor: #splitQualifiedName:!helpers!public! !

