"Filed out from Dolphin Smalltalk X6.1"!

HtmlForm subclass: #HtmlFileUploadForm
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlFileUploadForm guid: (GUID fromString: '{690B799F-70A3-4D14-99FA-053153BC6025}')!
HtmlFileUploadForm comment: ''!
!HtmlFileUploadForm categoriesForClass!Unclassified! !
!HtmlFileUploadForm methodsFor!

generateOn: aStream 
	aStream nextPutAll: '<form action="'.
	action printWebUrlOn: aStream.
	aStream nextPutAll: '" name="' , (name isNil ifTrue: ['f'] ifFalse: [name]) 
				, '" enctype="multipart/form-data" method="post">'.
	contents isNil ifFalse: [contents do: [:each | each generateOn: aStream]].
	aStream nextPutAll: '</form>'! !
!HtmlFileUploadForm categoriesFor: #generateOn:!public! !

