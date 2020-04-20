"Filed out from Dolphin Smalltalk 7"!

AbstractBindingReference subclass: #BindingReference
	instanceVariableNames: 'pathString path binding context'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BindingReference guid: (GUID fromString: '{801fde8c-7556-4b95-bb9d-eafb33552e79}')!
BindingReference comment: 'Generic binding reference.'!
!BindingReference categoriesForClass!System-Namespaces! !
!BindingReference methodsFor!

asString
	"Answer a <readableString> that describes the receiver as a qualified name in the context of the home namespace."

	^self pathString!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^(binding
		ifNil: 
			[self setBinding: ((self home resolveBindingPath: self path) ifNil: [Undeclared]).
			binding])
			targetVariable!

context
	"Answer the naming context in which this reference should be resolved."

	^context!

context: anObject
	context := anObject!

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

setPath: anArray
	<mutable>
	path := anArray!

setPathString: aString
	<mutable>
	pathString := aString! !
!BindingReference categoriesFor: #asString!converting!public! !
!BindingReference categoriesFor: #bindingOrNil!accessing!public! !
!BindingReference categoriesFor: #context!accessing!public! !
!BindingReference categoriesFor: #context:!initializing!private! !
!BindingReference categoriesFor: #hash!comparing!public! !
!BindingReference categoriesFor: #home!accessing!public! !
!BindingReference categoriesFor: #instance!converting!public! !
!BindingReference categoriesFor: #meta!converting!displaying!public! !
!BindingReference categoriesFor: #path!accessing!public! !
!BindingReference categoriesFor: #pathString!accessing!public! !
!BindingReference categoriesFor: #setBinding:!initializing!private! !
!BindingReference categoriesFor: #setPath:!initializing!private! !
!BindingReference categoriesFor: #setPathString:!initializing!private! !

!BindingReference class methodsFor!

clearCachedBindings
	| instances |
	instances := self primAllInstances.
	1 to: instances size do: [:i | (instances at: i) setBinding: nil]!

initialize
	VMLibrary default
		registryAt: self name put: self;
		registryAtIndex: 65 put: #pathString:context:meta:!

newPath: anArray context: anObject
	^self basicNew
		setPath: anArray;
		context: anObject;
		isImmutable: true;
		yourself!

pathString: aString
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument."

	^self basicNew
		setPathString: aString;
		yourself!

pathString: aString context: aBehavior
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument,
	which is relative to the binding context, anObject. If anObject is nil, then the instance is a reference from Smalltalk.
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method),
	and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self basicNew
		setPathString: aString;
		context: aBehavior;
		isImmutable: true;
		yourself!

pathString: aString context: anObject meta: aBoolean
	"Private - Use by the Compiler to construct literal instances."

	| ref |
	ref := self pathString: aString context: anObject.
	^aBoolean ifTrue: [ref meta] ifFalse: [ref]!

uninitialize
	VMLibrary default
		registryAt: self name put: nil;
		registryAtIndex: 65 put: nil! !
!BindingReference class categoriesFor: #clearCachedBindings!private! !
!BindingReference class categoriesFor: #initialize!class initialization!public! !
!BindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!BindingReference class categoriesFor: #pathString:!instance creation!public! !
!BindingReference class categoriesFor: #pathString:context:!instance creation!public! !
!BindingReference class categoriesFor: #pathString:context:meta:!instance creation!private! !
!BindingReference class categoriesFor: #uninitialize!class hierarchy-removing!private! !

