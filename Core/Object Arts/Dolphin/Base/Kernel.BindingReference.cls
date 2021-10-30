"Filed out from Dolphin Smalltalk"!

Kernel.AbstractBindingReference subclass: #'Kernel.BindingReference'
	instanceVariableNames: 'pathString path private binding generation'
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

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable if bound at the same time."

	"Implementation Note: This implementation depends on the fact that for absolute references the context is always nil, and for (useful) relative references, the context is not nil."

	^self == anObject or: 
			[self class == anObject class
				and: [self pathString = anObject pathString and: [private == anObject isPrivate]]]!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^self displayString!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	"Implementation Note: Implemented for compatibility with the reference platform, although not used in Dolphin. The selector is likely to confuse anyone with a C++ background; it has nothing to do with a class' superclass."

	^nil
!

bind
	| scope |
	scope := self bindingScope.
	self
		setGeneration: Generation;
		setBinding: ((scope localScope resolveBindingPath: self path environment: scope environment)
					ifNil: [Undeclared])!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	(binding isNil or: [generation ~~ Generation])
		ifTrue: [self bind].
	^binding targetVariable!

bindingScope
	"Answer the <bindingScope> from which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	"Implementation Note: It is an invariant that the context must be nil if the receiver is an absolute binding reference. This will be the case if only the public instance creation methods on the class side are used."

	^Smalltalk!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the binding scope."

	| parts count stream |
	parts := self path.
	(count := parts size) < 2 ifTrue: [^nil].
	stream := String writeStream: 32.
	stream nextPutAll: (parts at: 1).
	2 to: count - 1
		do: 
			[:i |
			stream
				nextPut: $.;
				nextPutAll: (parts at: i)].
	^stream contents!

hash
	"Answer the <integer> hash value for the receiver."

	^self pathString hash!

home
	"Answer the 'namespace context' for this binding reference."

	"Implementation Note: This is defined for compatibility with the reference platform. It is not used in Dolphin."

	^Smalltalk!

instance
	"Answer a <BindingReference> that resolves to the value of the binding to which the receiver resolves."

	^self!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^private!

isPrivate: aBoolean
	<mutable>
	private := aBoolean!

isRelative
	"Answer whether the receiver specifies a binding path relative to a specific binding root, or alternatively is an absolute (or fully-qualified) binding reference."

	^false!

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

private
	^private ifTrue: [self] ifFalse: [BindingReference pathString: self pathString private: true]!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution. For absolute references this should always be nil."

	^nil!

setBinding: aVariableBindingOrNil
	<mutable>
	binding := aVariableBindingOrNil!

setGeneration: anInteger
	<mutable>
	generation := anInteger!

setPath: anArray
	<mutable>
	path := anArray!

setPath: anArray private: aBoolean
	path := anArray.
	private := aBoolean!

setPathString: aString
	<mutable>
	pathString := aString!

setPathString: aString private: aBoolean
	pathString := aString.
	private := aBoolean!

setScope: aBindingScope
	self shouldNotImplement!

stbSaveOn: anSTBOutFiler
	"Implmentation Note: We don't want to save out any cached binding. Easiest is to flush it - it isn't that expensive to re-cache when needed"

	self setBinding: nil.
	^super stbSaveOn: anSTBOutFiler!

undeclare
	"Remove the binding in the target namespace that would be resolved by the receiver, if it exists."

	super undeclare.
	self setBinding: nil!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined.
	Note that it will not be possible to distinguish the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil value! !
!Kernel.BindingReference categoriesForMethods!
=!comparing!public! !
asString!converting!public! !
baseClass!accessing!public! !
bind!operations!private! !
bindingOrNil!accessing!public! !
bindingScope!accessing!public! !
environmentName!accessing!public! !
hash!comparing!public! !
home!accessing!public! !
instance!converting!public! !
isPrivate!public!testing! !
isPrivate:!accessing!private! !
isRelative!public!testing! !
meta!converting!displaying!public! !
path!accessing!public! !
pathString!accessing!public! !
private!converting!public! !
scope!accessing!private! !
setBinding:!accessing!private! !
setGeneration:!accessing!private! !
setPath:!accessing!private! !
setPath:private:!initializing!private! !
setPathString:!accessing!private! !
setPathString:private:!initializing!private! !
setScope:!initializing!private! !
stbSaveOn:!binary filing!public! !
undeclare!operations!public! !
valueOrNil!accessing!public! !
!

!Kernel.BindingReference class methodsFor!

clearCachedBindings
	Generation := Generation + 1.
	"Avoid the generation number becoming a large integer - unlikely, but possible"
	Generation >= VMConstants.SmallIntegerMax ifTrue: [self flushBindings]!

flushBindings
	| instances |
	instances := self primAllSubinstances.
	1 to: instances size do: [:i | (instances at: i) setBinding: nil].
	Generation := 0!

fullPathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is expected to be a fully qualified name."

	^self basicNew
		setPathString: aString private: false;
		isImmutable: true;
		yourself!

initialize
	self flushBindings.
	VM
		registryAt: self name put: self;
		registryAtIndex: 65 put: #pathString:scope:flags:;
		registryAtIndex: 69 put: #setScope:!

newPath: anArray private: aBoolean scope: aBindingScope
	^(anArray size <= 1
		ifTrue: 
			[aBindingScope
				ifNil: [BindingReference basicNew setPath: anArray private: aBoolean]
				ifNotNil: 
					[RelativeBindingReference
						newPath: anArray
						private: aBoolean
						scope: aBindingScope]]
		ifFalse: 
			[(anArray at: 1) = '_'
				ifTrue: 
					[RelativeBindingReference
						newPath: (anArray copyFrom: 2 to: anArray size)
						private: aBoolean
						scope: aBindingScope]
				ifFalse: [BindingReference basicNew setPath: anArray private: aBoolean]])
		isImmutable: true;
		yourself!

pathString: aString private: aBoolean
	^BindingReference basicNew setPathString: aString private: aBoolean!

pathString: aString private: aBoolean scope: aBindingScope
	^RelativeBindingReference basicNew
		setPathString: aString
		private: aBoolean
		scope: aBindingScope!

pathString: aString scope: aBindingScope
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then the instance is a reference from Smalltalk.
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance is then a contextual BindingReference with that object as (potentially) its starting point for resolving the binding. However, the context is only relevant as a start point for binding if the path string is an unqualified name, or has the special relative prefix, '_', as the first component of the path. Otherwise the binding reference is considered to specify the full-name of the binding, and will always bind to the same static variable, regardless of context. Since the context is not needed for absolute bindings, it will be discarded - the context of absolute bindings is always nil, which in practice means their binding root is Smalltalk."

	| components count |
	components := $\x20 split: aString.
	count := components size.
	^count > 0
		ifTrue: 
			[| qualifiedName flags |
			qualifiedName := components at: 1.
			flags := (aBindingScope notNil
						and: [(qualifiedName identityIncludes: $.) not or: [qualifiedName beginsWith: '_.']])
							ifTrue: [RelativeMask]
							ifFalse: [0].
			count > 1
				ifTrue: 
					[(components includes: 'class') ifTrue: [flags := flags bitOr: MetaMask].
					(components includes: 'private') ifTrue: [flags := flags bitOr: PrivateMask]].
			self
				pathString: qualifiedName
				scope: aBindingScope
				flags: flags]
		ifFalse: 
			[self
				pathString: aString
				scope: aBindingScope
				flags: 0]!

pathString: aString scope: aBindingScope flags: anInteger
	"Private - Note that this is sent directly by the Compiler to construct literal instances."

	"Implementation Note: If the reference is absolute, then the <bindingScope> is ignored as it is not needed. This avoids keeping the object alive unnecessarily, e.g. if it is a method, and also allows for cheaper implementations of the #= and #hash methods."

	| ref |
	ref := ((anInteger allMask: RelativeMask)
				ifTrue: 
					[self
						pathString: aString
						private: (anInteger allMask: PrivateMask)
						scope: aBindingScope]
				ifFalse: [self pathString: aString private: (anInteger allMask: PrivateMask)])
				isImmutable: true;
				yourself.
	^(anInteger allMask: MetaMask) ifTrue: [ref meta] ifFalse: [ref]!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0:
		- RelativeBindingReference introduced - context pushed down
		- flags replaced with private inst var"

	^
	[:data |
	(data at: 1)
		ifNil: 
			[self
				path: (data at: 2)
				private: ((data at: 4) allMask: PrivateMask)
				scope: (data at: 3)]
		ifNotNil: 
			[:pathString |
			self
				pathString: pathString
				private: ((data at: 4) allMask: PrivateMask)
				scope: (data at: 3)]]!

stbVersion
	^1!

uninitialize
	VM
		registryAt: self name put: nil;
		registryAtIndex: 65 put: nil;
		registryAtIndex: 69 put: nil! !
!Kernel.BindingReference class categoriesForMethods!
clearCachedBindings!operations!private! !
flushBindings!operations!private! !
fullPathString:!instance creation!public! !
initialize!class initialization!public! !
newPath:private:scope:!instance creation!private! !
pathString:private:!instance creation!public! !
pathString:private:scope:!instance creation!public! !
pathString:scope:!instance creation!public! !
pathString:scope:flags:!instance creation!private! !
stbConvertFrom:!public! !
stbVersion!public! !
uninitialize!class hierarchy-removing!private! !
!

