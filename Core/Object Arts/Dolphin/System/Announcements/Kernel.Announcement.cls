"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.Announcement'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Announcement guid: (Core.GUID fromString: '{12525b20-16ef-4684-b01e-956b227a429d}')!
Kernel.Announcement comment: 'This class is the superclass for events that someone might want to announce, such as a button click or an attribute change. Typically you create subclasses for your own events you want to announce.

 
'!
!Kernel.Announcement categoriesForClass!Announcements-Core! !
!Kernel.Announcement methodsFor!

asAnnouncement
	^ self! !
!Kernel.Announcement categoriesFor: #asAnnouncement!converting!public! !

!Kernel.Announcement class methodsFor!

, anAnnouncementClass
	^AnnouncementSet with: self with: anAnnouncementClass!

asAnnouncement
	^ self new!

handlesAnnouncement: anAnnouncement
	"The receiver acts as a filter to determine whether subscribers who used the receiver as signaling tag (event identifier class or symbol) should receive incoming announcement. In particular, registering to a superclass will receive the announcements from all subclasses."


	^ anAnnouncement class == self or: [ anAnnouncement class inheritsFrom: self ]! !
!Kernel.Announcement class categoriesFor: #,!public! !
!Kernel.Announcement class categoriesFor: #asAnnouncement!converting!public! !
!Kernel.Announcement class categoriesFor: #handlesAnnouncement:!public!testing! !

