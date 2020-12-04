"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.AnnouncementSubscription'
	instanceVariableNames: 'announcer announcementClass subscriber action'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.AnnouncementSubscription guid: (Core.GUID fromString: '{4a8f9aba-3fcf-4905-9d19-124f99040d7a}')!
Kernel.AnnouncementSubscription comment: 'The subscription is a single entry in a SubscriptionRegistry.
Several subscriptions by the same object is possible.

I know how to make myself weak or strong, only use this capability if it can''t be determined at subscribe time though, as it uses become: (for thread-safety), which is quite slow.'!
!Kernel.AnnouncementSubscription categoriesForClass!Announcements-Core! !
!Kernel.AnnouncementSubscription methodsFor!

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
		with: (WeakAnnouncementSubscription new
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
!Kernel.AnnouncementSubscription categoriesFor: #action!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #action:!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #announcementClass!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #announcementClass:!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #announcer!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #announcer:!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #deliver:!announcing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #handlesAnnouncement:!public!testing! !
!Kernel.AnnouncementSubscription categoriesFor: #makeStrong!converting!public! !
!Kernel.AnnouncementSubscription categoriesFor: #makeWeak!converting!public! !
!Kernel.AnnouncementSubscription categoriesFor: #subscriber!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #subscriber:!accessing!public! !
!Kernel.AnnouncementSubscription categoriesFor: #valuable:!accessing!public! !

