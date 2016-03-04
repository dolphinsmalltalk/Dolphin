"Filed out from Dolphin Smalltalk 7"!

Model subclass: #MethodSpyManager
	instanceVariableNames: 'areSpiesEnabled'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'current'!
MethodSpyManager guid: (GUID fromString: '{72E11082-3F59-11D6-87E5-0010A70883E2}')!
MethodSpyManager comment: ''!
!MethodSpyManager categoriesForClass!Unclassified! !
!MethodSpyManager methodsFor!

areSpiesEnabled

	"areSpiesEnabled stores a Boolean indicating whether all spies are enabled/disabled.
	areSpiesEnabled = false overrides a spy's isLocallyEnabled setting"

	^areSpiesEnabled!

areSpiesEnabled: aBoolean

	"areSpiesEnabled stores a Boolean indicating whether all spies are enabled/disabled.
	areSpiesEnabled = false overrides a spy's isLocallyEnabled setting setting"

	areSpiesEnabled := aBoolean.

	self onSpyChanged!

compileSpy: anSSWMethodSpy

	"return success"

	^[anSSWMethodSpy method recompileWithSpy: anSSWMethodSpy.
	true] 
		on: CompilerErrorNotification do:
			[ :exc | 
			MessageBox warning: 'Did not compile: ', exc description.
			exc return: false]

!

formatForSpy: aMethodSpy

	"Return the appropriate format for the given spy"

	| format |

	aMethodSpy isLocallyEnabled
		ifTrue: [format := SmalltalkSystem current methodSpyFormat]
		ifFalse: [format := SmalltalkSystem current disabledMethodSpyFormat].

	self areSpiesEnabled ifFalse: 
		[format := format copy. 
		format backColor: (format backColor fadedBy: 4)].

	^format!

initialize

	self areSpiesEnabled: true!

onSpiesCompiledIn: aCompiledMethod

	self trigger: #methodSpiesCompiledIn: with: aCompiledMethod!

onSpyChanged

	self trigger: #methodSpyChanged!

onSpyChangedIn: aCompiledMethod

	self trigger: #methodSpyChangedIn: with: aCompiledMethod!

removeSpy: anSSWMethodSpy

	anSSWMethodSpy method removeSpy: anSSWMethodSpy!

spiesCompiledIn: aCompilationResult

	| spyMethod |

	spyMethod := aCompilationResult method.

	SmalltalkSystem current onMethodTransparentlyUpdated: aCompilationResult.
	self onSpiesCompiledIn: spyMethod!

spyChanged

	self onMethodSpyChanged!

spyChangedIn: aCompiledMethod

	self onSpyChangedIn: aCompiledMethod!

toggleAreSpiesEnabled

	self areSpiesEnabled: self areSpiesEnabled not! !
!MethodSpyManager categoriesFor: #areSpiesEnabled!accessing!public! !
!MethodSpyManager categoriesFor: #areSpiesEnabled:!accessing!public! !
!MethodSpyManager categoriesFor: #compileSpy:!actions!public! !
!MethodSpyManager categoriesFor: #formatForSpy:!accessing!public! !
!MethodSpyManager categoriesFor: #initialize!initializing!public! !
!MethodSpyManager categoriesFor: #onSpiesCompiledIn:!event handling!public! !
!MethodSpyManager categoriesFor: #onSpyChanged!event handling!public! !
!MethodSpyManager categoriesFor: #onSpyChangedIn:!event handling!public! !
!MethodSpyManager categoriesFor: #removeSpy:!actions!public! !
!MethodSpyManager categoriesFor: #spiesCompiledIn:!operations!public! !
!MethodSpyManager categoriesFor: #spyChanged!operations!public! !
!MethodSpyManager categoriesFor: #spyChangedIn:!operations!public! !
!MethodSpyManager categoriesFor: #toggleAreSpiesEnabled!actions!public! !

!MethodSpyManager class methodsFor!

current

	"© 2002 Solutions Software

	current stores the singleton instance of the receiver"

	current isNil ifTrue: [current := super new initialize].

	^current!

publishedEventsOfInstances
	"Answer a <Set> of <Symbol>s, being the names of all events published 
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #methodSpiesCompiledIn:;
		add: #methodSpyChanged;
		add: #methodSpyChangedIn:;
		yourself!

resetCurrent

	"© 2002 Solutions Software

	Destroy the singleton instance (it will be lazily recreated on next use)"

	current := nil!

uninitialize

	self resetCurrent! !
!MethodSpyManager class categoriesFor: #current!accessing!public! !
!MethodSpyManager class categoriesFor: #publishedEventsOfInstances!public! !
!MethodSpyManager class categoriesFor: #resetCurrent!accessing!public! !
!MethodSpyManager class categoriesFor: #uninitialize!accessing!public! !

