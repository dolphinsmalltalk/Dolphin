"Filed out from Dolphin Smalltalk"!

Kernel.BindingReference
	subclass: #'Kernel.FullBindingReference'
	instanceVariableNames: 'pathString path private binding generation'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.FullBindingReference guid: (Core.GUID fromString: '{801fde8c-7556-4b95-bb9d-eafb33552e79}')!
Kernel.FullBindingReference comment: '`FullBindingReference`s represent fully-qualified `BindingReferences`.

## Instance Variables:
  `pathString`		`<string>`. The qualified name.
  `path`			`<sequencedReadableCollection>`. The components of the qualified name.
  `private`			`<boolean>` indicating whether this is a private reference (typically only relevant when used to specify an import into a namespace).
  `binding`		`VariableBinding`. The resolved binding, or `Undeclared` if there is no binding for the name path in context.
  `generation`		`<integer>`. Value of `BindingReference.Generation` when `binding` was resolved. Used to check if the cache is stale.

'!
!Kernel.FullBindingReference categoriesForClass!System-Namespaces! !
!Kernel.FullBindingReference methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point, and the same privacy.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined  at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property such that two equal references would always bind to the same variable if bound at the same time."

	"Implementation Note: This implementation depends on the fact that for absolute references the context is always nil. Relative references are of a different class, so will never be equal to absolute references."

	^self == anObject or: 
			[self species == anObject species
				and: [self pathString = anObject pathString and: [private == anObject isPrivate]]]!

asNamespaceImport
	"Answer a<NamespaceImport> that references the same binding as the receiver, the value of which (if any) must to be an <importableNamespace>."

	^self valueOrNil
		ifNil: 
			[NamespaceImport
				pathString: pathString
				path: path
				private: private]
		ifNotNil: 
			[:imported |
			(imported class conformsToProtocol: #importableNamespace)
				ifFalse: [self error: 'Invalid import: <1p>' << self].
			NamespaceImport newFull: imported fullName private: private]!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^self pathString!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	"Implementation Note: Implemented for compatibility with the reference platform, although not used in Dolphin. The selector is likely to confuse anyone with a C++ background; it has nothing to do with a class' superclass."

	^nil
!

bind
	self
		setGeneration: Generation;
		setBinding: (self resolveIn: self bindingScope) ?? Undeclared!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	(binding isNil or: [generation ~~ Generation]) ifTrue: [self bind].
	^binding targetVariable!

bindingScope
	"Answer the <bindingScope> from which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	"Implementation Note: It is an invariant that the context must be nil if the receiver is an absolute binding reference. This will be the case if only the public instance creation methods on the class side are used."

	^Smalltalk!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: self pathString!

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
				nextPut: PathSeparator;
				nextPutAll: (parts at: i)].
	^stream contents!

getBinding
	"Private - For testing purposes only. Does not attempt to resolve the binding."

	^binding!

hash
	"Answer the <integer> hash value for the receiver."

	^self pathString hash!

home
	"Answer the 'namespace context' for this binding reference."

	"Implementation Note: This is defined for compatibility with the reference platform. It is not used in Dolphin."

	^self bindingScope!

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
			[self setPath: ((PathSeparator split: pathString)
						isImmutable: true;
						yourself).
			path]!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name, which may be relative to a binding root, or absolute."

	^pathString
		ifNil: 
			[self setPathString: (PathSeparator join: path).
			pathString]!

private
	^private
		ifTrue: [self]
		ifFalse: 
			[self class
				pathString: pathString
				path: path
				private: true]!

resolveIn: aBindingScope
	^aBindingScope localScope resolveBindingPath: self path environment: aBindingScope environment!

scope
	"Private - Answer the <bindingScope> in which the reference was created. For relative references this is used to determine the start point for binding resolution. For absolute references this should always be nil."

	^nil!

scope: anObject
	"Answer a <RelativeBindingReference> with the receiver's path, but with the specified <bindingScope>."

	^self class
		pathString: self pathString
		private: private
		scope: anObject!

setBinding: aVariableBindingOrNil
	<mutable>
	binding := aVariableBindingOrNil!

setGeneration: anInteger
	<mutable>
	generation := anInteger!

setPath: anArray
	<mutable>
	path := anArray!

setPathString: aString
	<mutable>
	pathString := aString!

setScope: aBindingScope
	self shouldNotImplement!

stbSaveOn: anSTBOutFiler
	"Implmentation Note: We don't want to save out any cached binding. Easiest is to flush it - it isn't that expensive to re-cache when needed"

	self
		setBinding: nil;
		setGeneration: nil.
	^super stbSaveOn: anSTBOutFiler!

undeclare
	"Remove the binding in the target namespace that would be resolved by the receiver, if it exists."

	super undeclare.
	self setBinding: nil!

valueOrNil
	"Answer the value of the variable named by the receiver, or nil if not defined."
	
	"Implementation Note: Overridden as a micro-optimisation as this is perf critical."

	^self bindingOrNil value! !
!Kernel.FullBindingReference categoriesForMethods!
=!comparing!public! !
asNamespaceImport!converting!public! !
asString!converting!public! !
baseClass!accessing!public! !
bind!accessing!private! !
bindingOrNil!accessing!public! !
bindingScope!accessing!public! !
displayOn:!displaying!public! !
environmentName!accessing!public! !
getBinding!accessing!private! !
hash!comparing!public! !
home!accessing!public! !
instance!converting!public! !
isPrivate!public!testing! !
isPrivate:!initializing!private! !
isRelative!public!testing! !
meta!converting!public! !
path!accessing!public! !
pathString!accessing!public! !
private!converting!public! !
resolveIn:!operations!private! !
scope!accessing!private! !
scope:!converting!public! !
setBinding:!initializing!private! !
setGeneration:!initializing!private! !
setPath:!initializing!private! !
setPathString:!initializing!private! !
setScope:!initializing!private! !
stbSaveOn:!binary filing!public! !
undeclare!operations!public! !
valueOrNil!accessing!public! !
!

!Kernel.FullBindingReference class methodsFor!

newPathString: aString path: anArray private: aBoolean
	<primitive: 157>
	^self basicNew
		setPathString: aString;
		setPath: anArray;
		isPrivate: aBoolean;
		yourself!

path: aSequencedReadableCollection private: aBoolean
	"Answer a new instance of the receiver representing the qualified name composed of the <readableString> elements of the argument."

	^self path: aSequencedReadableCollection scope: nil!

pathString: aString path: anArray private: aBoolean
	^(self
		newPathString: aString
		path: anArray
		private: aBoolean)
		isImmutable: true;
		yourself!

uninitialize
	VM
		registryAt: self name put: nil;
		registryAtIndex: 65 put: nil;
		registryAtIndex: 69 put: nil! !
!Kernel.FullBindingReference class categoriesForMethods!
newPathString:path:private:!instance creation!private! !
path:private:!instance creation!public! !
pathString:path:private:!instance creation!private! !
uninitialize!class hierarchy-removing!private! !
!

