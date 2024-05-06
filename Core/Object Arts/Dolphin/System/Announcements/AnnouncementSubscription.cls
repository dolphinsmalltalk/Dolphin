"Filed out from Dolphin Smalltalk"!

Object subclass: #AnnouncementSubscription
	instanceVariableNames: 'announcer announcementClass subscriber action'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AnnouncementSubscription guid: (GUID fromString: '{4a8f9aba-3fcf-4905-9d19-124f99040d7a}')!

AnnouncementSubscription comment: 'The subscription is a single entry in a SubscriptionRegistry.
Several subscriptions by the same object is possible.

I know how to make myself weak or strong, only use this capability if it can''t be determined at subscribe time though, as it uses become: (for thread-safety), which is quite slow.'!

!AnnouncementSubscription categoriesForClass!Announcements-Core! !

!AnnouncementSubscription methodsFor!

action

	^ action!

action: anObject

	action := anObject!

announcementClass

	^ announcementClass!

announcementClass: anObject

	announcementClass := anObject!

announcer

	^ announcer!

announcer: anAnnouncer
	announcer := anAnnouncer!

deliver: anAnnouncement 
	" deliver an announcement to receiver."

	^(self handlesAnnouncement: anAnnouncement) ifTrue: [action cull: anAnnouncement cull: announcer]!

handlesAnnouncement: anAnnouncement

	^ announcementClass handlesAnnouncement: anAnnouncement!

makeStrong
	" i am already strong. Do nothing "!

makeWeak
	^announcer replace: self
		with: ((WeakAnnouncementSubscription new)
				announcer: announcer;
				action: action asWeakMessageSend;
				subscriber: subscriber;
				announcementClass: announcementClass)!

subscriber
	^ subscriber!

subscriber: aSubscriber
	subscriber := aSubscriber!

valuable: aValuable
	"Used when subscriber should be extracted from valuable object"
	self action:  aValuable.
	self subscriber: aValuable announcementSubscriber.! !

!AnnouncementSubscription categoriesForMethods!
action!accessing!public! !
action:!accessing!public! !
announcementClass!accessing!public! !
announcementClass:!accessing!public! !
announcer!accessing!public! !
announcer:!accessing!public! !
deliver:!announcing!public! !
handlesAnnouncement:!public!testing! !
makeStrong!converting!public! !
makeWeak!converting!public! !
subscriber!accessing!public! !
subscriber:!accessing!public! !
valuable:!accessing!public! !
!

