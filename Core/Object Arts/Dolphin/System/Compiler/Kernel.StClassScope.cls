"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticScope subclass: #'Kernel.StClassScope'
	instanceVariableNames: 'methodClass environment instanceVariables selfVariable superVariable metaScope staticVariables'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StClassScope guid: (Core.GUID fromString: '{b221d07f-4ae8-400c-b48e-28b90fca0050}')!
Kernel.StClassScope comment: ''!
!Kernel.StClassScope categoriesForClass!Kernel-Objects! !
!Kernel.StClassScope methodsFor!

classScope
	^self!

environment
	^environment!

environment: aNamespace
	environment := aNamespace!

instanceVariables
	^instanceVariables
		ifNil: 
			[| names |
			names := methodClass allInstanceVariableNames.
			instanceVariables := LookupTable new: names size.
			names keysAndValuesDo: 
					[:i :v |
					instanceVariables at: v
						put: ((StInstanceVariable index: i name: v)
								scope: self;
								yourself)].
			instanceVariables]!

metaScope
	^metaScope
		ifNil: 
			[metaScope := methodClass isMeta
						ifTrue: [self]
						ifFalse: [StClassScope methodClass: methodClass metaclass environment: environment]]!

methodClass
	^methodClass!

methodClass: aClassDescription environment: aNamespace
	methodClass := aClassDescription.
	environment := aNamespace.
	staticVariables := LookupTable new.
	^self!

outer
	^nil!

resolveVariable: aStVariableNode
	| identifier |
	^(self instanceVariables lookup: (identifier := aStVariableNode name))
		ifNil: 
			[staticVariables at: identifier
				ifAbsentPutClean: 
					[(methodClass fullBindingFor: identifier environment: environment)
						ifNotNil: [:b | StStaticVariable scope: self binding: b]]]!

selfVariable
	^selfVariable
		ifNil: 
			[selfVariable := StSelfVariable new
						scope: self;
						yourself]!

superVariable
	^superVariable
		ifNil: 
			[superVariable := StSuperVariable new
						scope: self;
						yourself]! !
!Kernel.StClassScope categoriesForMethods!
classScope!accessing!public! !
environment!accessing!public! !
environment:!accessing!public! !
instanceVariables!accessing!public! !
metaScope!accessing!public! !
methodClass!accessing!public! !
methodClass:environment:!initializing!private! !
outer!accessing!public! !
resolveVariable:!operations!private! !
selfVariable!operations!public! !
superVariable!operations!public! !
!

!Kernel.StClassScope class methodsFor!

methodClass: aClassDescription
	^self methodClass: aClassDescription environment: aClassDescription environment!

methodClass: aClassDescription environment: aNamespace
	^self new
		methodClass: aClassDescription environment: aNamespace! !
!Kernel.StClassScope class categoriesForMethods!
methodClass:!instance creation!public! !
methodClass:environment:!instance creation!public! !
!

