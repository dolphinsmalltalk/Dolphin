"This file contains patches to base system classes that are required in order to be able to reload the base class library, but which are not yet consolidated into the boot image. Note that the BCL is reloaded anyway (see Boot.st), so most BCL changes do not require pre-patching; try without first"!

VMLibrary default primRegistryAt: 71 put: #~~; primRegistryAt: 72 put: #not!

AttributeDescriptorFlags keysAndValuesDo: [:k :v | AttributeDescriptor addClassConstant: k value: v].
AttributeDescriptor addClassConstant: 'NonBrowsableMask' value: 128!
#(#AttributeDescriptorFlags #STBPrefixConstants) do: [:each | Package manager systemPackage removeGlobalNamed: each. Smalltalk removeKey: each ifAbsent: []]!
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

"Behavior.methodDictionary can now be nil"
Behavior addClassConstant: '_NullMethodDictionary'
		value: ((MethodDictionary new)
				isImmutable: true;
				yourself)!

!Behavior methodsFor!

addSelector: aSymbol withMethod: aCompiledMethod
	| selector |
	selector := aSymbol asSymbol.
	aCompiledMethod
		methodClass: self;
		selector: selector.
	(methodDictionary ifNil: [methodDictionary := MethodDictionary new]) at: selector
		put: aCompiledMethod.

	self flushMethodCache!

basicCompile: aString flags: anInteger
	| error result stubMethod |
	result := error := stubMethod := nil.
	
	[result := self compilerClass
				compile: aString
				in: self
				flags: anInteger]
			on: self compilerClass errorClass
			do: 
				[:n |
				error := n.
				stubMethod := (MethodCompileFailed with: n) signal: n description.
				n pass].
	error notNil ifTrue: [result := stubMethod].
	result notNil
		ifTrue: 
			[| selector method |
			method := result method.
			selector := method selector asSymbol.
			methodDictionary
				ifNotNil: 
					[| oldMethod |
					oldMethod := methodDictionary at: selector ifAbsent: [].
					result oldMethod: oldMethod.
					oldMethod ifNotNil: [method isPrivate: oldMethod isPrivate]].
			self addSelector: selector withMethod: method.
			method
				storeSourceString: aString asString;
				isImmutable: true].
	^result! !

(Array with: ExternalCallback with: ExternalDescriptor) do: [:each | each class removeSelector: #initialize]!
ExternalDescriptor addClassConstant: 'RetTypeMask' value: 63!
#(always caseInsensitive equality identity never uninitialize) do: [:each | SearchPolicy class removeSelector: each]!
#(current uninitialize) do: [:each | SymbolStringSearchPolicy class removeSelector: each. AssociationSearchPolicy class removeSelector: each]!

BYTE subclass: #BOOLEAN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

!BOOLEAN class methodsFor!

fileOutStem
	^super fileOutStem, '_struct'! !

NTLibrary addClassVariable: 'IsWine' value: false!

(Array with: ArrayField with: ArrayPointerField) do: [:each | each withAllSubclassesDo: [:f | (f whichSelectorsAccess: 'length') do: [:s | f removeSelector: s]]]!

(Array with: CPINFO with: TIME_ZONE_INFORMATION) do: [:each | each resetTemplate]!

ByteCodeDispatcher.RunStarts at: #shortSpecialSendEx: put: 200!