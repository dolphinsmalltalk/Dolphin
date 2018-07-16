"Filed out from Dolphin Smalltalk 7"!

STBProxy subclass: #STBViewProxy
	instanceVariableNames: 'viewClass instVars state placement subViews resolution events version'
	classVariableNames: 'CreationParentIndex CreationStyleIndex EventsIndex HandleIndex'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
STBViewProxy guid: (GUID fromString: '{87b4c6f4-026e-11d3-9fd7-00a0cc3e4a32}')!
STBViewProxy comment: 'STBViewProxy is the class of <STBProxy> objects used to represent <View> instances in STB files.'!
!STBViewProxy categoriesForClass!System-Binary storage! !
!STBViewProxy methodsFor!

beNotChild
	"Ensure that the receiver's represented object does not have the WS_CHILD style.
	The main user of this will be the ViewComposer which sets the WS_CHILD style
	of Shells in order to edit them."

	| styleArray style |
	styleArray := instVars at: CreationStyleIndex.
	style := styleArray at: 1.
	(style allMask: WS_CHILD) ifFalse: [^self].
	style := style maskClear: WS_CHILD.
	instVars at: CreationStyleIndex put: {style. styleArray at: 2}!

beTopView
	"Make the receiver's represented object appear as a top view, ie. one with an unspecified parent.
	This will be detected on input and it will be assigned the parent stored in the STBInFiler context."

	instVars at: CreationParentIndex put: nil!

clearSubViews
	"Set the receiver's subViews inst var to an empty collection. i.e. don't save the children of the
	represented view."

	subViews := #()!

connectModel
	"This method is mainly present to shut up the Code Mentor, since although it is a self send,
	it it will be sent to the receiver's other self after a #become:, and consequently it is not
	really an unimplemented message."

	^self error: 'Not yet realized'!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

icon
	"Private - Answers the icon for the view held by this proxy"

	^viewClass icon!

instVars
	"Answer the <Array> of instance variables held on behalf of the saved view instance."

	^instVars!

instVars: anArray
	"Set the <Array> of instance variables held on behalf of the saved view instance."

	instVars := anArray!

isTopView
	"Private - Answer whether the receiver represents a top view, ie. one with an unspecified parent."

	^(instVars at: CreationParentIndex) isNil!

nameOf: aView
	^nil!

parentView: aView
	"Private - This method is mainly present to shut up the Code Mentor, since although it is a self send,
	it it will be sent to the receiver's other self after a #become:, and consequently it is not
	really an unimplemented message."

	^self error: 'Not yet realized'!

printOn: aStream
	"Append a debugging description of the receiver to aStream."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: viewClass;
		nextPut: $@;
		print: version;
"		space;
		print: array;
"		nextPut: $)!

resolution
	"Private - Answer the logical pixels/inch at which the receiver is saved."

	^resolution!

resolution: anInteger
	"Private - Set the logical pixels/inch at which the receiver was saved to be anInteger."

	resolution := anInteger!

restoreTopView
	"Private - Mutate the hierarchy of proxies below the receiver into real Views.
	Since this is the top of the hierarchy we must inform the context in which this
	hierarchy is being realized that it has a new subview"

	| topView |
	topView := self restoreView.
	topView parentView onSubViewAdded: topView.!

restoreView
	"Private - Mutate the hierarchy of proxies below the receiver into real Views.
	Apply the receiver's state sequence, then recursively call this method for any
	subViews and then apply the receiver's placement."

	| newView stateTemp placementTemp resolutionTemp subViewsTemp |
	stateTemp := self state.

	"Get the window placement as saved. If the resolution of the saved view
	is not equal to the current desktop resolution then we must scale the 
	placement rectangle appropriately"
	placementTemp := placement.
	resolutionTemp := self resolution.
	subViewsTemp := subViews.

	"Create and populate the view object"
	newView := viewClass basicNew.
	1 to: instVars size do: [:i | newView instVarAt: i put: (instVars at: i)].

	"Copy across any events which might have been registered during the restoration of parents"
	newView setEvents: self getEvents.

	"Switch this proxy for the View"
	self become: newView.

	"After this point we cannot reference any instance variables, as 'self' is now the restored
	View instance and the Compiler thought it was compiling  this method for STBViewProxy, 
	not some View!!"

	"The creationParent is already set, but we set it again here
	to so that #parentView: can set the WS_CHILD style appropriately."
	self parentView: self creationParentView.
	self isStateRestoring: true.
	self state: stateTemp.
	subViewsTemp do: [:proxy | proxy restoreView].
	placementTemp notNil 
		ifTrue: [self restorePlacement: placementTemp resolution: resolutionTemp].
	self isStateRestoring: false.

	"The STB mechanism does not save and restore event triggers.
	We must cause these to be rebuilt here"
	self connectModel.

	"In some situations (notably when restoring a ReferenceView for example) it may be that nothing has
	yet caused the view to be realized. We do this here by forcing an access to its window handle. #57"
	self handle!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setView: aView
	"Initialize the receiver to represent aView.
	This is a case of storing the Smalltalk class of aView, an Array containing its instance variables,
	its state sequence, placement info and subViews."

	viewClass := aView class.
	version := viewClass stbVersion.
	instVars := Array new: viewClass instSize.
	1 to: instVars size do: [:i | instVars at: i put: (aView instVarAt: i)].
	self state: aView state.
	aView isOpen 
		ifTrue: 
			[placement := aView placement.
			subViews := aView subViews asArray.
			instVars at: HandleIndex put: nil].

	"We must not save the events."
	instVars at: EventsIndex put: nil.

	"Set the resolution at which the view is being saved."
	self resolution: aView resolution!

state
	^state!

state: aMessageSequence
	state := aMessageSequence!

stbFixup: inFiler at: anInteger
	"We can't answer the real object at this stage as it is difficult to restore the
	window hierarchy. So, for the moment, we content ourselves with ensuring that we
	represent the view hierarchy by a complete set of proxies.
	Note that individual View class STB conversions may need to be performed at this
	point."

	version == viewClass stbVersion ifFalse: [ "The View's individual class version has changed"
		"Transcript print: self; nextPutAll: ': upgrading from version '; print: version; nextPutAll: ' to: '; print: viewClass stbVersion; cr."
		viewClass stbVersion < 9 ifTrue: [self error: 'View STB versions must start at 9, not ', viewClass stbVersion printString].
		"The #stbConvertProxy: method can replace inst. vars, and even the viewClass"
		viewClass stbConvertProxy: self].

	"For top shells we also defer a send of the receiver's #restoreView method. 
	A top view is one with a nil 'creationParent' array entry. The actual parent
	to use is answered by inFiler #context."
	self isTopView ifTrue: [
		instVars at: CreationParentIndex put: inFiler context.
		inFiler deferAction: [self restoreTopView]].

	^self!

version
	"Answer an <integer> which is the STB version of the class of the view for which 
	the receiver is a proxy."

	^version!

version: viewVersion
	"Set the STB version of the class of the view for which the receiver is a proxy
	to the <integer>, viewVersion"

	version := viewVersion!

viewClass
	"Answer the class of <View> of which the receiver is representing an instance."

	^viewClass!

viewClass: aClass
	"Set the class of <View> of which the receiver is representing an instance."

	viewClass := aClass! !
!STBViewProxy categoriesFor: #beNotChild!accessing!public! !
!STBViewProxy categoriesFor: #beTopView!accessing!public! !
!STBViewProxy categoriesFor: #clearSubViews!accessing!public! !
!STBViewProxy categoriesFor: #connectModel!models!public! !
!STBViewProxy categoriesFor: #getEvents!events!private! !
!STBViewProxy categoriesFor: #icon!accessing!private! !
!STBViewProxy categoriesFor: #instVars!accessing!public! !
!STBViewProxy categoriesFor: #instVars:!accessing!public! !
!STBViewProxy categoriesFor: #isTopView!accessing!private! !
!STBViewProxy categoriesFor: #nameOf:!accessing!public! !
!STBViewProxy categoriesFor: #parentView:!accessing!private! !
!STBViewProxy categoriesFor: #printOn:!development!printing!public! !
!STBViewProxy categoriesFor: #resolution!accessing!private! !
!STBViewProxy categoriesFor: #resolution:!accessing!private! !
!STBViewProxy categoriesFor: #restoreTopView!converting!private! !
!STBViewProxy categoriesFor: #restoreView!converting!private! !
!STBViewProxy categoriesFor: #setEvents:!events!private! !
!STBViewProxy categoriesFor: #setView:!accessing!public! !
!STBViewProxy categoriesFor: #state!accessing!private! !
!STBViewProxy categoriesFor: #state:!accessing!development!private! !
!STBViewProxy categoriesFor: #stbFixup:at:!converting!public! !
!STBViewProxy categoriesFor: #version!accessing!public! !
!STBViewProxy categoriesFor: #version:!accessing!public! !
!STBViewProxy categoriesFor: #viewClass!accessing!public! !
!STBViewProxy categoriesFor: #viewClass:!accessing!public! !

!STBViewProxy class methodsFor!

forView: aView 
	"Answer a new instance representing aView."

	^(self basicNew)
		setView: aView;
		yourself!

initialize
	"Initialize the receiver's class variables.
	N.B. This must be reinitialized if View or any subclasses have new instance variables
	added, in case the inst. var. indices are changed.

		STBViewProxy initialize.
	"

	| allInstVarNames |
	allInstVarNames := View allInstVarNames.
	HandleIndex := allInstVarNames indexOf: 'handle'.
	CreationParentIndex := allInstVarNames indexOf: 'creationParent'.
	CreationStyleIndex := allInstVarNames indexOf: 'creationStyle'.
	EventsIndex := allInstVarNames indexOf: 'events'
!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version view proxies.
	Note that as of Dolphin 4.0 upgrading of old View resources is handled by the View
	classes themselves. In future this method should only be modified for genuine
	upgrades to STBViewProxy, not for upgrades to individual view classes."

	^[:data | | ver viewProxy |
		ver := anSTBClassFormat version.

		"Finally, generate a new viewProxy and fill with data"
		viewProxy := self basicNew.
		1 to: data size do: [:i | viewProxy instVarAt: i put: (data at: i)].

		"Perform the version 6 to 7 conversion last as this affects only the proxy itself."
		ver < 7 ifTrue: [viewProxy resolution: 96@96].

		"As of version 10 we no longer attempt to maintain a single STB version for all view classes
		 (i.e. that of the proxy), because this is difficult for a user to maintain and will clash with base
		 system changes. In the case of older versions we assign over the common (proxy) version, and 
		 code to upgrade from these versions is implemented in View class>>stbConvert:from:)."
		ver < 10 ifTrue: [viewProxy version: ver].

		viewProxy]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.

	1: 	Add largeIcon and smallIcon instance variables to ShellViews and subclasses
	2:	 Map command->commandDescription for PushButtons
	3: 	Add iconSpacing to ListView and subclasses.
	4: 	Add getInfoTipBlock instance variable to IconicListAbstract and subclasses
	5: 	Add maxExtent and minExtent instance variables to ShellView and subclasses
	6: 	Add lvStyle inst. var. to ListView
	7: 	Add resolution instance variable
	8: 	Add events and unused instance variable to View, and events inst. var. to proxy.
	9: 	ShellView defaultButton <PushButton> changed to defaultButtonId <integer>.
	10: 	version instance variable added to record STB version of specific view class."

	"STBViewProxy should no longer need to be changed to upgrade view classes,
	 so if you are changing this number, THINK AGAIN."

	^10! !
!STBViewProxy class categoriesFor: #forView:!instance creation!public! !
!STBViewProxy class categoriesFor: #initialize!development!initializing!public! !
!STBViewProxy class categoriesFor: #stbConvertFrom:!binary filing!public! !
!STBViewProxy class categoriesFor: #stbVersion!binary filing!public! !

