"Filed out from Dolphin Smalltalk"!

Kernel.BindingReference
	subclass: #'Kernel.BindingReferenceWrapper'
	instanceVariableNames: 'reference'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.BindingReferenceWrapper guid: (Core.GUID fromString: '{87488d7c-57f8-4328-91f8-f2f6dd0e66fd}')!
Kernel.BindingReferenceWrapper isNonInstantiable: true!
Kernel.BindingReferenceWrapper comment: ''!
!Kernel.BindingReferenceWrapper categoriesForClass!System-Namespaces! !
!Kernel.BindingReferenceWrapper methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable if bound at the same time."

	^self == anObject or: [self class == anObject class and: [reference = anObject reference]]!

asFullyQualifiedReference
	"Answer a<BindingReference> that references the same binding as the receiver does currently in its home context, but from Smalltalk or Root."

	^self isRelative
		ifTrue: [self newWrapping: reference asFullyQualifiedReference]
		ifFalse: [self]!

asNamespaceImport
	"Answer a<NamespaceImport> that references the same binding as the receiver, the value of which is assumed to be an <importableNamespace>."

	| import |
	import := reference asNamespaceImport.
	^import == reference ifTrue: [self] ifFalse: [self newWrapping: import]!

asString
	"Answer a <readableString> that is the receiver's qualified name expression."

	^reference asString!

baseClass
	"Answer the 'class' context of the receiver, if a relative reference defined within the context of a class or method, or nil if absolute.
	When non-nil, this is the starting point for resolution of the binding path, and that 'class' context is asked to resolve the binding."

	^reference baseClass!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	^reference bindingOrNil!

bindingScope
	"Answer the <bindingScope> in which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	^reference bindingScope!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	reference displayOn: aPuttableStream!

environmentName
	"Answer the <String> qualified name of the receiver's full namespace qualifier. This includes the path for the binding scope."

	^reference environmentName!

hash
	"Answer the <integer> hash value for the receiver."

	^reference hash bitXor: 1!

home
	"Answer the 'namespace context' for this binding reference."

	^reference home!

instance
	"Answer a `BindingReference` that resolves to the value of the binding with the receiver's path."

	^reference instance!

isMeta
	"Is this a meta binding reference?"

	^reference isMeta!

isPrivate
	"Answer whether the receiver represents a private binding reference that should not be used outside its immediate scope."

	^reference isPrivate!

isPrivate: aBoolean
	reference isPrivate: aBoolean!

isRelative
	"Answer whether the receiver specifies a binding path relative to its home binding context, or alternatively is an absolute (or fully-qualified) binding reference."

	^reference isRelative!

meta
	"Answer a `MetaBindingReference` that resolves to the class of the value of the binding to which the receiver resolves."

	^self isMeta ifTrue: [self] ifFalse: [self newWrapping: reference meta]!

newWrapping: aBindingReference
	^self class wrapping: aBindingReference!

path
	"Answer a <sequencedReadableCollection> of <String>, being the component parts of the qualified name in order from the home namespace."

	^reference path!

pathString
	"Answer a <readableString> that expresses the receiver as a qualified name in the context of the home namespace."

	^reference pathString!

private
	"Answer a `BindingReference` that is the resolves to the same binding as the receiver, but which is flagged as private."

	^self isPrivate ifTrue: [self] ifFalse: [self newWrapping: reference private]!

reference
	^reference!

reference: aBindingReference
	reference := aBindingReference!

scope
	"Private - The <bindingScope> in which resolution of the binding should be initiated if relative, else nil."

	^reference scope!

scope: anObject
	"Answer a <RelativeBindingReference> with the receiver's path, but with the specified <bindingScope>."

	^self class instance: (reference scope: anObject)!

setScope: anObject
	^reference setScope: anObject!

unqualifiedPathLiteralPrefix
	^reference unqualifiedPathLiteralPrefix! !
!Kernel.BindingReferenceWrapper categoriesForMethods!
=!comparing!public! !
asFullyQualifiedReference!converting!public! !
asNamespaceImport!converting!public! !
asString!converting!public! !
baseClass!accessing!public! !
bindingOrNil!accessing!public! !
bindingScope!accessing!public! !
displayOn:!displaying!public! !
environmentName!accessing!public! !
hash!comparing!public! !
home!accessing!public! !
instance!accessing!public! !
isMeta!public!testing! !
isPrivate!public!testing! !
isPrivate:!initializing!private! !
isRelative!public!testing! !
meta!converting!public! !
newWrapping:!converting!private! !
path!accessing!public! !
pathString!accessing!public! !
private!converting!public! !
reference!accessing!private! !
reference:!initializing!private! !
scope!constants!private! !
scope:!converting!public! !
setScope:!initializing!private! !
unqualifiedPathLiteralPrefix!constants!private! !
!

!Kernel.BindingReferenceWrapper class methodsFor!

wrapping: aBindingReference
	<primitive: 157>
	^self basicNew
		reference: aBindingReference;
		yourself! !
!Kernel.BindingReferenceWrapper class categoriesForMethods!
wrapping:!instance creation!public! !
!

