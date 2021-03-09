"Filed out from Dolphin Smalltalk 7"!

Kernel.AbstractBindingReference subclass: #'Kernel.MetaBindingReference'
	instanceVariableNames: 'instance'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MetaBindingReference guid: (Core.GUID fromString: '{c54304a7-5aa9-404b-a969-27501f25f612}')!
Kernel.MetaBindingReference comment: '`MetaBindingReference` is a `BindingReference` wrapper that resolves to the class of the referenced binding''s value, for example `#{Object class}` is a static literal reference that evaluates to the same object as the expression `#{Object} class`, i.e. the metaclass of the class `Object`.

`MetaBindingReference` instances are useful for cases such as constructing `MethodName`s that refer to class-side methods. They are used as part of the file out format for packages and allow the list of loose methods to be represented efficiently as literal arrays.'!
!Kernel.MetaBindingReference categoriesForClass!System-Namespaces! !
!Kernel.MetaBindingReference methodsFor!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."
 
	^instance asString, ' class'!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	^instance baseClass
	!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^instance bindingOrNil!

bindingRoot
	"Private - Answer the root binding context from which the receiver's binding path is traversed to locate the target binding.
	This is always a <Class>. It may be a <Namespace>. If the receiver is an absolute binding reference it will be the Smalltalk namespace class."

	^instance bindingRoot!

context
	"The name context in which resolution of the binding should be initiated if relative, else nil."

	^instance context!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: instance;
		space;
		nextPutAll: #class!

flags
	^instance flags bitOr: MetaMask!

hash
	"Answer the <integer> hash value for the receiver."

	^instance hash bitXor: 1!

home
	"Answer the 'namespace context' for this binding reference."

	^instance home!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^instance!

isMeta
	"Is this a meta binding reference?"

	^true!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^instance isPrivate!

isPrivate: aBoolean
	instance isPrivate: aBoolean!

isRelative
	"Answer whether the receiver specifies a binding path relative to its home binding context, or alternatively is an absolute (or fully-qualified) binding reference."

	^instance isRelative!

meta
	"Answer a <BindingReference> that resolves to the class of the value of the binding to which the receiver resolves."

	^self!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^instance path!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

	^instance pathString!

setInstance: aBindingReference
	instance := aBindingReference!

shortName
	"Answer the shortest <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^super shortName, ' class'!

unqualifiedName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^super unqualifiedName, ' class'!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.MetaBindingReference categoriesFor: #asString!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #baseClass!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #bindingRoot!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #context!constants!public! !
!Kernel.MetaBindingReference categoriesFor: #displayOn:!converting!displaying!public! !
!Kernel.MetaBindingReference categoriesFor: #flags!accessing!private! !
!Kernel.MetaBindingReference categoriesFor: #hash!comparing!public! !
!Kernel.MetaBindingReference categoriesFor: #home!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #instance!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #isMeta!public!testing! !
!Kernel.MetaBindingReference categoriesFor: #isPrivate!public!testing! !
!Kernel.MetaBindingReference categoriesFor: #isPrivate:!accessing!private! !
!Kernel.MetaBindingReference categoriesFor: #isRelative!public!testing! !
!Kernel.MetaBindingReference categoriesFor: #meta!converting!displaying!public! !
!Kernel.MetaBindingReference categoriesFor: #path!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #pathString!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #setInstance:!converting!private! !
!Kernel.MetaBindingReference categoriesFor: #shortName!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #unqualifiedName!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #valueOfBinding:!accessing!private! !

!Kernel.MetaBindingReference class methodsFor!

instance: aBindingReference
	^self basicNew
		setInstance: aBindingReference;
		isImmutable: true;
		yourself!

newPath: anArray context: anObject
	^self instance: (BindingReference newPath: anArray context: anObject)!

pathString: aString context: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self instance: (BindingReference pathString: aString context: anObject)! !
!Kernel.MetaBindingReference class categoriesFor: #instance:!instance creation!public! !
!Kernel.MetaBindingReference class categoriesFor: #newPath:context:!instance creation!private! !
!Kernel.MetaBindingReference class categoriesFor: #pathString:context:!instance creation!public! !

