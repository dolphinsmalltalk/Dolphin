"Filed out from Dolphin Smalltalk X6.1"!

HtmlContainer subclass: #HtmlForm
	instanceVariableNames: 'action target name'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlForm guid: (GUID fromString: '{A79E8CB0-51B2-4425-A64C-FE2D1DFE777B}')!
HtmlForm comment: ''!
!HtmlForm categoriesForClass!Unclassified! !
!HtmlForm methodsFor!

action: url 
	action := url!

generateOn: aStream 
	aStream nextPutAll: '<form action="'.
	action printWebUrlOn: aStream.
	aStream
		nextPutAll: '" name="';
		nextPutAll: (name isNil ifTrue: ['form'] ifFalse: [name]).
	self elementId isNilOrEmpty 
		ifFalse: 
			[aStream
				nextPutAll: '" id="';
				nextPutAll: self elementId].
	cssStyle isNilOrEmpty ifFalse: [aStream nextPutAll: '" style="' , cssStyle].
	(target isNil or: [target isEmpty]) 
		ifTrue: [aStream nextPutAll: '" method="post">']
		ifFalse: [aStream nextPutAll: '" target="' , target , '" method="post">'].
	super generateOn: aStream.
	aStream nextPutAll: '</form>'!

name: formName 
	name := formName!

target: aString 
	target := aString! !
!HtmlForm categoriesFor: #action:!public! !
!HtmlForm categoriesFor: #generateOn:!public! !
!HtmlForm categoriesFor: #name:!public! !
!HtmlForm categoriesFor: #target:!public! !

!HtmlForm class methodsFor!

action: aWebServletClass

	^self new action: aWebServletClass!

name: aString action: aWebServletClass

	^self new name: aString; action: aWebServletClass! !
!HtmlForm class categoriesFor: #action:!public! !
!HtmlForm class categoriesFor: #name:action:!public! !

