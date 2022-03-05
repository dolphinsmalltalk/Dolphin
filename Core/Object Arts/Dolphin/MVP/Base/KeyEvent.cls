"Filed out from Dolphin Smalltalk"!

WindowsEvent subclass: #KeyEvent
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
KeyEvent guid: (GUID fromString: '{87b4c54e-026e-11d3-9fd7-00a0cc3e4a32}')!
KeyEvent comment: ''!
!KeyEvent categoriesForClass!Events!MVP-Views-Events! !
!KeyEvent methodsFor!

code
	"Answer the code part of the message."

	^self wParam!

data
	"Answer the data part of the message."

	^self lParam!

isAlreadyDown
	"Answer whether the key was already down."

	^self data isBitSet: 30!

isAltKeyDown
	"Answer whether the alt key is down."

	^self data isBitSet: 29!

isBeingReleased
	"Answer whether the key is being released."

	^self data isBitSet: 31!

isExtended
	"Answer whether the key is an extended key."

	^self data isBitSet: 24!

printLParamOn: aStream
	"Append a localised textual representation of the receiver's key name."

	aStream print: (Keyboard default keyNameFromLParam: self lParam)!

repeatCount
	"Answer the repeat count."

	^self data lowWord!

scanCode
	"Answer the scan code."

	^self data highWord bitAnd: 16rFF! !
!KeyEvent categoriesForMethods!
code!accessing!public! !
data!accessing!public! !
isAlreadyDown!public!testing! !
isAltKeyDown!public!testing! !
isBeingReleased!public!testing! !
isExtended!public!testing! !
printLParamOn:!printing!public! !
repeatCount!accessing!public! !
scanCode!accessing!public! !
!

