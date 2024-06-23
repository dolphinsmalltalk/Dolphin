"Filed out from Dolphin Smalltalk"!

Kernel.BindingReferenceWrapper
	subclass: #'Refactory.Browser.RBBindingReference'
	instanceVariableNames: 'model'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.RBBindingReference guid: (Core.GUID fromString: '{6087e072-0c5e-458a-8084-877b910c0553}')!

Refactory.Browser.RBBindingReference comment: ''!

!Refactory.Browser.RBBindingReference methodsFor!

= anObject
	"Answer whether the receiver and the <Object> argument should be considered equivalent. Binding references are considered equivalent if they have the same path and starting point.
	Note that two binding references that would resolve to the same actual variable binding may not be considered equivalent as the binding resolution is a dynamic quality determined 
	at the time of resolution, and is not necessarily temporally stable. Equality of binding references is a static property based and is such that two equal references will always bind
	to the same variable if bound at the same time."

	^self == anObject or: [anObject = reference]!

bindingOrNil
	"Answer the <VariableBinding> referenced by the receiver (i.e. resolve the variable), or nil if there is no such variable."

	| scope |
	scope := self bindingScope.
	^scope localScope resolveBindingPath: self path environment: scope environment!

bindingScope
	"Answer the <bindingScope> in which the receiver's binding path is traversed to locate the target binding.
	This will be a <Class> or a <CompiledCode>. If a class, it may be a <Namespace>. If the receiver is an absolute binding reference it will be the <Smalltalk> namespace class."

	^model smalltalkNamespace!

model: aRBClass 
	model := aRBClass!

newWrapping: aBindingReference
	^self class model: model reference: aBindingReference!

realReference
	"Answer the receiver's non-model reference."

	^reference!

referenceInModel: aRBModel
	^model == aRBModel ifTrue: [self] ifFalse: [self class model: aRBModel reference: reference]!

species
	^reference species!

valueOfBinding: aVariableBinding
	^reference isMeta ifTrue: [aVariableBinding value metaclass] ifFalse: [aVariableBinding value]! !

!Refactory.Browser.RBBindingReference categoriesForMethods!
=!comparing!public! !
bindingOrNil!accessing!public! !
bindingScope!accessing!public! !
model:!initializing!private! !
newWrapping:!converting!private! !
realReference!accessing!public! !
referenceInModel:!converting!public! !
species!comparing!public! !
valueOfBinding:!accessing!private! !
!

!Refactory.Browser.RBBindingReference class methodsFor!

model: aRBModel reference: aBindingReference
	^(self wrapping: aBindingReference)
		model: aRBModel;
		isImmutable: true;
		yourself!

pathString: aString scope: aBindingScope flags: anInteger
	^self model: aBindingScope model
		reference: (super
				pathString: aString
				scope: aBindingScope
				flags: anInteger)! !

!Refactory.Browser.RBBindingReference class categoriesForMethods!
model:reference:!public! !
pathString:scope:flags:!instance creation!private! !
!

