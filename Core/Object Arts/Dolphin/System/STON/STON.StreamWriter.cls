"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'STON.StreamWriter'
	instanceVariableNames: 'writer first'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.StreamWriter guid: (Core.GUID fromString: '{6bdb0b54-8382-4d5b-b901-b52c3b1fdb07}')!
STON.StreamWriter comment: 'STONStreamWriter helps in streaming writing STON representations.
This is an abstract class.'!
!STON.StreamWriter categoriesForClass!STON-Core-Writer! !
!STON.StreamWriter methodsFor!

initialize
	super initialize.
	first := true!

on: stonWriter
	writer := stonWriter! !
!STON.StreamWriter categoriesFor: #initialize!initialize/release!public! !
!STON.StreamWriter categoriesFor: #on:!initialize/release!public! !

!STON.StreamWriter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^STON icon!

new
	^super new initialize!

on: stonWriter
	^ self new
		on: stonWriter;
		yourself! !
!STON.StreamWriter class categoriesFor: #icon!constants!public! !
!STON.StreamWriter class categoriesFor: #new!public! !
!STON.StreamWriter class categoriesFor: #on:!instance creation!public! !

