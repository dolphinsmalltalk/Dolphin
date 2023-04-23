"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.MessageBoxAbstract'
	instanceVariableNames: 'text caption owner'
	classVariableNames: ''
	imports: #(#{OS.MessageBoxConstants})
	classInstanceVariableNames: 'defaultCaptions'
	classConstants: {
			'IconStyles'
				-> (IdentityDictionary withAll: {
								#error -> 16r10.
								#none -> 16r0.
								#notify -> 16r40.
								#prompt -> 16r20.
								#user -> 16r80.
								#warning -> 16r30
							})
		}!
UI.MessageBoxAbstract guid: (Core.GUID fromString: '{32ce06b2-35c6-41eb-a41f-6b20f935676d}')!
UI.MessageBoxAbstract isNonInstantiable: true!
UI.MessageBoxAbstract comment: 'MessageBoxAbstract is the abstract class of dialogs that display a message to the user to acknowledge. Subclasses might include a number of responses that the user can make, typically by pressing buttons, making them useful for asking questions as well as displaying informational messages.

Instance Variables:
	text			<String>. Message text.
	caption		<String>. Caption text.
	owner		<view>

Class Variables:
	DefaultCaptions		<LookupTable> mapping <integer> message box iocn styles (e.g. MB_ICONQUESTION) to caption <String>s
	IconStyles			<IdentityDictionary>

'!
!UI.MessageBoxAbstract categoriesForClass!Kernel-Objects! !
!UI.MessageBoxAbstract methodsFor!

areLinksParsed
	"Answer whether hyperlinks in the text will be intepreted as links."

	^self subclassResponsibility!

areLinksParsed: aBoolean
	"Set whether hyperlinks in the text will be intepreted as links."

	self subclassResponsibility!

beep
	"Private - Play the system parp appropriate for the style of the receiver."

	self isSilent ifFalse: [User32 messageBeep: self iconStyleFlag]!

caption
	"Answer the receiver's current caption."

	^caption ifNil: [self defaultCaption]!

caption: aString 
	"Set the receiver's caption to be the argument, aString."

	caption := aString!

defaultCaption
	^self class defaultCaption: self iconStyle!

errorMsg
	self hasIcon ifFalse: [self iconStyle: #error].
	^self open!

errorMsg: textString
	"Display a Windows message box for the receiver with the currently configured caption, and the error message, textString. Answer the <Symbol> name of the button pressed to close the dialog (usually #ok)."

	self text: textString.
	^self errorMsg!

exceptionDescription: anException
	self
		iconStyle: anException iconStyle;
		text: anException displayString!

hasIcon
	^self iconStyle ~~ #none!

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

isSilent
	"Answer whether the bubble will remain silent when opened. The default is to beep in an appropriate way depending on the icon style."

	^self iconStyleFlag = 0!

notify
	self hasIcon ifFalse: [self iconStyle: #notify].
	^self open!

notify: notifyString
	"Display a bubble message box with the current caption, the notification icon, and the specified informational message. Answer the <Symbol> name of the button pressed to close the dialog (usually #ok)."

	self text: notifyString.
	^self notify!

open
	"Display the message box for the receiver, and answer a portable symbolic constant for the button pressed by the user.
	Answer the <Symbol> name of the button pressed to close the dialog."

	^self subclassResponsibility!

owner
	^owner!

owner: aViewOrHandle 
	"Set the receiver's owning window handle to be the argument, aHandle.
	aHandle can be 0 if desired. If the handle is not explicitly set to 0,
	then the current active window handle will be used."

	owner := aViewOrHandle!

ownerHandle
	^owner ifNil: [User32 getActiveWindow ?? 0] ifNotNil: [owner asParameter]!

text
	^text!

text: aString 
	"Set the receiver's text message to be the argument, aString."

	text := aString!

warning
	self hasIcon ifFalse: [self iconStyle: #warning].
	^self open!

warning: warningString
	"Display a Windows message box for the receiver with the currently configured caption, and the warning message, warningString, and an OK button. Answer the <Symbol> name of the button pressed to close the dialog (usually #ok)."

	self text: warningString.
	^self warning! !
!UI.MessageBoxAbstract categoriesForMethods!
areLinksParsed!accessing-styles!public!testing! !
areLinksParsed:!accessing-styles!public! !
beep!parping!private! !
caption!accessing!public! !
caption:!accessing!public! !
defaultCaption!constants!private! !
errorMsg!public! !
errorMsg:!operations!public! !
exceptionDescription:!accessing!public! !
hasIcon!accessing-styles!public!testing! !
iconStyle!accessing-styles!public! !
iconStyle:!accessing-styles!public! !
iconStyleFlag!accessing-styles!private! !
iconStyleFlag:!accessing-styles!private! !
isSilent!parping!public!testing! !
notify!operations!public! !
notify:!operations!public! !
open!displaying!public! !
owner!accessing!public! !
owner:!accessing!public! !
ownerHandle!accessing!private! !
text!accessing!public! !
text:!accessing!public! !
warning!operations!public! !
warning:!operations!public! !
!

!UI.MessageBoxAbstract class methodsFor!

defaultCaption: aSymbol
	"Private - Answer a suitable default caption based on style of the 
	message box."

	^defaultCaptions at: aSymbol ifAbsent: [SessionManager current applicationName]!

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
!UI.MessageBoxAbstract class categoriesForMethods!
defaultCaption:!constants!private! !
errorMsg:!instance creation!public! !
errorMsg:caption:!instance creation!public! !
new!instance creation!public! !
notify:!instance creation!public! !
notify:caption:!instance creation!public! !
warning:!instance creation!public! !
warning:caption:!instance creation!public! !
!

