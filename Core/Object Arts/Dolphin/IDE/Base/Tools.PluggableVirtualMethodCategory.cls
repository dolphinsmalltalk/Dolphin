"Filed out from Dolphin Smalltalk 7"!

Tools.VirtualMethodCategory subclass: #'Tools.PluggableVirtualMethodCategory'
	instanceVariableNames: 'filter isSlowToEnumerate'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PluggableVirtualMethodCategory guid: (Core.GUID fromString: '{cf4b4026-94a0-45e3-9949-2dca5b07b1e8}')!
Tools.PluggableVirtualMethodCategory comment: 'PluggableMethodCategory is a virtual method category class the dynamically generated membership of which includes all methods that pass a configurable filter. See the class side #initialize method for examples.

Instance Variables:
	filter	- <MonadicValuable> evaluated against each candidate method, expected to answer true/false to include/exclude that method.

Class Variables:
	None'!
!Tools.PluggableVirtualMethodCategory categoriesForClass!System-Support! !
!Tools.PluggableVirtualMethodCategory methodsFor!

includesMethod: aCompiledMethod 
	"Answer whether this category includes the <CompiledMethod> argument."

	^filter value: aCompiledMethod!

isSlowToEnumerate
	"Answer whether this method category is slow to enumerate. This may be the case for certain
	calculated categories."

	^isSlowToEnumerate!

isSlowToEnumerate: aBoolean 
	isSlowToEnumerate := aBoolean!

setFilter: aMonadicValuable 
	filter := aMonadicValuable.
	isSlowToEnumerate := false!

setName: aString 
	super setName: aString.
	filter := [:each | true]! !
!Tools.PluggableVirtualMethodCategory categoriesFor: #includesMethod:!public!testing! !
!Tools.PluggableVirtualMethodCategory categoriesFor: #isSlowToEnumerate!public!testing! !
!Tools.PluggableVirtualMethodCategory categoriesFor: #isSlowToEnumerate:!accessing!public! !
!Tools.PluggableVirtualMethodCategory categoriesFor: #setFilter:!initializing!private! !
!Tools.PluggableVirtualMethodCategory categoriesFor: #setName:!initializing!private! !

!Tools.PluggableVirtualMethodCategory class methodsFor!

initialize
	"Private - Initialize the receiver.
		self  initialize.
	"

	"The '*-compilation failures' category contains only those methods that could not be compiled.
	Usually these can only result from a compilation error during a package load or file-in, or when
	the class definition is changed to remove variables that are referenced from the method."

	self addPseud: (self newNamed: self pseudPrefix , 'compilation failures'
				withFilter: [:each | each isCompilationFailure]).
	"The '*-compilation issues' category contains only those methods that have some kind of compiler error
	or warning associated with them, detected either by the compiler or the semantic analyser."
	self addPseud: ((self newNamed: self pseudPrefix , 'compilation issues'
				withFilter: [:each | each hasCompilationIssues])
				isSlowToEnumerate: true;
				yourself).
	"The '*-primitives' category contains all the true primitive methods in the system, i.e. those where
	the VM provides the default implementation as a built-in operation, with any Smalltalk code in the
	method only being run should that operation fail for some reason."
	self addPseud: (self newNamed: self pseudPrefix , 'primitives'
				withFilter: [:each | each isExternalCall not and: [each isPrimitive]]).
	"The '*-sends unimplemented message' category contains all methods that send messages which
	are not implemented in any class in the image"
	self addPseud: ((self newNamed: self pseudPrefix , 'sends unimplemented message'
				withFilter: [:each | (each messages difference: SmalltalkSystem current allSelectors) notEmpty])
				isSlowToEnumerate: true;
				yourself)!

newNamed: aString withFilter: aMonadicValuable 
	^(self newNamed: aString)
		setFilter: aMonadicValuable;
		yourself!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	#('compilation failures' 'primitives') 
		do: [:each | self removePseud: self pseudPrefix , each]! !
!Tools.PluggableVirtualMethodCategory class categoriesFor: #initialize!initializing!private! !
!Tools.PluggableVirtualMethodCategory class categoriesFor: #newNamed:withFilter:!instance creation!public! !
!Tools.PluggableVirtualMethodCategory class categoriesFor: #uninitialize!class hierarchy-removing!private! !

