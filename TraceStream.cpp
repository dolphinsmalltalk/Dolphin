#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif
#include "segdefs.h"

#pragma code_seg(DEBUG_SEG)
#include "TraceStream.h"
#pragma warning(push,3)
#include <wtypes.h>
#include <winbase.h>
#pragma warning(disable:4530)
#include <iostream>
#include <iomanip>
#pragma warning(pop)

std::wostream& operator<<(std::wostream& stream, const SYSTEMTIME& st)
{
	char buf[128];
	GetTimeFormat(LOCALE_SYSTEM_DEFAULT, TIME_FORCE24HOURFORMAT, &st, NULL, buf, 64);
	stream <<  buf<< L", ";
	GetDateFormat(LOCALE_SYSTEM_DEFAULT, DATE_SHORTDATE, &st, NULL, buf, 64);
	return stream << buf;
}
