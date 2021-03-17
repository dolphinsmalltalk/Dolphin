"Filed out from Dolphin Smalltalk 7"!

Kernel.AbstractBindingReference subclass: #'Kernel.BindingReference'
	instanceVariableNames: 'pathString path context flags binding generation'
	classVariableNames: 'Generation'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BindingReference guid: (Core.GUID fromString: '{801fde8c-7556-4b95-bb9d-eafb33552e79}')!
Kernel.BindingReference comment: '`BindingReference`s represent symbolic references to static variables in the system. They describe a path through nested namespaces to locate a particular <VariableBinding>, with an optional context specifying the root namespace from which to start resolving the binding path.

`BindingReference` has a literal syntax of the form #{<identifier>}, where identifier can be an unqualified or dot qualified name. If unqualified then the binding reference is assumed to be relative to the method in which it is defined, and so should follow the same binding rules as an unqualified identifier that might appear in the code of the same method. Note that this may also find static variables in enclosing or imported scopes. If the identifier is qualified, then it is assumed to be an absolute reference to be bound starting in Smalltalk. Because Smalltalk is directly nested in `Root` (the root namespace), starting the binding search in `Smalltalk` will also find variables accessible using the same path from `Root` even if they are not part of a namespace imported into `Smalltalk`. For those cases where a partially qualified relative reference is required, the first component of the name can be an underscore, in which case the compiler regards it as a relative reference even though it contains more than one name component.

It might have been better if literal binding references were always relative, unless having a special prefix or other marker, or conversely always relative unless so marked. However there is an established precedent, hence the rather confusing implicit distinction between the treatment of single and multi-part names for literal binding references.

## Instance Variables:
  `pathString`		`<string>`. The qualified name.
  `path`			`<sequencedReadableCollection>`. The components of the qualified name.
  `context`		`<Class>`. The namespace from which binding resolution should start, or nil if an absolute reference.
  `binding`		`<VariableBinding>`. The resolved binding, or `Undeclared` if there is no binding for the name path in context.
  `generation`		`<integer>`. Value of Generation when the binding was resolved.

## Class Variables:
  `Generation`		`<integer>`. Latest valid generation. Incremented whenever a system change is made that could alter binding resolution, e.g. addition of a new class.

'!
!Kernel.BindingReference categoriesForClass!System-Namespaces! !
!Kernel.BindingReference methodsFor!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^self displayString!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	"Implementation Note: Implemented for compatibility with the reference platform, although not used in Dolphin. The selector is likely to confuse anyone with a C++ background; it has nothing to do with a class' superclass."

	^(context notNil and: [self isRelative]) ifTrue: [context localScope]
!

bind
	self
		setGeneration: Generation;
		setBinding: ((self bindingRoot resolveBindingPath: self path) ifNil: [Undeclared])!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	(binding isNil or: [generation ~~ Generation])
		ifTrue: [self bind].
	^binding targetVariable!

bindingRoot
	"Answer the root binding context from which the receiver's binding path is traversed to locate the target binding.
	This is always a <Class>. It may be a <Namespace>. If the receiver is an absolute binding reference it will be the Smalltalk namespace class."

	^(context isNil or: [self isRelative not]) ifTrue: [Smalltalk] ifFalse: [context localScope]!

context
	"Answer the context in which the reference was created. For relative references this is used to determine the start point for binding resolution."

	^context!

flags
	^flags!

hash
	"Answer the <integer> hash value for the receiver."

	^context
		ifNil: [self pathString hash]
		ifNotNil: [context hash hashMultiply + self pathString hash bitAnd: VMConstants.SmallIntegerMax]!

home
	"Answer the 'namespace context' for this binding reference."

	"Implementation Note: This is defined for compatibility with the reference platform. It is not used in Dolphin."

	^(context isNil or: [self isRelative not]) ifTrue: [Smalltalk] ifFalse: [context localEnvironment]!

instance
	"Answer a <BindingReference> that resolves to the value of the binding to which the receiver resolves."

	^self!

isPrivate: aBoolean
	self setFlags: (flags mask: PrivateMask set: aBoolean)!

meta
	"Answer a <BindingReference> that resolves to the class of the value of the binding to which the receiver resolves."

	^MetaBindingReference instance: self!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^path
		ifNil: 
			[self setPath: ($. split: pathString).
			path]!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name, which may be relative to a binding root, or absolute."

	^pathString
		ifNil: 
			[self setPathString: ($. join: path).
			pathString]!

setBinding: aVariableBindingOrNil
	<mutable>
	binding := aVariableBindingOrNil!

setContext: anObject
	<mutable>
	context := anObject!

setFlags: anInteger
	<mutable>
	flags := anInteger!

setGeneration: anInteger
	<mutable>
	generation := anInteger!

setPath: anArray
	<mutable>
	path := anArray!

setPath: anArray context: anObject flags: anInteger
	path := anArray.
	context := anObject.
	flags := anInteger!

setPathString: aString
	<mutable>
	pathString := aString!

setPathString: aString context: anObject flags: anInteger
	pathString := aString.
	context := anObject.
	flags := anInteger!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined.
	Note that it will not be possible to distinguish the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil ifNotNil: [:var | var value]! !
!Kernel.BindingReference categoriesFor: #asString!converting!public! !
!Kernel.BindingReference categoriesFor: #baseClass!accessing!public! !
!Kernel.BindingReference categoriesFor: #bind!operations!private! !
!Kernel.BindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.BindingReference categoriesFor: #bindingRoot!accessing!public! !
!Kernel.BindingReference categoriesFor: #context!accessing!public! !
!Kernel.BindingReference categoriesFor: #flags!accessing!private! !
!Kernel.BindingReference categoriesFor: #hash!comparing!public! !
!Kernel.BindingReference categoriesFor: #home!accessing!public! !
!Kernel.BindingReference categoriesFor: #instance!converting!public! !
!Kernel.BindingReference categoriesFor: #isPrivate:!accessing!private! !
!Kernel.BindingReference categoriesFor: #meta!converting!displaying!public! !
!Kernel.BindingReference categoriesFor: #path!accessing!public! !
!Kernel.BindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.BindingReference categoriesFor: #setBinding:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setContext:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setFlags:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setGeneration:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPath:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPath:context:flags:!initializing!private! !
!Kernel.BindingReference categoriesFor: #setPathString:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPathString:context:flags:!initializing!private! !
!Kernel.BindingReference categoriesFor: #valueOrNil!accessing!public! !

!Kernel.BindingReference class methodsFor!

clearCachedBindings
	Generation := Generation + 1.
	"Avoid the generation number becoming a large integer - unlikely, but possible"
	Generation >= VMConstants.SmallIntegerMax ifTrue: [self flushBindings]!

flushBindings
	| instances |
	instances := self primAllInstances.
	1 to: instances size do: [:i | (instances at: i) setBinding: nil].
	Generation := 0!

fullPathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is expected to be a fully qualified name."

	^self basicNew
		setPathString: aString;
		setFlags: 0;
		isImmutable: true;
		yourself!

initialize
	self flushBindings.
	VMLibrary default
		registryAt: self name put: self;
		registryAtIndex: 65 put: #pathString:context:flags:!

newPath: anArray context: anObject
	| ref |
	ref := self basicNew.
	anArray size <= 1
		ifTrue: 
			[ref
				setPath: anArray
				context: anObject
				flags: (anObject ifNil: [0] ifNotNil: [RelativeMask])]
		ifFalse: 
			[(anArray at: 1) = '_'
				ifTrue: 
					[ref
						setPath: (anArray copyFrom: 2 to: anArray size)
						context: anObject
						flags: RelativeMask]
				ifFalse: 
					["Absolute - note that the context is ignored as it is not needed"
					ref
						setPath: anArray
						context: nil
						flags: 0]].
	^ref
		isImmutable: true;
		yourself!

pathString: aString context: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then the instance is a reference from Smalltalk.
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance is then a contextual BindingReference with that object as (potentially) its starting point for resolving the binding. However, the context is only relevant as a start point for binding if the path string is an unqualified name, or has the special relative prefix, '_', as the first component of the path. Otherwise the binding reference is considered to specify the full-name of the binding, and will always bind to the same static variable, regardless of context. Since the context is not needed for absolute bindings, it will be discarded - the context of absolute bindings is always nil, which in practice means their binding root is Smalltalk."

	^self
		pathString: aString
		context: anObject
		flags: ((anObject notNil and: [(aString includes: $.) not or: [aString beginsWith: '_.']])
				ifTrue: [RelativeMask]
				ifFalse: [0])!

pathString: aString context: anObject flags: anInteger
	"Private - Note that this is sent directly by the Compiler to construct literal instances."

	"Implementation Note: If the reference is absolute, then the context is ignored as it is not needed. This avoids keeping the context alive unnecessarily, and also allows for cheaper implementations of the #= and #hash methods."

	| ref |
	ref := self basicNew
				setPathString: aString
					context: ((anInteger allMask: RelativeMask) ifTrue: [anObject])
					flags: (anInteger bitAnd: ##(MetaMask bitInvert));
				isImmutable: true;
				yourself.
	^(anInteger allMask: MetaMask) ifTrue: [ref meta] ifFalse: [ref]!

uninitialize
	VMLibrary default
		registryAt: self name put: nil;
		registryAtIndex: 65 put: nil! !
!Kernel.BindingReference class categoriesFor: #clearCachedBindings!operations!private! !
!Kernel.BindingReference class categoriesFor: #flushBindings!operations!private! !
!Kernel.BindingReference class categoriesFor: #fullPathString:!instance creation!public! !
!Kernel.BindingReference class categoriesFor: #initialize!class initialization!public! !
!Kernel.BindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!Kernel.BindingReference class categoriesFor: #pathString:context:!instance creation!public! !
!Kernel.BindingReference class categoriesFor: #pathString:context:flags:!instance creation!private! !
!Kernel.BindingReference class categoriesFor: #uninitialize!class hierarchy-removing!private! !

