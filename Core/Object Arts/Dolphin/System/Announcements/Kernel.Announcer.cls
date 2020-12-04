"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.Announcer'
	instanceVariableNames: 'registry'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Announcer guid: (Core.GUID fromString: '{1c9ed26a-0ea9-497c-af74-175569414ae7}')!
Kernel.Announcer comment: 'The code is based on the announcements as described by Vassili Bykov in <http://www.cincomsmalltalk.com/userblogs/vbykov/blogView?searchCategory=Announcements%20Framework>. The implementation uses a threadsafe subscription registry, in the sense that registering, unregistering, and announcing from an announcer at the same time in different threads should never cause failures.

For security reasons, registry is kept private, and has no accessor like in other implementations'!
!Kernel.Announcer categoriesForClass!Announcements-Core! !
!Kernel.Announcer methodsFor!

announce: anAnnouncement

	| announcement |
	announcement := anAnnouncement asAnnouncement.	
	registry ifNotNil: [
		registry deliver: announcement
		].
	^ announcement!

basicSubscribe: subscription
	^ registry add: subscription!

hasSubscriber: anObject

	registry subscriptionsOf: anObject do: [:each | ^ true].
	^ false!

initialize
	super initialize.
	registry := SubscriptionRegistry new!

numberOfSubscriptions
	^ registry numberOfSubscriptions
!

on: anAnnouncementClass do: aValuable
	"This method is deprecated!!
	Declare that when anAnnouncementClass is raised, aValuable is executed.
	In addition pay attention that ushc method as well as when:do: should not be used on weak announcer since the
	block holds the receiver and more strongly."
	
	^ self when: anAnnouncementClass do: aValuable!

on: anAnnouncementClass send: aSelector to: anObject
	"This method is deprecated!! Use when:send:to:.
	Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"

	^ self when: anAnnouncementClass send: aSelector to: anObject!

removeSubscription: subscription
	"Remove the given subscription from the receiver"
	
	^ registry remove: subscription
!

replace: subscription with: newOne
	^ registry replace: subscription with: newOne
!

subscribe: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed."

	^registry add: (AnnouncementSubscription new
				announcer: self;
				announcementClass: anAnnouncementClass;
				valuable: aValuable)!

subscribe: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector."

	^self subscribe: anAnnouncementClass
		do: (MessageSend
				receiver: anObject
				selector: aSelector
				arguments: (Array new: aSelector numArgs))!

subscriptions

	^ registry!

unsubscribe: anObject
	"Unsubscribe all subscriptions of anObject from the receiver"
	
	registry removeSubscriber: anObject!

weak
	"announcer weak subscribe: foo"

	^WeakSubscriptionBuilder on: self!

when: anAnnouncementClass do: aValuable
	"Declare that when anAnnouncementClass is raised, aValuable is executed.  Pay attention that ushc method as well as when:do: should not be used on weak announcer since the block holds the receiver and more strongly."
	
	^ self subscribe: anAnnouncementClass do: aValuable!

when: anAnnouncementClass do: aValuable for: aSubscriber
	"Declare that when anAnnouncementClass is raised, aValuable is executed and define the subscriber."
	
    ^ (self subscribe: anAnnouncementClass do: aValuable) subscriber: aSubscriber; yourself!

when: anAnnouncementClass send: aSelector to: anObject
	"Declare that when anAnnouncementClass is raised, anObject should receive the message aSelector.
    When the message expects one argument (eg #fooAnnouncement:) the announcement is passed as argument.
    When the message expects two arguments (eg #fooAnnouncement:announcer:) both the announcement and the announcer 
    are passed as argument"

	^ self subscribe: anAnnouncementClass send: aSelector to: anObject! !
!Kernel.Announcer categoriesFor: #announce:!announce!public! !
!Kernel.Announcer categoriesFor: #basicSubscribe:!private! !
!Kernel.Announcer categoriesFor: #hasSubscriber:!public! !
!Kernel.Announcer categoriesFor: #initialize!initialization!public! !
!Kernel.Announcer categoriesFor: #numberOfSubscriptions!public!statistics! !
!Kernel.Announcer categoriesFor: #on:do:!public! !
!Kernel.Announcer categoriesFor: #on:send:to:!public! !
!Kernel.Announcer categoriesFor: #removeSubscription:!public!subscription! !
!Kernel.Announcer categoriesFor: #replace:with:!private! !
!Kernel.Announcer categoriesFor: #subscribe:do:!public!subscription! !
!Kernel.Announcer categoriesFor: #subscribe:send:to:!public!subscription! !
!Kernel.Announcer categoriesFor: #subscriptions!public! !
!Kernel.Announcer categoriesFor: #unsubscribe:!public!subscription! !
!Kernel.Announcer categoriesFor: #weak!public!weak! !
!Kernel.Announcer categoriesFor: #when:do:!convenience!public! !
!Kernel.Announcer categoriesFor: #when:do:for:!convenience!public! !
!Kernel.Announcer categoriesFor: #when:send:to:!convenience!public! !

!Kernel.Announcer class methodsFor!

new	
	^super new initialize! !
!Kernel.Announcer class categoriesFor: #new!public! !

