"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.MethodName'
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.MethodName guid: (Core.GUID fromString: '{22638432-c25d-413a-9087-34a3b4ad2b08}')!

Kernel.MethodName comment: ''!

!Kernel.MethodName categoriesForClass!Kernel-Objects! !

!Kernel.MethodName methodsFor!

= aMethodName
	^self == aMethodName or: 
			[self species == aMethodName species
				and: [selector == aMethodName selector and: [className = aMethodName className]]]!

className
	^className!

className: aBindingReference 
	className := aBindingReference!

className: aBindingReference selector: aSymbol
	className := aBindingReference.
	selector := aSymbol!

hash
	^(className hash + selector hash) hashMultiply!

isResourceMethod
	^className isMeta and: [selector beginsWith: UI.ResourceIdentifier.SelectorPrefix]!

methodClass
	^className valueOrNil!

printOn: aPuttableStream
	aPuttableStream
		nextPutAll: className shortName;
		nextPutAll: '>>';
		print: selector!

selector
	^selector!

selector: aSymbol
	selector := aSymbol!

value
	^className value compiledMethodAt: selector!

valueOrNil
	^className valueOrNil ifNotNil: [:class | class compiledMethodAt: selector ifAbsent: nil]! !

!Kernel.MethodName categoriesForMethods!
=!comparing!public! !
className!accessing!public! !
className:!initializing!public! !
className:selector:!initializing!private! !
hash!comparing!public! !
isResourceMethod!public!testing! !
methodClass!accessing!public! !
printOn:!printing!public! !
selector!accessing!public! !
selector:!initializing!private! !
value!evaluating!public! !
valueOrNil!evaluating!public! !
!

!Kernel.MethodName class methodsFor!

class: aClassDescription selector: aSymbol
	^self className: aClassDescription fullyQualifiedReference selector: aSymbol!

className: aBindingReference selector: aSymbol
	<primitive: 157>
	^self new 	
		className: aBindingReference selector: aSymbol;
		yourself!

method: aCompiledMethod
	^self className: aCompiledMethod methodClass fullyQualifiedReference selector: aCompiledMethod selector! !

!Kernel.MethodName class categoriesForMethods!
class:selector:!public! !
className:selector:!public! !
method:!public! !
!

