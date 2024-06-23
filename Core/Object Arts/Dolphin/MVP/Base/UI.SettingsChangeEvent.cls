"Filed out from Dolphin Smalltalk"!

UI.WindowsEvent
	subclass: #'UI.SettingsChangeEvent'
	instanceVariableNames: 'area'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.SettingsChangeEvent guid: (Core.GUID fromString: '{8d98098a-b8d5-4e20-97c1-7410fb47c17f}')!

UI.SettingsChangeEvent comment: ''!

!UI.SettingsChangeEvent categoriesForClass!MVP-Views-Events! !

!UI.SettingsChangeEvent methodsFor!

area
	^area ifNil: [area := lParam == 0 ifTrue: ['All'] ifFalse: [Utf16String fromAddress: lParam]]!

isColorSetChange
	^self area = 'ImmersiveColorSet'!

isFontChange
	^wParam == SPI_SETICONTITLELOGFONT!

printLParamOn: aStream
	aStream print: self area!

uiAction
	^wParam! !

!UI.SettingsChangeEvent categoriesForMethods!
area!accessing!public! !
isColorSetChange!public!testing! !
isFontChange!public!testing! !
printLParamOn:!printing!public! !
uiAction!accessing!public! !
!

