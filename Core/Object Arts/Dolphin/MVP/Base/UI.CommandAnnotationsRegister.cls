"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CommandAnnotationsRegister'
	instanceVariableNames: 'register'
	classVariableNames: 'Current'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.CommandAnnotationsRegister guid: (Core.GUID fromString: '{e5ddba4d-9de4-4c48-8dea-3931a5af109a}')!
UI.CommandAnnotationsRegister comment: ''!
!UI.CommandAnnotationsRegister methodsFor!

addAnnotationsFor: aClass
	^(aClass conformsToProtocol: #commandTarget)
		ifTrue: [register at: aClass put: (CommandAnnotations targetClass: aClass)]!

annotationsFor: aClass
	^(register lookup: aClass) ifNil: [self addAnnotationsFor: aClass]!

initialize
	register := IdentityDictionary new.
	Smalltalk
		when: #methodAdded:
			send: #onMethodAdded:
			to: self;
		when: #methodUpdated:
			send: #onMethodUpdated:
			to: self;
		when: #methodRemoved:
			send: #onMethodRemoved:
			to: self;
		when: #classRemoved:
			send: #onClassRemoved:
			to: self!

onClassRemoved: aClass
	"Private - The class aClass has been removed. Remove any associated CommandAnnotations."

	register removeKey: aClass ifAbsent: nil!

onMethodAdded: aCompilationResult
	(register lookup: aCompilationResult methodClass)
		ifNotNil: 
			[:annotations |
			"Any method addition, whether annotated or not, may have an impact on the command annotations. For example an override may be added that removes the inherited command query without adding a replacement."
			annotations onMethodAdded: aCompilationResult]!

onMethodRemoved: aCompiledMethod
	(register lookup: aCompiledMethod methodClass)
		ifNotNil: 
			[:annotations |
			"Any method removal, whether annotated or not, may have an impact on the command annotations. For example an override may be removed that was shadowing an inherited command query."
			annotations onMethodRemoved: aCompiledMethod]!

onMethodUpdated: aCompilationResult
	((register lookup: aCompilationResult methodClass)
		ifNil: 
			[aCompilationResult isInteractive ifTrue: [self addAnnotationsFor: aCompilationResult methodClass]])
			ifNotNil: 
				[:annotations |
				"Any method update, whether annotated or not, may have an impact on the command annotations. For example annotations may be removed."
				annotations onMethodUpdated: aCompilationResult]! !
!UI.CommandAnnotationsRegister categoriesForMethods!
addAnnotationsFor:!helpers!private! !
annotationsFor:!public! !
initialize!public! !
onClassRemoved:!event handling!private! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!private! !
onMethodUpdated:!event handling!private! !
!

!UI.CommandAnnotationsRegister class methodsFor!

initialize
	"Can be reset safely at any time, as will just rebuild."

	Current := self new initialize!

uninitialize
	Smalltalk removeEventsTriggeredFor: Current! !
!UI.CommandAnnotationsRegister class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
!

