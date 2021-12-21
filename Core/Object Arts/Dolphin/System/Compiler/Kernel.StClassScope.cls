"Filed out from Dolphin Smalltalk"!

Kernel.StSemanticScope subclass: #'Kernel.StClassScope'
	instanceVariableNames: 'methodClass environment instanceVariables selfVariable superVariable'
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
			[instanceVariables := LookupTable new: 5.
			methodClass allInstVarNames keysAndValuesDo: 
					[:i :v |
					instanceVariables at: v
						put: ((StInstanceVariable index: i name: v)
								scope: self;
								yourself)].
			instanceVariables]!

methodClass
	^methodClass!

methodClass: aClassDescription
	methodClass := aClassDescription!

outer
	^nil!

resolveVariable: anStVariableNode
	| identifier |
	^(self instanceVariables lookup: (identifier := anStVariableNode name))
		ifNil: 
			[(methodClass fullBindingFor: identifier environment: environment)
				ifNotNil: [:b | StStaticVariable scope: self binding: b]]!

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
methodClass!accessing!public! !
methodClass:!initializing!private! !
outer!accessing!public! !
resolveVariable:!operations!private! !
selfVariable!operations!public! !
superVariable!operations!public! !
!

!Kernel.StClassScope class methodsFor!

methodClass: aClassDescription environment: aNamespace
	<primitive: 157>
	^self new
		methodClass: aClassDescription;
		environment: aNamespace;
		yourself! !
!Kernel.StClassScope class categoriesForMethods!
methodClass:environment:!instance creation!public! !
!

