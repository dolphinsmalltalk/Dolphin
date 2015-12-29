"Filed out from Dolphin Smalltalk X6"!

CommandPolicy subclass: #LegacyCommandPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LegacyCommandPolicy guid: (GUID fromString: '{CD4F5C9F-18D7-4B31-94AF-4F76D1E56C08}')!
LegacyCommandPolicy comment: ''!
!LegacyCommandPolicy categoriesForClass!Unclassified! !
!LegacyCommandPolicy methodsFor!

queryCommand: query
	"Private - Enter details about a potential command into the <CommandQuery>, query.
	Typically this involves visiting each potential <commandTarget> on the
	chain-of-command.
	Implementation Note: Override the superclass behaviour to implement the pre
	Dolphin 4.0 command routing pattern, which did not include the command itself
	in the route."

	self commandPath do: [:each | 
		each queryCommand: query.
		query isEnabled ifTrue: [
			"If the accepting target has not specified the receiver, then default to it."
			query receiver isNil ifTrue: [query receiver: each]].
		"Early out if a receiver was found irrespective of whether the command is actually enabled."
		query receiver notNil ifTrue: [^query]].

	^query.

	
	!

visitPresenter: presenter
	"Visit the <presenter>, presenter, as the next in the chain-of-command, 
	adding its contributions to that chain. Answer the next <presenter> to visit,
	or answer the argument to get the default behaviour which is to move up
	to the parent presenter."

	self appendPresenter: presenter.
	^presenter! !
!LegacyCommandPolicy categoriesFor: #queryCommand:!operations!private! !
!LegacyCommandPolicy categoriesFor: #visitPresenter:!operations!private! !

