"Filed out from Dolphin Smalltalk 7"!

Kernel.AbstractBindingReference subclass: #'Kernel.BindingReference'
	instanceVariableNames: 'pathString path context flags binding generation'
	classVariableNames: 'Generation'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MetaMask' -> 16r1.
		'PrivateMask' -> 16r2
	}!
Kernel.BindingReference guid: (Core.GUID fromString: '{801fde8c-7556-4b95-bb9d-eafb33552e79}')!
Kernel.BindingReference comment: 'BindingReference''s represent symbolic references to static variables in the system. They describe a path through nested namespaces to locate a particular <VariableBinding>, with an optional context specifying the root namespace from which to start resolving the binding path.

## Instance Variables:
  `pathString`		`<string>`. The qualified name.
  `path`			`<sequencedReadableCollection>`. The components of the qualified name.
  `context`		`<Class>`. The namespace from which binding resolution should start, or nil if unspecified.
  `binding`		`<VariableBinding>`. The resolved binding, or `Undeclared` if there is no binding for the name path in context.
  `generation`		`<integer>`. Value of Generation when the binding was resolved.

## Class Variables:
  `Generation`		`<integer>`. Latest valid generation. Incremented whenever a system change is made that could alter binding resolution, e.g. addition of a new class.

'!
!Kernel.BindingReference categoriesForClass!System-Namespaces! !
!Kernel.BindingReference methodsFor!

asString
	"Answer a <readableString> that describes the receiver as a qualified name in the context of the home namespace."

	^self pathString!

bind
	self
		setGeneration: Generation;
		setBinding: ((self home resolveBindingPath: self path) ifNil: [Undeclared])!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	(binding isNil or: [generation ~~ Generation])
		ifTrue: [self bind].
	^binding targetVariable!

context
	"Answer the naming context in which this reference should be resolved."

	^context!

flags
	^flags!

hash
	"Answer the <integer> hash value for the receiver."

	^context
		ifNil: [self pathString hash]
		ifNotNil: [context hash hashMultiply + self pathString hash bitAnd: VMConstants.SmallIntegerMax]!

home
	"Answer the home namespace to which this BindingReference is relative."

	^context ifNil: [Smalltalk] ifNotNil: [context localEnvironment]!

instance
	"Answer a <BindingReference> that resolves to the value of the binding to which the receiver resolves."

	^self!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^flags allMask: PrivateMask!

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
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

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

setPath: anArray context: anObject
	path := anArray.
	context := anObject.
	flags := 0!

setPathString: aString
	<mutable>
	pathString := aString!

setPathString: aString context: anObject
	pathString := aString.
	context := anObject.
	flags := 0!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined.
	Note that it will not be possible to distinguish the cases of an undefined variable and a defined variable with value nil."

	^self bindingOrNil ifNotNil: [:var | var value]! !
!Kernel.BindingReference categoriesFor: #asString!converting!public! !
!Kernel.BindingReference categoriesFor: #bind!operations!private! !
!Kernel.BindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.BindingReference categoriesFor: #context!accessing!public! !
!Kernel.BindingReference categoriesFor: #flags!accessing!private! !
!Kernel.BindingReference categoriesFor: #hash!comparing!public! !
!Kernel.BindingReference categoriesFor: #home!accessing!public! !
!Kernel.BindingReference categoriesFor: #instance!converting!public! !
!Kernel.BindingReference categoriesFor: #isPrivate!public!testing! !
!Kernel.BindingReference categoriesFor: #isPrivate:!accessing!public! !
!Kernel.BindingReference categoriesFor: #meta!converting!displaying!public! !
!Kernel.BindingReference categoriesFor: #path!accessing!public! !
!Kernel.BindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.BindingReference categoriesFor: #setBinding:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setContext:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setFlags:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setGeneration:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPath:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPath:context:!initializing!private! !
!Kernel.BindingReference categoriesFor: #setPathString:!accessing!private! !
!Kernel.BindingReference categoriesFor: #setPathString:context:!initializing!private! !
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

initialize
	self flushBindings.
	VMLibrary default
		registryAt: self name put: self;
		registryAtIndex: 65 put: #pathString:context:flags:!

newPath: anArray context: anObject
	^self basicNew
		setPath: anArray context: anObject;
		isImmutable: true;
		yourself!

pathString: aString context: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then the instance is a reference from Smalltalk.
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self basicNew
		setPathString: aString context: anObject;
		isImmutable: true;
		yourself!

pathString: aString context: anObject flags: anInteger
	"Private - Use by the Compiler to construct literal instances."

	| ref |
	ref := self pathString: aString context: anObject.
	(anInteger allMask: PrivateMask) ifTrue: [ref isPrivate: true].
	^(anInteger allMask: MetaMask) ifTrue: [ref meta] ifFalse: [ref]!

uninitialize
	VMLibrary default
		registryAt: self name put: nil;
		registryAtIndex: 65 put: nil! !
!Kernel.BindingReference class categoriesFor: #clearCachedBindings!operations!private! !
!Kernel.BindingReference class categoriesFor: #flushBindings!operations!private! !
!Kernel.BindingReference class categoriesFor: #initialize!class initialization!public! !
!Kernel.BindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!Kernel.BindingReference class categoriesFor: #pathString:context:!instance creation!public! !
!Kernel.BindingReference class categoriesFor: #pathString:context:flags:!instance creation!private! !
!Kernel.BindingReference class categoriesFor: #uninitialize!class hierarchy-removing!private! !

