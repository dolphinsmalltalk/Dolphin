"Filed out from Dolphin Smalltalk"!

Kernel.STBProxy
	subclass: #'UI.STBViewProxy'
	instanceVariableNames: 'viewClass instVars state placement subViews resolution events version'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
			'CreationParentIndex' -> 16r2.
			'CreationStyleIndex' -> 16r3.
			'EventsIndex' -> 16rB.
			'HandleIndex' -> 16r1
		}!
UI.STBViewProxy guid: (Core.GUID fromString: '{87b4c6f4-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.STBViewProxy comment: 'STBViewProxy is the class of <STBProxy> objects used to represent <View> instances in STB files.'!
!UI.STBViewProxy categoriesForClass!System-Binary storage! !
!UI.STBViewProxy methodsFor!

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

placement
	^placement!

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

restoreFromProxy: aView
	"This should never actually be sent to the receiver. The method is present because the semantic analyser thinks it is sent from #restoreView."

	^self shouldNotImplement!

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

	| newView |
	newView := viewClass basicNew.
	1 to: instVars size do: [:i | newView instVarAt: i put: (instVars at: i)].

	"Copy across any events which might have been registered during the restoration of parents"
	newView setEvents: self getEvents.

	"Switch this proxy for the View"
	self become: newView.

	"After this point self is actually the view."
	self restoreFromProxy: newView!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setView: aView
	"Initialize the receiver to represent aView.
	This is a case of storing the Smalltalk class of aView, an Array containing its instance variables,
	its state sequence, placement info and subViews."

	| size class |
	class := aView class.
	self viewClass: class.
	size := class instSize.
	instVars := Array new: size.
	1 to: size do: [:i | instVars at: i put: (aView instVarAt: i)].
	self state: aView state.
	aView isOpen
		ifTrue: 
			[placement := aView placement.
			subViews := aView subViews asArray.
			instVars at: HandleIndex put: nil].

	"We must not save the events."
	instVars at: EventsIndex put: nil.

	"Set the resolution at which the view is being saved."
	resolution := aView resolution!

state
	^state!

state: aMessageSequence
	state := aMessageSequence.
	state freeze!

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

subViews
	^subViews!

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

	viewClass := aClass.
	version := aClass stbVersion! !
!UI.STBViewProxy categoriesForMethods!
beTopView!accessing!public! !
clearSubViews!accessing!public! !
connectModel!models!public! !
getEvents!events!private! !
icon!accessing!private! !
instVars!accessing!public! !
instVars:!accessing!public! !
isTopView!accessing!private! !
nameOf:!accessing!public! !
parentView:!accessing!private! !
placement!accessing!public! !
printOn:!development!printing!public! !
resolution!accessing!private! !
resolution:!accessing!private! !
restoreFromProxy:!binary filing!private! !
restoreTopView!converting!private! !
restoreView!converting!private! !
setEvents:!events!private! !
setView:!accessing!public! !
state!accessing!public! !
state:!accessing!public! !
stbFixup:at:!converting!public! !
subViews!accessing!public! !
version!accessing!public! !
version:!accessing!public! !
viewClass!accessing!public! !
viewClass:!accessing!public! !
!

!UI.STBViewProxy class methodsFor!

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
	allInstVarNames := View allInstanceVariableNames.
	self
		addClassConstant: 'HandleIndex' value: (allInstVarNames indexOf: 'handle');
		addClassConstant: 'CreationParentIndex' value: (allInstVarNames indexOf: 'creationParent');
		addClassConstant: 'CreationStyleIndex' value: (allInstVarNames indexOf: 'creationStyle');
		addClassConstant: 'EventsIndex' value: (allInstVarNames indexOf: 'events')!

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
!UI.STBViewProxy class categoriesForMethods!
forView:!instance creation!public! !
initialize!development!initializing!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

