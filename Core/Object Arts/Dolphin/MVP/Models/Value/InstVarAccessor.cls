"Filed out from Dolphin Smalltalk 2000 release 5.00"!

IndexedInstVarAccessor subclass: #InstVarAccessor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InstVarAccessor guid: (GUID fromString: '{DA630AC6-C186-11D5-9849-0800460222F0}')!
InstVarAccessor comment: ''!
!InstVarAccessor categoriesForClass!MVP-Models! !
!InstVarAccessor methodsFor!

instVarName
	"Answer the name of the instance variable"
	
	self key=0 ifTrue: [^#self].
	^self subject class allInstVarNames at: self key!

subject: anObject key: aKey
	"Private - Sets the subject object and the key being used to access an element of it"

	super subject: anObject key: aKey.
	getSelector := #instVarAt:.
	putSelector := #instVarAt:put:.

! !
!InstVarAccessor categoriesFor: #instVarName!accessing!public! !
!InstVarAccessor categoriesFor: #subject:key:!initializing!private! !

