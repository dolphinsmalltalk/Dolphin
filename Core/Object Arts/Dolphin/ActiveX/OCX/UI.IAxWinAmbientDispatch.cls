"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'UI.IAxWinAmbientDispatch'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.IAxWinAmbientDispatch guid: (OS.COM.IID fromString: '{b6ea2051-048a-11d1-82b9-00c04fb9942e}')!
UI.IAxWinAmbientDispatch comment: '<IAxWinAmbientDispatch> is a wrapper class for the COM interface ''ActiveXHost.IAxWinAmbientDispatch'' generated from type information in the ''Dolphin Smalltalk Active-X Host Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IAxWinAmbientDispatch Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(B6EA2051-048A-11D1-82B9-00C04FB9942E), 
	helpstring("IAxWinAmbientDispatch Interface"), 
	dual
]
interface IAxWinAmbientDispatch : IDispatch {
	[id(0x60020000), propput, helpstring("Enable or disable windowless activation")] 
	HRESULT __stdcall AllowWindowlessActivation(
		[in] VARIANT_BOOL pbCanWindowlessActivate);
	[id(0x60020000), propget, helpstring("Enable or disable windowless activation")] 
	HRESULT __stdcall AllowWindowlessActivation(
		[out, retval] VARIANT_BOOL* pbCanWindowlessActivate);
	[id(0xfffffd43), propput, helpstring("Set the background color")] 
	HRESULT __stdcall BackColor(
		[in] OLE_COLOR pclrBackground);
	[id(0xfffffd43), propget, helpstring("Set the background color")] 
	HRESULT __stdcall BackColor(
		[out, retval] OLE_COLOR* pclrBackground);
	[id(0xfffffd40), propput, helpstring("Set the ambient foreground color")] 
	HRESULT __stdcall ForeColor(
		[in] OLE_COLOR pclrForeground);
	[id(0xfffffd40), propget, helpstring("Set the ambient foreground color")] 
	HRESULT __stdcall ForeColor(
		[out, retval] OLE_COLOR* pclrForeground);
	[id(0xfffffd3f), propput, helpstring("Set the ambient locale")] 
	HRESULT __stdcall LocaleID(
		[in] unsigned long plcidLocaleID);
	[id(0xfffffd3f), propget, helpstring("Set the ambient locale")] 
	HRESULT __stdcall LocaleID(
		[out, retval] unsigned long* plcidLocaleID);
	[id(0xfffffd3b), propput, helpstring("Set the ambient user mode")] 
	HRESULT __stdcall UserMode(
		[in] VARIANT_BOOL pbUserMode);
	[id(0xfffffd3b), propget, helpstring("Set the ambient user mode")] 
	HRESULT __stdcall UserMode(
		[out, retval] VARIANT_BOOL* pbUserMode);
	[id(0xfffffd37), propput, helpstring("Enable or disable the control as default")] 
	HRESULT __stdcall DisplayAsDefault(
		[in] VARIANT_BOOL pbDisplayAsDefault);
	[id(0xfffffd37), propget, helpstring("Enable or disable the control as default")] 
	HRESULT __stdcall DisplayAsDefault(
		[out, retval] VARIANT_BOOL* pbDisplayAsDefault);
	[id(0xfffffd41), propput, helpstring("Set the ambient font")] 
	HRESULT __stdcall Font(
		[in] IFontDisp* pFont);
	[id(0xfffffd41), propget, helpstring("Set the ambient font")] 
	HRESULT __stdcall Font(
		[out, retval] IFontDisp** pFont);
	[id(0xfffffd3e), propput, helpstring("Enable or disable message reflection")] 
	HRESULT __stdcall MessageReflect(
		[in] VARIANT_BOOL pbMsgReflect);
	[id(0xfffffd3e), propget, helpstring("Enable or disable message reflection")] 
	HRESULT __stdcall MessageReflect(
		[out, retval] VARIANT_BOOL* pbMsgReflect);
	[id(0xfffffd39), propget, helpstring("Show or hide grab handles")] 
	HRESULT __stdcall ShowGrabHandles(
		[out, retval] VARIANT_BOOL* pbShowGrabHandles);
	[id(0xfffffd38), propget, helpstring("Are grab handles enabled")] 
	HRESULT __stdcall ShowHatching(
		[out, retval] VARIANT_BOOL* pbShowHatching);
	[id(0x60020012), propput, helpstring("Set the DOCHOSTUIFLAG flags")] 
	HRESULT __stdcall DocHostFlags(
		[in] unsigned long pdwDocHostFlags);
	[id(0x60020012), propget, helpstring("Set the DOCHOSTUIFLAG flags")] 
	HRESULT __stdcall DocHostFlags(
		[out, retval] unsigned long* pdwDocHostFlags);
	[id(0x60020014), propput, helpstring("Set the DOCHOSTUIDBLCLK flags")] 
	HRESULT __stdcall DocHostDoubleClickFlags(
		[in] unsigned long pdwDocHostDoubleClickFlags);
	[id(0x60020014), propget, helpstring("Set the DOCHOSTUIDBLCLK flags")] 
	HRESULT __stdcall DocHostDoubleClickFlags(
		[out, retval] unsigned long* pdwDocHostDoubleClickFlags);
	[id(0x60020016), propput, helpstring("Enable or disable context menus")] 
	HRESULT __stdcall AllowContextMenu(
		[in] VARIANT_BOOL pbAllowContextMenu);
	[id(0x60020016), propget, helpstring("Enable or disable context menus")] 
	HRESULT __stdcall AllowContextMenu(
		[out, retval] VARIANT_BOOL* pbAllowContextMenu);
	[id(0x60020018), propput, helpstring("Enable or disable UI")] 
	HRESULT __stdcall AllowShowUI(
		[in] VARIANT_BOOL pbAllowShowUI);
	[id(0x60020018), propget, helpstring("Enable or disable UI")] 
	HRESULT __stdcall AllowShowUI(
		[out, retval] VARIANT_BOOL* pbAllowShowUI);
	[id(0x6002001a), propput, helpstring("Set the option key path")] 
	HRESULT __stdcall OptionKeyPath(
		[in] BSTR pbstrOptionKeyPath);
	[id(0x6002001a), propget, helpstring("Set the option key path")] 
	HRESULT __stdcall OptionKeyPath(
		[out, retval] BSTR* pbstrOptionKeyPath);
};
'!
!UI.IAxWinAmbientDispatch categoriesForClass!COM-Interfaces!DolphinVM-Interfaces! !
!UI.IAxWinAmbientDispatch methodsFor!

allowContextMenu
	"Answer the <varbool> value of the 'AllowContextMenu' property of the receiver.
	Helpstring: Enable or disable context menus"

	| answer |
	answer := VARIANT_BOOL new.
	self get_AllowContextMenu: answer.
	^answer asObject!

allowContextMenu: pbAllowContextMenu
	"Set the 'AllowContextMenu' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable context menus"

	self put_AllowContextMenu: pbAllowContextMenu
!

allowShowUI
	"Answer the <varbool> value of the 'AllowShowUI' property of the receiver.
	Helpstring: Enable or disable UI"

	| answer |
	answer := VARIANT_BOOL new.
	self get_AllowShowUI: answer.
	^answer asObject!

allowShowUI: pbAllowShowUI
	"Set the 'AllowShowUI' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable UI"

	self put_AllowShowUI: pbAllowShowUI
!

allowWindowlessActivation
	"Answer the <varbool> value of the 'AllowWindowlessActivation' property of the receiver.
	Helpstring: Enable or disable windowless activation"

	| answer |
	answer := VARIANT_BOOL new.
	self get_AllowWindowlessActivation: answer.
	^answer asObject!

allowWindowlessActivation: pbCanWindowlessActivate
	"Set the 'AllowWindowlessActivation' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable windowless activation"

	self put_AllowWindowlessActivation: pbCanWindowlessActivate
!

backColor
	"Answer the <dword> value of the 'BackColor' property of the receiver.
	Helpstring: 'Get the background color'"

	"Implementation Note: Modify auto-generated method to answer a <Color> rather than an <integer>."

	| answer |
	answer := DWORD new.
	self get_BackColor: answer.
	^Color fromCOLORREF: answer value!

backColor: aColor 
	"Set the 'BackColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Set the background color'"

	"Implementation Note: Modify auto-generated method to take a <Color> as the argument."

	self put_BackColor: (aColor ifNil: [Color window]) asCOLORREF!

displayAsDefault
	"Answer the <varbool> value of the 'DisplayAsDefault' property of the receiver.
	Helpstring: Enable or disable the control as default"

	| answer |
	answer := VARIANT_BOOL new.
	self get_DisplayAsDefault: answer.
	^answer asObject!

displayAsDefault: pbDisplayAsDefault
	"Set the 'DisplayAsDefault' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable the control as default"

	self put_DisplayAsDefault: pbDisplayAsDefault
!

docHostDoubleClickFlags
	"Answer the <dword> value of the 'DocHostDoubleClickFlags' property of the receiver.
	Helpstring: Set the DOCHOSTUIDBLCLK flags"

	| answer |
	answer := (DWORD new).
	self get_DocHostDoubleClickFlags: answer.
	^answer asObject
!

docHostDoubleClickFlags: pdwDocHostDoubleClickFlags
	"Set the 'DocHostDoubleClickFlags' property of the receiver to the <dword> value of the argument.
	Helpstring: Set the DOCHOSTUIDBLCLK flags"

	self put_DocHostDoubleClickFlags: pdwDocHostDoubleClickFlags
!

docHostFlags
	"Answer the <dword> value of the 'DocHostFlags' property of the receiver.
	Helpstring: Set the DOCHOSTUIFLAG flags"

	| answer |
	answer := (DWORD new).
	self get_DocHostFlags: answer.
	^answer asObject
!

docHostFlags: pdwDocHostFlags
	"Set the 'DocHostFlags' property of the receiver to the <dword> value of the argument.
	Helpstring: Set the DOCHOSTUIFLAG flags"

	self put_DocHostFlags: pdwDocHostFlags
!

font
	"Answer a <Font> equivalent to the Ole font which is the 'Font' property of the receiver."

	"Implementation Note: Modify auto-generated method to answer a <Font> rather than an <IFontDisp>."

	| pFont |
	pFont := IFontDisp newPointer.
	self get_Font: pFont.
	^pFont isNull ifFalse: [Font fromOleFont: pFont]!

font: pFont
	"Set the 'Font' property of the receiver to the <IFontDisp*> value of the argument.
	Helpstring: Set the ambient font"

	self put_Font: pFont
!

foreColor
	"Answer the <dword> value of the 'ForeColor' property of the receiver.
	Helpstring: 'Set the ambient foreground color'"

	"Implementation Note: Modify auto-generated method to answer a <Color> rather than an <integer>."

	| answer |
	answer := DWORD new.
	self get_ForeColor: answer.
	^Color fromCOLORREF: answer value!

foreColor: aColor 
	"Set the 'ForeColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Set the ambient foreground color'"

	"Implementation Note: Modify auto-generated method to take a <Color> as the argument."

	self put_ForeColor: (aColor ifNil: [Color windowText]) asCOLORREF!

get_AllowContextMenu: pbAllowContextMenu
	"Private - Get the value of the 'AllowContextMenu' property of the receiver.

		HRESULT __stdcall AllowContextMenu(
			[out, retval] VARIANT_BOOL* pbAllowContextMenu);"

	<virtual stdcall: hresult 31 varbool*>
	^self invalidCall: _failureCode!

get_AllowShowUI: pbAllowShowUI
	"Private - Get the value of the 'AllowShowUI' property of the receiver.

		HRESULT __stdcall AllowShowUI(
			[out, retval] VARIANT_BOOL* pbAllowShowUI);"

	<virtual stdcall: hresult 33 varbool*>
	^self invalidCall: _failureCode!

get_AllowWindowlessActivation: pbCanWindowlessActivate
	"Private - Get the value of the 'AllowWindowlessActivation' property of the receiver.

		HRESULT __stdcall AllowWindowlessActivation(
			[out, retval] VARIANT_BOOL* pbCanWindowlessActivate);"

	<virtual stdcall: hresult 9 varbool*>
	^self invalidCall: _failureCode!

get_BackColor: pclrBackground
	"Private - Get the value of the 'BackColor' property of the receiver.

		HRESULT __stdcall BackColor(
			[out, retval] OLE_COLOR* pclrBackground);"

	<virtual stdcall: hresult 11 dword*>
	^self invalidCall: _failureCode!

get_DisplayAsDefault: pbDisplayAsDefault
	"Private - Get the value of the 'DisplayAsDefault' property of the receiver.

		HRESULT __stdcall DisplayAsDefault(
			[out, retval] VARIANT_BOOL* pbDisplayAsDefault);"

	<virtual stdcall: hresult 19 varbool*>
	^self invalidCall: _failureCode!

get_DocHostDoubleClickFlags: pdwDocHostDoubleClickFlags
	"Private - Get the value of the 'DocHostDoubleClickFlags' property of the receiver.

		HRESULT __stdcall DocHostDoubleClickFlags(
			[out, retval] unsigned long* pdwDocHostDoubleClickFlags);"

	<virtual stdcall: hresult 29 dword*>
	^self invalidCall: _failureCode!

get_DocHostFlags: pdwDocHostFlags
	"Private - Get the value of the 'DocHostFlags' property of the receiver.

		HRESULT __stdcall DocHostFlags(
			[out, retval] unsigned long* pdwDocHostFlags);"

	<virtual stdcall: hresult 27 dword*>
	^self invalidCall: _failureCode!

get_Font: pFont
	"Private - Get the value of the 'Font' property of the receiver.

		HRESULT __stdcall Font(
			[out, retval] IFontDisp** pFont);"

	<virtual stdcall: hresult 21 IFontDisp**>
	^self invalidCall: _failureCode!

get_ForeColor: pclrForeground
	"Private - Get the value of the 'ForeColor' property of the receiver.

		HRESULT __stdcall ForeColor(
			[out, retval] OLE_COLOR* pclrForeground);"

	<virtual stdcall: hresult 13 dword*>
	^self invalidCall: _failureCode!

get_LocaleID: plcidLocaleID
	"Private - Get the value of the 'LocaleID' property of the receiver.

		HRESULT __stdcall LocaleID(
			[out, retval] unsigned long* plcidLocaleID);"

	<virtual stdcall: hresult 15 dword*>
	^self invalidCall: _failureCode!

get_MessageReflect: pbMsgReflect
	"Private - Get the value of the 'MessageReflect' property of the receiver.

		HRESULT __stdcall MessageReflect(
			[out, retval] VARIANT_BOOL* pbMsgReflect);"

	<virtual stdcall: hresult 23 varbool*>
	^self invalidCall: _failureCode!

get_OptionKeyPath: pbstrOptionKeyPath
	"Private - Get the value of the 'OptionKeyPath' property of the receiver.

		HRESULT __stdcall OptionKeyPath(
			[out, retval] BSTR* pbstrOptionKeyPath);"

	<virtual stdcall: hresult 35 bstr*>
	^self invalidCall: _failureCode!

get_ShowGrabHandles: pbShowGrabHandles
	"Private - Get the value of the 'ShowGrabHandles' property of the receiver.

		HRESULT __stdcall ShowGrabHandles(
			[out, retval] VARIANT_BOOL* pbShowGrabHandles);"

	<virtual stdcall: hresult 24 varbool*>
	^self invalidCall: _failureCode!

get_ShowHatching: pbShowHatching
	"Private - Get the value of the 'ShowHatching' property of the receiver.

		HRESULT __stdcall ShowHatching(
			[out, retval] VARIANT_BOOL* pbShowHatching);"

	<virtual stdcall: hresult 25 varbool*>
	^self invalidCall: _failureCode!

get_UserMode: pbUserMode
	"Private - Get the value of the 'UserMode' property of the receiver.

		HRESULT __stdcall UserMode(
			[out, retval] VARIANT_BOOL* pbUserMode);"

	<virtual stdcall: hresult 17 varbool*>
	^self invalidCall: _failureCode!

localeID
	"Answer the <dword> value of the 'LocaleID' property of the receiver.
	Helpstring: Set the ambient locale"

	| answer |
	answer := (DWORD new).
	self get_LocaleID: answer.
	^answer asObject
!

localeID: plcidLocaleID
	"Set the 'LocaleID' property of the receiver to the <dword> value of the argument.
	Helpstring: Set the ambient locale"

	self put_LocaleID: plcidLocaleID
!

messageReflect
	"Answer the <varbool> value of the 'MessageReflect' property of the receiver.
	Helpstring: Enable or disable message reflection"

	| answer |
	answer := VARIANT_BOOL new.
	self get_MessageReflect: answer.
	^answer asObject!

messageReflect: pbMsgReflect
	"Set the 'MessageReflect' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable message reflection"

	self put_MessageReflect: pbMsgReflect
!

optionKeyPath
	"Answer the <bstr> value of the 'OptionKeyPath' property of the receiver.
	Helpstring: Set the option key path"

	| answer |
	answer := BSTR new.
	self get_OptionKeyPath: answer.
	^answer asObject!

optionKeyPath: pbstrOptionKeyPath
	"Set the 'OptionKeyPath' property of the receiver to the <bstr> value of the argument.
	Helpstring: Set the option key path"

	self put_OptionKeyPath: pbstrOptionKeyPath
!

put_AllowContextMenu: pbAllowContextMenu
	"Private - Set the value of the 'AllowContextMenu' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbAllowContextMenu.

		HRESULT __stdcall AllowContextMenu(
			[in] VARIANT_BOOL pbAllowContextMenu);"

	<virtual stdcall: hresult 30 varbool>
	^self invalidCall: _failureCode!

put_AllowShowUI: pbAllowShowUI
	"Private - Set the value of the 'AllowShowUI' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbAllowShowUI.

		HRESULT __stdcall AllowShowUI(
			[in] VARIANT_BOOL pbAllowShowUI);"

	<virtual stdcall: hresult 32 varbool>
	^self invalidCall: _failureCode!

put_AllowWindowlessActivation: pbCanWindowlessActivate
	"Private - Set the value of the 'AllowWindowlessActivation' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbCanWindowlessActivate.

		HRESULT __stdcall AllowWindowlessActivation(
			[in] VARIANT_BOOL pbCanWindowlessActivate);"

	<virtual stdcall: hresult 8 varbool>
	^self invalidCall: _failureCode!

put_BackColor: pclrBackground
	"Private - Set the value of the 'BackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrBackground.

		HRESULT __stdcall BackColor(
			[in] OLE_COLOR pclrBackground);"

	<virtual stdcall: hresult 10 dword>
	^self invalidCall: _failureCode!

put_DisplayAsDefault: pbDisplayAsDefault
	"Private - Set the value of the 'DisplayAsDefault' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbDisplayAsDefault.

		HRESULT __stdcall DisplayAsDefault(
			[in] VARIANT_BOOL pbDisplayAsDefault);"

	<virtual stdcall: hresult 18 varbool>
	^self invalidCall: _failureCode!

put_DocHostDoubleClickFlags: pdwDocHostDoubleClickFlags
	"Private - Set the value of the 'DocHostDoubleClickFlags' property of the object wrapped by the 
	 receiver to the <dword> argument, pdwDocHostDoubleClickFlags.

		HRESULT __stdcall DocHostDoubleClickFlags(
			[in] unsigned long pdwDocHostDoubleClickFlags);"

	<virtual stdcall: hresult 28 dword>
	^self invalidCall: _failureCode!

put_DocHostFlags: pdwDocHostFlags
	"Private - Set the value of the 'DocHostFlags' property of the object wrapped by the 
	 receiver to the <dword> argument, pdwDocHostFlags.

		HRESULT __stdcall DocHostFlags(
			[in] unsigned long pdwDocHostFlags);"

	<virtual stdcall: hresult 26 dword>
	^self invalidCall: _failureCode!

put_Font: pFont
	"Private - Set the value of the 'Font' property of the object wrapped by the 
	 receiver to the <IFontDisp*> argument, pFont.

		HRESULT __stdcall Font(
			[in] IFontDisp* pFont);"

	<virtual stdcall: hresult 20 IFontDisp*>
	^self invalidCall: _failureCode!

put_ForeColor: pclrForeground
	"Private - Set the value of the 'ForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrForeground.

		HRESULT __stdcall ForeColor(
			[in] OLE_COLOR pclrForeground);"

	<virtual stdcall: hresult 12 dword>
	^self invalidCall: _failureCode!

put_LocaleID: plcidLocaleID
	"Private - Set the value of the 'LocaleID' property of the object wrapped by the 
	 receiver to the <dword> argument, plcidLocaleID.

		HRESULT __stdcall LocaleID(
			[in] unsigned long plcidLocaleID);"

	<virtual stdcall: hresult 14 dword>
	^self invalidCall: _failureCode!

put_MessageReflect: pbMsgReflect
	"Private - Set the value of the 'MessageReflect' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbMsgReflect.

		HRESULT __stdcall MessageReflect(
			[in] VARIANT_BOOL pbMsgReflect);"

	<virtual stdcall: hresult 22 varbool>
	^self invalidCall: _failureCode!

put_OptionKeyPath: pbstrOptionKeyPath
	"Private - Set the value of the 'OptionKeyPath' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrOptionKeyPath.

		HRESULT __stdcall OptionKeyPath(
			[in] BSTR pbstrOptionKeyPath);"

	<virtual stdcall: hresult 34 bstr>
	^self invalidCall: _failureCode!

put_UserMode: pbUserMode
	"Private - Set the value of the 'UserMode' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbUserMode.

		HRESULT __stdcall UserMode(
			[in] VARIANT_BOOL pbUserMode);"

	<virtual stdcall: hresult 16 varbool>
	^self invalidCall: _failureCode!

showGrabHandles
	"Answer the <varbool> value of the 'ShowGrabHandles' property of the receiver.
	Helpstring: Show or hide grab handles"

	| answer |
	answer := VARIANT_BOOL new.
	self get_ShowGrabHandles: answer.
	^answer asObject!

showHatching
	"Answer the <varbool> value of the 'ShowHatching' property of the receiver.
	Helpstring: Are grab handles enabled"

	| answer |
	answer := VARIANT_BOOL new.
	self get_ShowHatching: answer.
	^answer asObject!

userMode
	"Answer the <varbool> value of the 'UserMode' property of the receiver.
	Helpstring: Set the ambient user mode"

	| answer |
	answer := VARIANT_BOOL new.
	self get_UserMode: answer.
	^answer asObject!

userMode: pbUserMode
	"Set the 'UserMode' property of the receiver to the <varbool> value of the argument.
	Helpstring: Set the ambient user mode"

	self put_UserMode: pbUserMode
! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowContextMenu!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowContextMenu:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowShowUI!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowShowUI:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowWindowlessActivation!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #allowWindowlessActivation:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #backColor!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #backColor:!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #displayAsDefault!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #displayAsDefault:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #docHostDoubleClickFlags!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #docHostDoubleClickFlags:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #docHostFlags!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #docHostFlags:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #font!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #font:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #foreColor!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #foreColor:!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_AllowContextMenu:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_AllowShowUI:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_AllowWindowlessActivation:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_BackColor:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_DisplayAsDefault:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_DocHostDoubleClickFlags:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_DocHostFlags:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_Font:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_ForeColor:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_LocaleID:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_MessageReflect:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_OptionKeyPath:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_ShowGrabHandles:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_ShowHatching:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #get_UserMode:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #localeID!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #localeID:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #messageReflect!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #messageReflect:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #optionKeyPath!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #optionKeyPath:!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_AllowContextMenu:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_AllowShowUI:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_AllowWindowlessActivation:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_BackColor:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_DisplayAsDefault:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_DocHostDoubleClickFlags:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_DocHostFlags:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_Font:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_ForeColor:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_LocaleID:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_MessageReflect:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_OptionKeyPath:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #put_UserMode:!**auto generated**!COM Interfaces-IAxWinAmbientDispatch!private! !
!UI.IAxWinAmbientDispatch categoriesFor: #showGrabHandles!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #showHatching!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #userMode!**auto generated**!properties!public! !
!UI.IAxWinAmbientDispatch categoriesFor: #userMode:!**auto generated**!properties!public! !

!UI.IAxWinAmbientDispatch class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'DolphinVM.IAxWinAmbientDispatch'
		IAxWinAmbientDispatch defineTemplate
	"

	self
		defineFunction: #put_AllowWindowlessActivation: argumentTypes: 'varbool';
		defineFunction: #get_AllowWindowlessActivation1: argumentTypes: 'varbool*';
		defineFunction: #put_BackColor: argumentTypes: 'dword';
		defineFunction: #get_BackColor: argumentTypes: 'dword*';
		defineFunction: #put_ForeColor: argumentTypes: 'dword';
		defineFunction: #get_ForeColor: argumentTypes: 'dword*';
		defineFunction: #put_LocaleID: argumentTypes: 'dword';
		defineFunction: #get_LocaleID1: argumentTypes: 'dword*';
		defineFunction: #put_UserMode: argumentTypes: 'varbool';
		defineFunction: #get_UserMode: argumentTypes: 'varbool*';
		defineFunction: #put_DisplayAsDefault: argumentTypes: 'varbool';
		defineFunction: #get_DisplayAsDefault: argumentTypes: 'varbool*';
		defineFunction: #put_Font: argumentTypes: 'IFontDisp*';
		defineFunction: #get_Font: argumentTypes: 'IFontDisp**';
		defineFunction: #put_MessageReflect: argumentTypes: 'varbool';
		defineFunction: #get_MessageReflect1: argumentTypes: 'varbool*';
		defineFunction: #get_ShowGrabHandles1: argumentTypes: 'varbool*';
		defineFunction: #get_ShowHatching1: argumentTypes: 'varbool*';
		defineFunction: #put_DocHostFlags: argumentTypes: 'dword';
		defineFunction: #get_DocHostFlags: argumentTypes: 'dword*';
		defineFunction: #put_DocHostDoubleClickFlags: argumentTypes: 'dword';
		defineFunction: #get_DocHostDoubleClickFlags: argumentTypes: 'dword*';
		defineFunction: #put_AllowContextMenu: argumentTypes: 'varbool';
		defineFunction: #get_AllowContextMenu1: argumentTypes: 'varbool*';
		defineFunction: #put_AllowShowUI: argumentTypes: 'varbool';
		defineFunction: #get_AllowShowUI1: argumentTypes: 'varbool*';
		defineFunction: #put_OptionKeyPath: argumentTypes: 'bstr';
		defineFunction: #get_OptionKeyPath1: argumentTypes: 'bstr*';
		defineFunction: #get_IsWindowless: argumentTypes: 'varbool*'! !
!UI.IAxWinAmbientDispatch class categoriesFor: #defineFunctions!initializing!public! !

