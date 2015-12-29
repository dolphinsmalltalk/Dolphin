"Filed out from Dolphin Smalltalk X6.2"!

DeferredValue subclass: #ItcDeferredValue
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ItcDeferredValue guid: (GUID fromString: '{482A099A-03A8-4EE1-9999-330364D2C101}')!
ItcDeferredValue comment: ''!
!ItcDeferredValue categoriesForClass!Unclassified! !
!ItcDeferredValue methodsFor!

evaluate: operation withArguments: args at: priority 
	"Private - Answer a <niladicValuable> that begins evaluating the <valuable>, 
	operation with the <Array> of arguments, args, asynchronously at the specified 
	<integer> priority, and which when evaluated will synchronously supply the result. 
	This message must only be sent when the deferred value is first created.

	This overrides superclass implementation with copying of process's attributes into the forked thread."

	| newProcess activeProcess |
	self initialize.
	activeProcess := Processor activeProcess.
	newProcess := ItcSystemManager newProcessOn: 
					[[self setValue: (self _evaluate: operation withArguments: args)] 
						on: Error
						do: 
							[:e | 
							self exception: e.
							e pass]
						on: ProcessTermination
						do: 
							[:e | 
							self exception: ((Error new)
										tag: self;
										messageText: 'DeferredValue terminated prematurely')]]
				named: activeProcess itcProcessName , ' / deferred block'.
	activeProcess attributes keysAndValuesDo: 
			[:eachKey :eachValue | 
			"copy process's attributes (like session, application, ...) into new process's attributes"
			(#(#webApplication #webTask #webSession #webLanguage #webLanguageDict #webRequestCodePage #webRequest #webProcessingAjaxRequest #webHttpRequestDeadline) 
				includes: eachKey) ifTrue: [newProcess attributes at: eachKey put: eachValue]].
	newProcess attributes at: #webDeferredValueToSignalOnTerminate put: self.
	newProcess
		priority: priority;
		resume! !
!ItcDeferredValue categoriesFor: #evaluate:withArguments:at:!evaluating!private! !

