"Filed out from Dolphin Smalltalk"!

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

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable if bound at the same time."

	^self == anObject or: [self class == anObject class and: [instance = anObject instance]]!

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

bindingScope
	"Answer the <bindingScope> in which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	^instance bindingScope!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream
		display: instance;
		space;
		nextPutAll: #class!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the binding scope."

	^instance environmentName!

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

private
	^self isPrivate ifTrue: [self] ifFalse: [instance private meta]!

scope
	"Private - The <bindingScope> in which resolution of the binding should be initiated if relative, else nil."

	^instance scope!

setInstance: aBindingReference
	instance := aBindingReference!

setScope: anObject
	^instance setScope: anObject!

shortName
	"Answer the shortest <String> name equivalent to the receiver's pathString that is bindable from Smalltalk. i.e. for variables defined directly in Smalltalk, or in any of its imports, this will be an unqualified name. Otherwise it is the fully qualified name relative to Smalltalk."

	^super shortName, ' class'!

unqualifiedName
	"Answer the unqualified name part of the receiver (the final component of the name)."

	^super unqualifiedName, ' class'!

valueOfBinding: aVariableBinding
	^aVariableBinding value class! !
!Kernel.MetaBindingReference categoriesFor: #=!comparing!public! !
!Kernel.MetaBindingReference categoriesFor: #asString!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #baseClass!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #bindingOrNil!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #bindingScope!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #displayOn:!converting!displaying!public! !
!Kernel.MetaBindingReference categoriesFor: #environmentName!accessing!public! !
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
!Kernel.MetaBindingReference categoriesFor: #private!converting!public! !
!Kernel.MetaBindingReference categoriesFor: #scope!constants!private! !
!Kernel.MetaBindingReference categoriesFor: #setInstance:!converting!private! !
!Kernel.MetaBindingReference categoriesFor: #setScope:!initializing!private! !
!Kernel.MetaBindingReference categoriesFor: #shortName!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #unqualifiedName!accessing!public! !
!Kernel.MetaBindingReference categoriesFor: #valueOfBinding:!accessing!private! !

!Kernel.MetaBindingReference class methodsFor!

instance: aBindingReference
	^self basicNew
		setInstance: aBindingReference;
		isImmutable: true;
		yourself!

newPath: anArray private: aBoolean scope: aBindingScope
	^self instance: (BindingReference
				newPath: anArray
				private: aBoolean
				scope: aBindingScope)!

pathString: aString scope: anObject
	"Answer a new instance of the receiver representing the qualified name identified by the <readableString> argument, which is relative to the binding context, anObject. If anObject is nil, then an AbsoluteBindingPath is returned. 
	If anObject is not nil, then it is expected to be some kind of name binding context (i.e. a namespace, class, or method), and the new instance will be a contextual BindingReference with that object as its starting point for resolving the binding."

	^self instance: (BindingReference pathString: aString scope: anObject)! !
!Kernel.MetaBindingReference class categoriesFor: #instance:!instance creation!public! !
!Kernel.MetaBindingReference class categoriesFor: #newPath:private:scope:!instance creation!private! !
!Kernel.MetaBindingReference class categoriesFor: #pathString:scope:!instance creation!public! !

