﻿"Filed out from Dolphin Smalltalk"!

Core.Set
	variableSubclass: #'Kernel.AnnouncementSet'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.AnnouncementSet guid: (Core.GUID fromString: '{08b196a7-3cc4-4e21-82da-3e9b2c6baf34}')!

Kernel.AnnouncementSet comment: 'If you want to register the same action for multiple events, simply create an AnnouncementSet using a comma: 

	Parent>>initialize 
	    super initialize. 
	    self session announcer on: AddChild, RemoveChild do: [:it | self changeChild: it child]
	
Motivation example: Often the UI is built after/independently from the model. You want to have the model raise fine-grained announcements to enable the layers on top, but sometimes it is easier in the UI to refresh everything whenever something happens.'!

!Kernel.AnnouncementSet categoriesForClass!Announcements-Core! !

!Kernel.AnnouncementSet methodsFor!

, anAnnouncementClass
	self add: anAnnouncementClass!

handlesAnnouncement: anAnnouncement
	"If any of the set handles the announcements, subscribers should receive it."
	^ self anySatisfy: [ :each | each handlesAnnouncement: anAnnouncement ]! !

!Kernel.AnnouncementSet categoriesForMethods!
,!adding!public! !
handlesAnnouncement:!public!testing! !
!

