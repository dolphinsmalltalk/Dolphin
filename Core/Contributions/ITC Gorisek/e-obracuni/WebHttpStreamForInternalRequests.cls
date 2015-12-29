"Filed out from Dolphin Smalltalk X6.1"!

WebHttpStream subclass: #WebHttpStreamForInternalRequests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpStreamForInternalRequests guid: (GUID fromString: '{AC270AD8-EC70-47E9-A8C7-E8CC3CC379A9}')!
WebHttpStreamForInternalRequests comment: ''!
!WebHttpStreamForInternalRequests categoriesForClass!Unclassified! !
!WebHttpStreamForInternalRequests methodsFor!

isForRequestForInnerHtml
	^true!

on: aStream 
	contents := WriteStream on: (String new: 32768).
	isBytes := false!

sendResponse
	"do nothing"

	! !
!WebHttpStreamForInternalRequests categoriesFor: #isForRequestForInnerHtml!public!testing! !
!WebHttpStreamForInternalRequests categoriesFor: #on:!public! !
!WebHttpStreamForInternalRequests categoriesFor: #sendResponse!public! !

