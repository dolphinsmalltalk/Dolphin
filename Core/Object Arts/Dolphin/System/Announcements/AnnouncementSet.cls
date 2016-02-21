"Filed out from Dolphin Smalltalk 7"!

Set variableSubclass: #AnnouncementSet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnnouncementSet guid: (GUID fromString: '{08B196A7-3CC4-4E21-82DA-3E9B2C6BAF34}')!
AnnouncementSet comment: 'If you want to register the same action for multiple events, simply create an AnnouncementSet using a comma: 	Parent>>initialize 	    super initialize. 	    self session announcer on: AddChild, RemoveChild do: [:it | self changeChild: it child]	Motivation example: Often the UI is built after/independently from the model. You want to have the model raise fine-grained announcements to enable the layers on top, but sometimes it is easier in the UI to refresh everything whenever something happens.'!
!AnnouncementSet categoriesForClass!Announcements-Core! !
!AnnouncementSet methodsFor!

, anAnnouncementClass	self add: anAnnouncementClass!

handlesAnnouncement: anAnnouncement	"If any of the set handles the announcements, subscribers should receive it."	^ self anySatisfy: [ :each | each handlesAnnouncement: anAnnouncement ]! !
!AnnouncementSet categoriesFor: #,!adding!public! !
!AnnouncementSet categoriesFor: #handlesAnnouncement:!public!testing! !

