"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'Kernel.BindingReference'
	instanceVariableNames: ''
	classVariableNames: 'Generation Undeclared'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MetaMask' -> 16r1.
		'PathSeparator' -> $..
		'PathSeparatorString' -> '.'.
		'PrivateMask' -> 16r2.
		'RelativeMask' -> 16r4.
		'RelativePathPrefix' -> '_'.
		'RelativePathStringPrefix' -> '_.'
	}!
Kernel.BindingReference guid: (Core.GUID fromString: '{2d52489e-7275-4df4-9022-294a7b2f9381}')!
Kernel.BindingReference isNonInstantiable: true!
Kernel.BindingReference comment: '`BindingReference` is the abstract superclass of binding reference objects.

`BindingReference`s represent symbolic references to static variables in the system. They describe a path through nested namespaces to locate a particular `VariableBinding`, with an optional context specifying the root namespace from which to start resolving the binding path.

`BindingReference` has a literal syntax of the form #{<identifier>}, where <identifier> can be an unqualified or dot qualified name. If unqualified then the binding reference is assumed to be relative to the method in which it is defined, and so should follow the same binding rules as an unqualified identifier that might appear in the code of the same method. Note that this may also find static variables in enclosing or imported scopes. If the identifier is qualified, then it is assumed to be an absolute reference to be bound starting in Smalltalk. Because Smalltalk is directly nested in `Root` (the root namespace), starting the binding search in `Smalltalk` will also find variables accessible using the same path from `Root` even if they are not part of a namespace imported into `Smalltalk`. For those cases where a partially qualified relative reference is required, the first component of the name can be an underscore, in which case the compiler regards it as a relative reference even though it contains more than one name component.

It might have been better if literal binding references were always relative, unless having a special prefix or other marker, or conversely always relative unless so marked. However there is an established precedent in the ecosystem, hence the rather confusing implicit distinction between the treatment of single and multi-part names for literal binding references.

## Class Variables:
  `Generation`		`<integer>`. Latest valid generation. Incremented whenever a system change is made that could alter binding resolution, e.g. addition of a new class.

'!
!Kernel.BindingReference categoriesForClass!System-Namespaces! !
!Kernel.BindingReference methodsFor!

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

	^self!

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

	^self subclassResponsibility!

environment
	"Answer the namespace (i.e. any Class, not just Namespaces) in which the target binding should be found, or nil if any of the namespaces on the path do not exist."

	| parts length scope |
	scope := self bindingScope.
	parts := self path.
	length := parts size.
	^length > 1
		ifTrue: 
			[(scope localScope resolveBindingPath: (parts copyFrom: 1 to: length - 1)
				environment: scope environment) value]
		ifFalse: 
			[(scope localScope resolveUnqualifiedName: self pathString environment: scope environment)
				ifNil: [scope localScope]
				ifNotNil: [:binding | binding environment]]!

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

ifNotDefined: aNiladicValuable
	"Answer the the value of the receiver's binding, or the result of evaluating the <niladicValuable> argument if the receiver is not defined."

	^self bindingOrNil ifNil: [aNiladicValuable value] ifNotNil: [:var | self valueOfBinding: var]!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^self subclassResponsibility!

isDefined
	"Answer whether the receiver refers to a defined variable."

	^self bindingOrNil notNil!

isLiteral
	"Answer whether or not the receiver has a literal representation (probably its printString) which is directly recognised by the Compiler"

	"Although relative binding references can be expressed as literals, two compiled literals in different scopes may bind to different variables. The general expectation of literals is that the literal representation will compile back into a new instance equivalent to the original. This is only the case for relative references when they are compiled in the same scope."

	^self isRelative not!

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
	"Answer a `BindingReference` that is the resolves to the same binding as the receiver, but which is flagged as private."

	^self subclassResponsibility!

realReference
	"Answer the receiver's non-model reference."!

refersTo: anObject asLiteralOf: aCompiledCode
	"Private - Answer whether the receiver, a literal of the <CompiledCode> 2nd argument, is a reference to the <Object> first argument."

	^self = anObject
		or: [anObject notNil and: [self bindingOrNil refersTo: anObject asLiteralOf: aCompiledCode]]!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution. For absolute references this should always be nil."

	^self subclassResponsibility!

scope: anObject
	"Answer a <RelativeBindingReference> with the receiver's path, but with the specified <bindingScope>."

	^self subclassResponsibility!

shortName
	"Answer the shortest <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^Smalltalk shortNameFor: self basicUnqualifiedName in: self environment!

simpleName
	"Answer the unqualified name part of the receiver (the final component of the name).
	This is defined for compatibility. Use #unqualifiedName by preference."

	^self unqualifiedName!

storeOn: aStream
	"This should probably store the full path."

	self printOn: aStream!

undeclare
	"Remove the binding in the target namespace that would be resolved by the receiver, if it exists."

	^self environment ifNotNil: [:env | env removeBindingFor: self path last]!

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
!Kernel.BindingReference categoriesForMethods!
<=!comparing!public! !
=!comparing!public! !
append:!copying!public! !
asFullyQualifiedReference!converting!public! !
asQualifiedReference!converting!public! !
asString!converting!public! !
asSymbol!converting!public! !
baseClass!accessing!public! !
basicUnqualifiedName!accessing!private! !
binding!accessing!public! !
bindingOrNil!accessing!public! !
bindingScope!accessing!public! !
declare!operations!public! !
declare:!operations!public! !
displayOn:!displaying!public! !
environment!accessing!public! !
environmentName!accessing!public! !
hash!comparing!public! !
home!accessing!public! !
ifDefined:!evaluating!public! !
ifDefined:ifNotDefined:!evaluating!public! !
ifDefinedDo:!evaluating!public! !
ifDefinedDo:elseDo:!evaluating!public! !
ifNotDefined:!evaluating!public! !
instance!accessing!public! !
isDefined!public!testing! !
isLiteral!public!testing! !
isMeta!public!testing! !
isPrivate!public!testing! !
isPrivate:!initializing!private! !
isQualifiedName!public!testing! !
isRelative!public!testing! !
literalTextStyle!constants!public! !
meta!converting!public! !
namespaceBinding!accessing!public! !
owningPackage:!accessing!development!private! !
path!accessing!public! !
pathString!accessing!public! !
printOn:!printing!public! !
private!converting!public! !
realReference!accessing!public! !
refersTo:asLiteralOf:!private!testing! !
scope!constants!private! !
scope:!converting!private! !
shortName!accessing!public! !
simpleName!accessing!public! !
storeOn:!public!storing! !
undeclare!operations!public! !
unqualifiedName!accessing!public! !
value!accessing!public! !
valueOfBinding:!helpers!private! !
valueOrDo:!accessing!public! !
valueOrNil!accessing!public! !
!

!Kernel.BindingReference class methodsFor!

clearCachedBindings
	Generation := Generation + 1.
	"Avoid the generation number becoming a large integer - unlikely, but possible"
	Generation >= VMConstants.SmallIntegerMax ifTrue: [self flushBindings]!

flushBindings
	| instances |
	instances := FullBindingReference primAllSubinstances.
	1 to: instances size do: [:i | (instances at: i) setBinding: nil].
	Generation := 0!

initialize
	Undeclared := UndeclaredVariable new.
	VM
		registryAt: self name put: self;
		registryAtIndex: 65 put: #pathString:scope:flags:;
		registryAtIndex: 69 put: #setScope:.
	self flushBindings!

isQualifiedName: aString
	"Answer whether the argument is probably a qualified name (as opposed to an unqualified, or simple, name)."

	^(aString
		nextIdentityIndexOf: PathSeparator
		from: 1
		to: aString size) ~~ 0!

isValidQualifiedName: aString
	"Answer whether the argument is a valid static variable name, qualified or unqualified."

	^(self isQualifiedName: aString)
		ifTrue: [(PathSeparator split: aString) allSatisfy: [:each | self isValidUnqualifiedName: each]]
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
	^self shouldNotImplement!

newPath: anArray private: aBoolean scope: aBindingScope
	anArray size <= 1
		ifTrue: 
			[aBindingScope
				ifNotNil: 
					[^RelativeBindingReference
						pathString: nil
						path: anArray
						private: aBoolean
						scope: aBindingScope]]
		ifFalse: 
			[(anArray at: 1) = RelativePathPrefix
				ifTrue: 
					[^RelativeBindingReference
						pathString: nil
						path: (anArray copyFrom: 2 to: anArray size)
						private: aBoolean
						scope: aBindingScope]].
	^FullBindingReference
		pathString: nil
		path: anArray
		private: aBoolean!

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

pathString: aString private: aBoolean
	^self
		pathString: aString
		private: aBoolean
		scope: nil!

pathString: aString private: aBoolean scope: aBindingScope
	^aBindingScope
		ifNil: 
			[FullBindingReference
				pathString: aString
				path: nil
				private: aBoolean]
		ifNotNil: 
			[RelativeBindingReference
				pathString: aString
				path: nil
				private: aBoolean
				scope: aBindingScope]!

pathString: aString scope: aBindingScope
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then the instance is a reference from Smalltalk. If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance is then a contextual BindingReference with that object as (potentially) its starting point for resolving the binding. However, the context is only relevant as a start point for binding if the path string is an unqualified name, or has the special relative prefix, '_', as the first component of the path. Otherwise the binding reference is considered to specify the full-name of the binding, and will always bind to the same static variable, regardless of context. Since the context is not needed for absolute bindings, it will be discarded - the context of absolute bindings is always nil, which in practice means their binding root is Smalltalk."

	| components count qualifiedName flags scope |
	components := $\x20 split: aString.
	count := components size.
	count > 0
		ifFalse: 
			[^self
				pathString: aString
				scope: aBindingScope
				flags: 0].
	qualifiedName := components at: 1.
	scope := aBindingScope.
	flags := (qualifiedName beginsWith: RelativePathStringPrefix)
				ifTrue: 
					[scope := aBindingScope ?? Smalltalk.
					qualifiedName := qualifiedName copyFrom: 3 to: qualifiedName size.
					RelativeMask]
				ifFalse: 
					[(aBindingScope notNil and: [(qualifiedName identityIncludes: PathSeparator) not])
						ifTrue: [RelativeMask]
						ifFalse: [0]].
	count > 1
		ifTrue: 
			[(components includes: 'class') ifTrue: [flags := flags bitOr: MetaMask].
			(components includes: 'private') ifTrue: [flags := flags bitOr: PrivateMask]].
	^self
		pathString: qualifiedName
		scope: scope
		flags: flags!

pathString: aString scope: aBindingScope flags: anInteger
	"Private - Note that this is sent directly by the Compiler to construct literal instances. The path string is expected not to have a relative prefix, but rather to pass the RelativeMask flag to request a relative binding reference."

	"Implementation Note: If the reference is absolute, then the <bindingScope> is ignored as it is not needed. This avoids keeping the object alive unnecessarily, e.g. if it is a method, and also allows for cheaper implementations of the #= and #hash methods."

	| ref |
	ref := (anInteger allMask: RelativeMask)
				ifTrue: 
					[RelativeBindingReference
						pathString: aString
						path: nil
						private: (anInteger allMask: PrivateMask)
						scope: aBindingScope]
				ifFalse: 
					[FullBindingReference
						pathString: aString
						path: nil
						private: (anInteger allMask: PrivateMask)].
	^(anInteger allMask: MetaMask) ifTrue: [ref meta] ifFalse: [ref]!

simpleName: aString
	"Answer a new instance of the receiver representing the variable with the specified unqualified name."

	^self pathString: aString!

simpleName: aString in: aNamespace
	"Answer a new instance of the receiver representing the variable with the specified unqualified name in the specified <Namespace>."

	^self pathString: aString home: aNamespace!

splitQualifiedName: aString
	^PathSeparator split: aString!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0:
		- RelativeBindingReference introduced - context pushed down
		- flags replaced with private inst var"

	^
	[:data |
	| ver |
	ver := anSTBClassFormat version.
	ver < 1 ifTrue: [self stbConvertFromVersion0: data] ifFalse: [self stbConvertFromVersion1: data]]!

stbConvertFromVersion0: anArray
	"Private - Version 0 inst vars: 'pathString path context flags binding generation'
	Version 1&2 inst vars: 'pathString path private binding generation'"

	^(anArray at: 1)
		ifNil: 
			[self
				path: (anArray at: 2)
				private: ((anArray at: 4) allMask: PrivateMask)
				scope: (anArray at: 3)]
		ifNotNil: 
			[:pathString |
			self
				pathString: pathString
				private: ((anArray at: 4) allMask: PrivateMask)
				scope: (anArray at: 3)]!

stbConvertFromVersion1: anArray
	"Private - Version 2 same instance vars, but classes renamed so that BindingReference is the abstract class, and FullBindingReference is the concrete equivalent of what was BindingReference"

	| newInstance |
	newInstance := FullBindingReference basicNew.
	1 to: anArray size do: [:i | newInstance instVarAt: i put: (anArray at: i)].
	^newInstance!

stbVersion
	^2! !
!Kernel.BindingReference class categoriesForMethods!
clearCachedBindings!operations!private! !
flushBindings!operations!private! !
initialize!class initialization!public! !
isQualifiedName:!enquiries!public! !
isValidQualifiedName:!enquiries!public! !
isValidUnqualifiedName:!enquiries!public! !
new!instance creation!public! !
newPath:private:scope:!instance creation!private! !
path:!instance creation!public! !
path:home:!compatibility!instance creation!public! !
path:private:scope:!instance creation!public! !
path:scope:!instance creation!public! !
pathString:!instance creation!public! !
pathString:home:!compatibility!instance creation!public! !
pathString:private:!instance creation!public! !
pathString:private:scope:!instance creation!public! !
pathString:scope:!instance creation!public! !
pathString:scope:flags:!instance creation!private! !
simpleName:!instance creation!public! !
simpleName:in:!instance creation!public! !
splitQualifiedName:!helpers!public! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbVersion!binary filing!public! !
!

