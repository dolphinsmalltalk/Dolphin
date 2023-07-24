"Filed out from Dolphin Smalltalk"!

Kernel.ClassLocator
	subclass: #'Kernel.RestrictedClassLocator'
	instanceVariableNames: 'classMap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.RestrictedClassLocator guid: (Core.GUID fromString: '{2f0278c8-37bc-45b7-9a23-84a21a6895ed}')!
Kernel.RestrictedClassLocator comment: ''!
!Kernel.RestrictedClassLocator methodsFor!

classes: aCollection
	self initialize.
	classMap := LookupTable new.
	aCollection do: 
			[:each |
			| ref |
			ref := each asQualifiedReference.
			classMap
				at: ref shortName put: ref;
				at: ref fullName put: ref]!

classMap: aLookupTable
	classMap := aLookupTable!

copyWithCodeBase
	"Private - Answer a instance of the same class as the receiver with the same codeBase.
	This allows both the codeBase and the mechanism for using it to be propagated."

	^super copyWithCodeBase classMap: classMap!

excludeClass: aClass
	| ref |
	ref := aClass asQualifiedReference.
	classMap
		removeKey: ref shortName ifAbsent: nil;
		removeKey: ref fullName ifAbsent: nil!

findResidentClass: aBindingReference
	"Answer the class referred to by the receiver if it is fully resident in the image and is within the allowed set."

	^(classMap lookup: aBindingReference pathString)
		ifNil: [STBValidatingInFiler errorInvalidClass: aBindingReference]
		ifNotNil: [:name | name valueOrNil]!

includeClass: aClass
	| ref |
	ref := aClass asQualifiedReference.
	classMap
		at: ref shortName put: ref;
		at: ref fullName put: ref!

includesClass: aClass
	"Answer whether the <Class> argument is within the allowed set."

	^classMap includesKey: aClass fullName! !
!Kernel.RestrictedClassLocator categoriesForMethods!
classes:!initializing!private! !
classMap:!accessing!private! !
copyWithCodeBase!copying!private! !
excludeClass:!initializing!public! !
findResidentClass:!operations!public! !
includeClass:!initializing!public! !
includesClass:!public!testing! !
!

!Kernel.RestrictedClassLocator class methodsFor!

forClasses: aCollection
	^self basicNew classes: aCollection!

new
	"Answer a new instance of the receiver that is secure by default (disallows everything)."

	^self forClasses: #()! !
!Kernel.RestrictedClassLocator class categoriesForMethods!
forClasses:!public! !
new!public! !
!

