"Filed out from Dolphin Smalltalk"!

Core.Object subclass: #'UI.Presenter'
	instanceVariableNames: 'model view parentPresenter events subPresenters names helpId'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: 'acceleratorKeyAnnotations'
	classConstants: {}!
UI.Presenter guid: (Core.GUID fromString: '{87b4c4a9-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.Presenter comment: 'Presenter is an abstract class whose subclasses conform to <presenter> and represent components in the Model-View-Presenter framework. A presenter is the equivalent of a "user interface component" in the Dolphin MVP framework. It achieves flexibility over other component based architectures by allowing its data (its model) and its screen representation (its view) to be pluggable. Thus, one can change the way a user sees and manipulates a component by changing its view and one can change the data that the component is representing  by changing the model. Substituting a presenter''s model also allows several  presenter and view pairs to share and interact with the same data.  

SmalltalkSystem help: ''Overviews/ModelViewPresenter''.

A presenter determines how the user perceives, selects, and performs actions on its model data. Whereas a view is an output device to display model information, a presenter is generally a co-ordinator between actions received in the view and the changes these make to the model.  The changes that a presenter makes to its model are normally instigated either by a <commandSource> or by interpreting gestures that the view has received from the user. Such changes are usually applied to a selection of the model''s data that is held by the presenter.

You will find that presenters naturally fall into two camps; those that are generic simple components such as text editors,  lists and trees, and those that are specific to application models. Often the more specific presenters are <compositePresenter>s since these can be used to handle simultaneous user interaction with multiple aspects of a model. Note that in contrast to previous versions of Dolphin, in Dolphin 5 both <compositePresenter>s and <presenters> can be subclassed directly off <Presenter> (the old CompositePresenter class has gone and is replaced with a global variable that aliases Presenter). 

When implementing any <presenter> the following basic steps should be followed:

1. Decide what sort of presenter is being implemented and, therefore, its position in the class hierarchy. Normally, you will subclass below one of (Presenter, Shell, Dialog, ValueDialog or ValuePresenter). See the comments for these classes to understand more about when to use each type.

2. Implement a #defaultModel class method to answer a default model suitable for the presenter. This model can be superseded as the presenter is instantiated, or replaced later, but it must be available for default instantiations.

3. All presenters inherit a default view resource name of "Default view". It is recommended that if you only intend to have one view onto your presenter then it should be named this in the resource manager. Otherwise, it will be necessary to override the #defaultView class method to answer the actual name of the view resource you wish to use.

4. Next create a view resource for the presenter and associate it with the presenter''s class. This is normally done using the View Composer. The easiest way to create a new view is to write click on the presenter class in the Class Hierarchy Browser and choose the "New view" command. This will launch the View Composer on a copy of the closest "Default view" found for the presenter. If you are designing the default view itself then remember to save it under the name that will be answered by the #defaultView method (see above).

5. Override the #createSchematicWiring method on the instance side in order to "wire up" any event handlers that your presenter might need.

When implementing a <compositePresenter> the following basic steps should be followed (after the steps described above):

1. Add instance variables for each of the sub-presenters that will make up the composite. Often one uses sub-presenters to display/edit different aspects of the model, so you will require one variable for each aspect that is to be "presented"..

2. Implement a #createComponents instance side method. In here, the sub-presenters are created, named, and assigned to the appropriate instance variables. The names that you give them (not the instance variable names) are important since they indicate which sub-views, within the presenter''s associated <compositeView> will get connected to the various sub-presenters.

3. It has been mentioned that the #createSchematicWiring method may need to be overriden to specify appropriate event handling. This is much more likely to be required when creating a <compositePresenter> since you are liable to want to hook up to any events triggered by the sub-presenters and redirect them to specific methods within the new presenter class.

4. The next stage is to set up the models of the sub-presenters. Normally you will do this by overriding #model:. If your sub-presenters are to be used to display aspects of the <compositePresenter>''s model (as is common) then you should use this opportunity to assign appropriate <ValueAspectAdapter>s onto these aspects to them. 

Instance Variables:
	model		<Object> holding the model data that the presenter is to manipulate.
	view		<view> displaying the model data and supplying UI gestures and commands to the presenter.
	parentPresenter	<compositePresenter> that is the presenter''s parent or nil if it is a top level shell.
	events		<EventsCollection> holding the presenter''s event registrations.
	subPresenters	<OrderedCollection> of sub-presenters.
	names		<IdentityDictionary> mapping sub-presenter instances to their <readableString> names.

'!
!UI.Presenter categoriesForClass!MVP-Presenters!MVP-Resources-Misc! !
!UI.Presenter methodsFor!

add: aPresenter
	"Adds aPresenter to the receiver's collection of sub-presenters.
	Answers aPresenter"

	^self add: aPresenter name: (self defaultNameOf: aPresenter).
!

add: aPresenter name: aNameString
	"Adds aPresenter to the receiver's collection of sub-presenters and
	gives it aNameString. Answers aPresenter"

	^self add: aPresenter name: aNameString helpId: nil!

add: aPresenter name: aNameString helpId: anInteger 
	"Adds aPresenter to the receiver's collection of sub-presenters and
	gives it aNameString. Answers aPresenter"

	self subPresenters addLast: aPresenter.
	self name: aPresenter as: aNameString.
	anInteger ifNotNil: [:value | aPresenter helpId: value].
	aPresenter parentPresenter: self.
	^aPresenter!

additionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^self class additionalKeyBindings collect: [:each | {each acceleratorKeyString. each command}]!

additionalKeyBindings
	"Private - Answer a collection of <CommandDescriptions> for commands not on the menu bar of the receiver's view(s) but which are to be bound to a key sequence.
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol and the second the accelerator key string."

	^self class additionalKeyBindings!

addToCommandRoute: aCommandPolicy
	"Update the command routing path of the <CommandPolicy> argument with the receiver's contribution to the command path.  Answer the next <Presenter> to visit, or nil to terminate the chain."

	^aCommandPolicy appendPresenter: self!

addToImageList: aWinImageList mask: aColorOrNil 
	"Private - Add a pictorial representation of the receiver to aWinImageList. Typically this is used to create
	a thumbnail representation of the receiver."

	^self view addToImageList: aWinImageList mask: aColorOrNil!

allSubPresentersDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument for the receiver, and recursively each of its
	sub-presenters (i.e. a pre-order traversal)."

	self subPresenters do: 
			[:each | 
			aMonadicValuable value: each.
			each allSubPresentersDo: aMonadicValuable]!

asParameter
	"Answer the receiver in a form suitable for passing to an external
	function call (in this case the receiver's window handle)."

	^self view asParameter
!

attachSubPresenterViews: aView
	"Private - Now run through all our sub-presenters and connect them in turn
	to same named sub-views within aView."

	"N.B. If subPresenters is nil at this point, you might have forgotten
	a supersend in your presenter's #initialize method."

	self subPresenters do: 
			[:eachSubPresenter |
			| matchingSubView |
			matchingSubView := aView viewNamed: (self nameOf: eachSubPresenter) ifNone: nil.
			matchingSubView notNil
				ifTrue: [eachSubPresenter view: matchingSubView presenterConnectionPoint]
				ifFalse: 
					["No matching sub view - drill down one more layer"
					eachSubPresenter attachSubPresenterViews: aView]]!

basicOnViewOpened
	self subPresenters do: [:eachSubPresenter | eachSubPresenter onViewOpened].
	self createSchematicWiring.
	self view onViewOpened!

commandPolicy
	"Answers a <CommandPolicy> object set up for routing commands originating
	from the receiver. This should be overridden by subclasses that wish to use a different 
	routing policy."

	^self view commandPolicy!

commandSource
	"Private - Answer the <View> starting point for command routing if a UI command
	is received by the receiver. Subclasses may override to suggest another source for their
	own commands."

	^self view commandSource
!

connectView	
	"Private - Connect the view to the receiver. The default is to connect the 
	view's presenter to the receiver and the view's model to the receiver's model"

	self view presenter: self.
	self model notNil 
		ifTrue: [ self view model: self viewModel ]
	!

createComponents
	"Create the presenters contained by the receiver. At this stage
	the receiver has not yet been initialized."

!

createSchematicWiring
	"Create the trigger wiring for the receiver. At this stage the initialization
	is complete and the view is open"!

createView: aResourceNameString
	"Private - Creates and connects a view for the receiver from the resource identified
	by aResourceNameString. Answers the new view created"

	| parentView surrogateShellView newView |
	parentView := self parentPresenter
				ifNil: 
					["The receiver has no parent presenter so create a basic
					ShellView to hold its view"
					surrogateShellView := ShellView new create.
					surrogateShellView
						layoutManager: GridLayout new;
						caption: self printString;
						largeIcon: self icon;
						show;
						yourself]
				ifNotNil: [:parent | parent view].

	"Create the new view"
	newView := self class loadViewResource: aResourceNameString inContext: parentView.
	self view: newView.
	surrogateShellView notNil ifTrue: [self onViewOpened].
	self show.
	^newView!

defaultHelpId
	^nil!

defaultNameOf: aView
	"Private - Answer a default name for aView within the receiver. The name is 
	of the form: classnn, where 'class' is the class of aView and 'nn' is GUID string"

	^aView class name displayString , GUID newUnique asString!

destroy
	"Forcibly destroy the receiver by closing the associated View"

	self view destroy!

dragCut: session
	"The <DragDropSession>, session, has just completed a successful move operation.
	The dragged object(s) now need to be cut from the drag source. Shrug shoulders
	and reflect back to the View."

	self view dragCut: session!

dragEnter: session
	"The drag operation described by the <DragDropSession>, session,
	 has entered the receiver's window.
	Use the session to provide feedback to the user about allowable operations etc."

	self view dragEnter: session.!

dragLeave: session
	"The drag operation described by the <DragDropSession>, session,
	has left the receiver's window."

	"Allow the view a chance to give feedback"
	self view dragLeave: session!

dragOver: session
	"The drag operation described by the <DragDropSession>, session,
	has moved to a new position over the receiver's window. Use the session 
	to provide feedback to the user about allowable operations etc.
	Implementation Note: Reflect back to the view in anticipation of it eventually
	triggering an event off the receiver so that the receiver's observers (typically
	higher level presenters, may get involved in the drag-drop session)."

	self view dragOver: session.!

drop: session
	"The drag operation described by the <DragDropSession>, session,
	would like to do a drop. Answer whether the drop was accepted and
	should proceed - an affirmative reply from this message instructs the 
	drag source to cut the dragged objects (depending on the drag operation).

	Implementation Note: It is possible to override this method to accept the 
	dropped Object(s), but the preferred mechanism is now to observe the 
	#drop:  event triggered by the receiver. In any case, if the drop was 
	unsuccessful the operation attribute of the session should be set to nil, 
	and false answered as the result of #drop:."

	^self view drop: session!

ensureVisible
	"Ensures that the receiver is visible in it's parent"

	self view ensureVisible

	!

errorDuplicateName: aString
	"Report that aString is already in use"

	^self error: 'duplicate name: ', aString!

extent: aPoint 
	self view extent: aPoint!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

hasFocus
	"Answer true if the receiver's view has the input focus"

	^self view hasFocus!

hasFocusDeeply
	"Answer true if the receiver's view, or any of its sub-views, has the input focus"

	^self view hasFocusDeeply!

hasView
	"Answer true if the receiver has a real view connected"

	^self view class ~~ DeafObject!

helpId
	"Answer an integer ID used to associate the receicer with pop-up help"

	^helpId ifNil: [self view parentView helpId]!

helpId: anInteger
	helpId := anInteger!

hide
	"Hides the view of the receiver"

	self view hide!

initialize
	"Private - Initialize the receiver."

	"When overriding this method do remember to supersend!!"

	view := DeafObject.Current.
	subPresenters := OrderedCollection new.
	helpId := self defaultHelpId.
	self createComponents!

invalidateUserInterface
	"Invalidates the user interface of the receiver indicating that it needs
	to be requeried using #validateUserInterface (usually at idle time)"

	self view invalidateUserInterface!

isOpen
	"Answer whether the receiver has a real view connected, and it is open (i.e. 
	there is a valid native Window associated with it)"

	^self view isOpen == true!

isReadOnly
	"Answer whether the receiver's contents can be updated. Normally this is equivalent to
	whether or not the view is disabled, but some view classes may have a specific read-only
	mode."

	^false!

isReadOnly: aBoolean 
	"Set whether the receiver's contents can be updated. In many cases this is a no-op, but some
	presenters will support a read-only mode."

	!

model
	"Answer the model of the receiver"

	^model
!

model: anObject
	"Set the model of the receiver to be anObject"

	model := anObject.
	self hasView ifTrue: [self connectView]!

name: aPresenter as: aNameString
	"Sets the name of aPresenter within the receiver to be aNameString"

	names isNil
		ifTrue: [(names := IdentityDictionary new) at: aPresenter put: aNameString]
		ifFalse: 
			[| exists |
			"Check that aNameString has not already been used"
			exists := names keyAtEqualValue: aNameString ifAbsent: nil.
			(exists isNil or: [exists == self])
				ifTrue: [names at: aPresenter put: aNameString]
				ifFalse: [self errorDuplicateName: aNameString]]!

nameOf: aPresenter
	"Answer the name of aPresenter within the receiver or nil
	if it has not been assigned a name"

	^names ifNotNil: [names lookup: aPresenter]!

on: aSubjectModel
	"Private - Initializes the model connection for the receiver to aSubjectModel.
	Most Presenters are connected directly to the subject. Some subclasses override
	this method to provide buffering between the Presenter model and the 
	subject (Dialogs)."

	self initialize.
	aSubjectModel notNil ifTrue: [ self model: aSubjectModel ]!

onAboutToDisplayMenu: popup
	"The pop-up <Menu>, popup, is about to be displayed.
	This is our opportunity to update it, e.g. to add/remove items.
	Note: Adding an item persists as the menu is not destroyed
	until the view is closed."

	^self view onAboutToDisplayMenu: popup!

onActionPerformed
	"Handler for an action in the receiver's view"

	self view onActionPerformed.!

onCaptureChanged: hWnd
	^nil!

onCloseRequested
	"Default handler for a close request event. Pass on to the view"

	^self view onCloseRequested!

onGetCursor: aSymbol
	"The named area of the view associated with the receiver has been hit.
	Answer the appropriate mouse cursor or nil to accept the default."

	| globalCursor |
	^(aSymbol == #client and: [(globalCursor := Cursor current) notNil])
		ifTrue: [globalCursor]
		ifFalse: [self view onGetCursor: aSymbol]!

onHotKey: anInteger 
	"Private - Default handler for a hotKey event. The parameter identifies the hot key."

	^self view onHotKey: anInteger!

onIdleEntered
	"There are no messages in the input queue and the input state is
	about to go idle. Perform any idle processing (by default do nothing)."

	^true!

onInputLanguageChanged: aWindowsEvent 
	^self view onInputLanguageChanged: aWindowsEvent!

onInputMaskRequired: anEvent
	"Handler for an input event mask request from Windows.
	Reflect back to the view for processing - it doesn't seem worthwhile
	triggering an event in the general case, and if so it would required
	a value holder as its parameter."
	
	^self view onInputMaskRequired: anEvent!

onKeyPressed: aKeyEvent
	"Default handler for the receiver's view receiving a key press event."

	^self view onKeyPressed: aKeyEvent!

onKeyReleased: aKeyEvent
	"Default handler for the receiver's view receiving a key up event."

	^self view onKeyReleased: aKeyEvent!

onKeyTyped: aKeyEvent
	"Default handler for the receiver's view receiving a key entry."

	^self view onKeyTyped: aKeyEvent!

onKillFocus
	"Default handler for the receiver's view losing focus"

	^self view onKillFocus!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event."

	^self view onLeftButtonDoubleClicked: aMouseEvent!

onLeftButtonPressed: aMouseEvent
	"Default handler for a left button down mouse event."

	^self view onLeftButtonPressed: aMouseEvent!

onLeftButtonReleased: aMouseEvent
	"Default handler for a Left button up mouse event."

	^self view onLeftButtonReleased: aMouseEvent!

onMiddleButtonDoubleClicked: aMouseEvent 
	"Default handler for a mouse middle button double-click event."

	^self view onMiddleButtonDoubleClicked: aMouseEvent
!

onMiddleButtonPressed: aMouseEvent 
	"Default handler for a middle button down mouse event."

	^self view onMiddleButtonPressed: aMouseEvent!

onMiddleButtonReleased: aMouseEvent 
	"Default handler for a middle button up mouse event."

	^self view onMiddleButtonReleased: aMouseEvent!

onMouseHovering: aMouseEvent 
	^self view onMouseHovering: aMouseEvent!

onMouseLeave: aMouseEvent 
	^self view onMouseLeave: aMouseEvent!

onMouseMoved: aMouseEvent
	"Default handler for a mouse move event over the
	receiver's view."

	^self view onMouseMoved: aMouseEvent!

onMouseWheeled: aMouseWheelEvent
	"Default handler for a mouse wheel movement event."

	^self view onMouseWheeled: aMouseWheelEvent!

onPositionChanged: aPositionEvent
	"Default handler for a change in position (resize or move) of the receiver's view."
	
	^self view onPositionChanged: aPositionEvent!

onPositionChanging: aPositionEvent
	"Default handler for window position changing (move or resize).
	Modifying the contents of aPositionEvent can alter how it gets mapped
	to an actual position change of the receiver."

	^self view onPositionChanging: aPositionEvent!

onRightButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse Right button double-click event."

	^self view onRightButtonDoubleClicked: aMouseEvent!

onRightButtonPressed: aMouseEvent
	"Default handler for a Right button down mouse event."

	^self view onRightButtonPressed: aMouseEvent!

onRightButtonReleased: aMouseEvent
	"Default handler for a Right button up mouse event."

	^self view onRightButtonReleased: aMouseEvent!

onSetFocus
	"Handler for the receiver's view gaining focus"

	^self view onSetFocus!

onSysKeyPressed: aKeyEvent 
	"Default handler for the receiver's view receiving a sys key press event (e.g. ALT key
	down)."

	^self view onSysKeyPressed: aKeyEvent!

onSysKeyReleased: aKeyEvent 
	"Default handler for the receiver's view receiving a sys key up event."

	^self view onSysKeyReleased: aKeyEvent!

onSysKeyTyped: aKeyEvent 
	"Default handler for the receiver's view receiving a sys key entry (e.g. Alt-X)."

	^self view onSysKeyTyped: aKeyEvent!

onTipDetailsRequired: aNMTTDISPINFOA 
	^self view onTipDetailsRequired: aNMTTDISPINFOA 
!

onTipTextRequired: tool
	"Tool tip text is required for the <ToolbarItem>, tool."

	^tool toolTipText!

onViewAvailable
	"A new view is available, but has not yet been connected to the receiver, i.e. the view will
	not yet be aware of this presenter, or its model. This is an appropriate point for
	subclasses to apply any dynamic view configuration that the application may require (e.g.
	setting a user configured font previously saved in the Registry). Since the view is not yet
	connected, any events fired will not reach this presenter or the model. This event is new
	for Dolphin 3.0. Note that this event is only sent when a presenter-view pair is first
	created, it is not sent when a view is restored on image restart. Typically this is not
	relevant in applications (which do not save the image), but it may be at development time.
	The similar #onViewCreated event is, however, sent every time a view is created, whether it
	be the first time, or on restoration of saved state. Thus if you need to perform one-time
	initialisation you should override this method, or to perform initialisation that is needed
	every time a view is created you should override #onViewCreated."

	!

onViewClosed
	"Sent by the receiver's view when it has been closed"

	self view onViewClosed!

onViewCreated
	"The receiver's view has been created, but may not yet be connected to the receiver (if the
	view-presenter pair is being instantiated, then the connection will not have been made, but
	if the view is being restored from saved state in the image then the presenter will be
	connected). This is an appropriate point for subclasses to apply any dynamic view
	configuration that must be performed every time the view is created. Typically this might
	involve customising some feature of the view that it does not itself save, perhaps because a
	feature of the underlying control does not have full support in the wrapper class. Note that
	one should normally override #onViewAvailable to restore user configuration settings, since
	the views will normally save and restore all relevant settings across an image save."

	^self view onViewCreated!

onViewDestroyed
	"Handler for view final view destruction. This is sent on receipt of WM_NCDESTROY,
	and is expected to be the last communication from Windows. There is nothing
	more we can do to save the patient. No event is triggered."

	self view onViewDestroyed.
	view isStateRestoring 
		ifFalse: 
			["If not recreating the view then discard it"
			view := DeafObject.Current]!

onViewOpened
	"Now run through all our sub-presenters and connect them in turn
	to same named sub-views within aCompositeView"

	self basicOnViewOpened!

onXButtonDoubleClicked: aMouseEvent 
	"Default handler for a mouse X button double-click event."

	^self view onXButtonDoubleClicked: aMouseEvent
!

onXButtonPressed: aMouseEvent 
	"Default handler for an X button down mouse event."

	^self view onXButtonPressed: aMouseEvent!

onXButtonReleased: aMouseEvent 
	"Default handler for a X button up mouse event."

	^self view onXButtonReleased: aMouseEvent!

parentPresenter
	"Answer the Presenter that is the parent of the receiver, or nil if there
	is no parent"

	^parentPresenter!

parentPresenter: aPresenter
	"Private - Set the Presenter that is the parent of the receiver to be aPresenter"

	parentPresenter := aPresenter!

performAction
	"Cause an #actionPerformed event to be routed"

	self view performAction!

position: aPoint 
	self view position: aPoint!

presenterNamed: aString
	"Answer the sub-presenter within the receiver with aString as its
	name. Signals a NotFoundError if no matching named presenter exists."

	^self presenterNamed: aString ifNone: [ self errorNotFound: aString ]
!

presenterNamed: aString ifNone: exceptionHandler
	"Answer the sub-presenter within the receiver's hierarchy with aString as its
	name. Evaluates the <niladicValuable>, exceptionHandler, if no matching 
	named view exists."

	^names
		ifNil: [exceptionHandler value]
		ifNotNil: [names keyAtEqualValue: aString ifAbsent: exceptionHandler]!

preTranslateKeyboardInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG, which is a keyboard message."

	^self view preTranslateKeyboardInput: aMSG!

preTranslateMouseInput: aMSG
	"Answer whether the receiver would like to consume the argument aMSG."

	^self view preTranslateMouseInput: aMSG

!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver 
	into the <CommandQuery>, query."

	(self queryCommandHandlers: aCommandQuery) ifTrue: [^true].
	(aCommandQuery canPerformAgainst: self) ifTrue: [aCommandQuery beEnabled].
	^false	"There was no specific enablement of the command at this level"!

queryCommandHandlers: aCommandQuery 
	| class |
	class := self class.
	
	[class commandQueryHandlers do: [:each | (self perform: each with: aCommandQuery) ifTrue: [^true]].
	class == ##(self)] 
			whileFalse: [class := class superclass].
	^false!

remove: aPresenter
	"Removes aPresenter from the receiver's collection of sub-presenters.
	Answers aPresenter"

	self view removeSubView: aPresenter view.
	self subPresenters remove: aPresenter.
	aPresenter parentPresenter == self ifTrue: [aPresenter parentPresenter: nil].
	names isNil ifFalse: [names removeKey: aPresenter].
	^aPresenter!

requestDragImages: session
	"This is where the receiver specifies any drag image overrides.
	To do this use DragDropSession>>#imageAt: <Symbol> put: <Image> where 
	the Symbol is an either #object (to specify the underlying icon), or an 
	operation Symbol such as #none, #move, #copy, #link, #moveScroll, #copyScroll, 
	#linkScroll or some other Symbol to match an operation symbol. The Image
	is any Image (e.g. Icon or Cursor)."

	self view requestDragImages: session!

requestDragObjects: session
	"This is where the receiver specifies which object(s) the <DragDropSession>, session,
	is to drag. The objects are added to the session using DragDropSession>>addDragObject: 
	or DragDropSession>>dragObjects:."

	self view requestDragObjects: session!

requestDropOperations: session
	"Update the <DragDropSession>, session, with the set of supported 
	drag and drop operation symbols (for right-button drags).
	Implementation Note: Reflect back to the View, which will (normally)
	tigger a #requestDropOperations: event off the receiver."

	self view requestDropOperations: session!

routeCommand: aCommandDescription 
	self commandPolicy route: aCommandDescription!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setFocus
	"Sets keyboard input focus to the view associated with the receiver.
	First ensure that the view is visible within it's parent"

	| v |
	v := self view.
	v  ensureVisible.
	v setFocus!

setView: aView
	view := aView!

show
	"Shows the view of the receiver"

	self view show!

showNewView
	"Private - Sent from #createView: to show the newly created view. Can be overridden to show 
	with a custom placement."

	self show!

showShell
	"Shows the Shell to which the receiver belongs"

	self view topShell show!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.!

subPresenters
	"Answers an OrderedCollection of Presenters that are the
	children of the receiver"

	^subPresenters!

topShell
	"Answer the <topPresenter> associated with the receiver."

	| next |
	next := self parentPresenter.
	next isNil ifTrue: [next := self view].
	^next topShell!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the  UI has been flagged as being invalid"

	self view validateUserInterface!

view
	"Answer the view for the receiver. If the view has not yet been created then
	it is created now"

	^view !

view: aView 
	"Set the view for the receiver to aView. We also connect up any sub-views
	to same named presenters in our subPresenters collection"

	self attachSubPresenterViews: aView.	
	view := aView.
	self onViewAvailable.
	self connectView!

viewModel
	"Private - Answer the model that is to be connected to the view. In general this	
	is identical to the receiver's model but in some cases the presenter may want to
	donate a different model to the view"

	^self model! !
!UI.Presenter categoriesForMethods!
add:!public!subpresenters! !
add:name:!public!subpresenters! !
add:name:helpId:!public!subpresenters! !
additionalAccelerators!constants!public! !
additionalKeyBindings!constants!private! !
addToCommandRoute:!commands!public! !
addToImageList:mask:!double dispatch!private! !
allSubPresentersDo:!enumerating!public! !
asParameter!converting!public! !
attachSubPresenterViews:!accessing!private! !
basicOnViewOpened!event handling!public! !
commandPolicy!commands!public! !
commandSource!accessing!public! !
connectView!operations!private! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
createView:!operations!private! !
defaultHelpId!constants!public! !
defaultNameOf:!helpers!private! !
destroy!operations!public! !
dragCut:!drag & drop!public! !
dragEnter:!event handling!public! !
dragLeave:!event handling!public! !
dragOver:!event handling!public! !
drop:!event handling!public! !
ensureVisible!accessing!public! !
errorDuplicateName:!exceptions!public! !
extent:!accessing!public! !
getEvents!events!private! !
hasFocus!public!testing! !
hasFocusDeeply!public!testing! !
hasView!public!testing! !
helpId!accessing!public! !
helpId:!accessing!public! !
hide!operations!public! !
initialize!initializing!private! !
invalidateUserInterface!accessing!public! !
isOpen!public!testing! !
isReadOnly!public!testing! !
isReadOnly:!accessing!public! !
model!accessing!public! !
model:!accessing!public! !
name:as:!public!subpresenters! !
nameOf:!public!subpresenters! !
on:!initializing!private! !
onAboutToDisplayMenu:!event handling!public! !
onActionPerformed!event handling!public! !
onCaptureChanged:!event handling!public! !
onCloseRequested!event handling!public! !
onGetCursor:!event handling!public! !
onHotKey:!event handling!public! !
onIdleEntered!event handling!public! !
onInputLanguageChanged:!event handling!public! !
onInputMaskRequired:!event handling!public! !
onKeyPressed:!event handling!public! !
onKeyReleased:!event handling!public! !
onKeyTyped:!event handling!public! !
onKillFocus!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onLeftButtonPressed:!event handling!public! !
onLeftButtonReleased:!event handling!public! !
onMiddleButtonDoubleClicked:!event handling!public! !
onMiddleButtonPressed:!event handling!public! !
onMiddleButtonReleased:!event handling!public! !
onMouseHovering:!event handling!public! !
onMouseLeave:!event handling!public! !
onMouseMoved:!event handling!public! !
onMouseWheeled:!event handling!public! !
onPositionChanged:!event handling!public! !
onPositionChanging:!event handling!public! !
onRightButtonDoubleClicked:!event handling!public! !
onRightButtonPressed:!event handling!public! !
onRightButtonReleased:!event handling!public! !
onSetFocus!event handling!public! !
onSysKeyPressed:!event handling!public! !
onSysKeyReleased:!event handling!public! !
onSysKeyTyped:!event handling!public! !
onTipDetailsRequired:!event handling!public! !
onTipTextRequired:!event handling!public! !
onViewAvailable!event handling!public! !
onViewClosed!event handling!public! !
onViewCreated!event handling!public! !
onViewDestroyed!event handling!public! !
onViewOpened!event handling!public! !
onXButtonDoubleClicked:!event handling!public! !
onXButtonPressed:!event handling!public! !
onXButtonReleased:!event handling!public! !
parentPresenter!accessing!public! !
parentPresenter:!accessing!private! !
performAction!operations!public! !
position:!accessing!public! !
presenterNamed:!public!subpresenters! !
presenterNamed:ifNone:!public!subpresenters! !
preTranslateKeyboardInput:!dispatching!public! !
preTranslateMouseInput:!dispatching!public! !
queryCommand:!commands!private! !
queryCommandHandlers:!commands!private! !
remove:!public!subpresenters! !
requestDragImages:!drag & drop!public! !
requestDragObjects:!drag & drop!public! !
requestDropOperations:!drag & drop!public! !
routeCommand:!commands!public! !
setEvents:!events!private! !
setFocus!operations!public! !
setView:!initializing!public! !
show!operations!public! !
showNewView!operations!private! !
showShell!operations!public! !
stbSaveOn:!binary filing!public! !
subPresenters!accessing!public!subpresenters! !
topShell!accessing!public! !
validateUserInterface!operations!public! !
view!accessing!public! !
view:!accessing!public! !
viewModel!accessing!private! !
!

UI.Presenter methodProtocol: #commandTarget attributes: #(#readOnly) selectors: #(#queryCommand:)!
UI.Presenter methodProtocol: #compositePresenter attributes: #(#readOnly) selectors: #(#add: #add:name: #createComponents #createSchematicWiring #name:as: #nameOf: #presenterNamed: #presenterNamed:ifNone: #remove: #subPresenters)!
UI.Presenter methodProtocol: #dragSource attributes: #(#readOnly) selectors: #(#dragCut: #requestDragImages: #requestDragObjects:)!
UI.Presenter methodProtocol: #dropTarget attributes: #(#readOnly) selectors: #(#dragEnter: #dragLeave: #dragOver: #drop: #requestDropOperations:)!
UI.Presenter methodProtocol: #interactor attributes: #(#readOnly) selectors: #(#onGetCursor: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMiddleButtonDoubleClicked: #onMiddleButtonPressed: #onMiddleButtonReleased: #onMouseLeave: #onMouseMoved: #onMouseWheeled: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSysKeyPressed: #onSysKeyReleased: #onSysKeyTyped: #onXButtonDoubleClicked: #onXButtonPressed: #onXButtonReleased:)!
UI.Presenter methodProtocol: #presenter attributes: #(#readOnly) selectors: #(#addToCommandRoute: #commandPolicy #ensureVisible #isOpen #onAboutToDisplayMenu: #onActionPerformed #onCloseRequested #onIdleEntered #onInputMaskRequired: #onKeyPressed: #onKeyReleased: #onKeyTyped: #onKillFocus #onLeftButtonDoubleClicked: #onLeftButtonPressed: #onLeftButtonReleased: #onMiddleButtonPressed: #onMiddleButtonReleased: #onMouseMoved: #onPositionChanged: #onPositionChanging: #onRightButtonDoubleClicked: #onRightButtonPressed: #onRightButtonReleased: #onSetFocus #onTipTextRequired: #onViewClosed #onViewDestroyed #onViewOpened #parentPresenter #performAction #setFocus #show #topShell #view)!
UI.Presenter methodProtocol: #whatsThisHelp attributes: #(#readOnly) selectors: #(#helpId)!

!UI.Presenter class methodsFor!

acceleratorKeyAnnotations
	"Private - Answer the {commandSymbol. acceleratorKeyString} pairs defined by annotationed command methods in the receiver or superclasses."

	^acceleratorKeyAnnotations
		ifNil: 
			["All the commands are expected to be implemented on the instance side, so that is where we should find the annotated command methods (if any)"
			acceleratorKeyAnnotations := self findAcceleratorKeyAnnotations]!

acceleratorKeyBindings
	"Answer a <Dictionary> mapping accelerator key sequences to commands, being the additional accelerator 
	definitions for commands not on the menu bars (if any) of the receiver's view(s)."

	| answer |
	answer := Dictionary new.
	self additionalKeyBindings do: [:each | answer at: each acceleratorKeyString put: each command].
	^answer!

acceleratorKeyBindings: aDictionary
	"Set a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s).
	The argument should be an <abstractDictionary> mapping accelerator key strings, e.g. 'Ctrl+I' to command name
	<Symbol>s."

	self setAdditionalAccelerators: (aDictionary associations collect: [:each | {each value. each key}])!

addCommandQueryHandler: aSymbol 
	"Register an additional CommandQuery handler to be invoked by the #queryCommand: processing
	of instances of the receiver. This allows for additional commands to be added without
	needing to modify the '#queryCommand: method. The handler is passed an instance of
	<CommandQuery>, and should answer true if it handles the command, false if not. Handled
	commands should be enabled/disabled in the normal way."

	self setCommandQueryHandlers: (self commandQueryHandlers copyWith: aSymbol)!

additionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s). Each element of the collection should be a two element <Array>, the first element of which is the command symbol and the second the accelerator key string."

	"By default this is built by collection from methods with #acceleratorKey: annotations, and also any hard-coded in the class' implementation of #defaultAdditionAccelerators. The 2nd source is partly for backwards compatibility, since this existed before the annotation mechanism, and partly because it allows a Presenter class to define accelerator keys for commands that are implemented elsewhere. This allows keys to be bound to any of the commands that might be available on the command route initiated from the presenter. Typically this is used to specify accelerators for commands that are implemented in View classes."

	^self acceleratorKeyAnnotations , self defaultAdditionalAccelerators!

additionalKeyBindings
	^self getAdditionalKeyBindings
		ifNil: 
			[self additionalAccelerators collect: 
					[:each |
					(CommandDescription command: each first)
						acceleratorKeyString: each second;
						yourself]]!

annotationsUpdated: aCompilationResult
	"Annotations may have been added or removed in the receiver's methods. This is an opportunity to update any metadata that might be based on method annotations."

	(aCompilationResult affectsAnnotation: #acceleratorKey:)
		ifTrue: [self updateAdditionalAccelerators: aCompilationResult]!

commandQueryHandlers
	^self getCommandQueryHandlers ?? #()!

create
	"Answers an instance of the receiver with a default view"

	^self create: self defaultView
	!

create: aResourceNameString
	"Answers an instance of the receiver with a view identified by aResourceNameString"

	^self create: aResourceNameString on: self defaultModel
	!

create: aResourceNameString in: aCompositePresenter
	"Answers an instance of the receiver created as a sub-presenter of aCompositePresenter
	and wired up to a view identified by the resource name aResourceNameString."

	^self create: aResourceNameString in: aCompositePresenter on: self defaultModel.
	!

create: aResourceNameString in: aCompositePresenter on: aModel
	"Answers an instance of the receiver created as a sub-presenter of aCompositePresenter
	and wired up to a view identified by the resource name aResourceNameString. The new
	presenter is to be connected to aModel. It is assumed that, at this stage, aCompositePresenter
	is already opened in a view. For this reason we must force an #onViewOpened message to
	the newly created presenter"

	| newOne |
	newOne := aCompositePresenter add: (self on: aModel).
	newOne createView: aResourceNameString.
	^newOne onViewOpened; yourself
	!

create: aResourceNameString on: aModel
	"Answers an instance of the receiver with a view identified by aResourceNameString
	and connected to aModel"

	^(self on: aModel)
		createView: aResourceNameString; 
		yourself.
	!

createIn: aCompositePresenter
	"Answers an instance of the receiver created as a sub-presenter of aCompositePresenter
	and wired up to a default view"

	^self create: self defaultView in: aCompositePresenter
	!

createIn: aCompositePresenter on: aModel
	"Answers an instance of the receiver created as a sub-presenter of aCompositePresenter
	and wired up to its default view. The new presenter is to be connected to aModel. "

	^self create: self defaultView in: aCompositePresenter on: aModel
	!

createOn: aModel
	"Answers an instance of the receiver with a default view"

	^self create: self defaultView on: aModel
	!

defaultAdditionalAccelerators
	"Answer a collection of additional accelerator definitions for commands not on the menu bar of the receiver's view(s). Each element of the collection should be a two element <Array>, the first element of which is the command symbol and the second the accelerator key string, e.g. #(#(#widen 'Ctrl+W') #(#(#narrow 'Ctrl+N')).
	Note that in Dolphin 8 the use of <acceleratorKey: 'key-chord-string'> annotations in the command methods is preferred. The defaultAdditionalAccelerators mechanism is retained for backwards compatibility, and as a way of registering accelerator keys for sub-views in a composite, i.e. to define accelerator keys to map to the commands in those views when they do not normally have those key bindings. It is not necessary to define
	additional accelerators for sub-presenters, as these will be traversed for their contributed accelerators when building the combined accelerator table."

	^#()!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized. Answer nil for no default. Overidden by subclasses
	that can provide a more sensible default"

	^nil!

defaultResourceIdentifier
	"Answer the resource identifier of the default view for the receiver."

	^ResourceIdentifier class: self name: self defaultView!

defaultView
	"Answer the resource name of the default view for the receiver.
	Subclasses should override this method if they wish to use a different
	resource name for the default view"

	^View defaultView!

findAcceleratorKeyAnnotations
	| stream |
	self == ##(self)
		ifTrue: [stream := WriteStream on: {}]
		ifFalse: 
			[| inherited |
			inherited := superclass acceleratorKeyAnnotations.
			stream := WriteStream on: (Array new: inherited size).
			stream nextPutAll: inherited].
	"All the commands are expected to be implemented on the instance side, so that is where we should find the annotated command methods (if any)"
	self methodsDo: 
			[:each |
			each annotations
				ifNotNil: 
					[:annotations |
					annotations withSelector: #acceleratorKey:
						do: [:args | stream nextPut: {each selector. AcceleratorTable canonicalizeKeyString: (args at: 1)}]]].
	^stream contents!

getAdditionalKeyBindings
	^nil!

getCommandQueryHandlers
	^nil!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

loadViewResource: aString inContext: aParentView
	"Private - Load a view resource called aString owned by this class."

	| resourceIdentifier |
	resourceIdentifier := ResourceIdentifier class: self name: aString.
	^resourceIdentifier loadWithContext: aParentView!

methodRemoved: aCompiledMethod
	(aCompiledMethod hasAnnotation: #acceleratorKey:) ifTrue: [self updateAdditionalAccelerators: nil]!

new
	"Answer an instance of the receiver not yet connected to any view
	but connected to a default model"

	^self on: self defaultModel!

on: aModel
	"Answer an instance of the receiver not yet connected to any view
	but connected to aModel."

	^(super new) on: aModel; yourself!

removeCommandQueryHandler: aSymbol 
	"Unregister an additional CommandQuery handler to reverse out a previous
	addCommandQueryHandler: call. This should be called by IDE extension packages that are
	uninstalling command handlers."

	self setCommandQueryHandlers: (self commandQueryHandlers copyWithout: aSymbol)!

resetDefaultAdditionalAccelerators
	acceleratorKeyAnnotations := nil!

resource_Container_view
	"Answer the literal data from which the 'Container view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Container_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1140850688 131073 416 nil nil nil 7 nil nil nil 416 nil 170 192 8 #() nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 610 701 501 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 8 #() 610 193 193 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ContainerView} 34 15 nil nil 34 2 8 1409286144 131073 416 nil nil nil 5 nil nil nil 416 nil 170 192 8 #() nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 610 701 501 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 93 25 0 0 4 1 0 0] 8 #() 610 193 193 nil 27)!

setAdditionalAccelerators: anArray
	| bindings |
	bindings := anArray
				ifNotNil: 
					[anArray collect: 
							[:each |
							(CommandDescription command: each first)
								acceleratorKeyString: each second;
								yourself]].
	self setAdditionalKeyBindings: bindings.
	^bindings!

setAdditionalKeyBindings: anArray
	"Private - Store key bindings, if supported."

	!

setCommandQueryHandlers: anArray 
	self error: 'configuring command query handlers is not supported'!

show
	"Answers an instance of the receiver shown in a default view"

	^self create showShell
	!

show: aResourceNameString
	"Answers an instance of the receiver shown in a view identified by aResourceNameString"

	^(self create: aResourceNameString) showShell.
	!

show: aResourceNameString on: aModel
	"Answers an instance of the receiver shown in a view identified by aResourceNameString
	and connected to aModel"

	^(self create: aResourceNameString on: aModel) showShell.
	!

showOn: aModel
	"Answers an instance of the receiver shown in a default view
	and connected to aModel"

	^(self createOn: aModel) showShell.
	!

updateAdditionalAccelerators: aCompilationResult
	self withAllSubclassesDo: [:each | each resetDefaultAdditionalAccelerators]! !
!UI.Presenter class categoriesForMethods!
acceleratorKeyAnnotations!constants!private! !
acceleratorKeyBindings!constants!public! !
acceleratorKeyBindings:!constants!public! !
addCommandQueryHandler:!accessing!public! !
additionalAccelerators!accessing!public! !
additionalKeyBindings!accessing!private! !
annotationsUpdated:!public! !
commandQueryHandlers!accessing!private! !
create!instance creation!public! !
create:!instance creation!public! !
create:in:!instance creation!public! !
create:in:on:!instance creation!public! !
create:on:!instance creation!public! !
createIn:!instance creation!public! !
createIn:on:!instance creation!public! !
createOn:!instance creation!public! !
defaultAdditionalAccelerators!constants!private! !
defaultModel!models!public! !
defaultResourceIdentifier!constants!public! !
defaultView!constants!public! !
findAcceleratorKeyAnnotations!constants!private! !
getAdditionalKeyBindings!accessing!private! !
getCommandQueryHandlers!accessing!private! !
icon!constants!public! !
loadViewResource:inContext:!operations!private! !
methodRemoved:!public! !
new!instance creation!public! !
on:!instance creation!public! !
removeCommandQueryHandler:!accessing!public! !
resetDefaultAdditionalAccelerators!public! !
resource_Container_view!public!resources-views! !
resource_Default_view!public!resources-views! !
setAdditionalAccelerators:!accessing!private! !
setAdditionalKeyBindings:!accessing!private! !
setCommandQueryHandlers:!accessing!private! !
show!instance creation!public! !
show:!instance creation!public! !
show:on:!instance creation!public! !
showOn:!instance creation!public! !
updateAdditionalAccelerators:!event handling!private! !
!

UI.Presenter class methodProtocol: #'presenter factory' attributes: #(#readOnly) selectors: #(#create #create: #create:in: #create:in:on: #create:on: #createIn: #createIn:on: #createOn: #defaultModel #defaultView #on: #show #show: #show:on: #showOn:)!

