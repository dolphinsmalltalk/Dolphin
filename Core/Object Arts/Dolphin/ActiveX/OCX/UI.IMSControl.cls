﻿"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch
	subclass: #'UI.IMSControl'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!

UI.IMSControl guid: (OS.COM.IID fromString: '{882a259f-9029-41dc-826f-6821fa73a486}')!

UI.IMSControl isNonInstantiable: true!

UI.IMSControl comment: 'IMSControl is an abstract superclass the purpose of which is to share the common implementation details for typical MS OCXs designed primarily for use in VB. These controls have a number of common properties.'!

!UI.IMSControl categoriesForClass!COM-Interfaces! !

!UI.IMSControl methodsFor!

aboutBox
	"Invoke the AboutBox() method of the COM object wrapped by the receiver.
	Helpstring: 'AboutBox Method'

		void __stdcall AboutBox();
	"

	self AboutBox!

AboutBox
	"Invoke the AboutBox() method of the COM object wrapped by the receiver."

	^self subclassResponsibility!

appearance
	"Answer the <sdword> value of the 'Appearance' property of the receiver.
	Helpstring: 'Sets whether the control has a flat or sunken 3d appearance'"

	| answer |
	answer := Int32 new.
	self get_Appearance: answer.
	^answer asObject!

appearance: peAppearance
	"Set the 'Appearance' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Sets whether the control has a flat or sunken 3d appearance'"

	self put_Appearance: peAppearance!

backColor
	"Answer the <dword> value of the 'BackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'"

	| answer |
	answer := UInt32 new.
	self get_BackColor: answer.
	^Color fromCOLORREF: answer value!

backColor: aColor
	"Set the 'BackColor' property of the receiver to the <ColorRef> value of the argument.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'"

	self put_BackColor: (self convertToBackColorRef: aColor)!

borderStyle
	"Answer the <sdword> value of the 'BorderStyle' property of the receiver.
	Helpstring: 'Returns/sets the border style for an object.'"

	| answer |
	answer := Int32 new.
	self get_BorderStyle: answer.
	^answer asObject!

borderStyle: psBorderStyle
	"Set the 'BorderStyle' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the border style for an object.'"

	self put_BorderStyle: psBorderStyle!

convertToBackColorRef: aColor
	^(aColor ?? Color.Window) asCOLORREF!

convertToForeColorRef: aColor
	^(aColor ?? Color.WindowText) asCOLORREF!

enabled
	"Answer the <varbool> value of the 'Enabled' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether a form or control can respond to user-generated events.'"

	| answer |
	answer := VARIANT_BOOL new.
	self get_Enabled: answer.
	^answer asObject!

enabled: pbEnabled
	"Set the 'Enabled' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets a value that determines whether a form or control can respond to user-generated events.'"

	self put_Enabled: pbEnabled!

font
	"Answer the <IFontDisp> value of the 'Font' property of the receiver.
	Helpstring: 'Returns a Font object.'"

	| answer |
	answer := IFontDisp newPointer.
	self get_Font: answer.
	^answer asObject!

font: ppFont 
	"Set the 'Font' property of the receiver to the <IFontDisp*> value of the argument.
	Helpstring: 'Returns a Font object.'"

	self putref_Font: ppFont!

foreColor
	"Answer the <dword> value of the 'ForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'"

	| answer |
	answer := UInt32 new.
	self get_ForeColor: answer.
	^Color fromCOLORREF: answer value!

foreColor: aColor
	"Set the 'ForeColor' property of the receiver to the <ColorRef> value of the argument.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'"

	self put_ForeColor: (self convertToForeColorRef: aColor)!

get_Appearance: penumAppearances
	"Private - Get the value of the 'Appearance' property of the receiver."
	
	^self subclassResponsibility!

get_BackColor: pclrBackColor
	"Private - Get the value of the 'BackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'

		HRESULT __stdcall BackColor(
			[out, retval] OLE_COLOR* pclrBackColor);"

	<virtual stdcall: hresult 10 uint32*>
	^self invalidCall: _failureCode!

get_BorderStyle: psBorderStyle
	"Private - Get the value of the 'BorderStyle' property of the receiver."

	^self subclassResponsibility
!

get_Enabled: pbEnabled
	"Private - Get the value of the 'Enabled' property of the receiver."

	^self subclassResponsibility!

get_Font: ppFont 
	"Private - Get the value of the 'Font' property of the receiver."

	^self subclassResponsibility!

get_ForeColor: pclrForeColor 
	"Private - Get the value of the 'ForeColor' property of the receiver."

	^self subclassResponsibility!

get_hWnd: phWnd 
	"Private - Get the value of the 'hWnd' property of the receiver."

	^self subclassResponsibility!

get_OLEDropMode: psOLEDropMode 
	"Private - Get the value of the 'OLEDropMode' property of the receiver."

	^self subclassResponsibility!

hWnd
	"Answer the <sdword> value of the 'hWnd' property of the receiver.
	Helpstring: 'Returns a handle to a form or control.'"

	| answer |
	answer := Int32 new.
	self get_hWnd: answer.
	^answer asObject!

hWnd: phWnd
	"Set the 'hWnd' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns a handle to a form or control.'"

	self put_hWnd: phWnd!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

oleDropMode
	"Answer the <sdword> value of the 'OLEDropMode' property of the receiver.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'"

	| answer |
	answer := Int32 new.
	self get_OLEDropMode: answer.
	^answer asObject!

oleDropMode: psOLEDropMode
	"Set the 'OLEDropMode' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'"

	self put_OLEDropMode: psOLEDropMode!

put_Appearance: peAppearance 
	"Private - Set the value of the 'Appearance' property of the object wrapped by the 
	 receiver to the <sdword> argument, peAppearance."

	^self subclassResponsibility!

put_BackColor: pclrBackColor 
	"Private - Set the value of the 'BackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrBackColor."

	^self subclassResponsibility!

put_BorderStyle: psBorderStyle 
	"Private - Set the value of the 'BorderStyle' property of the object wrapped by the 
	 receiver to the <sdword> argument, psBorderStyle."

	^self subclassResponsibility!

put_Enabled: pbEnabled 
	"Private - Set the value of the 'Enabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbEnabled."

	^self subclassResponsibility!

put_ForeColor: pclrForeColor 
	"Private - Set the value of the 'ForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrForeColor."

	^self subclassResponsibility!

put_hWnd: phWnd 
	"Private - Set the value of the 'hWnd' property of the object wrapped by the 
	 receiver to the <sdword> argument, phWnd."

	^self subclassResponsibility!

put_OLEDropMode: psOLEDropMode 
	"Private - Set the value of the 'OLEDropMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, psOLEDropMode."

	^self subclassResponsibility!

putref_Font: ppFont 
	"Private - Set the value of the 'Font' property of the object wrapped by the 
	 receiver to the <IFontDisp*> argument, ppFont."

	^self subclassResponsibility!

refresh 
	"Invoke the Refresh() method of the COM object wrapped by the receiver.
	Helpstring: 'Forces a complete repaint of a form or control.'

		void __stdcall Refresh();
	"

	self Refresh!

Refresh
	"Invoke the Refresh() method of the COM object wrapped by the receiver."

	^self subclassResponsibility!

setFont: ppFont
	"Set the 'Font' property of the receiver to the <IFontDisp*> value of the argument.
	Helpstring: 'Returns a Font object.'"

	self putref_Font: ppFont
! !

!UI.IMSControl categoriesForMethods!
aboutBox!COM Interfaces-IMSControl!public! !
AboutBox!COM Interfaces-IMSControl!public! !
appearance!properties!public! !
appearance:!properties!public! !
backColor!properties!public! !
backColor:!properties!public! !
borderStyle!properties!public! !
borderStyle:!properties!public! !
convertToBackColorRef:!private!properties! !
convertToForeColorRef:!properties!public! !
enabled!properties!public! !
enabled:!properties!public! !
font!properties!public! !
font:!properties!public! !
foreColor!properties!public! !
foreColor:!properties!public! !
get_Appearance:!COM Interfaces-IMSControl!private! !
get_BackColor:!COM Interfaces-IMSControl!private! !
get_BorderStyle:!COM Interfaces-IMSControl!private! !
get_Enabled:!COM Interfaces-IMSControl!private! !
get_Font:!COM Interfaces-IMSControl!private! !
get_ForeColor:!COM Interfaces-IMSControl!private! !
get_hWnd:!COM Interfaces-IMSControl!private! !
get_OLEDropMode:!COM Interfaces-IMSControl!private! !
hWnd!properties!public! !
hWnd:!properties!public! !
isExtensible!public!testing! !
isVBCollection!public!testing! !
oleDropMode!properties!public! !
oleDropMode:!properties!public! !
put_Appearance:!COM Interfaces-IMSControl!private! !
put_BackColor:!COM Interfaces-IMSControl!private! !
put_BorderStyle:!COM Interfaces-IMSControl!private! !
put_Enabled:!COM Interfaces-IMSControl!private! !
put_ForeColor:!COM Interfaces-IMSControl!private! !
put_hWnd:!COM Interfaces-IMSControl!private! !
put_OLEDropMode:!COM Interfaces-IMSControl!private! !
putref_Font:!COM Interfaces-IMSControl!private! !
refresh!COM Interfaces-IMSControl!public! !
Refresh!COM Interfaces-IMSControl!public! !
setFont:!properties!public! !
!

