"Filed out from Dolphin Smalltalk X6"!

ValueConvertingControlView subclass: #IPAddressView
	instanceVariableNames: ''
	classVariableNames: 'IpnMap'
	poolDictionaries: 'IPAddressControlConstants'
	classInstanceVariableNames: ''!
IPAddressView guid: (GUID fromString: '{425D0EAA-542E-11D3-998B-D5CA2C3C1D61}')!
IPAddressView comment: 'IPAddressView is a <valueView> wrapping the Windows IPAddress common control. The <valueModel> associated with a IPAddress  must always yield an <integer> value when mapped through the installed type converter.

IPAddressView is a convenient way of displaying and editing IPv4 addresses. The interface is limited to using 32-bits to transmit the IP address, so the control is not currently suitable for IPv6 addresses.

Note that comctl32.dll version 4.71 or later is required, but this is a minimum prerequisite for Dolphin in any case.
'!
!IPAddressView categoriesForClass!Unclassified! !
!IPAddressView methodsFor!

constrainField: anInteger toRange: anInterval 
	| stop start |
	start := anInterval start asInteger.
	(start between: 0 and: 255) ifFalse: [^self error: 'invalid lower bound'].
	stop := anInterval stop asInteger.
	((stop between: 0 and: 255) or: [stop < start]) ifFalse: [^self error: 'invalid upper bound'].
	^self 
		sendMessage: IPM_SETRANGE
		wParam: anInteger - 1
		lParam: ((stop bitShift: 4) bitOr: start)!

defaultExtent
	"Private - Answer the default size of the receiver. This is used only to set the size of a
	view when it is created. Thereafter preferredExtent is used when the desired size of a view
	is requested."

	^##(140 @ 21)!

displayValue
	"Private - Answer the displayable contents of the receiver"

	| addr |
	self isBlank ifTrue: [^nil].
	addr := DWORD new.
	self 
		sendMessage: IPM_GETADDRESS
		wParam: 0
		lpParam: addr.
	^addr asInteger!

displayValue: anInteger 
	"Private - Set the displayable contents of the receiver"

	anInteger isNil 
		ifTrue: [self sendMessage: IPM_CLEARADDRESS]
		ifFalse: 
			[self 
				sendMessage: IPM_SETADDRESS
				wParam: 0
				lParam: anInteger]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self setModel: 0 asValue!

ipnFieldChanged: pNMHDR 
	"Private - Default handler for the IPN_FIELDCHANGED notification message. An NMIPADDRESS is available
	from the header to inspect the proposed change. Any changes made here to the NMIPADDRESS
	structure will be passed back"

	| nmIPAddress |
	nmIPAddress := NMIPADDRESS fromAddress: pNMHDR.
	self trigger: #fieldChanged: with: nmIPAddress!

isBlank
	"Answer whether all the fields in the IP address are blank (not zero)."

	^(self sendMessage: IPM_ISBLANK) ~= 0!

nmNotify: pNMHDR 
	"Private - Handler for a redirected IPAddress WM_NOTIFY message."

	^(IpnMap at: IPN_FIRST - (pNMHDR sdwordAtOffset: 8) + 1 ifAbsent: []) 
		ifNil: [super nmNotify: pNMHDR]
		ifNotNil: [:action | self perform: action with: pNMHDR]!

setFocusIndex: anInteger 
	"Set focus to the address field in the view with the specified index, in the range 1..4. If
	anInteger is greater than four, then focus is set to the first non-blank field, or to the
	first field is none of the fields are blank."

	^self sendMessage: IPM_SETFOCUS wParam: anInteger - 1!

setFont: aFont 
	"Private - Apply the specified font to the receiver's associated 
	Windows control."

	"Implementation Note: Override to set a copy of the font because the control (most
	unusually) deletes its font when destroyed."

	#todo.	"This solves the basic problem of the control deleting the default font, however the control still seems to delete the font at other times, 
for example when repainting, so this is not sufficient by itself."
	super setFont: aFont copy!

text
	^self isBlank ifTrue: [''] ifFalse: [super text]! !
!IPAddressView categoriesFor: #constrainField:toRange:!accessing!public! !
!IPAddressView categoriesFor: #defaultExtent!constants!private! !
!IPAddressView categoriesFor: #displayValue!private!updating! !
!IPAddressView categoriesFor: #displayValue:!private!updating! !
!IPAddressView categoriesFor: #initialize!initializing!private! !
!IPAddressView categoriesFor: #ipnFieldChanged:!event handling!private! !
!IPAddressView categoriesFor: #isBlank!accessing!public! !
!IPAddressView categoriesFor: #nmNotify:!event handling-win32!private! !
!IPAddressView categoriesFor: #setFocusIndex:!accessing!public! !
!IPAddressView categoriesFor: #setFont:!accessing!private! !
!IPAddressView categoriesFor: #text!accessing!public! !

!IPAddressView class methodsFor!

initialize
	CommCtrlLibrary initFlags: (CommCtrlLibrary initFlags maskSet: ICC_INTERNET_CLASSES).
	self initializeNotificationMap!

initializeNotificationMap
	(Array new: 1)
		at: IPN_FIRST - IPN_FIELDCHANGED + 1 put: #ipnFieldChanged:;
		yourself!

uninitialize
	CommCtrlLibrary initFlags: (CommCtrlLibrary initFlags maskClear: ICC_INTERNET_CLASSES)!

winClassName
	"Answer the name of the Windows window class to use when realizing the receiver."

	^'SysIPAddress32'! !
!IPAddressView class categoriesFor: #initialize!initializing!private! !
!IPAddressView class categoriesFor: #initializeNotificationMap!initializing!private! !
!IPAddressView class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!IPAddressView class categoriesFor: #winClassName!constants!private! !

