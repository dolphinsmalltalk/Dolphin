"Filed out from Dolphin Smalltalk"!

Core.WeakArray
	variableSubclass: #'Kernel.WeakAnnouncementSubscription'
	instanceVariableNames: 'announcer announcementClass action'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.WeakAnnouncementSubscription guid: (Core.GUID fromString: '{d0e41596-8781-40bb-97fb-9ea63e7e7698}')!

Kernel.WeakAnnouncementSubscription comment: 'A WeakAnnouncementSubscription is a subscription which is removed automatically when the subscriber is unreferenced.

No support for ephemerons currently prevents this from working for Block actions (blocks hold their receiver, which is the default subscriber strongly). 

To switch between subscription types, use makeStrong/makeWeak on the subscription returned when initially registering with announcer.


Note, that list and next must be first instance variables.'!

!Kernel.WeakAnnouncementSubscription categoriesForClass!Announcements-Core! !

!Kernel.WeakAnnouncementSubscription methodsFor!

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
	"Deliver an announcement to receiver. In case of failure"

	^(self handlesAnnouncement: anAnnouncement) ifTrue: [action cull: anAnnouncement cull: announcer]!

handlesAnnouncement: anAnnouncement
	self nilCorpsesAndDo: [:index | ].
	^ (announcementClass handlesAnnouncement: anAnnouncement) and: [self subscriber notNil ]!

makeStrong
	| sub |
	sub := self subscriber.
	sub ifNil: [^self error: 'Subscriber is nil, cannot make strong subscription'].
	^announcer replace: self
		with: (AnnouncementSubscription new
				announcer: announcer;
				action: action asMessageSend;
				subscriber: sub;
				announcementClass: announcementClass)!

makeWeak
	^ self!

subscriber

	^ self basicAt: 1!

subscriber: anObject

	self subscriber ifNotNil: [ self error: 'subscriber already set' ].

	self basicAt: 1 put: anObject!

valuable: aValuable
	"Used when subscriber should be extracted from valuable object"
	self action:  aValuable.
	self subscriber: aValuable receiver.! !

!Kernel.WeakAnnouncementSubscription categoriesForMethods!
action!accessing!public! !
action:!accessing!public! !
announcementClass!accessing!public! !
announcementClass:!accessing!public! !
announcer!accessing!public! !
announcer:!accessing!public! !
deliver:!announcing!public! !
handlesAnnouncement:!error handling!public! !
makeStrong!converting!public! !
makeWeak!converting!public! !
subscriber!accessing!public! !
subscriber:!accessing!public! !
valuable:!accessing!public! !
!

!Kernel.WeakAnnouncementSubscription class methodsFor!

new
	^super new: 1! !

!Kernel.WeakAnnouncementSubscription class categoriesForMethods!
new!public! !
!

