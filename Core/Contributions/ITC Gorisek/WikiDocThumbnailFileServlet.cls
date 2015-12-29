"Filed out from Dolphin Smalltalk X6.1"!

WikiDocImageFileServlet subclass: #WikiDocThumbnailFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocThumbnailFileServlet guid: (GUID fromString: '{6E52AA42-EC18-4677-A340-BBCF3FA2FA89}')!
WikiDocThumbnailFileServlet comment: ''!
!WikiDocThumbnailFileServlet categoriesForClass!Unclassified! !
!WikiDocThumbnailFileServlet methodsFor!

getImageBytesFor: aWikiDocImage 
	^aWikiDocImage thumbnailBytes isNil 
		ifTrue: [aWikiDocImage imageBytes]
		ifFalse: [aWikiDocImage thumbnailBytes]!

urlPrefix: aString 
	numberOfCharactersToCut := aString size + 2 + '/thumbnails-small/' size.
	urlPrefix := aString! !
!WikiDocThumbnailFileServlet categoriesFor: #getImageBytesFor:!public! !
!WikiDocThumbnailFileServlet categoriesFor: #urlPrefix:!public! !

!WikiDocThumbnailFileServlet class methodsFor!

servletName
	^'thumbnails'! !
!WikiDocThumbnailFileServlet class categoriesFor: #servletName!public! !

