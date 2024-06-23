"Filed out from Dolphin Smalltalk"!

VideoRecording subclass: #PVRRecording
	instanceVariableNames: 'episodeTitle description channel isViewed rating'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!PVRRecording categoriesForMethods!
channel!accessing!private! !
channel:!accessing!private! !
description!accessing!private! !
description:!accessing!private! !
episodeTitle!accessing!private! !
episodeTitle:!accessing!private! !
initialize!initializing!private! !
isViewed!accessing!private! !
isViewed:!accessing!private! !
rating!accessing!private! !
rating:!accessing!private! !
titleAndEpisode!accessing!public! !
!

