"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.CommandPolicy'
	instanceVariableNames: 'source path'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.CommandPolicy guid: (Core.GUID fromString: '{87b4c46a-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.CommandPolicy isNonInstantiable: true!
UI.CommandPolicy comment: 'A CommandPolicy determines how a user interface command is routed from its source (menu, toolbar button or pushbutton) to the eventual target that will be responsible for actually performing the command. A route consists of a sequence of potential command targets which in the standard MVP environment are usually (but not essentially) view, presenters or models. 

The CommandPolicy in use creates a CommandQuery object and use this to discover whether a command can successfully be performed by any of the potential targets. This is done in #query:. The end result will be a CommandQuery that is bound to a target object and filled in appropriately with information such as whether the command should be considered to be enable, checked, etc. This information is used to determine the state of menu items and toolbar buttons. Since the CommandQuery is bound to a target that is known to be able to accept the command, this can then be performed directly.

The MVP framework creates an instance of CommandPolicy each time it wishes to either determine the status of a command, in order to update the user interface representation of that command, or when the command is to be performed. This class routes from a starting view through its presenter and model. The route then continues with the same sequence moving up the view''s parent chain. If you wish to change the routing policy for a specific view then override #commandPolicy in the particular view class to answer an instance of a different CommandPolicy subclass. New CommandPolicy subclasses will need to override the #routeFrom: method to define their routing policy.

Note: In versions of Dolphin prior to the 3.0 release this class was a singleton. This proved to be inefficient as the system became more sophisticated - in particular the automatic idle time revalidation of toolbars, etc, was causing the route to be regenerated once for every toolbar button.

Instance Variables:
	source		<View> origin of the commands to be routed.
	path		<OrderedCollection> of <commandTarget>. The route built by #routeFrom:.






'!
!UI.CommandPolicy categoriesForClass!MVP-Commands! !
!UI.CommandPolicy methodsFor!

appendPresenter: presenter
	"Append the <presenter>, presenter, to the current command path in the standard 
	way, i.e. also add in the presenter's view, and its model if it is a <commandTarget>. 
	Answer the next <presenter> to visit."

	| model |
	self appendTarget: presenter.
	presenter hasView ifTrue: [self appendTarget: presenter view].
	model := presenter model.
	"Note: We only include the model if it conforms to the <commandTarget> protocol"
	(model class conformsToProtocol: #commandTarget)
		ifTrue: [self appendTarget: model].
	^presenter parentPresenter!

appendTarget: aCommandTarget
	"Append the <commandTarget> argument to the existing chain-of-command if not already present. Answers the target if it was appended, or nil if already in the path. This can be used by the presenter answering the command policy to amend the default routing by appending new command targets. Note that the new target will not be appended if already present in the path."

	| cofc |
	cofc := self commandPath.
	^(cofc identityIncludes: aCommandTarget)
		ifFalse: [cofc addLast: aCommandTarget]		!

commandPath
	"Answer an <OrderedCollection> of <commandTarget>s which is the chain-of-command
	(i.e. the path along which commands are routed) used by the receiver for querying and 
	performing commands."

	^path!

commandQueryClass
	"Answer the class of <CommandQuery> to use for querying the status of commands."

	^CommandQuery!

includesTarget: aCommandTarget
	"Append whether the receiver's path already includes the specified <commandTarget>."

	^self commandPath identityIncludes: aCommandTarget!

insertTarget: newTarget after: existingTarget
	"Insert the <commandTarget>, newTarget, into the existing chain-of-command 
	immediately after the <commandTarget>, existingTarget, shuffling any subsequent
	<commandTarget>s up one position. The target is not inserted if it already exists
	in the path at an earlier position, and is moved if already at a later position.
	Answers the target if it was added, or nil if already in the path."

	| existingIdx cofc |
	cofc := self commandPath.
	existingIdx := cofc identityIndexOf: existingTarget ifAbsent: [cofc size - 1].
	^self insertTarget: newTarget atIndex: existingIdx + 1!

insertTarget: target atIndex: index
	"Insert the <commandTarget>, target, into the existing chain-of-command 
	at the position identified by the <integer>, index, shuffling any subsequent
	<commandTarget>s up one. The target is not inserted if it already exists
	in the path at an earlier position, and is moved if already at a later position.
	Answers the target if it was added, or nil if already in the path."

	| idx cofc |
	cofc := self commandPath.
	^(idx := cofc identityIndexOf: target) == 0
		ifTrue: [cofc add: target beforeIndex: index]
		ifFalse: [
			index < idx ifTrue: [
				cofc removeAtIndex: idx.
				cofc add: target beforeIndex: index]]!

insertTarget: newTarget before: existingTarget
	"Insert the <commandTarget>, newTarget, into the existing chain-of-command 
	immediately before the <commandTarget>, existingTarget, shuffling any subsequent
	<commandTarget>s up one position. The target is not inserted if it already exists
	in the path at an earlier position, and is moved if already at a later position.
	Answers the target if it was added, or nil if already in the path."

	| existingIdx cofc |
	cofc := self commandPath.
	existingIdx := cofc identityIndexOf: existingTarget ifAbsent: [cofc size].
	^self insertTarget: newTarget atIndex: existingIdx!

newCommandQuery: action
	"Answer a new <CommandQuery> for the <commandDescription>, action, 
	originating in the receiver's source <View>."

	^self commandQueryClass
		commandDescription: action 
		source: self source!

prependTarget: target
	"Prepend the <commandTarget>, target, to the existing chain-of-command. If the target is already present in the chain, then it is moved from its existing position to the start of the chain. Answer the target.
	This can be used by the presenter answering the command policy to amend the default routing by inserting new command targets at its start."

	| idx cofc |
	cofc := self commandPath.
	(idx := cofc identityIndexOf: target) ~= 0 ifTrue: [cofc removeAtIndex: idx].
	cofc addFirst: target.
	^target!

query: action
	"Query the route of the <commandDescription>, action, starting from the 
	receiver's command source <View>, and answer an instance of <CommandQuery>
	that describes the enablement state of the command and a potential receiver.
	This is the command querying policy used in versions of Dolphin prior to 4.0, and
	it does not include the command itself as the first potential target."

	| query |
	query := self newCommandQuery: action.
	self queryCommand: query.
	^query.

	
	!

queryCommand: query
	"Private - Enter details about a potential command into the <CommandQuery>, query.
	Typically this involves visiting each potential <commandTarget> on the
	chain-of-command."

	"First ask the commandDescription itself in case it is configured for a static target"

	self queryCommand: query ofTarget: query commandDescription.
	query receiver
		ifNil: 
			["Dynamically target command, query at each potential target."
			self commandPath do: 
					[:each |
					self queryCommand: query ofTarget: each.
					"Early out if a receiver was found irrespective of whether the command is actually enabled."
					query receiver ifNotNil: [^query]]].
	^query!

queryCommand: aCommandQuery ofTarget: aCommandTarget
	"Private - Ask the <commandTarget> argument if it is prepared to accept the command
	described in the <CommandQuery> argument."

	aCommandTarget queryCommand: aCommandQuery.
	aCommandQuery isEnabled
		ifTrue: 
			["If the accepting target has not specified the receiver, then default to it."
			aCommandQuery receiver ifNil: [aCommandQuery receiver: aCommandTarget]]!

route: aCommandDescription
	"Routes the <CommandDescription>, action, along the receiver's route from
	its command source, and, if enabled, execute it.
	The command was originally generated by the receiver's command source."

	| query |
	query := self query: aCommandDescription.
	query canPerform ifTrue: [query perform] ifFalse: [User32 messageBeep: 0].
	^0	"Suppress default processing"!

routeFrom: sourceView
	"Build and answer an <OrderedCollection> of <commandTarget>s which constitues the path via
	which commands should be routed that originate from the <View> argument.
	The policy implemented here walks up the chain of presenters from the presenter of 
	the <View>, sourceView, at each stage appending the presenter followed the by the view itself, 
	and lastly the model if it is a <commandTarget>."

	| presenter |
	path := OrderedCollection new: 12.
	presenter := sourceView presenter.
	[presenter notNil and: [presenter ~= DeafObject current]] whileTrue: 
			[| next |
			"A common mistake is to forget to answer the next presenter to visit, so move up to the parent by default
		 to avoid entering an infinite loop."
			next := self visitPresenter: presenter.
			presenter := next == presenter ifTrue: [presenter parentPresenter] ifFalse: [next]].
	^path!

source
	"Private - Answer a <View> which is the original command source."

	^source!

source: sourceView
	"Private - Set the original command source to the <View> argument, sourceView."

	source := sourceView.
	path := self routeFrom: source!

visitPresenter: presenter
	"Private - Visit the <presenter>, presenter, as the next in the chain-of-command, 
	adding its contributions to that chain. Answer the next <presenter> to visit."

	^self subclassResponsibility! !
!UI.CommandPolicy categoriesForMethods!
appendPresenter:!adding!public! !
appendTarget:!adding!public! !
commandPath!accessing!public! !
commandQueryClass!constants!public! !
includesTarget:!adding!public! !
insertTarget:after:!adding!public! !
insertTarget:atIndex:!adding!public! !
insertTarget:before:!adding!public! !
newCommandQuery:!helpers!public! !
prependTarget:!adding!public! !
query:!operations!public! !
queryCommand:!operations!private! !
queryCommand:ofTarget:!operations!private! !
route:!operations!public! !
routeFrom:!operations!public! !
source!accessing!private! !
source:!initializing!private! !
visitPresenter:!operations!private! !
!

UI.CommandPolicy methodProtocol: #commandPolicy attributes: #(#readOnly) selectors: #(#query: #route:)!

!UI.CommandPolicy class methodsFor!

commandSource: sourceView
	"Answer a new instance of the receiver for routing commands
	from the <View>, source."

	^super new
		source: sourceView;
		yourself!

defaultClass
	"Answer the subclass used by default for command routing."

	^DelegatingCommandPolicy!

new
	"Instances of the receiver should be created using the #commandSource: message."

	^self shouldNotImplement! !
!UI.CommandPolicy class categoriesForMethods!
commandSource:!instance creation!public! !
defaultClass!constants!public! !
new!instance creation!public! !
!

UI.CommandPolicy class methodProtocol: #'commandPolicy factory' attributes: #(#readOnly) selectors: #(#commandSource:)!

