"Filed out from Dolphin Smalltalk 7"!

UI.WindowsEvent subclass: #'UI.KeyEvent'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.KeyEvent guid: (Core.GUID fromString: '{87b4c54e-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.KeyEvent comment: ''!
!UI.KeyEvent categoriesForClass!Events!MVP-Views-Events! !
!UI.KeyEvent methodsFor!

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
!UI.KeyEvent categoriesFor: #code!accessing!public! !
!UI.KeyEvent categoriesFor: #data!accessing!public! !
!UI.KeyEvent categoriesFor: #isAlreadyDown!public!testing! !
!UI.KeyEvent categoriesFor: #isAltKeyDown!public!testing! !
!UI.KeyEvent categoriesFor: #isBeingReleased!public!testing! !
!UI.KeyEvent categoriesFor: #isExtended!public!testing! !
!UI.KeyEvent categoriesFor: #printLParamOn:!printing!public! !
!UI.KeyEvent categoriesFor: #repeatCount!accessing!public! !
!UI.KeyEvent categoriesFor: #scanCode!accessing!public! !

