"Filed out from Dolphin Smalltalk"!

UI.ControlView subclass: #'UI.CommandButton'
	instanceVariableNames: 'commandDescription'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'StandardCommands' -> (IdentityDictionary withAll: {#cancel -> 16r2. #continue -> 16rB. #retry -> 16rA. #abort -> 16r3. #yes -> 16r6. #help -> 16r9. #no -> 16r7. #ignore -> 16r5. #close -> 16r8})
	}!
UI.CommandButton guid: (Core.GUID fromString: '{7e1607a8-cdec-4c98-b2a8-c1376e58380e}')!
UI.CommandButton comment: 'CommandButton is the abstract class of <ControlView>s that act as <commandSource>s, holding a <CommandDescription> detailing the command that should be fired when the button is clicked. The command is subject to the normal command routing followed by all commands in Dolphin, e.g. those initiated from menus, toolbars and keyboard accelerators. See the <CommandDescription> comment for further details.

Concrete subclasses provide implementations based on the Windows BUTTON (PushButton) and SysLink (LinkButton) controls.

Instance Variables:
	commandDescription	<CommandDescription> detailing the command to fire.

Class Variables:
	StandardCommands	<IdentityDictionary> map of <selector>s to standard button IDs.
'!
!UI.CommandButton categoriesForClass!MVP-Resources-Buttons!MVP-Views! !
!UI.CommandButton methodsFor!

command
	"Answer the <commandMessage> which is triggered when the receiver is pushed."

	^commandDescription command!

command: aCommandMessage 
	"Sets the command associated with the receiver to the <commandMessage> argument."

	commandDescription command: aCommandMessage!

commandDescription
	^commandDescription!

commandDescription: anObject
	commandDescription := anObject!

commandSource
	"Answer the <View> which is considered the source (and therefore typically the <commandTarget>
	at the head of the command route) of the receiver's action command. PushButtons themselves do
	not implement their own commands, so we might as well start in the parent."

	^self parentView!

defaultExtent
	"Private - Answer the default size of the receiver
	to be used when it is created."

	^##(100 @ 35)!

defaultId
	"Private - Answer the <integer> id to be used when the receiver is created as a child window."

	^StandardCommands at: self command ifAbsent: [super defaultId]!

displayOnFormats
	"Private - Answers a collection of selectors that can be used to determine how the receiver is
	represented as a textual display string by #displayOn:. These selectors are sent in turn
	until one yields a non-nil, non-empty, string as a result"

	^#(#command) , super displayOnFormats!

initialize
	super initialize.
	commandDescription := CommandDescription new!

isChecked
	"Answer whether the receiver is currently pushed."

	^false!

isChecked: aBoolean 
	"Set whether the receiver is 'checked'. By default this is considered unsupported, and the
	message has no effect."

	!

onActionPerformed
	"The button has been pressed: Route the view's command (if any) to an appropriate handler."

	self onCommand: self commandDescription.
	super onActionPerformed!

validateUserInterface
	| query |
	query := self commandSource queryCommandRouteFor: self commandDescription.
	self
		isEnabled: query isEnabled;
		isChecked: query isChecked.
	query text notNil 
		ifTrue: 
			["The button text should be updated"
			self text: query text]! !
!UI.CommandButton categoriesForMethods!
command!accessing!public! !
command:!accessing!public! !
commandDescription!accessing!public! !
commandDescription:!accessing!public! !
commandSource!accessing!public! !
defaultExtent!constants!private! !
defaultId!accessing!private! !
displayOnFormats!displaying!private! !
initialize!initializing!private! !
isChecked!accessing!public! !
isChecked:!accessing!public! !
onActionPerformed!event handling!public! !
validateUserInterface!operations!public! !
!

!UI.CommandButton class methodsFor!

icon
	"Answers an <Icon> that can be used to represent this class"

	^PushButton icon!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	"We don't use IDOK as it has some nasty behaviour, such as insisting on being the default
	button when focus is moved, even if another default button exists."

	self addClassConstant: 'StandardCommands'
		value: ((IdentityDictionary new: 10)
				at: #cancel put: IDCANCEL;
				at: #abort put: IDABORT;
				at: #retry put: IDRETRY;
				at: #ignore put: IDIGNORE;
				at: #yes put: IDYES;
				at: #no put: IDNO;
				at: #close put: IDCLOSE;
				at: #help put: IDHELP;
				at: #retry put: IDTRYAGAIN;
				at: #continue put: IDCONTINUE;
				shrink;
				isImmutable: true;
				yourself)!

themePartName
	^'BUTTON'! !
!UI.CommandButton class categoriesForMethods!
icon!constants!public! !
initialize!development!initializing!private! !
themePartName!constants!public!theming! !
!

