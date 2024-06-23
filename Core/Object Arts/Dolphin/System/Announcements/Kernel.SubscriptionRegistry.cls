"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.SubscriptionRegistry'
	instanceVariableNames: 'subscriptions monitor'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.SubscriptionRegistry guid: (Core.GUID fromString: '{a785d939-edab-48ad-b4a7-0bf0a69ec5f3}')!

Kernel.SubscriptionRegistry comment: 'The subscription registry is a threadsafe storage for the subscriptions to an Announcer.

In Pharo, subscriptionsFor: protocol is not implemented.
This is because Announcer does not provide public access to its registry for encapsulation reasons.
(We do not want access to the announcer from action blocks to break encapsulation to other subscribers)'!

!Kernel.SubscriptionRegistry categoriesForClass!Announcements-Core! !

!Kernel.SubscriptionRegistry methodsFor!

add: subscription
	^ self protected: [
		subscriptions add: subscription  ]
!

deliver: anAnnouncement
	|  interestedSubscriptions |
	
	"using a copy, so subscribers can unsubscribe from announcer "
	
	subscriptions isEmpty ifTrue: [ ^ self ].
	self protected: [ 
		interestedSubscriptions := self subscriptionsHandling: anAnnouncement ].
	self deliver: anAnnouncement to: interestedSubscriptions!

deliver: anAnnouncement to: subs
	^ self deliver: anAnnouncement to: subs startingAt: 1!

deliver: anAnnouncement to: subs startingAt: startIndex
	
	startIndex to: subs size do: [ :index| | subscription |
		subscription := subs at: index.
		[ subscription deliver: anAnnouncement ] 
			"Ensure delivery to remaining announcements"
			ifCurtailed: [
				self deliver: anAnnouncement to: subs startingAt: index + 1 ]]!

glmSubscriptions
	^ subscriptions!

initialize
	monitor := Semaphore forMutualExclusion.
	self reset!

numberOfSubscriptions
	^ subscriptions size!

protected: aBlock
	^ monitor critical: [ aBlock value ]!

remove: subscription
	^ self protected: [
		subscriptions remove: subscription ifAbsent: nil ]

!

removeSubscriber: subscriber
	
	^ self protected: [
		subscriptions removeAllSuchThat: [:subscription | subscription subscriber == subscriber ]]

!

replace: subscription with: newOne

	" Note that it will signal an error if subscription is not there "
	self protected: [
		subscriptions remove: subscription.
		subscriptions add: newOne 
	].
	^ newOne!

reset
	"subscriber -> subscriptions"

	subscriptions := IdentitySet new!

subscriptionsHandling: anAnnouncement
	^Array streamContents: 
			[:s |
			subscriptions do: [:each | (each handlesAnnouncement: anAnnouncement) ifTrue: [s nextPut: each]]]!

subscriptionsOf: aSubscriber do: aBlock
	| copy |
	
	self protected: [ copy := subscriptions copy ].
	
	copy do: 
		[:subscription | 
			subscription subscriber == aSubscriber 
				ifTrue: [ aBlock value: subscription ]	]
! !

!Kernel.SubscriptionRegistry categoriesForMethods!
add:!add/remove!public! !
deliver:!announcing!public! !
deliver:to:!private! !
deliver:to:startingAt:!private! !
glmSubscriptions!public! !
initialize!initialization!public! !
numberOfSubscriptions!accessing!public! !
protected:!private! !
remove:!add/remove!public! !
removeSubscriber:!add/remove!public! !
replace:with:!add/remove!public! !
reset!initialize/release!public! !
subscriptionsHandling:!accessing!public! !
subscriptionsOf:do:!iterating!public! !
!

!Kernel.SubscriptionRegistry class methodsFor!

new	
	^super new initialize! !

!Kernel.SubscriptionRegistry class categoriesForMethods!
new!public! !
!

