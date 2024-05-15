"Filed out from Dolphin Smalltalk"!

Kernel.STxProxy
	subclass: #'UI.STBViewProxy'
	instanceVariableNames: 'viewClass instVars state showCmd subViews resolution events version'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
			'CreationParentIndex' -> 16r2.
			'EventsIndex' -> 16rB.
			'FlagsIndex' -> 16r8.
			'HandleIndex' -> 16r1
		}!

UI.STBViewProxy guid: (Core.GUID fromString: '{87b4c6f4-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.STBViewProxy comment: '`STBViewProxy` is the class of `STXProxy` objects used to represent `View` instances in STB/STL object streams.'!

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
			[showCmd := aView placement showCmd.
			subViews := aView subViews.
			instVars at: HandleIndex put: nil].

	"Clear transient flags"
	instVars at: FlagsIndex
		put: ((instVars at: FlagsIndex) bitAnd: ##((View.UIValidMask bitOr: View.LayoutValidMask) bitInvert)).

	"We must not save the events."
	instVars at: EventsIndex put: nil.

	"Set the resolution at which the view is being saved."
	resolution := aView resolution!

showCmd
	^showCmd!

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

subViews: aSequenceableCollection
	subViews := aSequenceableCollection!

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
printOn:!development!printing!public! !
resolution!accessing!private! !
resolution:!accessing!private! !
restoreFromProxy:!binary filing!private! !
restoreTopView!converting!private! !
restoreView!converting!private! !
setEvents:!events!private! !
setView:!accessing!public! !
showCmd!accessing!public! !
state!accessing!public! !
state:!accessing!public! !
stbFixup:at:!converting!public! !
subViews!accessing!public! !
subViews:!accessing!public! !
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
		addClassConstant: 'EventsIndex' value: (allInstVarNames indexOf: 'events');
		addClassConstant: 'FlagsIndex' value: (allInstVarNames indexOf: 'flags')!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version view proxies.
	Note that from Dolphin 4.0 (circa 2000), version 10, responsibility for upgrading of old View resources was transferred to the View classes themselves. This method should only be modified for genuine upgrades to STBViewProxy, not for upgrades to individual view classes. Conversion of the proxy inst var arrays is now handled by View class>>#stbConvert:from:"

	| ver |
	ver := anSTBClassFormat version.
	ver < 7
		ifTrue: 
			[^
			[:data |
			(data resize: 8)
				at: 4 put: ((data at: 4) ifNotNil: [:placement | placement showCmd]);
				at: 6 put: ##(USER_DEFAULT_SCREEN_DPI @ USER_DEFAULT_SCREEN_DPI);
				at: 8 put: ver;
				becomeA: STBViewProxy]].
	ver < 10
		ifTrue: 
			[^
			[:data |
			(data resize: 8)
				at: 4 put: ((data at: 4) ifNotNil: [:placement | placement showCmd]);
				at: 8 put: ver;
				becomeA: STBViewProxy]].
	ver < 11
		ifTrue: 
			[^
			[:data |
			data
				at: 4 put: ((data at: 4) ifNotNil: [:placement | placement showCmd]);
				becomeA: STBViewProxy]].
	^super stbConvertFrom: anSTBClassFormat!

stbVersion
	"Answer the current binary filer version number for instances of the receiver.

	1: 	Add largeIcon and smallIcon instance variables to ShellViews and subclasses
	2:	Map command->commandDescription for PushButtons
	3: 	Add iconSpacing to ListView and subclasses.
	4: 	Add getInfoTipBlock instance variable to IconicListAbstract and subclasses
	5: 	Add maxExtent and minExtent instance variables to ShellView and subclasses
	6: 	Add lvStyle inst. var. to ListView
	7: 	Add resolution instance variable
	8: 	Add events and unused instance variable to View, and events inst. var. to proxy.
	9: 	ShellView defaultButton <PushButton> changed to defaultButtonId <integer>.
	10:	'version' instance variable added to record STB version of specific view class.
	11.	Full WINDOWPLACEMENT replaced by just the showCmd."

	"STBViewProxy should no longer need to be changed to upgrade view classes, so if you are changing this number, THINK AGAIN."

	^11! !

!UI.STBViewProxy class categoriesForMethods!
forView:!instance creation!public! !
initialize!development!initializing!public! !
stbConvertFrom:!binary filing!public! !
stbVersion!binary filing!public! !
!

