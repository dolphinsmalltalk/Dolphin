"Filed out from Dolphin Smalltalk 7"!

Object subclass: #WeakSubscriptionBuilder
	instanceVariableNames: 'announcer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WeakSubscriptionBuilder guid: (GUID fromString: '{c8b3ff0e-ed6e-4d0e-bd5c-316314346cc8}')!
WeakSubscriptionBuilder comment: 'I am a wrapper around an Announcer, used to create weak subscriptions at subscription time.

Use me like this:

anAnnouncer weak subscribe: Announcement send: #foo to: barObject.

I raise an error for block subscriptions, as they require non-existing Ephemeron support to function correctly.'!
!WeakSubscriptionBuilder categoriesForClass!Announcements-Core! !
!WeakSubscriptionBuilder methodsFor!

announcer: anAnnouncer
	announcer := anAnnouncer !

on: anAnnouncementClass do: aValuable
	"Do not use this message on announcer weak. We did not deprecated this method because it may break some behavior."
	self error: 'Not supported'!

on: anAnnouncementClass send: aSelector to: anObject
	^ self subscribe: anAnnouncementClass send: aSelector to: anObject!

subscribe: anAnnouncementClass do: aValuable 
	"Do not use this message on weak announcer because it does not work. The block will hold strongly the receiver and more.
	 We need ephemerons for that'"
	"aValuable isBlock ifTrue: [  
		self error: 'Do not use this message on weak and block because it does not work. We need ephemerons for that']."
	^	announcer basicSubscribe: (
			WeakAnnouncementSubscription new 
				announcer: announcer;
				announcementClass: anAnnouncementClass;
				valuable: aValuable)!

subscribe: anAnnouncementClass send: aSelector to: anObject
	^ self subscribe: anAnnouncementClass do: (WeakMessageSend receiver: anObject selector: aSelector)!

weak
	"already weak"
	^ self!

when: anAnnouncementClass do: aValuable
	"Do not use this message on announcer weak. We did not deprecated this method because it may break some behavior."
	self error: 'Not supported'!

when: anAnnouncementClass send: aSelector to: anObject
	^ self subscribe: anAnnouncementClass send: aSelector to: anObject! !
!WeakSubscriptionBuilder categoriesFor: #announcer:!initialize/release!public! !
!WeakSubscriptionBuilder categoriesFor: #on:do:!public!wrapped protocol! !
!WeakSubscriptionBuilder categoriesFor: #on:send:to:!public!wrapped protocol! !
!WeakSubscriptionBuilder categoriesFor: #subscribe:do:!private! !
!WeakSubscriptionBuilder categoriesFor: #subscribe:send:to:!public!wrapped protocol! !
!WeakSubscriptionBuilder categoriesFor: #weak!public!wrapped protocol! !
!WeakSubscriptionBuilder categoriesFor: #when:do:!public!wrapped protocol! !
!WeakSubscriptionBuilder categoriesFor: #when:send:to:!public!wrapped protocol! !

!WeakSubscriptionBuilder class methodsFor!

on: announcer
	^ self new announcer: announcer! !
!WeakSubscriptionBuilder class categoriesFor: #on:!instance creation!public! !

