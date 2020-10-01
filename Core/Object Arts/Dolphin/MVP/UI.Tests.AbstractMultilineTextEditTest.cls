"Filed out from Dolphin Smalltalk 7"!

UI.Tests.AbstractTextEditTest subclass: #'UI.Tests.AbstractMultilineTextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.AbstractMultilineTextEditTest guid: (Core.GUID fromString: '{8cec10d6-5d60-4f12-9a39-999fcc22b29d}')!
UI.Tests.AbstractMultilineTextEditTest isNonInstantiable: true!
UI.Tests.AbstractMultilineTextEditTest comment: ''!
!UI.Tests.AbstractMultilineTextEditTest categoriesForClass!Unclassified! !
!UI.Tests.AbstractMultilineTextEditTest methodsFor!

testPlainTextAtLine
	presenter text: ''.
	self assert: (presenter plainTextAtLine: 1) equals: ''.
	#(-1 0 2) do: [:i | self should: [presenter plainTextAtLine: i] raise: BoundsError].
	presenter text: 'a£b
c🐬d
'.
	self assert: (presenter plainTextAtLine: 1) equals: 'a£b'.
	self assert: (presenter plainTextAtLine: 2) equals: 'c🐬d'.
	self assert: (presenter plainTextAtLine: 3) equals: ''.
	#(-1 0 4 5) do: [:i | self should: [presenter plainTextAtLine: i] raise: BoundsError]!

text
	^'Object is the abstract root of the standard Smalltalk class hierarchy. It has no instance variables (indeed it must not have any), but provides behavior common to all objects.

Instance Variables:
<MUST BE NONE>

Class Variables:
_AssertionFailureSignal <Signal> raised when assertion failures occur (see #assert:)
_DependentsRegister<WeakIdentityDictionary> containing DependentsCollections for instances
_EventsRegister <WeakIdentityDictionary> containing EventsCollections for instances
_PropertyRegister <PropertyManager> Register of instance specific information not stored in instance variables

The following Instance specific behaviour mask constants are held in the PoolConstantsDictionary _InstanceBehaviorMasks in order that they may be readily shared into user defined root classes.
_FinalizeMask <Integer> bit mask to set/reset the finalize mark of instances
_GetSpecialMask <Integer> bit mask to retrieve special behavior flags of instances
_WeakMask <Integer> bit mask to use to set/reset the weak mark of instances. Includes pointer bit.

Note: All class variables beginning with $_ are private to the implementation. This convention is adopted to avoid potential name clashes with user defined classes, and is a requirement for ANSI compliance.

Object implements the ANSI protocol <Object> (browse the protocols-Object category).

The following messages defined in Object have optimized implementations inlined by the Compiler and cannot be overridden:
#==
#basicAt:(overridable if subclass not indexable)
#basicAt:put:(ditto)
#basicSize
#basicClass
#isNil
#notNil
#yourself
In addition any selector in Object with a ''basic'' prefix may be subject to inlining in future releases, so these should not be overridden.
'! !
!UI.Tests.AbstractMultilineTextEditTest categoriesFor: #testPlainTextAtLine!public!unit tests! !
!UI.Tests.AbstractMultilineTextEditTest categoriesFor: #text!constants!private! !

