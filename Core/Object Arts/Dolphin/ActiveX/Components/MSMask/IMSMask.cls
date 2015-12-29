"Filed out from Dolphin Smalltalk X6"!

IMSControl subclass: #IMSMask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'MSMaskConstants'
	classInstanceVariableNames: ''!
IMSMask guid: (IID fromString: '{4D6CC9A0-DF77-11CF-8E74-00A0C90F26F8}')!
IMSMask comment: '<IMSMask> is a wrapper class for the COM interface ''MSMask.IMSMask'' generated from type information in the ''Microsoft Masked Edit Control 6.0 (SP3)'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"MSMask Control"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(4D6CC9A0-DF77-11CF-8E74-00A0C90F26F8), 
	helpstring("MSMask Control"), 
	hidden, 
	dual, 
	nonextensible
]
interface IMSMask : IDispatch {
	[id(0x00000001), propget, helpstring("Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command."), helpcontext(0x0005092d)]
	HRESULT __stdcall ClipMode(
		[out, retval] ClipModeConstants* peClipMode);
	[id(0x00000001), propput, helpstring("Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command."), helpcontext(0x0005092d)]
	HRESULT __stdcall ClipMode(
		[in] ClipModeConstants peClipMode);
	[id(0x00000002), propget, helpstring("Specifies whether prompt characters are contained in the Text property value."), helpcontext(0x0005092e)]
	HRESULT __stdcall PromptInclude(
		[out, retval] VARIANT_BOOL* pbInclude);
	[id(0x00000002), propput, helpstring("Specifies whether prompt characters are contained in the Text property value."), helpcontext(0x0005092e)]
	HRESULT __stdcall PromptInclude(
		[in] VARIANT_BOOL pbInclude);
	[id(0x00000003), propget, helpstring("Determines whether or not the prompt character is a valid input character."), helpcontext(0x0005092f)]
	HRESULT __stdcall AllowPrompt(
		[out, retval] VARIANT_BOOL* pbAllow);
	[id(0x00000003), propput, helpstring("Determines whether or not the prompt character is a valid input character."), helpcontext(0x0005092f)]
	HRESULT __stdcall AllowPrompt(
		[in] VARIANT_BOOL pbAllow);
	[id(0x00000004), propget, helpstring("Determines whether or not the next control in the tab order receives the focus."), helpcontext(0x00050930)]
	HRESULT __stdcall AutoTab(
		[out, retval] VARIANT_BOOL* pbAuto);
	[id(0x00000004), propput, helpstring("Determines whether or not the next control in the tab order receives the focus."), helpcontext(0x00050930)]
	HRESULT __stdcall AutoTab(
		[in] VARIANT_BOOL pbAuto);
	[id(0x00000005), propget, helpstring("Returns/sets the three-dimensional style of the check box caption."), helpcontext(0x00050944)]
	HRESULT __stdcall MousePointer(
		[out, retval] MousePointerConstants* peMousePointer);
	[id(0x00000005), propput, helpstring("Returns/sets the three-dimensional style of the check box caption."), helpcontext(0x00050944)]
	HRESULT __stdcall MousePointer(
		[in] MousePointerConstants peMousePointer);
	[id(0x00000006), hidden, propget, helpstring("Returns/sets bold font styles."), helpcontext(0x00050931)]
	HRESULT __stdcall FontBold(
		[out, retval] VARIANT_BOOL* pbBold);
	[id(0x00000006), hidden, propput, helpstring("Returns/sets bold font styles."), helpcontext(0x00050931)]
	HRESULT __stdcall FontBold(
		[in] VARIANT_BOOL pbBold);
	[id(0x00000007), hidden, propget, helpstring("Returns/sets italic font styles."), helpcontext(0x00050932)]
	HRESULT __stdcall FontItalic(
		[out, retval] VARIANT_BOOL* pbItalic);
	[id(0x00000007), hidden, propput, helpstring("Returns/sets italic font styles."), helpcontext(0x00050932)]
	HRESULT __stdcall FontItalic(
		[in] VARIANT_BOOL pbItalic);
	[id(0x00000008), hidden, propget, helpstring("Specifies the name of the font that appears in each row for the given level."), helpcontext(0x00050933)]
	HRESULT __stdcall FontName(
		[out, retval] BSTR* pbstrName);
	[id(0x00000008), hidden, propput, helpstring("Specifies the name of the font that appears in each row for the given level."), helpcontext(0x00050933)]
	HRESULT __stdcall FontName(
		[in] BSTR pbstrName);
	[id(0x00000009), hidden, propget, helpstring("Specifies the size (in points) of the font that appears in each row for the given level."), helpcontext(0x00050934)]
	HRESULT __stdcall FontSize(
		[out, retval] single* pfSize);
	[id(0x00000009), hidden, propput, helpstring("Specifies the size (in points) of the font that appears in each row for the given level."), helpcontext(0x00050934)]
	HRESULT __stdcall FontSize(
		[in] single pfSize);
	[id(0x0000000a), hidden, propget, helpstring("Returns/sets strikethrough font styles."), helpcontext(0x00050935)]
	HRESULT __stdcall FontStrikethru(
		[out, retval] VARIANT_BOOL* pbStrikethru);
	[id(0x0000000a), hidden, propput, helpstring("Returns/sets strikethrough font styles."), helpcontext(0x00050935)]
	HRESULT __stdcall FontStrikethru(
		[in] VARIANT_BOOL pbStrikethru);
	[id(0x0000000b), hidden, propget, helpstring("Returns/sets underline font styles."), helpcontext(0x00050936)]
	HRESULT __stdcall FontUnderline(
		[out, retval] VARIANT_BOOL* pbUnderline);
	[id(0x0000000b), hidden, propput, helpstring("Returns/sets underline font styles."), helpcontext(0x00050936)]
	HRESULT __stdcall FontUnderline(
		[in] VARIANT_BOOL pbUnderline);
	[id(0x0000000c), propget, helpstring("Specifies whether the selection in a masked edit control is hidden when the control loses focus."), helpcontext(0x00050937)]
	HRESULT __stdcall HideSelection(
		[out, retval] VARIANT_BOOL* pbHide);
	[id(0x0000000c), propput, helpstring("Specifies whether the selection in a masked edit control is hidden when the control loses focus."), helpcontext(0x00050937)]
	HRESULT __stdcall HideSelection(
		[in] VARIANT_BOOL pbHide);
	[id(0x0000000d), propget, helpstring("Sets/returns the maximum length of the masked edit control."), helpcontext(0x00050938)]
	HRESULT __stdcall MaxLength(
		[out, retval] short* psMaxLen);
	[id(0x0000000d), propput, helpstring("Sets/returns the maximum length of the masked edit control."), helpcontext(0x00050938)]
	HRESULT __stdcall MaxLength(
		[in] short psMaxLen);
	[id(0x0000000e), propget, helpstring("Specifies the format for displaying and printing numbers, dates, times, and text."), helpcontext(0x00050939)]
	HRESULT __stdcall Format(
		[out, retval] BSTR* pbstrFormat);
	[id(0x0000000e), propput, helpstring("Specifies the format for displaying and printing numbers, dates, times, and text."), helpcontext(0x00050939)]
	HRESULT __stdcall Format(
		[in] BSTR pbstrFormat);
	[id(0x00000010), propget, helpstring("Determines the input mask for the control."), helpcontext(0x0005092c)]
	HRESULT __stdcall Mask(
		[out, retval] BSTR* pbstrMask);
	[id(0x00000010), propput, helpstring("Determines the input mask for the control."), helpcontext(0x0005092c)]
	HRESULT __stdcall Mask(
		[in] BSTR pbstrMask);
	[id(0x0000000f), propget, helpstring("This is identical to the string displayed in the masked edit control when the control doesn''t have the focus."), helpcontext(0x0005093a)]
	HRESULT __stdcall FormattedText(
		[out, retval] BSTR* pbstrFormat);
	[id(0x0000000f), propput, helpstring("This is identical to the string displayed in the masked edit control when the control doesn''t have the focus."), helpcontext(0x0005093a)]
	HRESULT __stdcall FormattedText(
		[in] BSTR pbstrFormat);
	[id(0x00000011), propget, helpstring("Returns/sets the number of characters selected."), helpcontext(0x0005093b)]
	HRESULT __stdcall SelLength(
		[out, retval] long* plSelLength);
	[id(0x00000011), propput, helpstring("Returns/sets the number of characters selected."), helpcontext(0x0005093b)]
	HRESULT __stdcall SelLength(
		[in] long plSelLength);
	[id(0x00000012), propget, helpstring("Returns/sets the starting point of text selected."), helpcontext(0x0005093c)]
	HRESULT __stdcall SelStart(
		[out, retval] long* plSelStart);
	[id(0x00000012), propput, helpstring("Returns/sets the starting point of text selected."), helpcontext(0x0005093c)]
	HRESULT __stdcall SelStart(
		[in] long plSelStart);
	[id(0x00000013), propget, helpstring("Returns/sets the string containing the currently selected text."), helpcontext(0x0005093d)]
	HRESULT __stdcall SelText(
		[out, retval] BSTR* pbstrText);
	[id(0x00000013), propput, helpstring("Returns/sets the string containing the currently selected text."), helpcontext(0x0005093d)]
	HRESULT __stdcall SelText(
		[in] BSTR pbstrText);
	[id(0x00000014), propget, helpstring("Returns the text in the masked edit control, excluding literal characters of the input mask."), helpcontext(0x0005093e)]
	HRESULT __stdcall ClipText(
		[out, retval] BSTR* pbstrText);
	[id(0x00000014), propput, helpstring("Returns the text in the masked edit control, excluding literal characters of the input mask."), helpcontext(0x0005093e)]
	HRESULT __stdcall ClipText(
		[in] BSTR pbstrText);
	[id(0x00000015), propget, helpstring("Sets/returns the character used to prompt a user for input."), helpcontext(0x0005093f)]
	HRESULT __stdcall PromptChar(
		[out, retval] BSTR* pbstrChar);
	[id(0x00000015), propput, helpstring("Sets/returns the character used to prompt a user for input."), helpcontext(0x0005093f)]
	HRESULT __stdcall PromptChar(
		[in] BSTR pbstrChar);
	[id(0000000000), hidden, propget]
	HRESULT __stdcall defaultText(
		[out, retval] BSTR* pbstrText);
	[id(0000000000), hidden, propput]
	HRESULT __stdcall defaultText(
		[in] BSTR pbstrText);
	[id(0x00000016), bindable, defaultbind, displaybind, propget, helpstring("Sets/returns the text contained in the control."), helpcontext(0x00050943)]
	HRESULT __stdcall Text(
		[out, retval] BSTR* pbstrText);
	[id(0x00000016), bindable, displaybind, propput, helpstring("Sets/returns the text contained in the control."), helpcontext(0x00050943)]
	HRESULT __stdcall Text(
		[in] BSTR pbstrText);
	[id(0x00000017), propget, helpstring("Returns/sets the type of mouse pointer displayed when over part of an object."), helpcontext(0x00050945)]
	HRESULT __stdcall MouseIcon(
		[out, retval] IPictureDisp** ppMouseIcon);
	[id(0x00000017), propput, helpstring("Returns/sets the type of mouse pointer displayed when over part of an object."), helpcontext(0x00050945)]
	HRESULT __stdcall MouseIcon(
		[in] IPictureDisp* ppMouseIcon);
	[id(0x00000017), propputref, helpstring("Returns/sets the type of mouse pointer displayed when over part of an object."), helpcontext(0x00050945)]
	HRESULT __stdcall MouseIcon(
		[in] IPictureDisp* ppMouseIcon);
	[id(0x00000018), propget, helpstring("Sets whether the control has a flat or sunken 3d appearance"), helpcontext(0x00050948)]
	HRESULT __stdcall Appearance(
		[out, retval] AppearanceConstants* peAppearance);
	[id(0x00000018), propput, helpstring("Sets whether the control has a flat or sunken 3d appearance"), helpcontext(0x00050948)]
	HRESULT __stdcall Appearance(
		[in] AppearanceConstants peAppearance);
	[id(0xfffffe0b), bindable, propget, requestedit, helpstring("Returns/sets the background color used to display text and graphics in an object."), helpcontext(0x00050940)]
	HRESULT __stdcall BackColor(
		[out, retval] OLE_COLOR* pocBackColor);
	[id(0xfffffe0b), bindable, propput, requestedit, helpstring("Returns/sets the background color used to display text and graphics in an object."), helpcontext(0x00050940)]
	HRESULT __stdcall BackColor(
		[in] OLE_COLOR pocBackColor);
	[id(0xfffffe00), bindable, propget, helpstring("Font Property"), helpcontext(0x00050941)]
	HRESULT __stdcall Font(
		[out, retval] IFontDisp** ppFont);
	[id(0xfffffe00), bindable, propputref, helpstring("Font Property"), helpcontext(0x00050941)]
	HRESULT __stdcall Font(
		[in] IFontDisp* ppFont);
	[id(0xfffffdff), bindable, propget, requestedit, helpstring("Returns/sets the foreground color used to display text and graphics in an object."), helpcontext(0x00050942)]
	HRESULT __stdcall ForeColor(
		[out, retval] OLE_COLOR* pocForeColor);
	[id(0xfffffdff), bindable, propput, requestedit, helpstring("Returns/sets the foreground color used to display text and graphics in an object."), helpcontext(0x00050942)]
	HRESULT __stdcall ForeColor(
		[in] OLE_COLOR pocForeColor);
	[id(0xfffffdfe), bindable, propget, requestedit, helpstring("Determines if the control can respond to user-generated events, such as the KeyPress and mouse events."), helpcontext(0x00050946)]
	HRESULT __stdcall Enabled(
		[out, retval] VARIANT_BOOL* pbEnabled);
	[id(0xfffffdfe), bindable, propput, requestedit, helpstring("Determines if the control can respond to user-generated events, such as the KeyPress and mouse events."), helpcontext(0x00050946)]
	HRESULT __stdcall Enabled(
		[in] VARIANT_BOOL pbEnabled);
	[id(0xfffffdfd), propget, helpstring("Returns a handle to a form or control."), helpcontext(0x00050949)]
	HRESULT __stdcall hWnd(
		[out, retval] OLE_HANDLE* phWnd);
	[id(0xfffffdfd), propput, helpstring("Returns a handle to a form or control."), helpcontext(0x00050949)]
	HRESULT __stdcall hWnd(
		[in] OLE_HANDLE phWnd);
	[id(0xfffffe08), bindable, propget, requestedit, helpstring("Returns/sets the border style for an object."), helpcontext(0x00050947)]
	HRESULT __stdcall BorderStyle(
		[out, retval] BorderStyleConstants* peBorderStyle);
	[id(0xfffffe08), bindable, propput, requestedit, helpstring("Returns/sets the border style for an object."), helpcontext(0x00050947)]
	HRESULT __stdcall BorderStyle(
		[in] BorderStyleConstants peBorderStyle);
	[id(0x0000060e), propget, helpstring("Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control."), helpcontext(0x0005098d)]
	HRESULT __stdcall OLEDragMode(
		[out, retval] OLEDragConstants* psOLEDragMode);
	[id(0x0000060e), propput, helpstring("Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control."), helpcontext(0x0005098d)]
	HRESULT __stdcall OLEDragMode(
		[in] OLEDragConstants psOLEDragMode);
	[id(0x0000060f), propget, helpstring("Returns/Sets whether this control can act as an OLE drop target."), helpcontext(0x0005098e)]
	HRESULT __stdcall OLEDropMode(
		[out, retval] OLEDropConstants* psOLEDropMode);
	[id(0x0000060f), propput, helpstring("Returns/Sets whether this control can act as an OLE drop target."), helpcontext(0x0005098e)]
	HRESULT __stdcall OLEDropMode(
		[in] OLEDropConstants psOLEDropMode);
	[id(0xfffffdd8), hidden, helpstring("AboutBox Method"), helpcontext(0x0005094a)]
	void __stdcall AboutBox();
	[id(0xfffffdda), helpstring("Forces a complete repaint of a form or control."), helpcontext(0x0005094b)]
	void __stdcall Refresh();
	[id(0x00000610), helpstring("Starts an OLE drag/drop event with the given control as the source."), helpcontext(0x0005098c)]
	HRESULT __stdcall OLEDrag();
};
'!
!IMSMask categoriesForClass!COM-Interfaces!MSMask-Interfaces! !
!IMSMask methodsFor!

AboutBox
	"Invoke the AboutBox() method of the COM object wrapped by the receiver.
	Helpstring: 'AboutBox Method'

		void __stdcall AboutBox();"

	<virtual stdcall: void 75>
	^self invalidCall
!

allowPrompt
	"Answer the <varbool> value of the 'AllowPrompt' property of the receiver.
	Helpstring: 'Determines whether or not the prompt character is a valid input character.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AllowPrompt: answer.
	^answer asObject
!

allowPrompt: pbAllow
	"Set the 'AllowPrompt' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Determines whether or not the prompt character is a valid input character.'"

	self put_AllowPrompt: pbAllow
!

autoTab
	"Answer the <varbool> value of the 'AutoTab' property of the receiver.
	Helpstring: 'Determines whether or not the next control in the tab order receives the focus.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_AutoTab: answer.
	^answer asObject
!

autoTab: pbAuto
	"Set the 'AutoTab' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Determines whether or not the next control in the tab order receives the focus.'"

	self put_AutoTab: pbAuto
!

clipMode
	"Answer the <sdword> value of the 'ClipMode' property of the receiver.
	Helpstring: 'Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command.'"

	| answer |
	answer := (SDWORD new).
	self get_ClipMode: answer.
	^answer asObject
!

clipMode: peClipMode
	"Set the 'ClipMode' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command.'"

	self put_ClipMode: peClipMode
!

clipText
	"Answer the <bstr> value of the 'ClipText' property of the receiver.
	Helpstring: 'Returns the text in the masked edit control, excluding literal characters of the input mask.'"

	| answer |
	answer := BSTR new.
	self get_ClipText: answer.
	^answer asObject
!

clipText: pbstrText
	"Set the 'ClipText' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Returns the text in the masked edit control, excluding literal characters of the input mask.'"

	self put_ClipText: pbstrText
!

defaultText
	"Answer the <bstr> value of the 'defaultText' property of the receiver."

	| answer |
	answer := BSTR new.
	self get_defaultText: answer.
	^answer asObject
!

defaultText: pbstrText
	"Set the 'defaultText' property of the receiver to the <bstr> value of the argument."

	self put_defaultText: pbstrText
!

fontBold
	"Answer the <varbool> value of the 'FontBold' property of the receiver.
	Helpstring: 'Returns/sets bold font styles.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontBold: answer.
	^answer asObject
!

fontBold: pbBold
	"Set the 'FontBold' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets bold font styles.'"

	self put_FontBold: pbBold
!

fontItalic
	"Answer the <varbool> value of the 'FontItalic' property of the receiver.
	Helpstring: 'Returns/sets italic font styles.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontItalic: answer.
	^answer asObject
!

fontItalic: pbItalic
	"Set the 'FontItalic' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets italic font styles.'"

	self put_FontItalic: pbItalic
!

fontName
	"Answer the <bstr> value of the 'FontName' property of the receiver.
	Helpstring: 'Specifies the name of the font that appears in each row for the given level.'"

	| answer |
	answer := BSTR new.
	self get_FontName: answer.
	^answer asObject
!

fontName: pbstrName
	"Set the 'FontName' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Specifies the name of the font that appears in each row for the given level.'"

	self put_FontName: pbstrName
!

fontSize
	"Answer the <float> value of the 'FontSize' property of the receiver.
	Helpstring: 'Specifies the size (in points) of the font that appears in each row for the given level.'"

	| answer |
	answer := (FLOAT new).
	self get_FontSize: answer.
	^answer asObject
!

fontSize: pfSize
	"Set the 'FontSize' property of the receiver to the <float> value of the argument.
	Helpstring: 'Specifies the size (in points) of the font that appears in each row for the given level.'"

	self put_FontSize: pfSize
!

fontStrikethru
	"Answer the <varbool> value of the 'FontStrikethru' property of the receiver.
	Helpstring: 'Returns/sets strikethrough font styles.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontStrikethru: answer.
	^answer asObject
!

fontStrikethru: pbStrikethru
	"Set the 'FontStrikethru' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets strikethrough font styles.'"

	self put_FontStrikethru: pbStrikethru
!

fontUnderline
	"Answer the <varbool> value of the 'FontUnderline' property of the receiver.
	Helpstring: 'Returns/sets underline font styles.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_FontUnderline: answer.
	^answer asObject
!

fontUnderline: pbUnderline
	"Set the 'FontUnderline' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets underline font styles.'"

	self put_FontUnderline: pbUnderline
!

format
	"Answer the <bstr> value of the 'Format' property of the receiver.
	Helpstring: 'Specifies the format for displaying and printing numbers, dates, times, and text.'"

	| answer |
	answer := BSTR new.
	self get_Format: answer.
	^answer asObject
!

format: pbstrFormat
	"Set the 'Format' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Specifies the format for displaying and printing numbers, dates, times, and text.'"

	self put_Format: pbstrFormat
!

formattedText
	"Answer the <bstr> value of the 'FormattedText' property of the receiver.
	Helpstring: 'This is identical to the string displayed in the masked edit control when the control doesn''t have the focus.'"

	| answer |
	answer := BSTR new.
	self get_FormattedText: answer.
	^answer asObject
!

formattedText: pbstrFormat
	"Set the 'FormattedText' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'This is identical to the string displayed in the masked edit control when the control doesn''t have the focus.'"

	self put_FormattedText: pbstrFormat
!

get_AllowPrompt: pbAllow
	"Private - Get the value of the 'AllowPrompt' property of the receiver.
	Helpstring: 'Determines whether or not the prompt character is a valid input character.'

		HRESULT __stdcall AllowPrompt(
			[out, retval] VARIANT_BOOL* pbAllow);"

	<virtual stdcall: hresult 12 varbool*>
	^self invalidCall
!

get_Appearance: peAppearance
	"Private - Get the value of the 'Appearance' property of the receiver.
	Helpstring: 'Sets whether the control has a flat or sunken 3d appearance'

		HRESULT __stdcall Appearance(
			[out, retval] AppearanceConstants* peAppearance);"

	<virtual stdcall: hresult 57 sdword*>
	^self invalidCall
!

get_AutoTab: pbAuto
	"Private - Get the value of the 'AutoTab' property of the receiver.
	Helpstring: 'Determines whether or not the next control in the tab order receives the focus.'

		HRESULT __stdcall AutoTab(
			[out, retval] VARIANT_BOOL* pbAuto);"

	<virtual stdcall: hresult 14 varbool*>
	^self invalidCall
!

get_BackColor: pocBackColor
	"Private - Get the value of the 'BackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'

		HRESULT __stdcall BackColor(
			[out, retval] OLE_COLOR* pocBackColor);"

	<virtual stdcall: hresult 59 dword*>
	^self invalidCall
!

get_BorderStyle: peBorderStyle
	"Private - Get the value of the 'BorderStyle' property of the receiver.
	Helpstring: 'Returns/sets the border style for an object.'

		HRESULT __stdcall BorderStyle(
			[out, retval] BorderStyleConstants* peBorderStyle);"

	<virtual stdcall: hresult 69 sdword*>
	^self invalidCall
!

get_ClipMode: peClipMode
	"Private - Get the value of the 'ClipMode' property of the receiver.
	Helpstring: 'Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command.'

		HRESULT __stdcall ClipMode(
			[out, retval] ClipModeConstants* peClipMode);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_ClipText: pbstrText
	"Private - Get the value of the 'ClipText' property of the receiver.
	Helpstring: 'Returns the text in the masked edit control, excluding literal characters of the input mask.'

		HRESULT __stdcall ClipText(
			[out, retval] BSTR* pbstrText);"

	<virtual stdcall: hresult 46 bstr*>
	^self invalidCall
!

get_defaultText: pbstrText
	"Private - Get the value of the 'defaultText' property of the receiver.

		HRESULT __stdcall defaultText(
			[out, retval] BSTR* pbstrText);"

	<virtual stdcall: hresult 50 bstr*>
	^self invalidCall
!

get_Enabled: pbEnabled
	"Private - Get the value of the 'Enabled' property of the receiver.
	Helpstring: 'Determines if the control can respond to user-generated events, such as the KeyPress and mouse events.'

		HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* pbEnabled);"

	<virtual stdcall: hresult 65 varbool*>
	^self invalidCall
!

get_Font: ppFont
	"Private - Get the value of the 'Font' property of the receiver.
	Helpstring: 'Font Property'

		HRESULT __stdcall Font(
			[out, retval] IFontDisp** ppFont);"

	<virtual stdcall: hresult 61 IFontDisp**>
	^self invalidCall
!

get_FontBold: pbBold
	"Private - Get the value of the 'FontBold' property of the receiver.
	Helpstring: 'Returns/sets bold font styles.'

		HRESULT __stdcall FontBold(
			[out, retval] VARIANT_BOOL* pbBold);"

	<virtual stdcall: hresult 18 varbool*>
	^self invalidCall
!

get_FontItalic: pbItalic
	"Private - Get the value of the 'FontItalic' property of the receiver.
	Helpstring: 'Returns/sets italic font styles.'

		HRESULT __stdcall FontItalic(
			[out, retval] VARIANT_BOOL* pbItalic);"

	<virtual stdcall: hresult 20 varbool*>
	^self invalidCall
!

get_FontName: pbstrName
	"Private - Get the value of the 'FontName' property of the receiver.
	Helpstring: 'Specifies the name of the font that appears in each row for the given level.'

		HRESULT __stdcall FontName(
			[out, retval] BSTR* pbstrName);"

	<virtual stdcall: hresult 22 bstr*>
	^self invalidCall
!

get_FontSize: pfSize
	"Private - Get the value of the 'FontSize' property of the receiver.
	Helpstring: 'Specifies the size (in points) of the font that appears in each row for the given level.'

		HRESULT __stdcall FontSize(
			[out, retval] single* pfSize);"

	<virtual stdcall: hresult 24 float*>
	^self invalidCall
!

get_FontStrikethru: pbStrikethru
	"Private - Get the value of the 'FontStrikethru' property of the receiver.
	Helpstring: 'Returns/sets strikethrough font styles.'

		HRESULT __stdcall FontStrikethru(
			[out, retval] VARIANT_BOOL* pbStrikethru);"

	<virtual stdcall: hresult 26 varbool*>
	^self invalidCall
!

get_FontUnderline: pbUnderline
	"Private - Get the value of the 'FontUnderline' property of the receiver.
	Helpstring: 'Returns/sets underline font styles.'

		HRESULT __stdcall FontUnderline(
			[out, retval] VARIANT_BOOL* pbUnderline);"

	<virtual stdcall: hresult 28 varbool*>
	^self invalidCall
!

get_ForeColor: pocForeColor
	"Private - Get the value of the 'ForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'

		HRESULT __stdcall ForeColor(
			[out, retval] OLE_COLOR* pocForeColor);"

	<virtual stdcall: hresult 63 dword*>
	^self invalidCall
!

get_Format: pbstrFormat
	"Private - Get the value of the 'Format' property of the receiver.
	Helpstring: 'Specifies the format for displaying and printing numbers, dates, times, and text.'

		HRESULT __stdcall Format(
			[out, retval] BSTR* pbstrFormat);"

	<virtual stdcall: hresult 34 bstr*>
	^self invalidCall
!

get_FormattedText: pbstrFormat
	"Private - Get the value of the 'FormattedText' property of the receiver.
	Helpstring: 'This is identical to the string displayed in the masked edit control when the control doesn''t have the focus.'

		HRESULT __stdcall FormattedText(
			[out, retval] BSTR* pbstrFormat);"

	<virtual stdcall: hresult 38 bstr*>
	^self invalidCall
!

get_HideSelection: pbHide
	"Private - Get the value of the 'HideSelection' property of the receiver.
	Helpstring: 'Specifies whether the selection in a masked edit control is hidden when the control loses focus.'

		HRESULT __stdcall HideSelection(
			[out, retval] VARIANT_BOOL* pbHide);"

	<virtual stdcall: hresult 30 varbool*>
	^self invalidCall
!

get_hWnd: phWnd
	"Private - Get the value of the 'hWnd' property of the receiver.
	Helpstring: 'Returns a handle to a form or control.'

		HRESULT __stdcall hWnd(
			[out, retval] OLE_HANDLE* phWnd);"

	<virtual stdcall: hresult 67 sdword*>
	^self invalidCall
!

get_Mask: pbstrMask
	"Private - Get the value of the 'Mask' property of the receiver.
	Helpstring: 'Determines the input mask for the control.'

		HRESULT __stdcall Mask(
			[out, retval] BSTR* pbstrMask);"

	<virtual stdcall: hresult 36 bstr*>
	^self invalidCall
!

get_MaxLength: psMaxLen
	"Private - Get the value of the 'MaxLength' property of the receiver.
	Helpstring: 'Sets/returns the maximum length of the masked edit control.'

		HRESULT __stdcall MaxLength(
			[out, retval] short* psMaxLen);"

	<virtual stdcall: hresult 32 sword*>
	^self invalidCall
!

get_MouseIcon: ppMouseIcon
	"Private - Get the value of the 'MouseIcon' property of the receiver.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'

		HRESULT __stdcall MouseIcon(
			[out, retval] IPictureDisp** ppMouseIcon);"

	<virtual stdcall: hresult 54 IPictureDisp**>
	^self invalidCall
!

get_MousePointer: peMousePointer
	"Private - Get the value of the 'MousePointer' property of the receiver.
	Helpstring: 'Returns/sets the three-dimensional style of the check box caption.'

		HRESULT __stdcall MousePointer(
			[out, retval] MousePointerConstants* peMousePointer);"

	<virtual stdcall: hresult 16 sdword*>
	^self invalidCall
!

get_OLEDragMode: psOLEDragMode
	"Private - Get the value of the 'OLEDragMode' property of the receiver.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.'

		HRESULT __stdcall OLEDragMode(
			[out, retval] OLEDragConstants* psOLEDragMode);"

	<virtual stdcall: hresult 71 sdword*>
	^self invalidCall
!

get_OLEDropMode: psOLEDropMode
	"Private - Get the value of the 'OLEDropMode' property of the receiver.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'

		HRESULT __stdcall OLEDropMode(
			[out, retval] OLEDropConstants* psOLEDropMode);"

	<virtual stdcall: hresult 73 sdword*>
	^self invalidCall
!

get_PromptChar: pbstrChar
	"Private - Get the value of the 'PromptChar' property of the receiver.
	Helpstring: 'Sets/returns the character used to prompt a user for input.'

		HRESULT __stdcall PromptChar(
			[out, retval] BSTR* pbstrChar);"

	<virtual stdcall: hresult 48 bstr*>
	^self invalidCall
!

get_PromptInclude: pbInclude
	"Private - Get the value of the 'PromptInclude' property of the receiver.
	Helpstring: 'Specifies whether prompt characters are contained in the Text property value.'

		HRESULT __stdcall PromptInclude(
			[out, retval] VARIANT_BOOL* pbInclude);"

	<virtual stdcall: hresult 10 varbool*>
	^self invalidCall
!

get_SelLength: plSelLength
	"Private - Get the value of the 'SelLength' property of the receiver.
	Helpstring: 'Returns/sets the number of characters selected.'

		HRESULT __stdcall SelLength(
			[out, retval] long* plSelLength);"

	<virtual stdcall: hresult 40 sdword*>
	^self invalidCall
!

get_SelStart: plSelStart
	"Private - Get the value of the 'SelStart' property of the receiver.
	Helpstring: 'Returns/sets the starting point of text selected.'

		HRESULT __stdcall SelStart(
			[out, retval] long* plSelStart);"

	<virtual stdcall: hresult 42 sdword*>
	^self invalidCall
!

get_SelText: pbstrText
	"Private - Get the value of the 'SelText' property of the receiver.
	Helpstring: 'Returns/sets the string containing the currently selected text.'

		HRESULT __stdcall SelText(
			[out, retval] BSTR* pbstrText);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall
!

get_Text: pbstrText
	"Private - Get the value of the 'Text' property of the receiver.
	Helpstring: 'Sets/returns the text contained in the control.'

		HRESULT __stdcall Text(
			[out, retval] BSTR* pbstrText);"

	<virtual stdcall: hresult 52 bstr*>
	^self invalidCall
!

hideSelection
	"Answer the <varbool> value of the 'HideSelection' property of the receiver.
	Helpstring: 'Specifies whether the selection in a masked edit control is hidden when the control loses focus.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_HideSelection: answer.
	^answer asObject
!

hideSelection: pbHide
	"Set the 'HideSelection' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Specifies whether the selection in a masked edit control is hidden when the control loses focus.'"

	self put_HideSelection: pbHide
!

mask
	"Answer the <bstr> value of the 'Mask' property of the receiver.
	Helpstring: 'Determines the input mask for the control.'"

	| answer |
	answer := BSTR new.
	self get_Mask: answer.
	^answer asObject
!

mask: pbstrMask
	"Set the 'Mask' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Determines the input mask for the control.'"

	self put_Mask: pbstrMask
!

maxLength
	"Answer the <sword> value of the 'MaxLength' property of the receiver.
	Helpstring: 'Sets/returns the maximum length of the masked edit control.'"

	| answer |
	answer := (SWORD new).
	self get_MaxLength: answer.
	^answer asObject
!

maxLength: psMaxLen
	"Set the 'MaxLength' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Sets/returns the maximum length of the masked edit control.'"

	self put_MaxLength: psMaxLen
!

mouseIcon
	"Answer the <IPictureDisp> value of the 'MouseIcon' property of the receiver.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'"

	| answer |
	answer := IPictureDisp newPointer.
	self get_MouseIcon: answer.
	^answer asObject
!

mouseIcon: ppMouseIcon
	"Set the 'MouseIcon' property of the receiver to the <IPictureDisp*> value of the argument.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'"

	self put_MouseIcon: ppMouseIcon
!

mousePointer
	"Answer the <sdword> value of the 'MousePointer' property of the receiver.
	Helpstring: 'Returns/sets the three-dimensional style of the check box caption.'"

	| answer |
	answer := (SDWORD new).
	self get_MousePointer: answer.
	^answer asObject
!

mousePointer: peMousePointer
	"Set the 'MousePointer' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the three-dimensional style of the check box caption.'"

	self put_MousePointer: peMousePointer
!

OLEDrag
	"Invoke the OLEDrag() method of the COM object wrapped by the receiver.
	Helpstring: 'Starts an OLE drag/drop event with the given control as the source.'

		HRESULT __stdcall OLEDrag();"

	<virtual stdcall: hresult 77>
	^self invalidCall
!

oleDragMode
	"Answer the <sdword> value of the 'OLEDragMode' property of the receiver.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.'"

	| answer |
	answer := (SDWORD new).
	self get_OLEDragMode: answer.
	^answer asObject
!

oleDragMode: psOLEDragMode
	"Set the 'OLEDragMode' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.'"

	self put_OLEDragMode: psOLEDragMode
!

promptChar
	"Answer the <bstr> value of the 'PromptChar' property of the receiver.
	Helpstring: 'Sets/returns the character used to prompt a user for input.'"

	| answer |
	answer := BSTR new.
	self get_PromptChar: answer.
	^answer asObject
!

promptChar: pbstrChar
	"Set the 'PromptChar' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Sets/returns the character used to prompt a user for input.'"

	self put_PromptChar: pbstrChar
!

promptInclude
	"Answer the <varbool> value of the 'PromptInclude' property of the receiver.
	Helpstring: 'Specifies whether prompt characters are contained in the Text property value.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_PromptInclude: answer.
	^answer asObject
!

promptInclude: pbInclude
	"Set the 'PromptInclude' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Specifies whether prompt characters are contained in the Text property value.'"

	self put_PromptInclude: pbInclude
!

put_AllowPrompt: pbAllow
	"Private - Set the value of the 'AllowPrompt' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbAllow.
	Helpstring: 'Determines whether or not the prompt character is a valid input character.'

		HRESULT __stdcall AllowPrompt(
			[in] VARIANT_BOOL pbAllow);"

	<virtual stdcall: hresult 13 varbool>
	^self invalidCall
!

put_Appearance: peAppearance
	"Private - Set the value of the 'Appearance' property of the object wrapped by the 
	 receiver to the <sdword> argument, peAppearance.
	Helpstring: 'Sets whether the control has a flat or sunken 3d appearance'

		HRESULT __stdcall Appearance(
			[in] AppearanceConstants peAppearance);"

	<virtual stdcall: hresult 58 sdword>
	^self invalidCall
!

put_AutoTab: pbAuto
	"Private - Set the value of the 'AutoTab' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbAuto.
	Helpstring: 'Determines whether or not the next control in the tab order receives the focus.'

		HRESULT __stdcall AutoTab(
			[in] VARIANT_BOOL pbAuto);"

	<virtual stdcall: hresult 15 varbool>
	^self invalidCall
!

put_BackColor: pocBackColor
	"Private - Set the value of the 'BackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pocBackColor.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'

		HRESULT __stdcall BackColor(
			[in] OLE_COLOR pocBackColor);"

	<virtual stdcall: hresult 60 dword>
	^self invalidCall
!

put_BorderStyle: peBorderStyle
	"Private - Set the value of the 'BorderStyle' property of the object wrapped by the 
	 receiver to the <sdword> argument, peBorderStyle.
	Helpstring: 'Returns/sets the border style for an object.'

		HRESULT __stdcall BorderStyle(
			[in] BorderStyleConstants peBorderStyle);"

	<virtual stdcall: hresult 70 sdword>
	^self invalidCall
!

put_ClipMode: peClipMode
	"Private - Set the value of the 'ClipMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, peClipMode.
	Helpstring: 'Determines whether to include or exclude the literal characters in the input mask when doing a cut or copy command.'

		HRESULT __stdcall ClipMode(
			[in] ClipModeConstants peClipMode);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall
!

put_ClipText: pbstrText
	"Private - Set the value of the 'ClipText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrText.
	Helpstring: 'Returns the text in the masked edit control, excluding literal characters of the input mask.'

		HRESULT __stdcall ClipText(
			[in] BSTR pbstrText);"

	<virtual stdcall: hresult 47 bstr>
	^self invalidCall
!

put_defaultText: pbstrText
	"Private - Set the value of the 'defaultText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrText.

		HRESULT __stdcall defaultText(
			[in] BSTR pbstrText);"

	<virtual stdcall: hresult 51 bstr>
	^self invalidCall
!

put_Enabled: pbEnabled
	"Private - Set the value of the 'Enabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbEnabled.
	Helpstring: 'Determines if the control can respond to user-generated events, such as the KeyPress and mouse events.'

		HRESULT __stdcall Enabled(
			[in] VARIANT_BOOL pbEnabled);"

	<virtual stdcall: hresult 66 varbool>
	^self invalidCall
!

put_FontBold: pbBold
	"Private - Set the value of the 'FontBold' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbBold.
	Helpstring: 'Returns/sets bold font styles.'

		HRESULT __stdcall FontBold(
			[in] VARIANT_BOOL pbBold);"

	<virtual stdcall: hresult 19 varbool>
	^self invalidCall
!

put_FontItalic: pbItalic
	"Private - Set the value of the 'FontItalic' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbItalic.
	Helpstring: 'Returns/sets italic font styles.'

		HRESULT __stdcall FontItalic(
			[in] VARIANT_BOOL pbItalic);"

	<virtual stdcall: hresult 21 varbool>
	^self invalidCall
!

put_FontName: pbstrName
	"Private - Set the value of the 'FontName' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrName.
	Helpstring: 'Specifies the name of the font that appears in each row for the given level.'

		HRESULT __stdcall FontName(
			[in] BSTR pbstrName);"

	<virtual stdcall: hresult 23 bstr>
	^self invalidCall
!

put_FontSize: pfSize
	"Private - Set the value of the 'FontSize' property of the object wrapped by the 
	 receiver to the <float> argument, pfSize.
	Helpstring: 'Specifies the size (in points) of the font that appears in each row for the given level.'

		HRESULT __stdcall FontSize(
			[in] single pfSize);"

	<virtual stdcall: hresult 25 float>
	^self invalidCall
!

put_FontStrikethru: pbStrikethru
	"Private - Set the value of the 'FontStrikethru' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbStrikethru.
	Helpstring: 'Returns/sets strikethrough font styles.'

		HRESULT __stdcall FontStrikethru(
			[in] VARIANT_BOOL pbStrikethru);"

	<virtual stdcall: hresult 27 varbool>
	^self invalidCall
!

put_FontUnderline: pbUnderline
	"Private - Set the value of the 'FontUnderline' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbUnderline.
	Helpstring: 'Returns/sets underline font styles.'

		HRESULT __stdcall FontUnderline(
			[in] VARIANT_BOOL pbUnderline);"

	<virtual stdcall: hresult 29 varbool>
	^self invalidCall
!

put_ForeColor: pocForeColor
	"Private - Set the value of the 'ForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pocForeColor.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'

		HRESULT __stdcall ForeColor(
			[in] OLE_COLOR pocForeColor);"

	<virtual stdcall: hresult 64 dword>
	^self invalidCall
!

put_Format: pbstrFormat
	"Private - Set the value of the 'Format' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrFormat.
	Helpstring: 'Specifies the format for displaying and printing numbers, dates, times, and text.'

		HRESULT __stdcall Format(
			[in] BSTR pbstrFormat);"

	<virtual stdcall: hresult 35 bstr>
	^self invalidCall
!

put_FormattedText: pbstrFormat
	"Private - Set the value of the 'FormattedText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrFormat.
	Helpstring: 'This is identical to the string displayed in the masked edit control when the control doesn''t have the focus.'

		HRESULT __stdcall FormattedText(
			[in] BSTR pbstrFormat);"

	<virtual stdcall: hresult 39 bstr>
	^self invalidCall
!

put_HideSelection: pbHide
	"Private - Set the value of the 'HideSelection' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbHide.
	Helpstring: 'Specifies whether the selection in a masked edit control is hidden when the control loses focus.'

		HRESULT __stdcall HideSelection(
			[in] VARIANT_BOOL pbHide);"

	<virtual stdcall: hresult 31 varbool>
	^self invalidCall
!

put_hWnd: phWnd
	"Private - Set the value of the 'hWnd' property of the object wrapped by the 
	 receiver to the <sdword> argument, phWnd.
	Helpstring: 'Returns a handle to a form or control.'

		HRESULT __stdcall hWnd(
			[in] OLE_HANDLE phWnd);"

	<virtual stdcall: hresult 68 sdword>
	^self invalidCall
!

put_Mask: pbstrMask
	"Private - Set the value of the 'Mask' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrMask.
	Helpstring: 'Determines the input mask for the control.'

		HRESULT __stdcall Mask(
			[in] BSTR pbstrMask);"

	<virtual stdcall: hresult 37 bstr>
	^self invalidCall
!

put_MaxLength: psMaxLen
	"Private - Set the value of the 'MaxLength' property of the object wrapped by the 
	 receiver to the <sword> argument, psMaxLen.
	Helpstring: 'Sets/returns the maximum length of the masked edit control.'

		HRESULT __stdcall MaxLength(
			[in] short psMaxLen);"

	<virtual stdcall: hresult 33 sword>
	^self invalidCall
!

put_MouseIcon: ppMouseIcon
	"Private - Set the value of the 'MouseIcon' property of the object wrapped by the 
	 receiver to the <IPictureDisp*> argument, ppMouseIcon.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'

		HRESULT __stdcall MouseIcon(
			[in] IPictureDisp* ppMouseIcon);"

	<virtual stdcall: hresult 55 IPictureDisp*>
	^self invalidCall
!

put_MousePointer: peMousePointer
	"Private - Set the value of the 'MousePointer' property of the object wrapped by the 
	 receiver to the <sdword> argument, peMousePointer.
	Helpstring: 'Returns/sets the three-dimensional style of the check box caption.'

		HRESULT __stdcall MousePointer(
			[in] MousePointerConstants peMousePointer);"

	<virtual stdcall: hresult 17 sdword>
	^self invalidCall
!

put_OLEDragMode: psOLEDragMode
	"Private - Set the value of the 'OLEDragMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, psOLEDragMode.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drag/drop source, and whether this process is started automatically or under programmatic control.'

		HRESULT __stdcall OLEDragMode(
			[in] OLEDragConstants psOLEDragMode);"

	<virtual stdcall: hresult 72 sdword>
	^self invalidCall
!

put_OLEDropMode: psOLEDropMode
	"Private - Set the value of the 'OLEDropMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, psOLEDropMode.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'

		HRESULT __stdcall OLEDropMode(
			[in] OLEDropConstants psOLEDropMode);"

	<virtual stdcall: hresult 74 sdword>
	^self invalidCall
!

put_PromptChar: pbstrChar
	"Private - Set the value of the 'PromptChar' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrChar.
	Helpstring: 'Sets/returns the character used to prompt a user for input.'

		HRESULT __stdcall PromptChar(
			[in] BSTR pbstrChar);"

	<virtual stdcall: hresult 49 bstr>
	^self invalidCall
!

put_PromptInclude: pbInclude
	"Private - Set the value of the 'PromptInclude' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbInclude.
	Helpstring: 'Specifies whether prompt characters are contained in the Text property value.'

		HRESULT __stdcall PromptInclude(
			[in] VARIANT_BOOL pbInclude);"

	<virtual stdcall: hresult 11 varbool>
	^self invalidCall
!

put_SelLength: plSelLength
	"Private - Set the value of the 'SelLength' property of the object wrapped by the 
	 receiver to the <sdword> argument, plSelLength.
	Helpstring: 'Returns/sets the number of characters selected.'

		HRESULT __stdcall SelLength(
			[in] long plSelLength);"

	<virtual stdcall: hresult 41 sdword>
	^self invalidCall
!

put_SelStart: plSelStart
	"Private - Set the value of the 'SelStart' property of the object wrapped by the 
	 receiver to the <sdword> argument, plSelStart.
	Helpstring: 'Returns/sets the starting point of text selected.'

		HRESULT __stdcall SelStart(
			[in] long plSelStart);"

	<virtual stdcall: hresult 43 sdword>
	^self invalidCall
!

put_SelText: pbstrText
	"Private - Set the value of the 'SelText' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrText.
	Helpstring: 'Returns/sets the string containing the currently selected text.'

		HRESULT __stdcall SelText(
			[in] BSTR pbstrText);"

	<virtual stdcall: hresult 45 bstr>
	^self invalidCall
!

put_Text: pbstrText
	"Private - Set the value of the 'Text' property of the object wrapped by the 
	 receiver to the <bstr> argument, pbstrText.
	Helpstring: 'Sets/returns the text contained in the control.'

		HRESULT __stdcall Text(
			[in] BSTR pbstrText);"

	<virtual stdcall: hresult 53 bstr>
	^self invalidCall
!

putref_Font: ppFont
	"Private - Set the value of the 'Font' property of the object wrapped by the 
	 receiver to the <IFontDisp*> argument, ppFont.
	Helpstring: 'Font Property'

		HRESULT __stdcall Font(
			[in] IFontDisp* ppFont);"

	<virtual stdcall: hresult 62 IFontDisp*>
	^self invalidCall
!

putref_MouseIcon: ppMouseIcon
	"Private - Set the value of the 'MouseIcon' property of the object wrapped by the 
	 receiver to the <IPictureDisp*> argument, ppMouseIcon.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'

		HRESULT __stdcall MouseIcon(
			[in] IPictureDisp* ppMouseIcon);"

	<virtual stdcall: hresult 56 IPictureDisp*>
	^self invalidCall
!

Refresh
	"Invoke the Refresh() method of the COM object wrapped by the receiver.
	Helpstring: 'Forces a complete repaint of a form or control.'

		void __stdcall Refresh();"

	<virtual stdcall: void 76>
	^self invalidCall
!

selLength
	"Answer the <sdword> value of the 'SelLength' property of the receiver.
	Helpstring: 'Returns/sets the number of characters selected.'"

	| answer |
	answer := (SDWORD new).
	self get_SelLength: answer.
	^answer asObject
!

selLength: plSelLength
	"Set the 'SelLength' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the number of characters selected.'"

	self put_SelLength: plSelLength
!

selStart
	"Answer the <sdword> value of the 'SelStart' property of the receiver.
	Helpstring: 'Returns/sets the starting point of text selected.'"

	| answer |
	answer := (SDWORD new).
	self get_SelStart: answer.
	^answer asObject
!

selStart: plSelStart
	"Set the 'SelStart' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the starting point of text selected.'"

	self put_SelStart: plSelStart
!

selText
	"Answer the <bstr> value of the 'SelText' property of the receiver.
	Helpstring: 'Returns/sets the string containing the currently selected text.'"

	| answer |
	answer := BSTR new.
	self get_SelText: answer.
	^answer asObject
!

selText: pbstrText
	"Set the 'SelText' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Returns/sets the string containing the currently selected text.'"

	self put_SelText: pbstrText
!

setMouseIcon: ppMouseIcon
	"Set the 'MouseIcon' property of the receiver to the <IPictureDisp*> value of the argument.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'"

	self putref_MouseIcon: ppMouseIcon
!

text
	"Answer the <bstr> value of the 'Text' property of the receiver.
	Helpstring: 'Sets/returns the text contained in the control.'"

	| answer |
	answer := BSTR new.
	self get_Text: answer.
	^answer asObject
!

text: pbstrText
	"Set the 'Text' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Sets/returns the text contained in the control.'"

	self put_Text: pbstrText
!

value
	"Answer the <bstr> value of the 'defaultText' property of the receiver.
	This is the default value (DISPID_VALUE) property of the receiver."

	^self defaultText
!

value: pbstrText
	"Set the 'defaultText' property of the receiver to the <bstr> value of the argument.
	This is the default value (DISPID_VALUE) property of the receiver."

	self defaultText: pbstrText
! !
!IMSMask categoriesFor: #AboutBox!**auto generated**!COM Interfaces-IMSMask!public! !
!IMSMask categoriesFor: #allowPrompt!**auto generated**!properties!public! !
!IMSMask categoriesFor: #allowPrompt:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #autoTab!**auto generated**!properties!public! !
!IMSMask categoriesFor: #autoTab:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #clipMode!**auto generated**!properties!public! !
!IMSMask categoriesFor: #clipMode:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #clipText!**auto generated**!properties!public! !
!IMSMask categoriesFor: #clipText:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #defaultText!**auto generated**!properties!public! !
!IMSMask categoriesFor: #defaultText:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontBold!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontBold:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontItalic!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontItalic:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontName!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontName:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontSize!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontSize:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontStrikethru!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontStrikethru:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontUnderline!**auto generated**!properties!public! !
!IMSMask categoriesFor: #fontUnderline:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #format!**auto generated**!properties!public! !
!IMSMask categoriesFor: #format:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #formattedText!**auto generated**!properties!public! !
!IMSMask categoriesFor: #formattedText:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #get_AllowPrompt:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Appearance:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_AutoTab:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_BackColor:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_BorderStyle:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_ClipMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_ClipText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_defaultText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Font:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontBold:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontItalic:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontName:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontSize:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontStrikethru:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FontUnderline:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_ForeColor:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Format:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_FormattedText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_HideSelection:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_hWnd:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Mask:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_MaxLength:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_MouseIcon:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_MousePointer:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_OLEDragMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_OLEDropMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_PromptChar:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_PromptInclude:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_SelLength:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_SelStart:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_SelText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #get_Text:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #hideSelection!**auto generated**!properties!public! !
!IMSMask categoriesFor: #hideSelection:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mask!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mask:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #maxLength!**auto generated**!properties!public! !
!IMSMask categoriesFor: #maxLength:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mouseIcon!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mouseIcon:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mousePointer!**auto generated**!properties!public! !
!IMSMask categoriesFor: #mousePointer:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #OLEDrag!**auto generated**!COM Interfaces-IMSMask!public! !
!IMSMask categoriesFor: #oleDragMode!**auto generated**!properties!public! !
!IMSMask categoriesFor: #oleDragMode:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #promptChar!**auto generated**!properties!public! !
!IMSMask categoriesFor: #promptChar:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #promptInclude!**auto generated**!properties!public! !
!IMSMask categoriesFor: #promptInclude:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #put_AllowPrompt:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_Appearance:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_AutoTab:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_BackColor:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_BorderStyle:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_ClipMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_ClipText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_defaultText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_Enabled:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontBold:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontItalic:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontName:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontSize:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontStrikethru:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FontUnderline:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_ForeColor:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_Format:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_FormattedText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_HideSelection:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_hWnd:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_Mask:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_MaxLength:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_MouseIcon:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_MousePointer:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_OLEDragMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_OLEDropMode:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_PromptChar:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_PromptInclude:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_SelLength:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_SelStart:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_SelText:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #put_Text:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #putref_Font:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #putref_MouseIcon:!**auto generated**!COM Interfaces-IMSMask!private! !
!IMSMask categoriesFor: #Refresh!**auto generated**!COM Interfaces-IMSMask!public! !
!IMSMask categoriesFor: #selLength!**auto generated**!properties!public! !
!IMSMask categoriesFor: #selLength:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #selStart!**auto generated**!properties!public! !
!IMSMask categoriesFor: #selStart:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #selText!**auto generated**!properties!public! !
!IMSMask categoriesFor: #selText:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #setMouseIcon:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #text!**auto generated**!properties!public! !
!IMSMask categoriesFor: #text:!**auto generated**!properties!public! !
!IMSMask categoriesFor: #value!**auto generated**!properties!public! !
!IMSMask categoriesFor: #value:!**auto generated**!properties!public! !

!IMSMask class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (MaskEdBox) for which the receiver is the default interface."

	^CLSID fromString: '{C932BA85-4374-101B-A56C-00AA003668DC}'
! !
!IMSMask class categoriesFor: #clsid!**auto generated**!constants!private! !

