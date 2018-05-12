"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #IAgentCtlBalloon
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IAgentCtlBalloon guid: (IID fromString: '{F5BE8BD3-7DE6-11D0-91FE-00C04FD701A5}')!
IAgentCtlBalloon comment: '<IAgentCtlBalloon> is a wrapper class for the COM interface ''AgentObjects.IAgentCtlBalloon'' generated from type information in the ''Microsoft Agent Control 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface:
	"IAgentCtlBalloon Interface"

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IAgentCtlBalloon categoriesForClass!AgentObjects-Interfaces!COM-Interfaces! !
!IAgentCtlBalloon methodsFor!

backColor
	"Answer the <sdword> value of the 'BackColor' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_BackColor: answer.
	^answer asObject
!

borderColor
	"Answer the <sdword> value of the 'BorderColor' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_BorderColor: answer.
	^answer asObject
!

charsPerLine
	"Answer the <sdword> value of the 'CharsPerLine' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_CharsPerLine: answer.
	^answer asObject
!

enabled
	"Answer the <varbool> value of the 'Enabled' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Enabled: answer.
	^answer asObject
!

fontBold
	"Answer the <varbool> value of the 'FontBold' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontBold: answer.
	^answer asObject
!

fontCharSet
	"Answer the <sword> value of the 'FontCharSet' property of the receiver."

	| answer |
	answer := (SWORD new).
	self get_FontCharSet: answer.
	^answer asObject
!

fontCharSet: fontCharSet
	"Set the 'FontCharSet' property of the receiver to the <sword> value of the argument."

	self put_FontCharSet: fontCharSet
!

fontItalic
	"Answer the <varbool> value of the 'FontItalic' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontItalic: answer.
	^answer asObject
!

fontName
	"Answer the <bstr> value of the 'FontName' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_FontName: answer.
	^answer asObject
!

fontName: fontName
	"Set the 'FontName' property of the receiver to the <bstr> value of the argument."

	self put_FontName: fontName
!

fontSize
	"Answer the <sdword> value of the 'FontSize' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_FontSize: answer.
	^answer asObject
!

fontSize: fontSize
	"Set the 'FontSize' property of the receiver to the <sdword> value of the argument."

	self put_FontSize: fontSize
!

fontStrikethru
	"Answer the <varbool> value of the 'FontStrikethru' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontStrikethru: answer.
	^answer asObject
!

fontUnderline
	"Answer the <varbool> value of the 'FontUnderline' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontUnderline: answer.
	^answer asObject
!

foreColor
	"Answer the <sdword> value of the 'ForeColor' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_ForeColor: answer.
	^answer asObject
!

get_BackColor: backColor
	"Private - Get the value of the 'BackColor' property of the receiver.
				HRESULT __stdcall BackColor(
			[out, retval] long* BackColor);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_BorderColor: borderColor
	"Private - Get the value of the 'BorderColor' property of the receiver.
				HRESULT __stdcall BorderColor(
			[out, retval] long* BorderColor);"

	<virtual stdcall: hresult 19 sdword*>
	^self invalidCall
!

get_CharsPerLine: charsPerLine
	"Private - Get the value of the 'CharsPerLine' property of the receiver.
				HRESULT __stdcall CharsPerLine(
			[out, retval] long* CharsPerLine);"

	<virtual stdcall: hresult 10 sdword*>
	^self invalidCall
!

get_Enabled: enabled
	"Private - Get the value of the 'Enabled' property of the receiver.
				HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* Enabled);"

	<virtual stdcall: hresult 8 varbool*>
	^self invalidCall
!

get_FontBold: fontBold
	"Private - Get the value of the 'FontBold' property of the receiver.
				HRESULT __stdcall FontBold(
			[out, retval] VARIANT_BOOL* FontBold);"

	<virtual stdcall: hresult 13 varbool*>
	^self invalidCall
!

get_FontCharSet: fontCharSet
	"Private - Get the value of the 'FontCharSet' property of the receiver.
				HRESULT __stdcall FontCharSet(
			[out, retval] short* FontCharSet);"

	<virtual stdcall: hresult 25 sword*>
	^self invalidCall
!

get_FontItalic: fontItalic
	"Private - Get the value of the 'FontItalic' property of the receiver.
				HRESULT __stdcall FontItalic(
			[out, retval] VARIANT_BOOL* FontItalic);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall
!

get_FontName: fontName
	"Private - Get the value of the 'FontName' property of the receiver.
				HRESULT __stdcall FontName(
			[out, retval] BSTR* FontName);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall
!

get_FontSize: fontSize
	"Private - Get the value of the 'FontSize' property of the receiver.
				HRESULT __stdcall FontSize(
			[out, retval] long* FontSize);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_FontStrikethru: fontStrikethru
	"Private - Get the value of the 'FontStrikethru' property of the receiver.
				HRESULT __stdcall FontStrikethru(
			[out, retval] VARIANT_BOOL* FontStrikethru);"

	<virtual stdcall: hresult 15 varbool*>
	^self invalidCall
!

get_FontUnderline: fontUnderline
	"Private - Get the value of the 'FontUnderline' property of the receiver.
				HRESULT __stdcall FontUnderline(
			[out, retval] VARIANT_BOOL* FontUnderline);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall
!

get_ForeColor: foreColor
	"Private - Get the value of the 'ForeColor' property of the receiver.
				HRESULT __stdcall ForeColor(
			[out, retval] long* ForeColor);"

	<virtual stdcall: hresult 17 sdword*>
	^self invalidCall
!

get_NumberOfLines: lines
	"Private - Get the value of the 'NumberOfLines' property of the receiver.
				HRESULT __stdcall NumberOfLines(
			[out, retval] long* Lines);"

	<virtual stdcall: hresult 9 sdword*>
	^self invalidCall
!

get_Visible: visible
	"Private - Get the value of the 'Visible' property of the receiver.
				HRESULT __stdcall Visible(
			[out, retval] VARIANT_BOOL* Visible);"

	<virtual stdcall: hresult 21 varbool*>
	^self invalidCall
!

numberOfLines
	"Answer the <sdword> value of the 'NumberOfLines' property of the receiver."

	| answer |
	answer := (SDWORD new).
	self get_NumberOfLines: answer.
	^answer asObject
!

put_FontCharSet: fontCharSet
	"Private - Set the value of the 'FontCharSet' property of the object wrapped by the 
	 receiver to the <sword> argument, fontCharSet.
				HRESULT __stdcall FontCharSet(
			[in] short FontCharSet);"

	<virtual stdcall: hresult 24 sword>
	^self invalidCall
!

put_FontName: fontName
	"Private - Set the value of the 'FontName' property of the object wrapped by the 
	 receiver to the <bstr> argument, fontName.
				HRESULT __stdcall FontName(
			[in] BSTR FontName);"

	<virtual stdcall: hresult 22 bstr>
	^self invalidCall
!

put_FontSize: fontSize
	"Private - Set the value of the 'FontSize' property of the object wrapped by the 
	 receiver to the <sdword> argument, fontSize.
				HRESULT __stdcall FontSize(
			[in] long FontSize);"

	<virtual stdcall: hresult 23 sdword>
	^self invalidCall
!

put_Visible: visible
	"Private - Set the value of the 'Visible' property of the object wrapped by the 
	 receiver to the <varbool> argument, visible.
				HRESULT __stdcall Visible(
			[in] VARIANT_BOOL Visible);"

	<virtual stdcall: hresult 20 varbool>
	^self invalidCall
!

visible
	"Answer the <varbool> value of the 'Visible' property of the receiver."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_Visible: answer.
	^answer asObject
!

visible: visible
	"Set the 'Visible' property of the receiver to the <varbool> value of the argument."

	self put_Visible: visible
! !
!IAgentCtlBalloon categoriesFor: #backColor!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #borderColor!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #charsPerLine!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #enabled!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontBold!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontCharSet!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontCharSet:!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontItalic!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontName!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontName:!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontSize!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontSize:!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontStrikethru!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #fontUnderline!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #foreColor!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #get_BackColor:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_BorderColor:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_CharsPerLine:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontBold:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontCharSet:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontItalic:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontName:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontSize:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontStrikethru:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_FontUnderline:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_ForeColor:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_NumberOfLines:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #get_Visible:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #numberOfLines!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #put_FontCharSet:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #put_FontName:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #put_FontSize:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #put_Visible:!**auto generated**!COM Interfaces-IAgentCtlBalloon!private! !
!IAgentCtlBalloon categoriesFor: #visible!**auto generated**!properties!public! !
!IAgentCtlBalloon categoriesFor: #visible:!**auto generated**!properties!public! !

!IAgentCtlBalloon class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'AgentObjects.IAgentCtlBalloon'
		IAgentCtlBalloon defineTemplate"

	self
		defineFunction: #get_Enabled:
			argumentTypes: 'varbool*';
		defineFunction: #get_NumberOfLines:
			argumentTypes: 'sdword*';
		defineFunction: #get_CharsPerLine:
			argumentTypes: 'sdword*';
		defineFunction: #get_FontName:
			argumentTypes: 'bstr*';
		defineFunction: #get_FontSize:
			argumentTypes: 'sdword*';
		defineFunction: #get_FontBold:
			argumentTypes: 'varbool*';
		defineFunction: #get_FontItalic:
			argumentTypes: 'varbool*';
		defineFunction: #get_FontStrikethru:
			argumentTypes: 'varbool*';
		defineFunction: #get_FontUnderline:
			argumentTypes: 'varbool*';
		defineFunction: #get_ForeColor:
			argumentTypes: 'sdword*';
		defineFunction: #get_BackColor:
			argumentTypes: 'sdword*';
		defineFunction: #get_BorderColor:
			argumentTypes: 'sdword*';
		defineFunction: #put_Visible:
			argumentTypes: 'varbool';
		defineFunction: #get_Visible:
			argumentTypes: 'varbool*';
		defineFunction: #put_FontName:
			argumentTypes: 'bstr';
		defineFunction: #put_FontSize:
			argumentTypes: 'sdword';
		defineFunction: #put_FontCharSet:
			argumentTypes: 'sword';
		defineFunction: #get_FontCharSet:
			argumentTypes: 'sword*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		IAgentCtlBalloon initializeTypeLib"

	typeLib := AgentObjectsLib! !
!IAgentCtlBalloon class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IAgentCtlBalloon class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

