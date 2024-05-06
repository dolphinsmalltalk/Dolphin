"Filed out from Dolphin Smalltalk"!

Object subclass: #MessageBoxAbstract
	instanceVariableNames: 'text caption owner'
	classVariableNames: 'DefaultCaptions IconStyles'
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''!

MessageBoxAbstract guid: (GUID fromString: '{32ce06b2-35c6-41eb-a41f-6b20f935676d}')!

MessageBoxAbstract isAbstract: true!

MessageBoxAbstract comment: 'MessageBoxAbstract is the abstract class of dialogs that display a message to the user to acknowledge. Subclasses might include a number of responses that the user can make, typically by pressing buttons, making them useful for asking questions as well as displaying informational messages.

Instance Variables:
	text			<String>. Message text.
	caption		<String>. Caption text.
	owner		<view>

Class Variables:
	DefaultCaptions		<LookupTable> mapping <integer> message box iocn styles (e.g. MB_ICONQUESTION) to caption <String>s
	IconStyles			<IdentityDictionary>

'!

!MessageBoxAbstract categoriesForClass!Kernel-Objects! !

!MessageBoxAbstract methodsFor!

beep
	"Private - Play the system parp appropriate for the style of the receiver."

	| iStyle |
	iStyle := self iconStyleFlag.
	iStyle = 0 ifFalse: [UserLibrary default messageBeep: iStyle]!

caption
	"Answer the receiver's current caption."

	^caption ifNil: [self defaultCaption]!

caption: aString 
	"Set the receiver's caption to be the argument, aString."

	caption := aString!

defaultCaption
	^self class defaultCaption: self iconStyle!

errorMsg: textString 
	"Display a Windows message box for the receiver with the currently
	configured caption, and the error message, textString. Answer the 
	receiver (after the message box has closed)."

	self text: textString.
	self iconStyle: #error.
	^self open!

iconStyle
	"Answer the receiver's symbolic icon style name."

	^IconStyles keyAtValue: self iconStyleFlag!

iconStyle: aSymbol 
	"Set the receiver's icon style to that named by the argument."

	self iconStyleFlag: (IconStyles at: aSymbol)!

iconStyleFlag
	"Private - Answer the  icon style flag of the receiver (an integer from the MB_ICONXXX enumeration)."

	^self subclassResponsibility!

iconStyleFlag: anInteger 
	"Private - Set the receiver's icon to be that named by the argument."

	^self subclassResponsibility!

notify: notifyString 
	"Display a bubble message box with the current caption, the
	notification icon, and the specified informational message."

	self text: notifyString.
	self iconStyle: #notify.
	^self open!

open
	"Display the message box for the receiver, and answer a portable symbolic constant 
	for the button pressed by the user."

	^self subclassResponsibility!

owner
	^owner!

owner: aViewOrHandle 
	"Set the receiver's owning window handle to be the argument, aHandle.
	aHandle can be 0 if desired. If the handle is not explicitly set to 0,
	then the current active window handle will be used."

	owner := aViewOrHandle!

ownerHandle
	| handle |
	handle := owner ifNil: [UserLibrary default getActiveWindow] ifNotNil: [owner].
	^handle notNil ifTrue: [handle asParameter] ifFalse: [0]!

text
	^text!

text: aString 
	"Set the receiver's text message to be the argument, aString."

	text := aString!

warning: warningString 
	"Display a Windows message box for the receiver with the currently configured caption,
	and the warning message, warningString, and an OK button. Answer the receiver (after 
	the message box has closed)."

	self text: warningString.
	self iconStyle: #warning.
	^self open! !

!MessageBoxAbstract categoriesForMethods!
beep!parping!private! !
caption!accessing!public! !
caption:!accessing!public! !
defaultCaption!constants!private! !
errorMsg:!operations!public! !
iconStyle!accessing-styles!public! !
iconStyle:!accessing-styles!public! !
iconStyleFlag!accessing-styles!private! !
iconStyleFlag:!accessing-styles!private! !
notify:!operations!public! !
open!displaying!public! !
owner!accessing!public! !
owner:!accessing!public! !
ownerHandle!accessing!private! !
text!accessing!public! !
text:!accessing!public! !
warning:!operations!public! !
!

!MessageBoxAbstract class methodsFor!

defaultCaption: aSymbol
	"Private - Answer a suitable default caption based on style of the 
	message box."

	^DefaultCaptions at: aSymbol ifAbsent: [SessionManager current applicationName]!

errorMsg: aString 
	"Display a message with the default error caption, standard error icon, the specified
	<readableString> error message, and an OK button. Answer the receiver."

	self errorMsg: aString caption: nil!

errorMsg: errorString caption: titleString 
	"Display a Windows balloon tooltip for the receiver with the specified <readableString>
	caption, standard error icon, the specified <readableString> error message, and an OK button."

	(self new)
		caption: titleString;
		errorMsg: errorString!

initialize
	"Private - Initialize the class variables of the receiver:
		self initialize

	"

	IconStyles := (IdentityDictionary new)
				at: #none put: 0;
				at: #error put: MB_ICONERROR;
				at: #prompt put: MB_ICONQUESTION;
				at: #warning put: MB_ICONWARNING;
				at: #notify put: MB_ICONINFORMATION;
				at: #user put: MB_USERICON;
				shrink;
				yourself.

	"Where there is no entry in the table for the message box type, the application name is used."
	DefaultCaptions := (IdentityDictionary new)
				at: #confirm put: 'Please confirm...';
				at: #notify put: 'Note';
				shrink;
				yourself	"Use the Windows default caption"!

new
	"Answer a new, initialized, instance of the receiver."

	^super new initialize!

notify: aString 
	"Display a message with the default information caption, standard information icon,  the
	specified <readableString> message, and an OK button."

	self notify: aString caption: nil!

notify: notifyString caption: titleString
	"Display a message with the specified <readableString> caption, standard information icon,
	and the specified <readableString> message."

	^self new 
		caption: titleString;
		notify: notifyString!

warning: aString 
	"Display a message with the default warning caption, standard warning icon, the specified
	<readableString> warning message, and an OK button. Answer the receiver."

	self warning: aString caption: nil!

warning: warningString caption: titleString 
	"Display a Windows balloon tooltip for the receiver with the specified <readableString>
	caption, standard warning icon, the specified <readableString> warning message, and an OK
	button."

	(self new)
		caption: titleString;
		warning: warningString! !

!MessageBoxAbstract class categoriesForMethods!
defaultCaption:!constants!private! !
errorMsg:!instance creation!public! !
errorMsg:caption:!instance creation!public! !
initialize!development!initializing!public! !
new!instance creation!public! !
notify:!instance creation!public! !
notify:caption:!instance creation!public! !
warning:!instance creation!public! !
warning:caption:!instance creation!public! !
!

