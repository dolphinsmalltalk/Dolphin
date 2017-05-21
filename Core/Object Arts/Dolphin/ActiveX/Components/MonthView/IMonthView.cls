"Filed out from Dolphin Smalltalk 7"!

IMSControl subclass: #IMonthView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IMonthView guid: (IID fromString: '{232E4565-87C3-11D1-8BE3-0000F8754DA1}')!
IMonthView comment: '<IMonthView> is a wrapper class for the COM interface ''MSComCtl2.IMonthView'' generated from type information in the ''Microsoft Windows Common Controls-2 6.0 (SP4)'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Microsoft MonthView Control"

Warning: This class should not be regenerated as it has been refactored to move common functionality to an abstract superclass.

IDL definition follows:

[
	object, 
	uuid(232E4565-87C3-11D1-8BE3-0000F8754DA1), 
	helpstring("Microsoft MonthView Control"), 
	helpcontext(0x00035bf9), 
	hidden, 
	dual, 
	nonextensible
]
interface IMonthView : IDispatch {
	[id(0xfffffdf8), propget, helpstring("Returns/sets whether or not controls, Forms or an MDIForm are painted at run time with 3-D effects."), helpcontext(0x00035c1d)]
	HRESULT __stdcall Appearance(
		[out, retval] AppearanceConstants* penumAppearances);
	[id(0xfffffdf8), propput, helpstring("Returns/sets whether or not controls, Forms or an MDIForm are painted at run time with 3-D effects."), helpcontext(0x00035c1d)]
	HRESULT __stdcall Appearance(
		[in] AppearanceConstants penumAppearances);
	[id(0xfffffe0b), propget, helpstring("Returns/sets the background color used to display text and graphics in an object."), helpcontext(0x00035c1e)]
	HRESULT __stdcall BackColor(
		[out, retval] OLE_COLOR* pclrBackColor);
	[id(0xfffffe0b), propput, helpstring("Returns/sets the background color used to display text and graphics in an object."), helpcontext(0x00035c1e)]
	HRESULT __stdcall BackColor(
		[in] OLE_COLOR pclrBackColor);
	[id(0xfffffe08), propget, helpstring("Returns/sets the border style for an object."), helpcontext(0x00035c1f)]
	HRESULT __stdcall BorderStyle(
		[out, retval] BorderStyleConstants* psBorderStyle);
	[id(0xfffffe08), propput, helpstring("Returns/sets the border style for an object."), helpcontext(0x00035c1f)]
	HRESULT __stdcall BorderStyle(
		[in] BorderStyleConstants psBorderStyle);
	[id(0x00000001), propget, helpstring("Returns/sets the day number [1-31] for the currently selected date."), helpcontext(0x00035c20)]
	HRESULT __stdcall Day(
		[out, retval] short* psDay);
	[id(0x00000001), propput, helpstring("Returns/sets the day number [1-31] for the currently selected date."), helpcontext(0x00035c20)]
	HRESULT __stdcall Day(
		[in] short psDay);
	[id(0x00000002), propget, helpstring("An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date."), helpcontext(0x00035c21)]
	HRESULT __stdcall DayBold(
		[in] DATE dateIndex,
		[out, retval] VARIANT_BOOL* pbDayBold);
	[id(0x00000002), propput, helpstring("An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date."), helpcontext(0x00035c21)]
	HRESULT __stdcall DayBold(
		[in] DATE dateIndex,
		[in] VARIANT_BOOL pbDayBold);
	[id(0x00000003), propget, helpstring("Returns the day of the week [0-6] for the currently selected date."), helpcontext(0x00035c22)]
	HRESULT __stdcall DayOfWeek(
		[out, retval] DayConstants* penumDayOfWeek);
	[id(0x00000003), propput, helpstring("Returns the day of the week [0-6] for the currently selected date."), helpcontext(0x00035c22)]
	HRESULT __stdcall DayOfWeek(
		[in] DayConstants penumDayOfWeek);
	[id(0xfffffdfe), propget, helpstring("Returns/sets a value that determines whether a form or control can respond to user-generated events."), helpcontext(0x00035c23)]
	HRESULT __stdcall Enabled(
		[out, retval] VARIANT_BOOL* pbEnabled);
	[id(0xfffffdfe), propput, helpstring("Returns/sets a value that determines whether a form or control can respond to user-generated events."), helpcontext(0x00035c23)]
	HRESULT __stdcall Enabled(
		[in] VARIANT_BOOL pbEnabled);
	[id(0xfffffe00), propget, helpstring("Returns a Font object."), helpcontext(0x00035c24)]
	HRESULT __stdcall Font(
		[out, retval] IFontDisp** ppFont);
	[id(0xfffffe00), propput, helpstring("Returns a Font object."), helpcontext(0x00035c24)]
	HRESULT __stdcall Font(
		[in] IFontDisp* ppFont);
	[id(0xfffffe00), propputref, helpstring("Returns a Font object."), helpcontext(0x00035c24)]
	HRESULT __stdcall Font(
		[in] IFontDisp* ppFont);
	[id(0xfffffdff), propget, helpstring("Returns/sets the foreground color used to display text and graphics in an object."), helpcontext(0x00035c25)]
	HRESULT __stdcall ForeColor(
		[out, retval] OLE_COLOR* pclrForeColor);
	[id(0xfffffdff), propput, helpstring("Returns/sets the foreground color used to display text and graphics in an object."), helpcontext(0x00035c25)]
	HRESULT __stdcall ForeColor(
		[in] OLE_COLOR pclrForeColor);
	[id(0xfffffdfd), propget, helpstring("Returns a handle to a form or control."), helpcontext(0x00035c26)]
	HRESULT __stdcall hWnd(
		[out, retval] OLE_HANDLE* phWnd);
	[id(0xfffffdfd), propput, helpstring("Returns a handle to a form or control."), helpcontext(0x00035c26)]
	HRESULT __stdcall hWnd(
		[in] OLE_HANDLE phWnd);
	[id(0x00000004), propget, helpstring("Returns/sets the latest date that can be displayed or accepted by the control."), helpcontext(0x00035c27)]
	HRESULT __stdcall MaxDate(
		[out, retval] DATE* pdateMaxDate);
	[id(0x00000004), propput, helpstring("Returns/sets the latest date that can be displayed or accepted by the control."), helpcontext(0x00035c27)]
	HRESULT __stdcall MaxDate(
		[in] DATE pdateMaxDate);
	[id(0x00000005), propget, helpstring("Returns/sets the limit on the number of dates that a user can multi-select."), helpcontext(0x00035c28)]
	HRESULT __stdcall MaxSelCount(
		[out, retval] short* psMaxSelCount);
	[id(0x00000005), propput, helpstring("Returns/sets the limit on the number of dates that a user can multi-select."), helpcontext(0x00035c28)]
	HRESULT __stdcall MaxSelCount(
		[in] short psMaxSelCount);
	[id(0x00000006), propget, helpstring("Returns/sets the earliest date that can be displayed or accepted by the control."), helpcontext(0x00035c29)]
	HRESULT __stdcall MinDate(
		[out, retval] DATE* pdateMinDate);
	[id(0x00000006), propput, helpstring("Returns/sets the earliest date that can be displayed or accepted by the control."), helpcontext(0x00035c29)]
	HRESULT __stdcall MinDate(
		[in] DATE pdateMinDate);
	[id(0x00000007), propget, helpstring("Returns/sets the month number [1-12] for the currently selected date."), helpcontext(0x00035c2a)]
	HRESULT __stdcall Month(
		[out, retval] MonthConstants* psMonth);
	[id(0x00000007), propput, helpstring("Returns/sets the month number [1-12] for the currently selected date."), helpcontext(0x00035c2a)]
	HRESULT __stdcall Month(
		[in] MonthConstants psMonth);
	[id(0x00000008), propget, helpstring("Returns/sets the background color used to display the month portion of the MonthView."), helpcontext(0x00035c2b)]
	HRESULT __stdcall MonthBackColor(
		[out, retval] OLE_COLOR* pclrMonthBackColor);
	[id(0x00000008), propput, helpstring("Returns/sets the background color used to display the month portion of the MonthView."), helpcontext(0x00035c2b)]
	HRESULT __stdcall MonthBackColor(
		[in] OLE_COLOR pclrMonthBackColor);
	[id(0x00000009), propget, helpstring("Returns/sets the number of months displayed horizontally across the control."), helpcontext(0x00035c2c)]
	HRESULT __stdcall MonthColumns(
		[out, retval] short* psMonthColumns);
	[id(0x00000009), propput, helpstring("Returns/sets the number of months displayed horizontally across the control."), helpcontext(0x00035c2c)]
	HRESULT __stdcall MonthColumns(
		[in] short psMonthColumns);
	[id(0x0000000a), propget, helpstring("Returns/sets the number of months displayed vertically in the control."), helpcontext(0x00035c2d)]
	HRESULT __stdcall MonthRows(
		[out, retval] short* psMonthRows);
	[id(0x0000000a), propput, helpstring("Returns/sets the number of months displayed vertically in the control."), helpcontext(0x00035c2d)]
	HRESULT __stdcall MonthRows(
		[in] short psMonthRows);
	[id(0x0000000b), propget, helpstring("Sets a custom mouse icon."), helpcontext(0x00035c2f)]
	HRESULT __stdcall MouseIcon(
		[out, retval] IPictureDisp** ppMouseIcon);
	[id(0x0000000b), propput, helpstring("Sets a custom mouse icon."), helpcontext(0x00035c2f)]
	HRESULT __stdcall MouseIcon(
		[in] IPictureDisp* ppMouseIcon);
	[id(0x0000000b), propputref, helpstring("Sets a custom mouse icon."), helpcontext(0x00035c2f)]
	HRESULT __stdcall MouseIcon(
		[in] IPictureDisp* ppMouseIcon);
	[id(0x0000000c), propget, helpstring("Returns/sets the type of mouse pointer displayed when over part of an object."), helpcontext(0x00035c2e)]
	HRESULT __stdcall MousePointer(
		[out, retval] MousePointerConstants* psMousePointer);
	[id(0x0000000c), propput, helpstring("Returns/sets the type of mouse pointer displayed when over part of an object."), helpcontext(0x00035c2e)]
	HRESULT __stdcall MousePointer(
		[in] MousePointerConstants psMousePointer);
	[id(0x0000000d), propget, helpstring("Returns/sets a value that determines whether the user can select multiple dates."), helpcontext(0x00035c30)]
	HRESULT __stdcall MultiSelect(
		[out, retval] VARIANT_BOOL* pbMultiSelect);
	[id(0x0000000d), propput, helpstring("Returns/sets a value that determines whether the user can select multiple dates."), helpcontext(0x00035c30)]
	HRESULT __stdcall MultiSelect(
		[in] VARIANT_BOOL pbMultiSelect);
	[id(0x0000060f), propget, helpstring("Returns/Sets whether this control can act as an OLE drop target."), helpcontext(0x00035bf2)]
	HRESULT __stdcall OLEDropMode(
		[out, retval] OLEDropConstants* psOLEDropMode);
	[id(0x0000060f), propput, helpstring("Returns/Sets whether this control can act as an OLE drop target."), helpcontext(0x00035bf2)]
	HRESULT __stdcall OLEDropMode(
		[in] OLEDropConstants psOLEDropMode);
	[id(0x0000000e), propget, helpstring("Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button."), helpcontext(0x00035c31)]
	HRESULT __stdcall ScrollRate(
		[out, retval] short* psScrollRate);
	[id(0x0000000e), propput, helpstring("Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button."), helpcontext(0x00035c31)]
	HRESULT __stdcall ScrollRate(
		[in] short psScrollRate);
	[id(0x0000000f), propget, helpstring("Returns/sets the end date for the current selection range."), helpcontext(0x00035c32)]
	HRESULT __stdcall SelEnd(
		[out, retval] DATE* pdateSelEnd);
	[id(0x0000000f), propput, helpstring("Returns/sets the end date for the current selection range."), helpcontext(0x00035c32)]
	HRESULT __stdcall SelEnd(
		[in] DATE pdateSelEnd);
	[id(0x00000010), propget, helpstring("Returns/sets the start date for the current selection range."), helpcontext(0x00035c33)]
	HRESULT __stdcall SelStart(
		[out, retval] DATE* pdateSelStart);
	[id(0x00000010), propput, helpstring("Returns/sets the start date for the current selection range."), helpcontext(0x00035c33)]
	HRESULT __stdcall SelStart(
		[in] DATE pdateSelStart);
	[id(0x00000011), propget, helpstring("Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView."), helpcontext(0x00035c34)]
	HRESULT __stdcall ShowToday(
		[out, retval] VARIANT_BOOL* pbShowToday);
	[id(0x00000011), propput, helpstring("Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView."), helpcontext(0x00035c34)]
	HRESULT __stdcall ShowToday(
		[in] VARIANT_BOOL pbShowToday);
	[id(0x00000012), propget, helpstring("Returns/sets a value that determines whether the control displays week numbers to the left of each row of days."), helpcontext(0x00035c35)]
	HRESULT __stdcall ShowWeekNumbers(
		[out, retval] VARIANT_BOOL* pbShowWeekNumbers);
	[id(0x00000012), propput, helpstring("Returns/sets a value that determines whether the control displays week numbers to the left of each row of days."), helpcontext(0x00035c35)]
	HRESULT __stdcall ShowWeekNumbers(
		[in] VARIANT_BOOL pbShowWeekNumbers);
	[id(0x00000013), propget, helpstring("Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days."), helpcontext(0x00035c36)]
	HRESULT __stdcall StartOfWeek(
		[out, retval] DayConstants* penumStartOfWeek);
	[id(0x00000013), propput, helpstring("Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days."), helpcontext(0x00035c36)]
	HRESULT __stdcall StartOfWeek(
		[in] DayConstants penumStartOfWeek);
	[id(0x00000014), propget, helpstring("Returns/sets the background color used to display the title portion of the MonthView."), helpcontext(0x00035c37)]
	HRESULT __stdcall TitleBackColor(
		[out, retval] OLE_COLOR* pclrTitleBackColor);
	[id(0x00000014), propput, helpstring("Returns/sets the background color used to display the title portion of the MonthView."), helpcontext(0x00035c37)]
	HRESULT __stdcall TitleBackColor(
		[in] OLE_COLOR pclrTitleBackColor);
	[id(0x00000015), propget, helpstring("Returns/sets the foreground color used to display the title portion of the MonthView."), helpcontext(0x00035c38)]
	HRESULT __stdcall TitleForeColor(
		[out, retval] OLE_COLOR* pclrTitleForeColor);
	[id(0x00000015), propput, helpstring("Returns/sets the foreground color used to display the title portion of the MonthView."), helpcontext(0x00035c38)]
	HRESULT __stdcall TitleForeColor(
		[in] OLE_COLOR pclrTitleForeColor);
	[id(0x00000016), propget, helpstring("Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months."), helpcontext(0x00035c39)]
	HRESULT __stdcall TrailingForeColor(
		[out, retval] OLE_COLOR* pclrTrailingForeColor);
	[id(0x00000016), propput, helpstring("Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months."), helpcontext(0x00035c39)]
	HRESULT __stdcall TrailingForeColor(
		[in] OLE_COLOR pclrTrailingForeColor);
	[id(0x00000017), propget, bindable, helpstring("Returns/sets the currently selected date."), helpcontext(0x00035c3a)]
	HRESULT __stdcall Value(
		[out, retval] DATE* pdateValue);
	[id(0x00000017), propput, bindable, helpstring("Returns/sets the currently selected date."), helpcontext(0x00035c3a)]
	HRESULT __stdcall Value(
		[in] DATE pdateValue);
	[id(0000000000), propget, hidden]
	HRESULT __stdcall _Value(
		[out, retval] DATE* pdateValue);
	[id(0000000000), propput, hidden]
	HRESULT __stdcall _Value(
		[in] DATE pdateValue);
	[id(0x00000018), propget, helpstring("An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed."), helpcontext(0x00035c3b)]
	HRESULT __stdcall VisibleDays(
		[in] short sIndex,
		[out, retval] DATE* pdateVisibleDays);
	[id(0x00000018), propput, helpstring("An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed."), helpcontext(0x00035c3b)]
	HRESULT __stdcall VisibleDays(
		[in] short sIndex,
		[in] DATE pdateVisibleDays);
	[id(0x00000019), propget, helpstring("Returns/sets the week number [1-52] for the currently selected date."), helpcontext(0x00035c3c)]
	HRESULT __stdcall Week(
		[out, retval] short* psWeek);
	[id(0x00000019), propput, helpstring("Returns/sets the week number [1-52] for the currently selected date."), helpcontext(0x00035c3c)]
	HRESULT __stdcall Week(
		[in] short psWeek);
	[id(0x0000001a), propget, helpstring("Returns/sets the year for the currently selected date."), helpcontext(0x00035c3d)]
	HRESULT __stdcall Year(
		[out, retval] short* psYear);
	[id(0x0000001a), propput, helpstring("Returns/sets the year for the currently selected date."), helpcontext(0x00035c3d)]
	HRESULT __stdcall Year(
		[in] short psYear);
	[id(0xfffffdd8), hidden]
	HRESULT __stdcall AboutBox();
	[id(0x0000001c), helpstring("A method that returns the width and height of a MonthView control for a given number of rows and columns."), helpcontext(0x00035c3e)]
	HRESULT __stdcall ComputeControlSize(
		[in] short Rows,
		[in] short Columns,
		[out] single* Width,
		[out] single* Height);
	[id(0x0000001b), helpstring("A method that returns a value which indicates the MonthView element located at the specified x,y coordinates."), helpcontext(0x00035c3f)]
	HRESULT __stdcall HitTest(
		[in] int x,
		[in] int y,
		[out] DATE* Date,
		[out, retval] MonthViewHitTestAreas* enumHitTestArea);
	[id(0x00000610), helpstring("Starts an OLE drag/drop event with the given control as the source."), helpcontext(0x00035bf1)]
	HRESULT __stdcall OLEDrag();
	[id(0xfffffdda), helpstring("Forces a complete repaint of a form or control."), helpcontext(0x00035c40)]
	HRESULT __stdcall Refresh();
};
'!
!IMonthView categoriesForClass!COM-Interfaces!MSComCtl2-Interfaces! !
!IMonthView methodsFor!

_value
	"Answer the <date> value of the '_Value' property of the receiver."

	| answer |
	answer := (DATE new).
	self get__Value: answer.
	^answer asObject
!

_value: pdateValue
	"Set the '_Value' property of the receiver to the <date> value of the argument."

	self put__Value: pdateValue
!

AboutBox
	"Invoke the AboutBox() method of the COM object wrapped by the receiver.

		HRESULT __stdcall AboutBox();"

	<virtual stdcall: hresult 80>
	^self invalidCall
!

computeControlSize: rows columns: columns 
	"Invoke the ComputeControlSize() method of the COM Object.
	Helpstring: 'A method that returns the width and height of a MonthView control for a given number of rows and columns.'"

	| width height |
	width := FLOAT new.
	height := FLOAT new.
	self 
		ComputeControlSize: rows
		Columns: columns
		Width: width
		Height: height.
	^width value @ height value!

ComputeControlSize: rows Columns: columns Width: width Height: height
	"Private - Invoke the ComputeControlSize() method of the COM object wrapped by the receiver.
	Helpstring: 'A method that returns the width and height of a MonthView control for a given number of rows and columns.'

		HRESULT __stdcall ComputeControlSize(
			[in] short Rows,
			[in] short Columns,
			[out] single* Width,
			[out] single* Height);"

	<virtual stdcall: hresult 81 sword sword float* float*>
	^self invalidCall
!

day
	"Answer the <sword> value of the 'Day' property of the receiver.
	Helpstring: 'Returns/sets the day number [1-31] for the currently selected date.'"

	| answer |
	answer := (SWORD new).
	self get_Day: answer.
	^answer asObject
!

day: psDay
	"Set the 'Day' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the day number [1-31] for the currently selected date.'"

	self put_Day: psDay
!

dayBold: dateIndex
	"Answer the <varbool> value of the 'DayBold' property of the receiver.
	Helpstring: 'An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_DayBold: dateIndex
		pbDayBold: answer.
	^answer asObject
!

dayBold: dateIndex pbDayBold: pbDayBold
	"Set the 'DayBold' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date.'"

	self
		put_DayBold: dateIndex
		pbDayBold: pbDayBold
!

dayOfWeek
	"Answer the <sdword> value of the 'DayOfWeek' property of the receiver.
	Helpstring: 'Returns the day of the week [0-6] for the currently selected date.'"

	| answer |
	answer := (SDWORD new).
	self get_DayOfWeek: answer.
	^answer asObject
!

dayOfWeek: penumDayOfWeek
	"Set the 'DayOfWeek' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns the day of the week [0-6] for the currently selected date.'"

	self put_DayOfWeek: penumDayOfWeek
!

get__Value: pdateValue
	"Private - Get the value of the '_Value' property of the receiver.

		HRESULT __stdcall _Value(
			[out, retval] DATE* pdateValue);"

	<virtual stdcall: hresult 72 date*>
	^self invalidCall
!

get_Appearance: penumAppearances
	"Private - Get the value of the 'Appearance' property of the receiver.
	Helpstring: 'Returns/sets whether or not controls, Forms or an MDIForm are painted at run time with 3-D effects.'

		HRESULT __stdcall Appearance(
			[out, retval] AppearanceConstants* penumAppearances);"

	<virtual stdcall: hresult 8 sdword*>
	^self invalidCall
!

get_BackColor: pclrBackColor
	"Private - Get the value of the 'BackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'

		HRESULT __stdcall BackColor(
			[out, retval] OLE_COLOR* pclrBackColor);"

	<virtual stdcall: hresult 10 dword*>
	^self invalidCall
!

get_BorderStyle: psBorderStyle
	"Private - Get the value of the 'BorderStyle' property of the receiver.
	Helpstring: 'Returns/sets the border style for an object.'

		HRESULT __stdcall BorderStyle(
			[out, retval] BorderStyleConstants* psBorderStyle);"

	<virtual stdcall: hresult 12 sdword*>
	^self invalidCall
!

get_Day: psDay
	"Private - Get the value of the 'Day' property of the receiver.
	Helpstring: 'Returns/sets the day number [1-31] for the currently selected date.'

		HRESULT __stdcall Day(
			[out, retval] short* psDay);"

	<virtual stdcall: hresult 14 sword*>
	^self invalidCall
!

get_DayBold: dateIndex pbDayBold: pbDayBold
	"Private - Get the value of the 'DayBold' property of the receiver.
	Helpstring: 'An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date.'

		HRESULT __stdcall DayBold(
			[in] DATE dateIndex,
			[out, retval] VARIANT_BOOL* pbDayBold);"

	<virtual stdcall: hresult 16 date varbool*>
	^self invalidCall
!

get_DayOfWeek: penumDayOfWeek
	"Private - Get the value of the 'DayOfWeek' property of the receiver.
	Helpstring: 'Returns the day of the week [0-6] for the currently selected date.'

		HRESULT __stdcall DayOfWeek(
			[out, retval] DayConstants* penumDayOfWeek);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall
!

get_Enabled: pbEnabled
	"Private - Get the value of the 'Enabled' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether a form or control can respond to user-generated events.'

		HRESULT __stdcall Enabled(
			[out, retval] VARIANT_BOOL* pbEnabled);"

	<virtual stdcall: hresult 20 varbool*>
	^self invalidCall
!

get_Font: ppFont
	"Private - Get the value of the 'Font' property of the receiver.
	Helpstring: 'Returns a Font object.'

		HRESULT __stdcall Font(
			[out, retval] IFontDisp** ppFont);"

	<virtual stdcall: hresult 22 IFontDisp**>
	^self invalidCall
!

get_ForeColor: pclrForeColor
	"Private - Get the value of the 'ForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'

		HRESULT __stdcall ForeColor(
			[out, retval] OLE_COLOR* pclrForeColor);"

	<virtual stdcall: hresult 25 dword*>
	^self invalidCall
!

get_hWnd: phWnd
	"Private - Get the value of the 'hWnd' property of the receiver.
	Helpstring: 'Returns a handle to a form or control.'

		HRESULT __stdcall hWnd(
			[out, retval] OLE_HANDLE* phWnd);"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall
!

get_MaxDate: pdateMaxDate
	"Private - Get the value of the 'MaxDate' property of the receiver.
	Helpstring: 'Returns/sets the latest date that can be displayed or accepted by the control.'

		HRESULT __stdcall MaxDate(
			[out, retval] DATE* pdateMaxDate);"

	<virtual stdcall: hresult 29 date*>
	^self invalidCall
!

get_MaxSelCount: psMaxSelCount
	"Private - Get the value of the 'MaxSelCount' property of the receiver.
	Helpstring: 'Returns/sets the limit on the number of dates that a user can multi-select.'

		HRESULT __stdcall MaxSelCount(
			[out, retval] short* psMaxSelCount);"

	<virtual stdcall: hresult 31 sword*>
	^self invalidCall
!

get_MinDate: pdateMinDate
	"Private - Get the value of the 'MinDate' property of the receiver.
	Helpstring: 'Returns/sets the earliest date that can be displayed or accepted by the control.'

		HRESULT __stdcall MinDate(
			[out, retval] DATE* pdateMinDate);"

	<virtual stdcall: hresult 33 date*>
	^self invalidCall
!

get_Month: psMonth
	"Private - Get the value of the 'Month' property of the receiver.
	Helpstring: 'Returns/sets the month number [1-12] for the currently selected date.'

		HRESULT __stdcall Month(
			[out, retval] MonthConstants* psMonth);"

	<virtual stdcall: hresult 35 sdword*>
	^self invalidCall
!

get_MonthBackColor: pclrMonthBackColor
	"Private - Get the value of the 'MonthBackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display the month portion of the MonthView.'

		HRESULT __stdcall MonthBackColor(
			[out, retval] OLE_COLOR* pclrMonthBackColor);"

	<virtual stdcall: hresult 37 dword*>
	^self invalidCall
!

get_MonthColumns: psMonthColumns
	"Private - Get the value of the 'MonthColumns' property of the receiver.
	Helpstring: 'Returns/sets the number of months displayed horizontally across the control.'

		HRESULT __stdcall MonthColumns(
			[out, retval] short* psMonthColumns);"

	<virtual stdcall: hresult 39 sword*>
	^self invalidCall
!

get_MonthRows: psMonthRows
	"Private - Get the value of the 'MonthRows' property of the receiver.
	Helpstring: 'Returns/sets the number of months displayed vertically in the control.'

		HRESULT __stdcall MonthRows(
			[out, retval] short* psMonthRows);"

	<virtual stdcall: hresult 41 sword*>
	^self invalidCall
!

get_MouseIcon: ppMouseIcon
	"Private - Get the value of the 'MouseIcon' property of the receiver.
	Helpstring: 'Sets a custom mouse icon.'

		HRESULT __stdcall MouseIcon(
			[out, retval] IPictureDisp** ppMouseIcon);"

	<virtual stdcall: hresult 43 IPictureDisp**>
	^self invalidCall
!

get_MousePointer: psMousePointer
	"Private - Get the value of the 'MousePointer' property of the receiver.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'

		HRESULT __stdcall MousePointer(
			[out, retval] MousePointerConstants* psMousePointer);"

	<virtual stdcall: hresult 46 sdword*>
	^self invalidCall
!

get_MultiSelect: pbMultiSelect
	"Private - Get the value of the 'MultiSelect' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the user can select multiple dates.'

		HRESULT __stdcall MultiSelect(
			[out, retval] VARIANT_BOOL* pbMultiSelect);"

	<virtual stdcall: hresult 48 varbool*>
	^self invalidCall
!

get_OLEDropMode: psOLEDropMode
	"Private - Get the value of the 'OLEDropMode' property of the receiver.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'

		HRESULT __stdcall OLEDropMode(
			[out, retval] OLEDropConstants* psOLEDropMode);"

	<virtual stdcall: hresult 50 sdword*>
	^self invalidCall
!

get_ScrollRate: psScrollRate
	"Private - Get the value of the 'ScrollRate' property of the receiver.
	Helpstring: 'Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button.'

		HRESULT __stdcall ScrollRate(
			[out, retval] short* psScrollRate);"

	<virtual stdcall: hresult 52 sword*>
	^self invalidCall
!

get_SelEnd: pdateSelEnd
	"Private - Get the value of the 'SelEnd' property of the receiver.
	Helpstring: 'Returns/sets the end date for the current selection range.'

		HRESULT __stdcall SelEnd(
			[out, retval] DATE* pdateSelEnd);"

	<virtual stdcall: hresult 54 date*>
	^self invalidCall
!

get_SelStart: pdateSelStart
	"Private - Get the value of the 'SelStart' property of the receiver.
	Helpstring: 'Returns/sets the start date for the current selection range.'

		HRESULT __stdcall SelStart(
			[out, retval] DATE* pdateSelStart);"

	<virtual stdcall: hresult 56 date*>
	^self invalidCall
!

get_ShowToday: pbShowToday
	"Private - Get the value of the 'ShowToday' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView.'

		HRESULT __stdcall ShowToday(
			[out, retval] VARIANT_BOOL* pbShowToday);"

	<virtual stdcall: hresult 58 varbool*>
	^self invalidCall
!

get_ShowWeekNumbers: pbShowWeekNumbers
	"Private - Get the value of the 'ShowWeekNumbers' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the control displays week numbers to the left of each row of days.'

		HRESULT __stdcall ShowWeekNumbers(
			[out, retval] VARIANT_BOOL* pbShowWeekNumbers);"

	<virtual stdcall: hresult 60 varbool*>
	^self invalidCall
!

get_StartOfWeek: penumStartOfWeek
	"Private - Get the value of the 'StartOfWeek' property of the receiver.
	Helpstring: 'Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days.'

		HRESULT __stdcall StartOfWeek(
			[out, retval] DayConstants* penumStartOfWeek);"

	<virtual stdcall: hresult 62 sdword*>
	^self invalidCall
!

get_TitleBackColor: pclrTitleBackColor
	"Private - Get the value of the 'TitleBackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display the title portion of the MonthView.'

		HRESULT __stdcall TitleBackColor(
			[out, retval] OLE_COLOR* pclrTitleBackColor);"

	<virtual stdcall: hresult 64 dword*>
	^self invalidCall
!

get_TitleForeColor: pclrTitleForeColor
	"Private - Get the value of the 'TitleForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display the title portion of the MonthView.'

		HRESULT __stdcall TitleForeColor(
			[out, retval] OLE_COLOR* pclrTitleForeColor);"

	<virtual stdcall: hresult 66 dword*>
	^self invalidCall
!

get_TrailingForeColor: pclrTrailingForeColor
	"Private - Get the value of the 'TrailingForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months.'

		HRESULT __stdcall TrailingForeColor(
			[out, retval] OLE_COLOR* pclrTrailingForeColor);"

	<virtual stdcall: hresult 68 dword*>
	^self invalidCall
!

get_Value: pdateValue
	"Private - Get the value of the 'Value' property of the receiver.
	Helpstring: 'Returns/sets the currently selected date.'

		HRESULT __stdcall Value(
			[out, retval] DATE* pdateValue);"

	<virtual stdcall: hresult 70 date*>
	^self invalidCall
!

get_VisibleDays: sIndex pdateVisibleDays: pdateVisibleDays
	"Private - Get the value of the 'VisibleDays' property of the receiver.
	Helpstring: 'An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed.'

		HRESULT __stdcall VisibleDays(
			[in] short sIndex,
			[out, retval] DATE* pdateVisibleDays);"

	<virtual stdcall: hresult 74 sword date*>
	^self invalidCall
!

get_Week: psWeek
	"Private - Get the value of the 'Week' property of the receiver.
	Helpstring: 'Returns/sets the week number [1-52] for the currently selected date.'

		HRESULT __stdcall Week(
			[out, retval] short* psWeek);"

	<virtual stdcall: hresult 76 sword*>
	^self invalidCall
!

get_Year: psYear
	"Private - Get the value of the 'Year' property of the receiver.
	Helpstring: 'Returns/sets the year for the currently selected date.'

		HRESULT __stdcall Year(
			[out, retval] short* psYear);"

	<virtual stdcall: hresult 78 sword*>
	^self invalidCall
!

hitTest: x y: y
	"Invoke the HitTest() method of the COM object.
	Helpstring: 'A method that returns a value which indicates the MonthView element located at the specified x,y coordinates.'"

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (DATE new);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		HitTest: x
		y: y
		Date: (answer basicAt: 1)
		enumHitTestArea: (answer basicAt: 2).
	^answer collect: [:e | e asObject]
!

HitTest: x y: y Date: date enumHitTestArea: enumHitTestArea
	"Private - Invoke the HitTest() method of the COM object wrapped by the receiver.
	Helpstring: 'A method that returns a value which indicates the MonthView element located at the specified x,y coordinates.'

		HRESULT __stdcall HitTest(
			[in] int x,
			[in] int y,
			[out] DATE* Date,
			[out, retval] MonthViewHitTestAreas* enumHitTestArea);"

	<virtual stdcall: hresult 82 sdword sdword date* sdword*>
	^self invalidCall
!

maxDate
	"Answer the <date> value of the 'MaxDate' property of the receiver.
	Helpstring: 'Returns/sets the latest date that can be displayed or accepted by the control.'"

	| answer |
	answer := (DATE new).
	self get_MaxDate: answer.
	^answer asObject
!

maxDate: pdateMaxDate
	"Set the 'MaxDate' property of the receiver to the <date> value of the argument.
	Helpstring: 'Returns/sets the latest date that can be displayed or accepted by the control.'"

	self put_MaxDate: pdateMaxDate
!

maxSelCount
	"Answer the <sword> value of the 'MaxSelCount' property of the receiver.
	Helpstring: 'Returns/sets the limit on the number of dates that a user can multi-select.'"

	| answer |
	answer := (SWORD new).
	self get_MaxSelCount: answer.
	^answer asObject
!

maxSelCount: psMaxSelCount
	"Set the 'MaxSelCount' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the limit on the number of dates that a user can multi-select.'"

	self put_MaxSelCount: psMaxSelCount
!

minDate
	"Answer the <date> value of the 'MinDate' property of the receiver.
	Helpstring: 'Returns/sets the earliest date that can be displayed or accepted by the control.'"

	| answer |
	answer := (DATE new).
	self get_MinDate: answer.
	^answer asObject
!

minDate: pdateMinDate
	"Set the 'MinDate' property of the receiver to the <date> value of the argument.
	Helpstring: 'Returns/sets the earliest date that can be displayed or accepted by the control.'"

	self put_MinDate: pdateMinDate
!

month
	"Answer the <sdword> value of the 'Month' property of the receiver.
	Helpstring: 'Returns/sets the month number [1-12] for the currently selected date.'"

	| answer |
	answer := (SDWORD new).
	self get_Month: answer.
	^answer asObject
!

month: psMonth
	"Set the 'Month' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the month number [1-12] for the currently selected date.'"

	self put_Month: psMonth
!

monthBackColor
	"Answer the <dword> value of the 'MonthBackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display the month portion of the MonthView.'"

	| answer |
	answer := DWORD new.
	self get_MonthBackColor: answer.
	^Color fromInteger: answer value!

monthBackColor: aColor
	"Set the 'MonthBackColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Returns/sets the background color used to display the month portion of the MonthView.'"

	self put_MonthBackColor: (self convertToBackColorRef: aColor)!

monthColumns
	"Answer the <sword> value of the 'MonthColumns' property of the receiver.
	Helpstring: 'Returns/sets the number of months displayed horizontally across the control.'"

	| answer |
	answer := (SWORD new).
	self get_MonthColumns: answer.
	^answer asObject
!

monthColumns: psMonthColumns
	"Set the 'MonthColumns' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the number of months displayed horizontally across the control.'"

	self put_MonthColumns: psMonthColumns
!

monthRows
	"Answer the <sword> value of the 'MonthRows' property of the receiver.
	Helpstring: 'Returns/sets the number of months displayed vertically in the control.'"

	| answer |
	answer := (SWORD new).
	self get_MonthRows: answer.
	^answer asObject
!

monthRows: psMonthRows
	"Set the 'MonthRows' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the number of months displayed vertically in the control.'"

	self put_MonthRows: psMonthRows
!

mouseIcon
	"Answer the <IPictureDisp> value of the 'MouseIcon' property of the receiver.
	Helpstring: 'Sets a custom mouse icon.'"

	| answer |
	answer := IPictureDisp newPointer.
	self get_MouseIcon: answer.
	^answer asObject
!

mouseIcon: ppMouseIcon
	"Set the 'MouseIcon' property of the receiver to the <IPictureDisp*> value of the argument.
	Helpstring: 'Sets a custom mouse icon.'"

	self put_MouseIcon: ppMouseIcon
!

mousePointer
	"Answer the <sdword> value of the 'MousePointer' property of the receiver.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'"

	| answer |
	answer := (SDWORD new).
	self get_MousePointer: answer.
	^answer asObject
!

mousePointer: psMousePointer
	"Set the 'MousePointer' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'"

	self put_MousePointer: psMousePointer
!

multiSelect
	"Answer the <varbool> value of the 'MultiSelect' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the user can select multiple dates.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_MultiSelect: answer.
	^answer asObject
!

multiSelect: pbMultiSelect
	"Set the 'MultiSelect' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets a value that determines whether the user can select multiple dates.'"

	self put_MultiSelect: pbMultiSelect
!

OLEDrag
	"Invoke the OLEDrag() method of the COM object wrapped by the receiver.
	Helpstring: 'Starts an OLE drag/drop event with the given control as the source.'

		HRESULT __stdcall OLEDrag();"

	<virtual stdcall: hresult 83>
	^self invalidCall
!

put__Value: pdateValue
	"Private - Set the value of the '_Value' property of the object wrapped by the 
	 receiver to the <date> argument, pdateValue.

		HRESULT __stdcall _Value(
			[in] DATE pdateValue);"

	<virtual stdcall: hresult 73 date>
	^self invalidCall
!

put_Appearance: penumAppearances
	"Private - Set the value of the 'Appearance' property of the object wrapped by the 
	 receiver to the <sdword> argument, penumAppearances.
	Helpstring: 'Returns/sets whether or not controls, Forms or an MDIForm are painted at run time with 3-D effects.'

		HRESULT __stdcall Appearance(
			[in] AppearanceConstants penumAppearances);"

	<virtual stdcall: hresult 9 sdword>
	^self invalidCall
!

put_BackColor: pclrBackColor
	"Private - Set the value of the 'BackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrBackColor.
	Helpstring: 'Returns/sets the background color used to display text and graphics in an object.'

		HRESULT __stdcall BackColor(
			[in] OLE_COLOR pclrBackColor);"

	<virtual stdcall: hresult 11 dword>
	^self invalidCall
!

put_BorderStyle: psBorderStyle
	"Private - Set the value of the 'BorderStyle' property of the object wrapped by the 
	 receiver to the <sdword> argument, psBorderStyle.
	Helpstring: 'Returns/sets the border style for an object.'

		HRESULT __stdcall BorderStyle(
			[in] BorderStyleConstants psBorderStyle);"

	<virtual stdcall: hresult 13 sdword>
	^self invalidCall
!

put_Day: psDay
	"Private - Set the value of the 'Day' property of the object wrapped by the 
	 receiver to the <sword> argument, psDay.
	Helpstring: 'Returns/sets the day number [1-31] for the currently selected date.'

		HRESULT __stdcall Day(
			[in] short psDay);"

	<virtual stdcall: hresult 15 sword>
	^self invalidCall
!

put_DayBold: dateIndex pbDayBold: pbDayBold
	"Private - Set the value of the 'DayBold' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbDayBold.
	Helpstring: 'An array of boolean values, 1 for each Visible Day, indicating whether the day is displayed using a bold font.  Indexed by date.'

		HRESULT __stdcall DayBold(
			[in] DATE dateIndex,
			[in] VARIANT_BOOL pbDayBold);"

	<virtual stdcall: hresult 17 date varbool>
	^self invalidCall
!

put_DayOfWeek: penumDayOfWeek
	"Private - Set the value of the 'DayOfWeek' property of the object wrapped by the 
	 receiver to the <sdword> argument, penumDayOfWeek.
	Helpstring: 'Returns the day of the week [0-6] for the currently selected date.'

		HRESULT __stdcall DayOfWeek(
			[in] DayConstants penumDayOfWeek);"

	<virtual stdcall: hresult 19 sdword>
	^self invalidCall
!

put_Enabled: pbEnabled
	"Private - Set the value of the 'Enabled' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbEnabled.
	Helpstring: 'Returns/sets a value that determines whether a form or control can respond to user-generated events.'

		HRESULT __stdcall Enabled(
			[in] VARIANT_BOOL pbEnabled);"

	<virtual stdcall: hresult 21 varbool>
	^self invalidCall
!

put_Font: ppFont
	"Private - Set the value of the 'Font' property of the object wrapped by the 
	 receiver to the <IFontDisp*> argument, ppFont.
	Helpstring: 'Returns a Font object.'

		HRESULT __stdcall Font(
			[in] IFontDisp* ppFont);"

	<virtual stdcall: hresult 23 IFontDisp*>
	^self invalidCall
!

put_ForeColor: pclrForeColor
	"Private - Set the value of the 'ForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrForeColor.
	Helpstring: 'Returns/sets the foreground color used to display text and graphics in an object.'

		HRESULT __stdcall ForeColor(
			[in] OLE_COLOR pclrForeColor);"

	<virtual stdcall: hresult 26 dword>
	^self invalidCall
!

put_hWnd: phWnd
	"Private - Set the value of the 'hWnd' property of the object wrapped by the 
	 receiver to the <sdword> argument, phWnd.
	Helpstring: 'Returns a handle to a form or control.'

		HRESULT __stdcall hWnd(
			[in] OLE_HANDLE phWnd);"

	<virtual stdcall: hresult 28 sdword>
	^self invalidCall
!

put_MaxDate: pdateMaxDate
	"Private - Set the value of the 'MaxDate' property of the object wrapped by the 
	 receiver to the <date> argument, pdateMaxDate.
	Helpstring: 'Returns/sets the latest date that can be displayed or accepted by the control.'

		HRESULT __stdcall MaxDate(
			[in] DATE pdateMaxDate);"

	<virtual stdcall: hresult 30 date>
	^self invalidCall
!

put_MaxSelCount: psMaxSelCount
	"Private - Set the value of the 'MaxSelCount' property of the object wrapped by the 
	 receiver to the <sword> argument, psMaxSelCount.
	Helpstring: 'Returns/sets the limit on the number of dates that a user can multi-select.'

		HRESULT __stdcall MaxSelCount(
			[in] short psMaxSelCount);"

	<virtual stdcall: hresult 32 sword>
	^self invalidCall
!

put_MinDate: pdateMinDate
	"Private - Set the value of the 'MinDate' property of the object wrapped by the 
	 receiver to the <date> argument, pdateMinDate.
	Helpstring: 'Returns/sets the earliest date that can be displayed or accepted by the control.'

		HRESULT __stdcall MinDate(
			[in] DATE pdateMinDate);"

	<virtual stdcall: hresult 34 date>
	^self invalidCall
!

put_Month: psMonth
	"Private - Set the value of the 'Month' property of the object wrapped by the 
	 receiver to the <sdword> argument, psMonth.
	Helpstring: 'Returns/sets the month number [1-12] for the currently selected date.'

		HRESULT __stdcall Month(
			[in] MonthConstants psMonth);"

	<virtual stdcall: hresult 36 sdword>
	^self invalidCall
!

put_MonthBackColor: pclrMonthBackColor
	"Private - Set the value of the 'MonthBackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrMonthBackColor.
	Helpstring: 'Returns/sets the background color used to display the month portion of the MonthView.'

		HRESULT __stdcall MonthBackColor(
			[in] OLE_COLOR pclrMonthBackColor);"

	<virtual stdcall: hresult 38 dword>
	^self invalidCall
!

put_MonthColumns: psMonthColumns
	"Private - Set the value of the 'MonthColumns' property of the object wrapped by the 
	 receiver to the <sword> argument, psMonthColumns.
	Helpstring: 'Returns/sets the number of months displayed horizontally across the control.'

		HRESULT __stdcall MonthColumns(
			[in] short psMonthColumns);"

	<virtual stdcall: hresult 40 sword>
	^self invalidCall
!

put_MonthRows: psMonthRows
	"Private - Set the value of the 'MonthRows' property of the object wrapped by the 
	 receiver to the <sword> argument, psMonthRows.
	Helpstring: 'Returns/sets the number of months displayed vertically in the control.'

		HRESULT __stdcall MonthRows(
			[in] short psMonthRows);"

	<virtual stdcall: hresult 42 sword>
	^self invalidCall
!

put_MouseIcon: ppMouseIcon
	"Private - Set the value of the 'MouseIcon' property of the object wrapped by the 
	 receiver to the <IPictureDisp*> argument, ppMouseIcon.
	Helpstring: 'Sets a custom mouse icon.'

		HRESULT __stdcall MouseIcon(
			[in] IPictureDisp* ppMouseIcon);"

	<virtual stdcall: hresult 44 IPictureDisp*>
	^self invalidCall
!

put_MousePointer: psMousePointer
	"Private - Set the value of the 'MousePointer' property of the object wrapped by the 
	 receiver to the <sdword> argument, psMousePointer.
	Helpstring: 'Returns/sets the type of mouse pointer displayed when over part of an object.'

		HRESULT __stdcall MousePointer(
			[in] MousePointerConstants psMousePointer);"

	<virtual stdcall: hresult 47 sdword>
	^self invalidCall
!

put_MultiSelect: pbMultiSelect
	"Private - Set the value of the 'MultiSelect' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbMultiSelect.
	Helpstring: 'Returns/sets a value that determines whether the user can select multiple dates.'

		HRESULT __stdcall MultiSelect(
			[in] VARIANT_BOOL pbMultiSelect);"

	<virtual stdcall: hresult 49 varbool>
	^self invalidCall
!

put_OLEDropMode: psOLEDropMode
	"Private - Set the value of the 'OLEDropMode' property of the object wrapped by the 
	 receiver to the <sdword> argument, psOLEDropMode.
	Helpstring: 'Returns/Sets whether this control can act as an OLE drop target.'

		HRESULT __stdcall OLEDropMode(
			[in] OLEDropConstants psOLEDropMode);"

	<virtual stdcall: hresult 51 sdword>
	^self invalidCall
!

put_ScrollRate: psScrollRate
	"Private - Set the value of the 'ScrollRate' property of the object wrapped by the 
	 receiver to the <sword> argument, psScrollRate.
	Helpstring: 'Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button.'

		HRESULT __stdcall ScrollRate(
			[in] short psScrollRate);"

	<virtual stdcall: hresult 53 sword>
	^self invalidCall
!

put_SelEnd: pdateSelEnd
	"Private - Set the value of the 'SelEnd' property of the object wrapped by the 
	 receiver to the <date> argument, pdateSelEnd.
	Helpstring: 'Returns/sets the end date for the current selection range.'

		HRESULT __stdcall SelEnd(
			[in] DATE pdateSelEnd);"

	<virtual stdcall: hresult 55 date>
	^self invalidCall
!

put_SelStart: pdateSelStart
	"Private - Set the value of the 'SelStart' property of the object wrapped by the 
	 receiver to the <date> argument, pdateSelStart.
	Helpstring: 'Returns/sets the start date for the current selection range.'

		HRESULT __stdcall SelStart(
			[in] DATE pdateSelStart);"

	<virtual stdcall: hresult 57 date>
	^self invalidCall
!

put_ShowToday: pbShowToday
	"Private - Set the value of the 'ShowToday' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbShowToday.
	Helpstring: 'Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView.'

		HRESULT __stdcall ShowToday(
			[in] VARIANT_BOOL pbShowToday);"

	<virtual stdcall: hresult 59 varbool>
	^self invalidCall
!

put_ShowWeekNumbers: pbShowWeekNumbers
	"Private - Set the value of the 'ShowWeekNumbers' property of the object wrapped by the 
	 receiver to the <varbool> argument, pbShowWeekNumbers.
	Helpstring: 'Returns/sets a value that determines whether the control displays week numbers to the left of each row of days.'

		HRESULT __stdcall ShowWeekNumbers(
			[in] VARIANT_BOOL pbShowWeekNumbers);"

	<virtual stdcall: hresult 61 varbool>
	^self invalidCall
!

put_StartOfWeek: penumStartOfWeek
	"Private - Set the value of the 'StartOfWeek' property of the object wrapped by the 
	 receiver to the <sdword> argument, penumStartOfWeek.
	Helpstring: 'Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days.'

		HRESULT __stdcall StartOfWeek(
			[in] DayConstants penumStartOfWeek);"

	<virtual stdcall: hresult 63 sdword>
	^self invalidCall
!

put_TitleBackColor: pclrTitleBackColor
	"Private - Set the value of the 'TitleBackColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrTitleBackColor.
	Helpstring: 'Returns/sets the background color used to display the title portion of the MonthView.'

		HRESULT __stdcall TitleBackColor(
			[in] OLE_COLOR pclrTitleBackColor);"

	<virtual stdcall: hresult 65 dword>
	^self invalidCall
!

put_TitleForeColor: pclrTitleForeColor
	"Private - Set the value of the 'TitleForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrTitleForeColor.
	Helpstring: 'Returns/sets the foreground color used to display the title portion of the MonthView.'

		HRESULT __stdcall TitleForeColor(
			[in] OLE_COLOR pclrTitleForeColor);"

	<virtual stdcall: hresult 67 dword>
	^self invalidCall
!

put_TrailingForeColor: pclrTrailingForeColor
	"Private - Set the value of the 'TrailingForeColor' property of the object wrapped by the 
	 receiver to the <dword> argument, pclrTrailingForeColor.
	Helpstring: 'Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months.'

		HRESULT __stdcall TrailingForeColor(
			[in] OLE_COLOR pclrTrailingForeColor);"

	<virtual stdcall: hresult 69 dword>
	^self invalidCall
!

put_Value: pdateValue
	"Private - Set the value of the 'Value' property of the object wrapped by the 
	 receiver to the <date> argument, pdateValue.
	Helpstring: 'Returns/sets the currently selected date.'

		HRESULT __stdcall Value(
			[in] DATE pdateValue);"

	<virtual stdcall: hresult 71 date>
	^self invalidCall
!

put_VisibleDays: sIndex pdateVisibleDays: pdateVisibleDays
	"Private - Set the value of the 'VisibleDays' property of the object wrapped by the 
	 receiver to the <date> argument, pdateVisibleDays.
	Helpstring: 'An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed.'

		HRESULT __stdcall VisibleDays(
			[in] short sIndex,
			[in] DATE pdateVisibleDays);"

	<virtual stdcall: hresult 75 sword date>
	^self invalidCall
!

put_Week: psWeek
	"Private - Set the value of the 'Week' property of the object wrapped by the 
	 receiver to the <sword> argument, psWeek.
	Helpstring: 'Returns/sets the week number [1-52] for the currently selected date.'

		HRESULT __stdcall Week(
			[in] short psWeek);"

	<virtual stdcall: hresult 77 sword>
	^self invalidCall
!

put_Year: psYear
	"Private - Set the value of the 'Year' property of the object wrapped by the 
	 receiver to the <sword> argument, psYear.
	Helpstring: 'Returns/sets the year for the currently selected date.'

		HRESULT __stdcall Year(
			[in] short psYear);"

	<virtual stdcall: hresult 79 sword>
	^self invalidCall
!

putref_Font: ppFont
	"Private - Set the value of the 'Font' property of the object wrapped by the 
	 receiver to the <IFontDisp*> argument, ppFont.
	Helpstring: 'Returns a Font object.'

		HRESULT __stdcall Font(
			[in] IFontDisp* ppFont);"

	<virtual stdcall: hresult 24 IFontDisp*>
	^self invalidCall
!

putref_MouseIcon: ppMouseIcon
	"Private - Set the value of the 'MouseIcon' property of the object wrapped by the 
	 receiver to the <IPictureDisp*> argument, ppMouseIcon.
	Helpstring: 'Sets a custom mouse icon.'

		HRESULT __stdcall MouseIcon(
			[in] IPictureDisp* ppMouseIcon);"

	<virtual stdcall: hresult 45 IPictureDisp*>
	^self invalidCall
!

Refresh
	"Invoke the Refresh() method of the COM object wrapped by the receiver.
	Helpstring: 'Forces a complete repaint of a form or control.'

		HRESULT __stdcall Refresh();"

	<virtual stdcall: hresult 84>
	^self invalidCall
!

scrollRate
	"Answer the <sword> value of the 'ScrollRate' property of the receiver.
	Helpstring: 'Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button.'"

	| answer |
	answer := (SWORD new).
	self get_ScrollRate: answer.
	^answer asObject
!

scrollRate: psScrollRate
	"Set the 'ScrollRate' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets a value that determines the number of months that the control moves when the user clicks a scroll button.'"

	self put_ScrollRate: psScrollRate
!

selEnd
	"Answer the <date> value of the 'SelEnd' property of the receiver.
	Helpstring: 'Returns/sets the end date for the current selection range.'"

	| answer |
	answer := (DATE new).
	self get_SelEnd: answer.
	^answer asObject
!

selEnd: pdateSelEnd
	"Set the 'SelEnd' property of the receiver to the <date> value of the argument.
	Helpstring: 'Returns/sets the end date for the current selection range.'"

	self put_SelEnd: pdateSelEnd
!

selStart
	"Answer the <date> value of the 'SelStart' property of the receiver.
	Helpstring: 'Returns/sets the start date for the current selection range.'"

	| answer |
	answer := (DATE new).
	self get_SelStart: answer.
	^answer asObject
!

selStart: pdateSelStart
	"Set the 'SelStart' property of the receiver to the <date> value of the argument.
	Helpstring: 'Returns/sets the start date for the current selection range.'"

	self put_SelStart: pdateSelStart
!

setMouseIcon: ppMouseIcon
	"Set the 'MouseIcon' property of the receiver to the <IPictureDisp*> value of the argument.
	Helpstring: 'Sets a custom mouse icon.'"

	self putref_MouseIcon: ppMouseIcon
!

showToday
	"Answer the <varbool> value of the 'ShowToday' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_ShowToday: answer.
	^answer asObject
!

showToday: pbShowToday
	"Set the 'ShowToday' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets a value that determines whether the control displays the ''Today xx/xx/xx'' literal at the bottom of the MonthView.'"

	self put_ShowToday: pbShowToday
!

showWeekNumbers
	"Answer the <varbool> value of the 'ShowWeekNumbers' property of the receiver.
	Helpstring: 'Returns/sets a value that determines whether the control displays week numbers to the left of each row of days.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_ShowWeekNumbers: answer.
	^answer asObject
!

showWeekNumbers: pbShowWeekNumbers
	"Set the 'ShowWeekNumbers' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Returns/sets a value that determines whether the control displays week numbers to the left of each row of days.'"

	self put_ShowWeekNumbers: pbShowWeekNumbers
!

startOfWeek
	"Answer the <sdword> value of the 'StartOfWeek' property of the receiver.
	Helpstring: 'Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days.'"

	| answer |
	answer := (SDWORD new).
	self get_StartOfWeek: answer.
	^answer asObject
!

startOfWeek: penumStartOfWeek
	"Set the 'StartOfWeek' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'Returns/sets a value that determines the day of the week [Mon-Sun] displayed in the leftmost column of days.'"

	self put_StartOfWeek: penumStartOfWeek
!

titleBackColor
	"Answer the <dword> value of the 'TitleBackColor' property of the receiver.
	Helpstring: 'Returns/sets the background color used to display the title portion of the MonthView.'"

	| answer |
	answer := (DWORD new).
	self get_TitleBackColor: answer.
	^answer asObject
!

titleBackColor: pclrTitleBackColor
	"Set the 'TitleBackColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Returns/sets the background color used to display the title portion of the MonthView.'"

	self put_TitleBackColor: pclrTitleBackColor
!

titleForeColor
	"Answer the <dword> value of the 'TitleForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display the title portion of the MonthView.'"

	| answer |
	answer := (DWORD new).
	self get_TitleForeColor: answer.
	^answer asObject
!

titleForeColor: pclrTitleForeColor
	"Set the 'TitleForeColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Returns/sets the foreground color used to display the title portion of the MonthView.'"

	self put_TitleForeColor: pclrTitleForeColor
!

trailingForeColor
	"Answer the <dword> value of the 'TrailingForeColor' property of the receiver.
	Helpstring: 'Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months.'"

	| answer |
	answer := (DWORD new).
	self get_TrailingForeColor: answer.
	^answer asObject
!

trailingForeColor: pclrTrailingForeColor
	"Set the 'TrailingForeColor' property of the receiver to the <dword> value of the argument.
	Helpstring: 'Returns/sets the foreground color used to display the days at the beginning and end of the MonthView that are from previous and following months.'"

	self put_TrailingForeColor: pclrTrailingForeColor
!

value
	"Answer the <date> value of the 'Value' property of the receiver.
	Helpstring: 'Returns/sets the currently selected date.'"

	| answer |
	answer := (DATE new).
	self get_Value: answer.
	^answer asObject
!

value: pdateValue
	"Set the 'Value' property of the receiver to the <date> value of the argument.
	Helpstring: 'Returns/sets the currently selected date.'"

	self put_Value: pdateValue asFloat!

visibleDays: sIndex
	"Answer the <date> value of the 'VisibleDays' property of the receiver.
	Helpstring: 'An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed.'"

	| answer |
	answer := (DATE new).
	self
		get_VisibleDays: sIndex
		pdateVisibleDays: answer.
	^answer asObject
!

visibleDays: sIndex pdateVisibleDays: pdateVisibleDays
	"Set the 'VisibleDays' property of the receiver to the <date> value of the argument.
	Helpstring: 'An array of dates, 1 for each day currently displayed. Indexed by a number from 1 to number of days currently displayed.'"

	self
		put_VisibleDays: sIndex
		pdateVisibleDays: pdateVisibleDays
!

week
	"Answer the <sword> value of the 'Week' property of the receiver.
	Helpstring: 'Returns/sets the week number [1-52] for the currently selected date.'"

	| answer |
	answer := (SWORD new).
	self get_Week: answer.
	^answer asObject
!

week: psWeek
	"Set the 'Week' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the week number [1-52] for the currently selected date.'"

	self put_Week: psWeek
!

year
	"Answer the <sword> value of the 'Year' property of the receiver.
	Helpstring: 'Returns/sets the year for the currently selected date.'"

	| answer |
	answer := (SWORD new).
	self get_Year: answer.
	^answer asObject
!

year: psYear
	"Set the 'Year' property of the receiver to the <sword> value of the argument.
	Helpstring: 'Returns/sets the year for the currently selected date.'"

	self put_Year: psYear
! !
!IMonthView categoriesFor: #_value!**auto generated**!properties!public! !
!IMonthView categoriesFor: #_value:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #AboutBox!**auto generated**!COM Interfaces-IMonthView!public! !
!IMonthView categoriesFor: #computeControlSize:columns:!methods!public! !
!IMonthView categoriesFor: #ComputeControlSize:Columns:Width:Height:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #day!**auto generated**!properties!public! !
!IMonthView categoriesFor: #day:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #dayBold:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #dayBold:pbDayBold:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #dayOfWeek!**auto generated**!properties!public! !
!IMonthView categoriesFor: #dayOfWeek:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #get__Value:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Appearance:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_BackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_BorderStyle:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Day:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_DayBold:pbDayBold:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_DayOfWeek:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Enabled:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Font:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_ForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_hWnd:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MaxDate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MaxSelCount:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MinDate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Month:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MonthBackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MonthColumns:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MonthRows:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MouseIcon:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MousePointer:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_MultiSelect:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_OLEDropMode:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_ScrollRate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_SelEnd:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_SelStart:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_ShowToday:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_ShowWeekNumbers:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_StartOfWeek:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_TitleBackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_TitleForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_TrailingForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Value:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_VisibleDays:pdateVisibleDays:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Week:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #get_Year:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #hitTest:y:!**auto generated**!methods!public! !
!IMonthView categoriesFor: #HitTest:y:Date:enumHitTestArea:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #maxDate!**auto generated**!properties!public! !
!IMonthView categoriesFor: #maxDate:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #maxSelCount!**auto generated**!properties!public! !
!IMonthView categoriesFor: #maxSelCount:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #minDate!**auto generated**!properties!public! !
!IMonthView categoriesFor: #minDate:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #month!**auto generated**!properties!public! !
!IMonthView categoriesFor: #month:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #monthBackColor!properties!public! !
!IMonthView categoriesFor: #monthBackColor:!properties!public! !
!IMonthView categoriesFor: #monthColumns!**auto generated**!properties!public! !
!IMonthView categoriesFor: #monthColumns:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #monthRows!**auto generated**!properties!public! !
!IMonthView categoriesFor: #monthRows:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #mouseIcon!**auto generated**!properties!public! !
!IMonthView categoriesFor: #mouseIcon:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #mousePointer!**auto generated**!properties!public! !
!IMonthView categoriesFor: #mousePointer:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #multiSelect!**auto generated**!properties!public! !
!IMonthView categoriesFor: #multiSelect:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #OLEDrag!**auto generated**!COM Interfaces-IMonthView!public! !
!IMonthView categoriesFor: #put__Value:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Appearance:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_BackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_BorderStyle:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Day:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_DayBold:pbDayBold:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_DayOfWeek:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Enabled:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Font:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_ForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_hWnd:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MaxDate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MaxSelCount:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MinDate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Month:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MonthBackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MonthColumns:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MonthRows:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MouseIcon:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MousePointer:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_MultiSelect:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_OLEDropMode:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_ScrollRate:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_SelEnd:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_SelStart:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_ShowToday:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_ShowWeekNumbers:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_StartOfWeek:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_TitleBackColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_TitleForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_TrailingForeColor:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Value:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_VisibleDays:pdateVisibleDays:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Week:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #put_Year:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #putref_Font:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #putref_MouseIcon:!**auto generated**!COM Interfaces-IMonthView!private! !
!IMonthView categoriesFor: #Refresh!**auto generated**!COM Interfaces-IMonthView!public! !
!IMonthView categoriesFor: #scrollRate!**auto generated**!properties!public! !
!IMonthView categoriesFor: #scrollRate:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #selEnd!**auto generated**!properties!public! !
!IMonthView categoriesFor: #selEnd:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #selStart!**auto generated**!properties!public! !
!IMonthView categoriesFor: #selStart:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #setMouseIcon:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #showToday!**auto generated**!properties!public! !
!IMonthView categoriesFor: #showToday:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #showWeekNumbers!**auto generated**!properties!public! !
!IMonthView categoriesFor: #showWeekNumbers:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #startOfWeek!**auto generated**!properties!public! !
!IMonthView categoriesFor: #startOfWeek:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #titleBackColor!**auto generated**!properties!public! !
!IMonthView categoriesFor: #titleBackColor:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #titleForeColor!**auto generated**!properties!public! !
!IMonthView categoriesFor: #titleForeColor:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #trailingForeColor!**auto generated**!properties!public! !
!IMonthView categoriesFor: #trailingForeColor:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #value!**auto generated**!properties!public! !
!IMonthView categoriesFor: #value:!properties!public! !
!IMonthView categoriesFor: #visibleDays:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #visibleDays:pdateVisibleDays:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #week!**auto generated**!properties!public! !
!IMonthView categoriesFor: #week:!**auto generated**!properties!public! !
!IMonthView categoriesFor: #year!**auto generated**!properties!public! !
!IMonthView categoriesFor: #year:!**auto generated**!properties!public! !

!IMonthView class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (MonthView) for which the receiver is the default interface."

	^CLSID fromString: '{232E456A-87C3-11D1-8BE3-0000F8754DA1}'
! !
!IMonthView class categoriesFor: #clsid!**auto generated**!constants!private! !

