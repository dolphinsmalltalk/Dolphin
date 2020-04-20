"Filed out from Dolphin Smalltalk 7"!

StToken subclass: #StQualifiedReferenceToken
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StQualifiedReferenceToken guid: (GUID fromString: '{308a8293-d6ec-4807-b588-16243c627507}')!
StQualifiedReferenceToken comment: '`StQualifiedReferenceToken` is a kind of `StToken` to represent the opening special character sequence, #{, of a qualified reference literal.'!
!StQualifiedReferenceToken categoriesForClass!System-Compiler! !
!StQualifiedReferenceToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitQualifiedReferenceToken: self!

isQualifiedReference
	^true!

length
	^2! !
!StQualifiedReferenceToken categoriesFor: #acceptVisitor:!public!visitor! !
!StQualifiedReferenceToken categoriesFor: #isQualifiedReference!helpers!public!testing! !
!StQualifiedReferenceToken categoriesFor: #length!accessing!public! !

!StQualifiedReferenceToken class methodsFor!

start: startInteger comments: aCollectionOrNil value: aString stop: stopInteger
	<primitive: 157>
	^self new
		start: startInteger;
		comments: aCollectionOrNil;
		value: aString;
		stop: stopInteger;
		yourself
! !
!StQualifiedReferenceToken class categoriesFor: #start:comments:value:stop:!instance creation!public! !

