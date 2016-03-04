"Filed out from Dolphin Smalltalk 7"!

VideoRecording subclass: #PVRRecording
	instanceVariableNames: 'episodeTitle description channel isViewed rating'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PVRRecording guid: (GUID fromString: '{AFE83110-1D7C-46C1-811C-BC5A22C18ECB}')!
PVRRecording comment: ''!
!PVRRecording categoriesForClass!Samples! !
!PVRRecording methodsFor!

channel
	^channel!

channel: anObject
	channel := anObject!

description
	^description!

description: anObject
	description := anObject!

episodeTitle
	^episodeTitle!

episodeTitle: anObject
	episodeTitle := anObject!

initialize

	self isViewed: false!

isViewed
	^isViewed!

isViewed: anObject
	isViewed := anObject!

rating
	^rating!

rating: anObject
	rating := anObject! !
!PVRRecording categoriesFor: #channel!accessing!private! !
!PVRRecording categoriesFor: #channel:!accessing!private! !
!PVRRecording categoriesFor: #description!accessing!private! !
!PVRRecording categoriesFor: #description:!accessing!private! !
!PVRRecording categoriesFor: #episodeTitle!accessing!private! !
!PVRRecording categoriesFor: #episodeTitle:!accessing!private! !
!PVRRecording categoriesFor: #initialize!initializing!private! !
!PVRRecording categoriesFor: #isViewed!accessing!private! !
!PVRRecording categoriesFor: #isViewed:!accessing!private! !
!PVRRecording categoriesFor: #rating!accessing!private! !
!PVRRecording categoriesFor: #rating:!accessing!private! !

