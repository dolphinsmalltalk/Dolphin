"Filed out from Dolphin Smalltalk 7"!

VideoRecording subclass: #PVRRecording
	instanceVariableNames: 'episodeTitle description channel isViewed rating'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
PVRRecording guid: (GUID fromString: '{afe83110-1d7c-46c1-811c-bc5a22c18ecb}')!
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
	rating := anObject!

titleAndEpisode

	^'Title: <1s><N>Episode: <2s>'expandMacrosWith: (self title ifNil: ['-']) with: (self episodeTitle ifNil: ['-'])! !
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
!PVRRecording categoriesFor: #titleAndEpisode!accessing!public! !

