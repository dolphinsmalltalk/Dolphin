"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.MethodName'
	instanceVariableNames: 'className selector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.MethodName guid: (Core.GUID fromString: '{22638432-c25d-413a-9087-34a3b4ad2b08}')!
Kernel.MethodName comment: ''!
!Kernel.MethodName categoriesForClass!Kernel-Objects! !
!Kernel.MethodName methodsFor!

<= aMethodName
	"Answer whether the receiver should sort before the argument."

	^className = aMethodName className
		ifTrue: [(selector <==> aMethodName selector) <= 0]
		ifFalse: [className <= aMethodName className]!

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

methodClass
	^className valueOrNil!

printOn: aPuttableStream
	aPuttableStream
		display: className;
		nextPutAll: '>>';
		print: selector!

selector
	^selector!

selector: aSymbol
	selector := aSymbol!

value
	^className value compiledMethodAt: selector!

valueOrNil
	^className valueOrNil ifNotNil: [:class | class compiledMethodAt: selector ifAbsent: []]! !
!Kernel.MethodName categoriesFor: #<=!comparing!public! !
!Kernel.MethodName categoriesFor: #=!comparing!public! !
!Kernel.MethodName categoriesFor: #className!accessing!public! !
!Kernel.MethodName categoriesFor: #className:!initializing!public! !
!Kernel.MethodName categoriesFor: #className:selector:!initializing!private! !
!Kernel.MethodName categoriesFor: #hash!comparing!public! !
!Kernel.MethodName categoriesFor: #methodClass!accessing!public! !
!Kernel.MethodName categoriesFor: #printOn:!printing!public! !
!Kernel.MethodName categoriesFor: #selector!accessing!public! !
!Kernel.MethodName categoriesFor: #selector:!initializing!private! !
!Kernel.MethodName categoriesFor: #value!evaluating!public! !
!Kernel.MethodName categoriesFor: #valueOrNil!evaluating!public! !

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
!Kernel.MethodName class categoriesFor: #class:selector:!public! !
!Kernel.MethodName class categoriesFor: #className:selector:!public! !
!Kernel.MethodName class categoriesFor: #method:!public! !

