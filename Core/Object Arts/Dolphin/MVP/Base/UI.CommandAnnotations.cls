"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CommandAnnotations'
	instanceVariableNames: 'targetClass commandQueries menuPopulators accelerators acceleratorKeys'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.CommandAnnotations guid: (Core.GUID fromString: '{615757db-92fd-4ed3-a799-60dc5fecf8dc}')!

UI.CommandAnnotations comment: ''!

!UI.CommandAnnotations methodsFor!

acceleratorKeys
	^acceleratorKeys
		ifNil: 
			[| stream |
			stream := Array writeStream: self accelerators size.
			accelerators
				keysAndValuesDo: [:selector :keyStrings | keyStrings do: [:each | stream nextPut: { selector. each }]].
			acceleratorKeys := stream grabContents]!

accelerators
	^accelerators ifNil: [accelerators := self findAcceleratorKeys]!

commandQueries
	^commandQueries ifNil: [commandQueries := self findCommandQueries]!

commandQueryFromAnnotation: aSymbol
	"Private - Answer a <dyadicValuable> that can be evaluated to perform the command query with the specified selector against the target class. The command query selectors can be unary, in which case the expectation is that the performed method is a testing method that will answer a <boolean> enablement status for the command, or can be a one-argument selector. Command queries that expect an argument are passed a <CommandQuery> object, and can update the enablement, checked status, and even change the text or image that will be displayed on a menu (where relevant). If the command query selector is invalid (more than 1 argument, or not understood), then the valuable will just disable the command."

	(targetClass canUnderstand: aSymbol)
		ifTrue: 
			[| argc |
			argc := aSymbol argumentCount.
			argc == 1 ifTrue: [^Message selector: aSymbol arguments: #('placeholder for aCommandQuery')].
			argc == 0 ifTrue: [^[:rcvr :query | query isEnabled: (rcvr perform: aSymbol)]]].
	Notification signal: 'Ignoring invalid command query selector #' , aSymbol.
	^
	[:rcvr :query |
	"Explicitly disable any command with an invalid or missing query. Prevent it from routing further by setting the receiver"
	query
		beDisabled;
		receiver: rcvr]!

findAcceleratorKeys
	| map |
	map := self superAnnotations
				ifNotNil: [:superRegister | superRegister accelerators copy]
				ifNil: [IdentityDictionary new].
	targetClass methodsDo: 
			[:each |
			(each hasAnnotation: #acceleratorKey:)
				ifTrue: 
					[| keyStrings |
					keyStrings := Array writeStream: 1.
					each annotations withSelector: #acceleratorKey:
						do: [:args | keyStrings nextPut: (AcceleratorTable canonicalizeKeyString: args first)].
					map at: each selector put: keyStrings grabContents]
				ifFalse: 
					["If we've inherited any accelerator keys for a command but none are defined in the target class method, we remove the inherited key(s)"
					map at: each selector put: #()]].
	^map!

findCommandQueries
	"Private - Find all the command query annotations in receiver's target <Class>, and use them to build a map between command symbols (the selectors of the annotated methods), and selectors to perform to run the command query. Any command queries in defined in <commandTarget> superclasses of the target class can be inherited, but following the normal inheritance rules a local annotation for the same command will be used instead, though command query methods can supersend if desired."

	| queries |
	queries := self superAnnotations
				ifNotNil: [:superRegister | superRegister commandQueries copy]
				ifNil: [IdentityDictionary new].
	targetClass methodsDo: 
			[:eachMethod |
			| selector |
			selector := eachMethod selector.
			(eachMethod hasAnnotation: #commandQuery:)
				ifTrue: 
					["If there is more than one #commandQuery: annotation, the last will win"
					eachMethod annotations withSelector: #commandQuery:
						do: [:annotationArgs | queries at: selector put: (self commandQueryFromAnnotation: annotationArgs first)]]
				ifFalse: 
					["If we've inherited a command query but none is defined in an overriding target class method, replace with an enabler since default behaviour is to enable queryless commands"
					(queries includesKey: selector)
						ifTrue: [queries at: selector put: [:rcvr :query | query beEnabled]]]].
	^queries!

findMenuPopulators
	"Private - Find all the menu populator annotations in the receiver's target class, and use them to build a map between menu names, and selectors to perform to populate the named menu. Menu populators expect to be passed a <Menu> object as their argument, and can then populate the menu with dynamic content."

	| populators |
	populators := self superAnnotations
				ifNotNil: 
					[:superRegister |
					"Inherit superclass populators, although there may be local method annotations that supercede these"
					superRegister menuPopulators copy]
				ifNil: [IdentityDictionary new].
	targetClass methodsDo: 
			[:eachMethod |
			| selector |
			selector := eachMethod selector.
			(eachMethod hasAnnotation: #menuPopulator:)
				ifTrue: 
					[eachMethod annotations withSelector: #menuPopulator:
						do: 
							[:annotationArgs |
							| populator |
							populator := annotationArgs first.
							(populator argumentCount == 1 and: [targetClass canUnderstand: populator])
								ifFalse: 
									[Notification signal: 'Ignoring invalid menu populator selector #' , populator.
									populator := nil].
							populators at: selector put: populator]]
				ifFalse: 
					["If we've inherited a populator but none is defined in the target class method, replace with a null populator"
					(populators includesKey: selector) ifTrue: [populators at: selector put: nil]]].
	^populators!

menuPopulators
	^menuPopulators ifNil: [menuPopulators := self findMenuPopulators]!

onAboutToDisplayMenu: aMenu for: aCommandTarget
	"The pop-up <Menu>, aMenu, is about to be displayed on behalf of the <commandTarget>, aCommandTarget. This is our opportunity to rebuild or update it by running any menu populator that the receiver's target class declares for the menu. Answer whether the menu was populated. Note: Adding an item persists as the menu is not destroyed until the owning view is closed."

	^(self menuPopulators lookup: aMenu name)
		ifNil: [false]
		ifNotNil: 
			[:selector |
			aCommandTarget perform: selector with: aMenu.
			true]!

onMethodAdded: aCompilationResult
	^self onMethodUpdated: aCompilationResult!

onMethodRemoved: aCompiledMethod
	"Private - When a method is removed, we only need to react if we previously collected annotations associated with that selector."

	| selector |
	selector := aCompiledMethod selector.
	(commandQueries notNil and: [commandQueries includesKey: selector])
		ifTrue: [self resetQueryHandlers].
	(menuPopulators notNil and: [menuPopulators includesKey: selector])
		ifTrue: [self resetMenuPopulators].
	(accelerators notNil and: [accelerators includesKey: selector]) ifTrue: [self resetAcceleratorKeys]!

onMethodUpdated: aCompilationResult
	(((aCompilationResult affectsAnnotation: #commandQuery:) and: 
			[self validateQueriesIn: aCompilationResult.
			true])
		or: [commandQueries notNil and: [commandQueries includesKey: aCompilationResult selector]])
			ifTrue: [self resetQueryHandlers].
	(((aCompilationResult affectsAnnotation: #menuPopulator:) and: 
			[self validateMenuPopulatorsIn: aCompilationResult.
			true])
		or: [menuPopulators notNil and: [menuPopulators includesKey: aCompilationResult selector]])
			ifTrue: [self resetMenuPopulators].
	((aCompilationResult affectsAnnotation: #acceleratorKey:)
		or: [accelerators notNil and: [accelerators includesKey: aCompilationResult selector]])
			ifTrue: [self resetAcceleratorKeys]!

queryCommand: aCommandQuery ofTarget: aCommandTarget
	| command |
	command := aCommandQuery commandSymbol.
	(self commandQueries lookup: command)
		ifNotNil: 
			[:handler |
			"Unless the handler specifically returns false, assume the command query was handled and terminate the search"
			(handler value: aCommandTarget value: aCommandQuery) == false ifFalse: [^true]].
	^false!

resetAcceleratorKeys
	accelerators := acceleratorKeys := nil.
	targetClass
		subclassesDo: [:each | (CommandAnnotationsRegister.Current annotationsFor: each) resetAcceleratorKeys]!

resetMenuPopulators
	menuPopulators := nil.
	targetClass
		subclassesDo: [:each | (CommandAnnotationsRegister.Current annotationsFor: each) resetMenuPopulators]!

resetQueryHandlers
	commandQueries := nil.
	targetClass
		subclassesDo: [:each | (CommandAnnotationsRegister.Current annotationsFor: each) resetQueryHandlers]!

superAnnotations
	^targetClass superclass
		ifNotNil: [:superc | CommandAnnotationsRegister.Current annotationsFor: superc]!

targetClass: aClass
	targetClass := aClass!

validateMenuPopulatorsIn: aCompilationResult
	"Private - Validate the populateMenu: annotations in the <CompilationResult>, warning of any issues found."

	| method isInteractive |
	method := aCompilationResult method.
	(method notNil and: [method hasAnnotation: #menuPopulator:]) ifFalse: [^self].
	isInteractive := aCompilationResult isInteractive.
	method annotations withSelector: #menuPopulator:
		do: 
			[:each |
			| argc selector |
			selector := each single.
			argc := selector argumentCount.
			argc ~~ 1
				ifTrue: 
					[SessionManager current
						warning: 'Menu populator selectors must have exactly 1 argument, not the <2d> of <1p>'
								<< { selector. argc }.
					self]
				ifFalse: 
					[(isInteractive not or: [targetClass canUnderstand: selector])
						ifFalse: 
							[SessionManager current
								warning: '<1p> does not understand the proposed menu populator selector <2p>, so it will be ignored'
										<< { targetClass. selector }.
							self]]]!

validateQueriesIn: aCompilationResult
	"Private - Validate the commandQuery: annotations in the <CompilationResult> argument, issuing appropriate warnings."

	| method isInteractive |
	method := aCompilationResult method.
	(method notNil and: [method hasAnnotation: #commandQuery:]) ifFalse: [^self].
	isInteractive := aCompilationResult isInteractive.
	method annotations withSelector: #commandQuery:
		do: 
			[:each |
			| argc selector |
			selector := each single.
			argc := selector argumentCount.
			argc > 1
				ifTrue: 
					[SessionManager current
						warning: 'Command query selectors must have at most 1 argument, not the <2d> of <1p>. The invalid query will be ignored.'
								<< { selector. argc }.
					self]
				ifFalse: 
					[(isInteractive not or: [targetClass canUnderstand: selector])
						ifFalse: 
							[SessionManager current
								warning: '<1p> does not understand the selector <2p>, so the command query will not be registered.'
										<< { targetClass. selector }.
							self]]]! !

!UI.CommandAnnotations categoriesForMethods!
acceleratorKeys!accessing!public! !
accelerators!public! !
commandQueries!accessing!public! !
commandQueryFromAnnotation:!helpers!private! !
findAcceleratorKeys!helpers!private! !
findCommandQueries!helpers!private! !
findMenuPopulators!helpers!private! !
menuPopulators!accessing!public! !
onAboutToDisplayMenu:for:!commands-menus!public! !
onMethodAdded:!event handling!private! !
onMethodRemoved:!event handling!private! !
onMethodUpdated:!event handling!private! !
queryCommand:ofTarget:!commands-queries!public! !
resetAcceleratorKeys!helpers!private! !
resetMenuPopulators!helpers!private! !
resetQueryHandlers!helpers!private! !
superAnnotations!helpers!private! !
targetClass:!initializing!private! !
validateMenuPopulatorsIn:!helpers!private! !
validateQueriesIn:!helpers!private! !
!

!UI.CommandAnnotations class methodsFor!

targetClass: aClass
	^self new targetClass: aClass! !

!UI.CommandAnnotations class categoriesForMethods!
targetClass:!public! !
!

