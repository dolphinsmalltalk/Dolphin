"Filed out from Dolphin Smalltalk X6.1"!

WikiDocUpload subclass: #WikiDocImage
	instanceVariableNames: 'width height imageName imageBytes thumbnailBytes'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocImage guid: (GUID fromString: '{F3A9B449-9A44-4C35-9F81-66C3C616E70E}')!
WikiDocImage comment: ''!
!WikiDocImage categoriesForClass!Unclassified! !
!WikiDocImage methodsFor!

fileSize
	^imageBytes isNil ifTrue: [0] ifFalse: [imageBytes size]!

getImageTagMaxWidth: maxWidth maxHeight: maxHeight border: border alt: altString 
	| w h ws |
	ws := WriteStream on: (String new: 128).
	ws
		nextPutAll: '<img src="wiki-images/';
		nextPutAll: imageName webHtmlEncodedForForm;
		nextPutAll: '" border="';
		nextPutAll: border printString.
	width notNil 
		ifTrue: 
			[w := width.
			h := height.
			maxWidth notNil 
				ifTrue: 
					[w > maxWidth 
						ifTrue: 
							[h := h / (w / maxWidth).
							w := maxWidth].
					h > maxHeight 
						ifTrue: 
							[w := w / (h / maxHeight).
							h := maxHeight]].
			ws nextPutAll: '" width="' , w asInteger asWebString , '" height="' , h asInteger asWebString].
	altString isNil 
		ifFalse: 
			[ws
				nextPutAll: '" alt="';
				nextPutAll: altString webHtmlEncodedForForm].
	ws nextPutAll: '"/>'.
	^ws contents!

height
	^height!

height: anObject
	height := anObject!

imageBytes
	^imageBytes!

imageBytes: anObject 
	imageBytes := anObject asByteArray!

imageName
	^imageName!

imageName: anObject
	imageName := anObject!

thumbnailBytes
	^thumbnailBytes!

thumbnailBytes: anObject 
	thumbnailBytes := anObject isNil ifTrue: [nil] ifFalse: [anObject asByteArray]!

width
	^width!

width: anObject
	width := anObject! !
!WikiDocImage categoriesFor: #fileSize!accessing!private! !
!WikiDocImage categoriesFor: #getImageTagMaxWidth:maxHeight:border:alt:!accessing!public! !
!WikiDocImage categoriesFor: #height!accessing!private! !
!WikiDocImage categoriesFor: #height:!accessing!private! !
!WikiDocImage categoriesFor: #imageBytes!accessing!private! !
!WikiDocImage categoriesFor: #imageBytes:!accessing!private! !
!WikiDocImage categoriesFor: #imageName!accessing!private! !
!WikiDocImage categoriesFor: #imageName:!accessing!private! !
!WikiDocImage categoriesFor: #thumbnailBytes!accessing!public! !
!WikiDocImage categoriesFor: #thumbnailBytes:!accessing!public! !
!WikiDocImage categoriesFor: #width!accessing!private! !
!WikiDocImage categoriesFor: #width:!accessing!private! !

!WikiDocImage class methodsFor!

getThumbnailBytesForImage: wikiDocImage application: application 
	^wikiDocImage imageBytes isNil 
		ifFalse: 
			[ItcSystemManager 
				getThumbnailBytesForImageNamed: wikiDocImage imageName
				imageBytes: wikiDocImage imageBytes
				application: application
				maxWidth: self maxThumbnailWidth
				maxHeight: self maxThumbnailHeight]!

maxThumbnailHeight
	^100!

maxThumbnailWidth
	^160! !
!WikiDocImage class categoriesFor: #getThumbnailBytesForImage:application:!public! !
!WikiDocImage class categoriesFor: #maxThumbnailHeight!public! !
!WikiDocImage class categoriesFor: #maxThumbnailWidth!public! !

