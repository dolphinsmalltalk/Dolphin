"This file contains patches to base system classes that are required in order to be able to reload the base class library, but which are not yet consolidated into the boot image. Note that the BCL is reloaded anyway (see Boot.st), so most BCL changes do not require pre-patching; try without first"!

ClassLocator.ImportedClasses := nil!
!ClassLocator class methodsFor!

isImportedClass: aClass
	^ImportedClasses notNil and: [ImportedClasses identityIncludes: aClass]! !
!ClassLocator class categoriesFor: #isImportedClass:!public!testing! !
!Package methodsFor!

isImportedClass: aClass
	"Private - Answer true if aClass is an imported binary class"

	^ClassLocator isImportedClass: aClass! !
!Package categoriesFor: #isImportedClass:!private!testing! !

"Switch to new identity hash - which is tricky"!

!Object methodsFor!

basicIdentityHash
	<primitive: 75>
	^self primitiveFailed! !

!SmallInteger methodsFor!

basicIdentityHash
	^self! !

!MethodDictionary methodsFor!

hash: anObject max: anInteger
	"Implementation Note: This must match the selector hashing implementation used by the VM."

	^(anObject basicIdentityHash bitAnd: anInteger - 1) + 1! !

!IdentitySet methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!SharedIdentitySet methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!IdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!SharedIdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!WeakIdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!IdentitySearchPolicy methodsFor!

hash: operand max: maximum
	^operand identityHash \\ maximum + 1! !

!Object methodsFor!

identityHash
	^self basicIdentityHash bitShift: 14! !

| m st | 
st := Smalltalk.
m := Symbol basicCompile: 'hash ^self identityHash'.
"As soon as we replace Symbol>>hash, the Smalltalk dictionary is invalidated"
st rehash!

Set allSubinstances do: [:each | each size > 0 ifTrue: [each rehash]]!
