"Filed out from Dolphin Smalltalk"!

Object subclass: #Announcement
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Announcement guid: (GUID fromString: '{12525b20-16ef-4684-b01e-956b227a429d}')!
Announcement comment: 'This class is the superclass for events that someone might want to announce, such as a button click or an attribute change. Typically you create subclasses for your own events you want to announce.

 
'!
!Announcement categoriesForClass!Announcements-Core! !
!Announcement methodsFor!

asAnnouncement
	^ self! !
!Announcement categoriesForMethods!
asAnnouncement!converting!public! !
!

!Announcement class methodsFor!

, anAnnouncementClass
	^ AnnouncementSet with: self with: anAnnouncementClass!

asAnnouncement
	^ self new!

handlesAnnouncement: anAnnouncement
	"The receiver acts as a filter to determine whether subscribers who used the receiver as signaling tag (event identifier class or symbol) should receive incoming announcement. In particular, registering to a superclass will receive the announcements from all subclasses."


	^ anAnnouncement class == self or: [ anAnnouncement class inheritsFrom: self ]! !
!Announcement class categoriesForMethods!
,!public! !
asAnnouncement!converting!public! !
handlesAnnouncement:!public!testing! !
!

