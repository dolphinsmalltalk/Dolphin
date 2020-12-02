"Filed out from Dolphin Smalltalk 7"!

View subclass: #AbstractDelegatingView
	instanceVariableNames: 'resourceIdentifier referee'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractDelegatingView guid: (GUID fromString: '{93fdcca7-1448-41db-abf2-5aa02abef751}')!
AbstractDelegatingView isAbstract: true!
AbstractDelegatingView comment: 'AbstractDelegatingView is an abstract class for views that contain another view internally and delegate their interface to it. An example is ToolBotton, which presents the interace of a toolbar button but actually contains an instance of class Toolbar internally and uses it to do all the work.

Instance Variables:
	resourceIdentifier	<ResourceIdentifier> only used by ReferenceView sublass. Here for compatibility with previous instances of ReferenceView.
	referee			<view> which is the delegated view.'!
!AbstractDelegatingView categoriesForClass!MVP-Resources-Misc! !
!AbstractDelegatingView methodsFor!

backcolor: aColorOrNil 
	"Sets the background colour of the receiver and the referee to aColorOrNil."

	self referee backcolor: aColorOrNil.
	super backcolor: aColorOrNil!

calculateExtent: aLayoutContext 
	"Private - Answer the calculated extent of the receiver that should be used by a layout
	manager during it's layout process."

	^self referee calculateExtent: aLayoutContext!

clearReferee
	referee := nil!

createDelegate
	self subclassResponsibility!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	We use the WS_EX_CONTROLPARENT style for ReferenceViews, otherwise notification
	messages (eg BN_CLICKED) for contained controls cause an infinite loop."

	^super defaultWindowExStyle bitOr: WS_EX_CONTROLPARENT
!

isDragSource: aBoolean
	"Set or reset the receiver's isDragSource flag. When true, the receiver can take part in
	a drag and drop operation as a drag source."

	super isDragSource: aBoolean.
	self referee isDragSource: aBoolean.!

isDropTarget: aBoolean
	"Set or reset the receiver's isDropTarget flag. When true, the receiver can take part in
	a drag and drop operation as a potential drop target."

	super isDropTarget: aBoolean.
	self referee isDropTarget: aBoolean.

!

isGroupStop: aBoolean
	"Sets whether the receiver has the WS_GROUP style according to aBoolean."

	super isGroupStop: aBoolean.
	self referee isGroupStop: aBoolean.!

isTabStop: aBoolean
	"Sets whether the receiver has the WS_TABSTOP style according to aBoolean."

	super isTabStop: aBoolean.
	self referee isTabStop: aBoolean.
!

layout: aLayoutContext 
	"Private - Recalculate the geometry of the receiver."

	"Implementation Note: Ensure that the referee is the same size as the receiver."

	super layout: aLayoutContext.
	aLayoutContext setView: self referee rectangle: (0 @ 0 extent: (aLayoutContext extentOf: self)).
	self referee layout: aLayoutContext.!

model
	"Private - Answers the effective model for the receiver.. that of the referee"

	^self referee model!

model: aModel
	"Private - Sets the effective model for the receiver.. that of the referee"

	^self referee model: aModel!

onDestroyed
	"Private - Handler for destroy. Ensure that we know the referee has also been destroyed"

	"Superclass method refers (indirectly) to referee, and we don't want it to be recreated, so do that first"
	| answer |
	answer := super onDestroyed.
	"#1667: Don't orphan referee on recreate"
	self isStateRestoring ifFalse: [self clearReferee].
	^answer!

onViewCreated
	"Private - The receiver has just been created. 
	If we have not yet loaded the referee then load it now"

	super onViewCreated.
	self createDelegate	!

preferredExtent
	"Answer the preferred size of the receiver or nil if none has been specified.
	Here we just answer the preferred extent of the referee."

	^self referee preferredExtent!

preferredExtent: aPointOrNil
	"Set the preferred size of the receiver to aPointOrNil. This is forwarded on to
	the referee view. Note that this is is intended to be used only at runtime. It is
	not suitable for use at design time in the View Composer since the extent value
	is not retained by the receiver. For this reason, ReferenceView does not
	publish the #preferredExtent and #usePreferredExtent aspects."

	self referee preferredExtent: aPointOrNil!

referee
	"Private - Answers the view which is delegated to by the receiver."

	^referee !

show
	"Makes the receiver visible."

	super show.
	self referee notNil
		ifTrue: [ self referee show ]!

tabFocus
	"Private - Sets focus to the receiver's referent. Answers the View which previously had focus,
	or nil if none/invalid handle."

	^self referee setFocus!

usePreferredExtent
	"Answers true if the receiver's preferred extent should be used by a layout manager when
	laying out the contents of a container view containing the receiver"

	^self referee usePreferredExtent!

usePreferredExtent: aBoolean
	"Set the receiver to use it's preferred extent during layout according to aBoolean.
	This is forwarded on to the referee view. Note that this is is intended to be used
	only at runtime. It is not suitable for use at design time in the View Composer
	since the extent value is not retained by the receiver. For this reason, 
	ReferenceView does not publish the #preferredExtent and #usePreferredExtent
	aspects."

	self referee usePreferredExtent: aBoolean
!

validateSubViewLayouts: aLayoutContext 
	"Private - Validate the layout of the visible sub-views of the receiver."

	self referee validateLayout: aLayoutContext!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time
	when the UI has been flagged as being invalid"

	self referee validateUserInterface!

viewNamed: aString ifNone: aBlock
	"Answer the sub-view within the receiver's hierarchy with aString as its
	name. Evaluates aBlock if no matching named view exists. Forward this
	on to our referee."

	^self referee viewNamed: aString ifNone: aBlock! !
!AbstractDelegatingView categoriesFor: #backcolor:!accessing!public! !
!AbstractDelegatingView categoriesFor: #calculateExtent:!geometry!private! !
!AbstractDelegatingView categoriesFor: #clearReferee!event handling!private! !
!AbstractDelegatingView categoriesFor: #createDelegate!event handling!private! !
!AbstractDelegatingView categoriesFor: #defaultWindowExStyle!constants!private! !
!AbstractDelegatingView categoriesFor: #isDragSource:!accessing!public! !
!AbstractDelegatingView categoriesFor: #isDropTarget:!accessing!public! !
!AbstractDelegatingView categoriesFor: #isGroupStop:!accessing-styles!public! !
!AbstractDelegatingView categoriesFor: #isTabStop:!accessing-styles!public! !
!AbstractDelegatingView categoriesFor: #layout:!geometry!private! !
!AbstractDelegatingView categoriesFor: #model!accessing!private! !
!AbstractDelegatingView categoriesFor: #model:!accessing!private! !
!AbstractDelegatingView categoriesFor: #onDestroyed!event handling!private! !
!AbstractDelegatingView categoriesFor: #onViewCreated!event handling!private! !
!AbstractDelegatingView categoriesFor: #preferredExtent!geometry!public! !
!AbstractDelegatingView categoriesFor: #preferredExtent:!geometry!public! !
!AbstractDelegatingView categoriesFor: #referee!accessing!private! !
!AbstractDelegatingView categoriesFor: #show!operations!public! !
!AbstractDelegatingView categoriesFor: #tabFocus!private!tabbing! !
!AbstractDelegatingView categoriesFor: #usePreferredExtent!accessing!public! !
!AbstractDelegatingView categoriesFor: #usePreferredExtent:!accessing!not an aspect!public! !
!AbstractDelegatingView categoriesFor: #validateSubViewLayouts:!geometry!private! !
!AbstractDelegatingView categoriesFor: #validateUserInterface!operations!public! !
!AbstractDelegatingView categoriesFor: #viewNamed:ifNone:!hierarchy!public!sub views! !

