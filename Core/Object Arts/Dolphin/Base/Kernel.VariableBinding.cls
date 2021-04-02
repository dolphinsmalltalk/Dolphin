"Filed out from Dolphin Smalltalk 7"!

Core.Association subclass: #'Kernel.VariableBinding'
	instanceVariableNames: 'environment flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'ClassMask' -> 16r2.
		'DeprecatedMask' -> 16r100.
		'PrivateMask' -> 16r1
	}!
Kernel.VariableBinding guid: (Core.GUID fromString: '{1e72742f-5466-4331-bb39-2ff12ac9743f}')!
Kernel.VariableBinding comment: ''!
!Kernel.VariableBinding categoriesForClass!Collections-Support! !
!Kernel.VariableBinding methodsFor!

= anAssociation
	"Answer whether the receiver is equal to the argument."

	^super = anAssociation and: [environment == anAssociation environment]!

absoluteName
	"Answer the <String> fully qualified name of this namespace, which is a dot-separated path to this binding from (but not including) Smalltalk."

	^self environment absoluteNameFor: self key!

asQualifiedReference
	"Answer a <BindingReference> that refs to this binding."

	^BindingReference pathString: self key home: self environment!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: key!

displayString
	^key!

environment
	^environment!

environment: aNamespace 
	<mutable>
	environment := aNamespace!

flags
	^flags!

fullName
	"Answer the <String> fully qualified name of this namespace, which is a dot-separated path to this binding from (but not including) Smalltalk."

	^self environment fullNameFor: self key!

fullyQualifiedReference
	"Answer a <BindingReference> that represents a fully qualified reference to the receiver relative to Smalltalk. If the Class is not in the hierarchy below Smalltalk (i.e. it is in Root, or another namespace hierarchy under Root), then it will be an absolute binding reference.
	The resulting binding reference can be used to resolve the receiver, if installed, or to redeclare it, when not."

	^BindingReference path: (environment fullPath copyWith: key)!

isAlias
	^false!

isClassVariable
	"Answer whether the receiver is a class variable binding (as opposed to a namespace variable binding)."

	^flags allMask: ClassMask!

isClassVariable: aBoolean
	"Set whether the receiver is a class variable binding (as opposed to a namespace variable binding)."

	self setFlags: (flags mask: ClassMask set: aBoolean)!

isConstant
	"Answer whether the receiver is a constant binding, the value of which cannot be assigned."

	^self isImmutable!

isConstant: aBoolean
	"Set whether the receiver should be a constant binding, the value of which cannot be assigned."

	self isImmutable: aBoolean!

isDeprecated
	"Answer whether the receiver should be considered deprecated."

	^flags allMask: DeprecatedMask!

isDeprecated: aBoolean
	"Set whether the receiver should be considered deprecated."

	flags := flags mask: DeprecatedMask set: aBoolean!

isPrivate
	"Answer whether the receiver is a private binding that should only be visible in its home namespace."

	^flags allMask: PrivateMask!

isPrivate: aBoolean
	self setFlags: (flags mask: PrivateMask set: aBoolean)!

key: aKey value: aValue
	"Private - Set the instance variables of the receiver to aKey->aValue"

	super key: aKey value: aValue.
	flags := 0.
	^self!

owningPackage
	"Answer the receiver's owning <Package>."

	^self class packageManager packageOfVariableNamed: self fullyQualifiedReference!

owningPackage: aPackageOrNil
	"Set the receiver's owning <Package> to be the argument. Any current package association is replaced."

	self class packageManager addVariableNamed: self fullyQualifiedReference to: aPackageOrNil!

refersTo: anObject asLiteralOf: aCompiledMethod
	^(anObject == environment and: 
			["Not useful to show every variable in a Namespace as an implicit reference to it, nor a class hierarchy's references to its own class variables."
			self isClassVariable and: [(aCompiledMethod methodClass includesBehavior: environment) not]])
		or: [self = anObject]!

refersToLiteral: anObject from: aCompiledMethod
	^(anObject == environment and: 
			["Not useful to show every variable in Smalltalk as an implicit reference to it. Probably true of all Namespaces except pools and classes."
			environment ~~ Smalltalk])
		or: [self = anObject]!

setFlags: anInteger
	<mutable>
	flags := anInteger!

targetVariable
	^self! !
!Kernel.VariableBinding categoriesFor: #=!comparing!public! !
!Kernel.VariableBinding categoriesFor: #absoluteName!accessing!public! !
!Kernel.VariableBinding categoriesFor: #asQualifiedReference!converting!public! !
!Kernel.VariableBinding categoriesFor: #displayOn:!printing!public! !
!Kernel.VariableBinding categoriesFor: #displayString!displaying!public! !
!Kernel.VariableBinding categoriesFor: #environment!accessing!public! !
!Kernel.VariableBinding categoriesFor: #environment:!accessing!public! !
!Kernel.VariableBinding categoriesFor: #flags!public! !
!Kernel.VariableBinding categoriesFor: #fullName!accessing!public! !
!Kernel.VariableBinding categoriesFor: #fullyQualifiedReference!converting!public! !
!Kernel.VariableBinding categoriesFor: #isAlias!public! !
!Kernel.VariableBinding categoriesFor: #isClassVariable!public! !
!Kernel.VariableBinding categoriesFor: #isClassVariable:!public! !
!Kernel.VariableBinding categoriesFor: #isConstant!public! !
!Kernel.VariableBinding categoriesFor: #isConstant:!public! !
!Kernel.VariableBinding categoriesFor: #isDeprecated!public! !
!Kernel.VariableBinding categoriesFor: #isDeprecated:!public! !
!Kernel.VariableBinding categoriesFor: #isPrivate!public! !
!Kernel.VariableBinding categoriesFor: #isPrivate:!public! !
!Kernel.VariableBinding categoriesFor: #key:value:!initializing!private! !
!Kernel.VariableBinding categoriesFor: #owningPackage!accessing!development!public! !
!Kernel.VariableBinding categoriesFor: #owningPackage:!accessing!development!public! !
!Kernel.VariableBinding categoriesFor: #refersTo:asLiteralOf:!private!testing! !
!Kernel.VariableBinding categoriesFor: #refersToLiteral:from:!private!testing! !
!Kernel.VariableBinding categoriesFor: #setFlags:!accessing!private! !
!Kernel.VariableBinding categoriesFor: #targetVariable!accessing!public! !

!Kernel.VariableBinding class methodsFor!

stbConvertFrom: anSTBClassFormat
	"Convert from previous version resource. 
	Version Changes:
		1) Adds 'environment'
		2) Adds 'flags'
	"

	^
	[:data |
	| answer value |
	answer := self basicNew.
	1 to: data size do: [:i | answer instVarAt: i put: (data at: i)].
	answer environment ifNil: [
		"In most cases a VariableBinding will be in STB because it is referenced from the literal frame of a method. For those cases where the reference is to a class, it is very likely that the variable is from the Smalltalk dictionary, so we patch the environment to that. For other cases, we don't have enough context here to be able to determine the correct environment, so we leave it nil."
		value := answer value.
		(value class isMeta and: [answer key == value name]) ifTrue: [answer environment: Smalltalk]].
	answer setFlags: 0.
	answer]!

stbVersion
	^2! !
!Kernel.VariableBinding class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Kernel.VariableBinding class categoriesFor: #stbVersion!binary filing!public! !

